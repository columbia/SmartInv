1 // File: contracts/nft.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-07-15
5 */
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Counters.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @title Counters
241  * @author Matt Condon (@shrugs)
242  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
243  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
244  *
245  * Include with `using Counters for Counters.Counter;`
246  */
247 library Counters {
248     struct Counter {
249         // This variable should never be directly accessed by users of the library: interactions must be restricted to
250         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
251         // this feature: see https://github.com/ethereum/solidity/issues/4637
252         uint256 _value; // default: 0
253     }
254 
255     function current(Counter storage counter) internal view returns (uint256) {
256         return counter._value;
257     }
258 
259     function increment(Counter storage counter) internal {
260         unchecked {
261             counter._value += 1;
262         }
263     }
264 
265     function decrement(Counter storage counter) internal {
266         uint256 value = counter._value;
267         require(value > 0, "Counter: decrement overflow");
268         unchecked {
269             counter._value = value - 1;
270         }
271     }
272 
273     function reset(Counter storage counter) internal {
274         counter._value = 0;
275     }
276 }
277 
278 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Contract module that helps prevent reentrant calls to a function.
287  *
288  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
289  * available, which can be applied to functions to make sure there are no nested
290  * (reentrant) calls to them.
291  *
292  * Note that because there is a single `nonReentrant` guard, functions marked as
293  * `nonReentrant` may not call one another. This can be worked around by making
294  * those functions `private`, and then adding `external` `nonReentrant` entry
295  * points to them.
296  *
297  * TIP: If you would like to learn more about reentrancy and alternative ways
298  * to protect against it, check out our blog post
299  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
300  */
301 abstract contract ReentrancyGuard {
302     // Booleans are more expensive than uint256 or any type that takes up a full
303     // word because each write operation emits an extra SLOAD to first read the
304     // slot's contents, replace the bits taken up by the boolean, and then write
305     // back. This is the compiler's defense against contract upgrades and
306     // pointer aliasing, and it cannot be disabled.
307 
308     // The values being non-zero value makes deployment a bit more expensive,
309     // but in exchange the refund on every call to nonReentrant will be lower in
310     // amount. Since refunds are capped to a percentage of the total
311     // transaction's gas, it is best to keep them low in cases like this one, to
312     // increase the likelihood of the full refund coming into effect.
313     uint256 private constant _NOT_ENTERED = 1;
314     uint256 private constant _ENTERED = 2;
315 
316     uint256 private _status;
317 
318     constructor() {
319         _status = _NOT_ENTERED;
320     }
321 
322     /**
323      * @dev Prevents a contract from calling itself, directly or indirectly.
324      * Calling a `nonReentrant` function from another `nonReentrant`
325      * function is not supported. It is possible to prevent this from happening
326      * by making the `nonReentrant` function external, and making it call a
327      * `private` function that does the actual work.
328      */
329     modifier nonReentrant() {
330         // On the first call to nonReentrant, _notEntered will be true
331         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
332 
333         // Any calls to nonReentrant after this point will fail
334         _status = _ENTERED;
335 
336         _;
337 
338         // By storing the original value once again, a refund is triggered (see
339         // https://eips.ethereum.org/EIPS/eip-2200)
340         _status = _NOT_ENTERED;
341     }
342 }
343 
344 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Interface of the ERC20 standard as defined in the EIP.
353  */
354 interface IERC20 {
355     /**
356      * @dev Returns the amount of tokens in existence.
357      */
358     function totalSupply() external view returns (uint256);
359 
360     /**
361      * @dev Returns the amount of tokens owned by `account`.
362      */
363     function balanceOf(address account) external view returns (uint256);
364 
365     /**
366      * @dev Moves `amount` tokens from the caller's account to `recipient`.
367      *
368      * Returns a boolean value indicating whether the operation succeeded.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transfer(address recipient, uint256 amount) external returns (bool);
373 
374     /**
375      * @dev Returns the remaining number of tokens that `spender` will be
376      * allowed to spend on behalf of `owner` through {transferFrom}. This is
377      * zero by default.
378      *
379      * This value changes when {approve} or {transferFrom} are called.
380      */
381     function allowance(address owner, address spender) external view returns (uint256);
382 
383     /**
384      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
385      *
386      * Returns a boolean value indicating whether the operation succeeded.
387      *
388      * IMPORTANT: Beware that changing an allowance with this method brings the risk
389      * that someone may use both the old and the new allowance by unfortunate
390      * transaction ordering. One possible solution to mitigate this race
391      * condition is to first reduce the spender's allowance to 0 and set the
392      * desired value afterwards:
393      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
394      *
395      * Emits an {Approval} event.
396      */
397     function approve(address spender, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Moves `amount` tokens from `sender` to `recipient` using the
401      * allowance mechanism. `amount` is then deducted from the caller's
402      * allowance.
403      *
404      * Returns a boolean value indicating whether the operation succeeded.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transferFrom(
409         address sender,
410         address recipient,
411         uint256 amount
412     ) external returns (bool);
413 
414     /**
415      * @dev Emitted when `value` tokens are moved from one account (`from`) to
416      * another (`to`).
417      *
418      * Note that `value` may be zero.
419      */
420     event Transfer(address indexed from, address indexed to, uint256 value);
421 
422     /**
423      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
424      * a call to {approve}. `value` is the new allowance.
425      */
426     event Approval(address indexed owner, address indexed spender, uint256 value);
427 }
428 
429 // File: @openzeppelin/contracts/interfaces/IERC20.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 
437 // File: @openzeppelin/contracts/utils/Strings.sol
438 
439 
440 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 /**
445  * @dev String operations.
446  */
447 library Strings {
448     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
449 
450     /**
451      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
452      */
453     function toString(uint256 value) internal pure returns (string memory) {
454         // Inspired by OraclizeAPI's implementation - MIT licence
455         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
456 
457         if (value == 0) {
458             return "0";
459         }
460         uint256 temp = value;
461         uint256 digits;
462         while (temp != 0) {
463             digits++;
464             temp /= 10;
465         }
466         bytes memory buffer = new bytes(digits);
467         while (value != 0) {
468             digits -= 1;
469             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
470             value /= 10;
471         }
472         return string(buffer);
473     }
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
477      */
478     function toHexString(uint256 value) internal pure returns (string memory) {
479         if (value == 0) {
480             return "0x00";
481         }
482         uint256 temp = value;
483         uint256 length = 0;
484         while (temp != 0) {
485             length++;
486             temp >>= 8;
487         }
488         return toHexString(value, length);
489     }
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
493      */
494     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
495         bytes memory buffer = new bytes(2 * length + 2);
496         buffer[0] = "0";
497         buffer[1] = "x";
498         for (uint256 i = 2 * length + 1; i > 1; --i) {
499             buffer[i] = _HEX_SYMBOLS[value & 0xf];
500             value >>= 4;
501         }
502         require(value == 0, "Strings: hex length insufficient");
503         return string(buffer);
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/Context.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Provides information about the current execution context, including the
516  * sender of the transaction and its data. While these are generally available
517  * via msg.sender and msg.data, they should not be accessed in such a direct
518  * manner, since when dealing with meta-transactions the account sending and
519  * paying for execution may not be the actual sender (as far as an application
520  * is concerned).
521  *
522  * This contract is only required for intermediate, library-like contracts.
523  */
524 abstract contract Context {
525     function _msgSender() internal view virtual returns (address) {
526         return msg.sender;
527     }
528 
529     function _msgData() internal view virtual returns (bytes calldata) {
530         return msg.data;
531     }
532 }
533 
534 // File: @openzeppelin/contracts/access/Ownable.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Contract module which provides a basic access control mechanism, where
544  * there is an account (an owner) that can be granted exclusive access to
545  * specific functions.
546  *
547  * By default, the owner account will be the one that deploys the contract. This
548  * can later be changed with {transferOwnership}.
549  *
550  * This module is used through inheritance. It will make available the modifier
551  * `onlyOwner`, which can be applied to your functions to restrict their use to
552  * the owner.
553  */
554 abstract contract Ownable is Context {
555     address private _owner;
556 
557     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
558 
559     /**
560      * @dev Initializes the contract setting the deployer as the initial owner.
561      */
562     constructor() {
563         _transferOwnership(_msgSender());
564     }
565 
566     /**
567      * @dev Returns the address of the current owner.
568      */
569     function owner() public view virtual returns (address) {
570         return _owner;
571     }
572 
573     /**
574      * @dev Throws if called by any account other than the owner.
575      */
576     modifier onlyOwner() {
577         require(owner() == _msgSender(), "Ownable: caller is not the owner");
578         _;
579     }
580 
581     /**
582      * @dev Leaves the contract without owner. It will not be possible to call
583      * `onlyOwner` functions anymore. Can only be called by the current owner.
584      *
585      * NOTE: Renouncing ownership will leave the contract without an owner,
586      * thereby removing any functionality that is only available to the owner.
587      */
588     function renounceOwnership() public virtual onlyOwner {
589         _transferOwnership(address(0));
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Can only be called by the current owner.
595      */
596     function transferOwnership(address newOwner) public virtual onlyOwner {
597         require(newOwner != address(0), "Ownable: new owner is the zero address");
598         _transferOwnership(newOwner);
599     }
600 
601     /**
602      * @dev Transfers ownership of the contract to a new account (`newOwner`).
603      * Internal function without access restriction.
604      */
605     function _transferOwnership(address newOwner) internal virtual {
606         address oldOwner = _owner;
607         _owner = newOwner;
608         emit OwnershipTransferred(oldOwner, newOwner);
609     }
610 }
611 
612 // File: @openzeppelin/contracts/utils/Address.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 /**
620  * @dev Collection of functions related to the address type
621  */
622 library Address {
623     /**
624      * @dev Returns true if `account` is a contract.
625      *
626      * [IMPORTANT]
627      * ====
628      * It is unsafe to assume that an address for which this function returns
629      * false is an externally-owned account (EOA) and not a contract.
630      *
631      * Among others, `isContract` will return false for the following
632      * types of addresses:
633      *
634      *  - an externally-owned account
635      *  - a contract in construction
636      *  - an address where a contract will be created
637      *  - an address where a contract lived, but was destroyed
638      * ====
639      */
640     function isContract(address account) internal view returns (bool) {
641         // This method relies on extcodesize, which returns 0 for contracts in
642         // construction, since the code is only stored at the end of the
643         // constructor execution.
644 
645         uint256 size;
646         assembly {
647             size := extcodesize(account)
648         }
649         return size > 0;
650     }
651 
652     /**
653      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
654      * `recipient`, forwarding all available gas and reverting on errors.
655      *
656      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
657      * of certain opcodes, possibly making contracts go over the 2300 gas limit
658      * imposed by `transfer`, making them unable to receive funds via
659      * `transfer`. {sendValue} removes this limitation.
660      *
661      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
662      *
663      * IMPORTANT: because control is transferred to `recipient`, care must be
664      * taken to not create reentrancy vulnerabilities. Consider using
665      * {ReentrancyGuard} or the
666      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
667      */
668     function sendValue(address payable recipient, uint256 amount) internal {
669         require(address(this).balance >= amount, "Address: insufficient balance");
670 
671         (bool success, ) = recipient.call{value: amount}("");
672         require(success, "Address: unable to send value, recipient may have reverted");
673     }
674 
675     /**
676      * @dev Performs a Solidity function call using a low level `call`. A
677      * plain `call` is an unsafe replacement for a function call: use this
678      * function instead.
679      *
680      * If `target` reverts with a revert reason, it is bubbled up by this
681      * function (like regular Solidity function calls).
682      *
683      * Returns the raw returned data. To convert to the expected return value,
684      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
685      *
686      * Requirements:
687      *
688      * - `target` must be a contract.
689      * - calling `target` with `data` must not revert.
690      *
691      * _Available since v3.1._
692      */
693     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
694         return functionCall(target, data, "Address: low-level call failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
699      * `errorMessage` as a fallback revert reason when `target` reverts.
700      *
701      * _Available since v3.1._
702      */
703     function functionCall(
704         address target,
705         bytes memory data,
706         string memory errorMessage
707     ) internal returns (bytes memory) {
708         return functionCallWithValue(target, data, 0, errorMessage);
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
713      * but also transferring `value` wei to `target`.
714      *
715      * Requirements:
716      *
717      * - the calling contract must have an ETH balance of at least `value`.
718      * - the called Solidity function must be `payable`.
719      *
720      * _Available since v3.1._
721      */
722     function functionCallWithValue(
723         address target,
724         bytes memory data,
725         uint256 value
726     ) internal returns (bytes memory) {
727         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
732      * with `errorMessage` as a fallback revert reason when `target` reverts.
733      *
734      * _Available since v3.1._
735      */
736     function functionCallWithValue(
737         address target,
738         bytes memory data,
739         uint256 value,
740         string memory errorMessage
741     ) internal returns (bytes memory) {
742         require(address(this).balance >= value, "Address: insufficient balance for call");
743         require(isContract(target), "Address: call to non-contract");
744 
745         (bool success, bytes memory returndata) = target.call{value: value}(data);
746         return verifyCallResult(success, returndata, errorMessage);
747     }
748 
749     /**
750      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
751      * but performing a static call.
752      *
753      * _Available since v3.3._
754      */
755     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
756         return functionStaticCall(target, data, "Address: low-level static call failed");
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
761      * but performing a static call.
762      *
763      * _Available since v3.3._
764      */
765     function functionStaticCall(
766         address target,
767         bytes memory data,
768         string memory errorMessage
769     ) internal view returns (bytes memory) {
770         require(isContract(target), "Address: static call to non-contract");
771 
772         (bool success, bytes memory returndata) = target.staticcall(data);
773         return verifyCallResult(success, returndata, errorMessage);
774     }
775 
776     /**
777      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
778      * but performing a delegate call.
779      *
780      * _Available since v3.4._
781      */
782     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
783         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
788      * but performing a delegate call.
789      *
790      * _Available since v3.4._
791      */
792     function functionDelegateCall(
793         address target,
794         bytes memory data,
795         string memory errorMessage
796     ) internal returns (bytes memory) {
797         require(isContract(target), "Address: delegate call to non-contract");
798 
799         (bool success, bytes memory returndata) = target.delegatecall(data);
800         return verifyCallResult(success, returndata, errorMessage);
801     }
802 
803     /**
804      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
805      * revert reason using the provided one.
806      *
807      * _Available since v4.3._
808      */
809     function verifyCallResult(
810         bool success,
811         bytes memory returndata,
812         string memory errorMessage
813     ) internal pure returns (bytes memory) {
814         if (success) {
815             return returndata;
816         } else {
817             // Look for revert reason and bubble it up if present
818             if (returndata.length > 0) {
819                 // The easiest way to bubble the revert reason is using memory via assembly
820 
821                 assembly {
822                     let returndata_size := mload(returndata)
823                     revert(add(32, returndata), returndata_size)
824                 }
825             } else {
826                 revert(errorMessage);
827             }
828         }
829     }
830 }
831 
832 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
833 
834 
835 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 /**
840  * @title ERC721 token receiver interface
841  * @dev Interface for any contract that wants to support safeTransfers
842  * from ERC721 asset contracts.
843  */
844 interface IERC721Receiver {
845     /**
846      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
847      * by `operator` from `from`, this function is called.
848      *
849      * It must return its Solidity selector to confirm the token transfer.
850      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
851      *
852      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
853      */
854     function onERC721Received(
855         address operator,
856         address from,
857         uint256 tokenId,
858         bytes calldata data
859     ) external returns (bytes4);
860 }
861 
862 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
863 
864 
865 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @dev Interface of the ERC165 standard, as defined in the
871  * https://eips.ethereum.org/EIPS/eip-165[EIP].
872  *
873  * Implementers can declare support of contract interfaces, which can then be
874  * queried by others ({ERC165Checker}).
875  *
876  * For an implementation, see {ERC165}.
877  */
878 interface IERC165 {
879     /**
880      * @dev Returns true if this contract implements the interface defined by
881      * `interfaceId`. See the corresponding
882      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
883      * to learn more about how these ids are created.
884      *
885      * This function call must use less than 30 000 gas.
886      */
887     function supportsInterface(bytes4 interfaceId) external view returns (bool);
888 }
889 
890 // File: @openzeppelin/contracts/interfaces/IERC165.sol
891 
892 
893 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
894 
895 pragma solidity ^0.8.0;
896 
897 
898 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 
906 /**
907  * @dev Interface for the NFT Royalty Standard
908  */
909 interface IERC2981 is IERC165 {
910     /**
911      * @dev Called with the sale price to determine how much royalty is owed and to whom.
912      * @param tokenId - the NFT asset queried for royalty information
913      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
914      * @return receiver - address of who should be sent the royalty payment
915      * @return royaltyAmount - the royalty payment amount for `salePrice`
916      */
917     function royaltyInfo(uint256 tokenId, uint256 salePrice)
918         external
919         view
920         returns (address receiver, uint256 royaltyAmount);
921 }
922 
923 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 
931 /**
932  * @dev Implementation of the {IERC165} interface.
933  *
934  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
935  * for the additional interface id that will be supported. For example:
936  *
937  * ```solidity
938  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
939  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
940  * }
941  * ```
942  *
943  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
944  */
945 abstract contract ERC165 is IERC165 {
946     /**
947      * @dev See {IERC165-supportsInterface}.
948      */
949     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
950         return interfaceId == type(IERC165).interfaceId;
951     }
952 }
953 
954 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
955 
956 
957 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
958 
959 pragma solidity ^0.8.0;
960 
961 
962 /**
963  * @dev Required interface of an ERC721 compliant contract.
964  */
965 interface IERC721 is IERC165 {
966     /**
967      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
968      */
969     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
970 
971     /**
972      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
973      */
974     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
975 
976     /**
977      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
978      */
979     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
980 
981     /**
982      * @dev Returns the number of tokens in ``owner``'s account.
983      */
984     function balanceOf(address owner) external view returns (uint256 balance);
985 
986     /**
987      * @dev Returns the owner of the `tokenId` token.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      */
993     function ownerOf(uint256 tokenId) external view returns (address owner);
994 
995     /**
996      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
997      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
998      *
999      * Requirements:
1000      *
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must exist and be owned by `from`.
1004      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1005      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) external;
1014 
1015     /**
1016      * @dev Transfers `tokenId` token from `from` to `to`.
1017      *
1018      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1019      *
1020      * Requirements:
1021      *
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function transferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) external;
1034 
1035     /**
1036      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1037      * The approval is cleared when the token is transferred.
1038      *
1039      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1040      *
1041      * Requirements:
1042      *
1043      * - The caller must own the token or be an approved operator.
1044      * - `tokenId` must exist.
1045      *
1046      * Emits an {Approval} event.
1047      */
1048     function approve(address to, uint256 tokenId) external;
1049 
1050     /**
1051      * @dev Returns the account approved for `tokenId` token.
1052      *
1053      * Requirements:
1054      *
1055      * - `tokenId` must exist.
1056      */
1057     function getApproved(uint256 tokenId) external view returns (address operator);
1058 
1059     /**
1060      * @dev Approve or remove `operator` as an operator for the caller.
1061      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1062      *
1063      * Requirements:
1064      *
1065      * - The `operator` cannot be the caller.
1066      *
1067      * Emits an {ApprovalForAll} event.
1068      */
1069     function setApprovalForAll(address operator, bool _approved) external;
1070 
1071     /**
1072      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1073      *
1074      * See {setApprovalForAll}
1075      */
1076     function isApprovedForAll(address owner, address operator) external view returns (bool);
1077 
1078     /**
1079      * @dev Safely transfers `tokenId` token from `from` to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must exist and be owned by `from`.
1086      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes calldata data
1096     ) external;
1097 }
1098 
1099 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1100 
1101 
1102 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 
1107 /**
1108  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1109  * @dev See https://eips.ethereum.org/EIPS/eip-721
1110  */
1111 interface IERC721Enumerable is IERC721 {
1112     /**
1113      * @dev Returns the total amount of tokens stored by the contract.
1114      */
1115     function totalSupply() external view returns (uint256);
1116 
1117     /**
1118      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1119      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1120      */
1121     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1122 
1123     /**
1124      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1125      * Use along with {totalSupply} to enumerate all tokens.
1126      */
1127     function tokenByIndex(uint256 index) external view returns (uint256);
1128 }
1129 
1130 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1131 
1132 
1133 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 
1138 /**
1139  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1140  * @dev See https://eips.ethereum.org/EIPS/eip-721
1141  */
1142 interface IERC721Metadata is IERC721 {
1143     /**
1144      * @dev Returns the token collection name.
1145      */
1146     function name() external view returns (string memory);
1147 
1148     /**
1149      * @dev Returns the token collection symbol.
1150      */
1151     function symbol() external view returns (string memory);
1152 
1153     /**
1154      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1155      */
1156     function tokenURI(uint256 tokenId) external view returns (string memory);
1157 }
1158 
1159 // File: contracts/ERC721A.sol
1160 
1161 
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 /**
1174  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1175  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1176  *
1177  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1178  *
1179  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1180  *
1181  * Does not support burning tokens to address(0).
1182  */
1183 contract ERC721A is
1184   Context,
1185   ERC165,
1186   IERC721,
1187   IERC721Metadata,
1188   IERC721Enumerable
1189 {
1190   using Address for address;
1191   using Strings for uint256;
1192 
1193   struct TokenOwnership {
1194     address addr;
1195     uint64 startTimestamp;
1196   }
1197 
1198   struct AddressData {
1199     uint128 balance;
1200     uint128 numberMinted;
1201   }
1202 
1203   uint256 private currentIndex = 0;
1204 
1205   uint256 internal immutable collectionSize;
1206   uint256 internal immutable maxBatchSize;
1207 
1208   // Token name
1209   string private _name;
1210 
1211   // Token symbol
1212   string private _symbol;
1213 
1214   // Mapping from token ID to ownership details
1215   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1216   mapping(uint256 => TokenOwnership) private _ownerships;
1217 
1218   // Mapping owner address to address data
1219   mapping(address => AddressData) private _addressData;
1220 
1221   // Mapping from token ID to approved address
1222   mapping(uint256 => address) private _tokenApprovals;
1223 
1224   // Mapping from owner to operator approvals
1225   mapping(address => mapping(address => bool)) private _operatorApprovals;
1226 
1227   /**
1228    * @dev
1229    * `maxBatchSize` refers to how much a minter can mint at a time.
1230    * `collectionSize_` refers to how many tokens are in the collection.
1231    */
1232   constructor(
1233     string memory name_,
1234     string memory symbol_,
1235     uint256 maxBatchSize_,
1236     uint256 collectionSize_
1237   ) {
1238     require(
1239       collectionSize_ > 0,
1240       "ERC721A: collection must have a nonzero supply"
1241     );
1242     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1243     _name = name_;
1244     _symbol = symbol_;
1245     maxBatchSize = maxBatchSize_;
1246     collectionSize = collectionSize_;
1247   }
1248 
1249   /**
1250    * @dev See {IERC721Enumerable-totalSupply}.
1251    */
1252   function totalSupply() public view override returns (uint256) {
1253     return currentIndex;
1254   }
1255 
1256   /**
1257    * @dev See {IERC721Enumerable-tokenByIndex}.
1258    */
1259   function tokenByIndex(uint256 index) public view override returns (uint256) {
1260     require(index < totalSupply(), "ERC721A: global index out of bounds");
1261     return index;
1262   }
1263 
1264   /**
1265    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1266    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1267    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1268    */
1269   function tokenOfOwnerByIndex(address owner, uint256 index)
1270     public
1271     view
1272     override
1273     returns (uint256)
1274   {
1275     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1276     uint256 numMintedSoFar = totalSupply();
1277     uint256 tokenIdsIdx = 0;
1278     address currOwnershipAddr = address(0);
1279     for (uint256 i = 0; i < numMintedSoFar; i++) {
1280       TokenOwnership memory ownership = _ownerships[i];
1281       if (ownership.addr != address(0)) {
1282         currOwnershipAddr = ownership.addr;
1283       }
1284       if (currOwnershipAddr == owner) {
1285         if (tokenIdsIdx == index) {
1286           return i;
1287         }
1288         tokenIdsIdx++;
1289       }
1290     }
1291     revert("ERC721A: unable to get token of owner by index");
1292   }
1293 
1294   /**
1295    * @dev See {IERC165-supportsInterface}.
1296    */
1297   function supportsInterface(bytes4 interfaceId)
1298     public
1299     view
1300     virtual
1301     override(ERC165, IERC165)
1302     returns (bool)
1303   {
1304     return
1305       interfaceId == type(IERC721).interfaceId ||
1306       interfaceId == type(IERC721Metadata).interfaceId ||
1307       interfaceId == type(IERC721Enumerable).interfaceId ||
1308       super.supportsInterface(interfaceId);
1309   }
1310 
1311   /**
1312    * @dev See {IERC721-balanceOf}.
1313    */
1314   function balanceOf(address owner) public view override returns (uint256) {
1315     require(owner != address(0), "ERC721A: balance query for the zero address");
1316     return uint256(_addressData[owner].balance);
1317   }
1318 
1319   function _numberMinted(address owner) internal view returns (uint256) {
1320     require(
1321       owner != address(0),
1322       "ERC721A: number minted query for the zero address"
1323     );
1324     return uint256(_addressData[owner].numberMinted);
1325   }
1326 
1327   function ownershipOf(uint256 tokenId)
1328     internal
1329     view
1330     returns (TokenOwnership memory)
1331   {
1332     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1333 
1334     uint256 lowestTokenToCheck;
1335     if (tokenId >= maxBatchSize) {
1336       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1337     }
1338 
1339     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1340       TokenOwnership memory ownership = _ownerships[curr];
1341       if (ownership.addr != address(0)) {
1342         return ownership;
1343       }
1344     }
1345 
1346     revert("ERC721A: unable to determine the owner of token");
1347   }
1348 
1349   /**
1350    * @dev See {IERC721-ownerOf}.
1351    */
1352   function ownerOf(uint256 tokenId) public view override returns (address) {
1353     return ownershipOf(tokenId).addr;
1354   }
1355 
1356   /**
1357    * @dev See {IERC721Metadata-name}.
1358    */
1359   function name() public view virtual override returns (string memory) {
1360     return _name;
1361   }
1362 
1363   /**
1364    * @dev See {IERC721Metadata-symbol}.
1365    */
1366   function symbol() public view virtual override returns (string memory) {
1367     return _symbol;
1368   }
1369 
1370   /**
1371    * @dev See {IERC721Metadata-tokenURI}.
1372    */
1373   function tokenURI(uint256 tokenId)
1374     public
1375     view
1376     virtual
1377     override
1378     returns (string memory)
1379   {
1380     require(
1381       _exists(tokenId),
1382       "ERC721Metadata: URI query for nonexistent token"
1383     );
1384 
1385     string memory baseURI = _baseURI();
1386     return
1387       bytes(baseURI).length > 0
1388         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1389         : "";
1390   }
1391 
1392   /**
1393    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1394    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1395    * by default, can be overriden in child contracts.
1396    */
1397   function _baseURI() internal view virtual returns (string memory) {
1398     return "";
1399   }
1400 
1401   /**
1402    * @dev See {IERC721-approve}.
1403    */
1404   function approve(address to, uint256 tokenId) public override {
1405     address owner = ERC721A.ownerOf(tokenId);
1406     require(to != owner, "ERC721A: approval to current owner");
1407 
1408     require(
1409       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1410       "ERC721A: approve caller is not owner nor approved for all"
1411     );
1412 
1413     _approve(to, tokenId, owner);
1414   }
1415 
1416   /**
1417    * @dev See {IERC721-getApproved}.
1418    */
1419   function getApproved(uint256 tokenId) public view override returns (address) {
1420     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1421 
1422     return _tokenApprovals[tokenId];
1423   }
1424 
1425   /**
1426    * @dev See {IERC721-setApprovalForAll}.
1427    */
1428   function setApprovalForAll(address operator, bool approved) public override {
1429     require(operator != _msgSender(), "ERC721A: approve to caller");
1430 
1431     _operatorApprovals[_msgSender()][operator] = approved;
1432     emit ApprovalForAll(_msgSender(), operator, approved);
1433   }
1434 
1435   /**
1436    * @dev See {IERC721-isApprovedForAll}.
1437    */
1438   function isApprovedForAll(address owner, address operator)
1439     public
1440     view
1441     virtual
1442     override
1443     returns (bool)
1444   {
1445     return _operatorApprovals[owner][operator];
1446   }
1447 
1448   /**
1449    * @dev See {IERC721-transferFrom}.
1450    */
1451   function transferFrom(
1452     address from,
1453     address to,
1454     uint256 tokenId
1455   ) public override {
1456     _transfer(from, to, tokenId);
1457   }
1458 
1459   /**
1460    * @dev See {IERC721-safeTransferFrom}.
1461    */
1462   function safeTransferFrom(
1463     address from,
1464     address to,
1465     uint256 tokenId
1466   ) public override {
1467     safeTransferFrom(from, to, tokenId, "");
1468   }
1469 
1470   /**
1471    * @dev See {IERC721-safeTransferFrom}.
1472    */
1473   function safeTransferFrom(
1474     address from,
1475     address to,
1476     uint256 tokenId,
1477     bytes memory _data
1478   ) public override {
1479     _transfer(from, to, tokenId);
1480     require(
1481       _checkOnERC721Received(from, to, tokenId, _data),
1482       "ERC721A: transfer to non ERC721Receiver implementer"
1483     );
1484   }
1485 
1486   /**
1487    * @dev Returns whether `tokenId` exists.
1488    *
1489    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1490    *
1491    * Tokens start existing when they are minted (`_mint`),
1492    */
1493   function _exists(uint256 tokenId) internal view returns (bool) {
1494     return tokenId < currentIndex;
1495   }
1496 
1497   function _safeMint(address to, uint256 quantity) internal {
1498     _safeMint(to, quantity, "");
1499   }
1500 
1501   /**
1502    * @dev Mints `quantity` tokens and transfers them to `to`.
1503    *
1504    * Requirements:
1505    *
1506    * - there must be `quantity` tokens remaining unminted in the total collection.
1507    * - `to` cannot be the zero address.
1508    * - `quantity` cannot be larger than the max batch size.
1509    *
1510    * Emits a {Transfer} event.
1511    */
1512   function _safeMint(
1513     address to,
1514     uint256 quantity,
1515     bytes memory _data
1516   ) internal {
1517     uint256 startTokenId = currentIndex;
1518     require(to != address(0), "ERC721A: mint to the zero address");
1519     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1520     require(!_exists(startTokenId), "ERC721A: token already minted");
1521     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1522 
1523     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1524 
1525     AddressData memory addressData = _addressData[to];
1526     _addressData[to] = AddressData(
1527       addressData.balance + uint128(quantity),
1528       addressData.numberMinted + uint128(quantity)
1529     );
1530     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1531 
1532     uint256 updatedIndex = startTokenId;
1533 
1534     for (uint256 i = 0; i < quantity; i++) {
1535       emit Transfer(address(0), to, updatedIndex);
1536       require(
1537         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1538         "ERC721A: transfer to non ERC721Receiver implementer"
1539       );
1540       updatedIndex++;
1541     }
1542 
1543     currentIndex = updatedIndex;
1544     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1545   }
1546 
1547   /**
1548    * @dev Transfers `tokenId` from `from` to `to`.
1549    *
1550    * Requirements:
1551    *
1552    * - `to` cannot be the zero address.
1553    * - `tokenId` token must be owned by `from`.
1554    *
1555    * Emits a {Transfer} event.
1556    */
1557   function _transfer(
1558     address from,
1559     address to,
1560     uint256 tokenId
1561   ) private {
1562     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1563 
1564     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1565       getApproved(tokenId) == _msgSender() ||
1566       isApprovedForAll(prevOwnership.addr, _msgSender()));
1567 
1568     require(
1569       isApprovedOrOwner,
1570       "ERC721A: transfer caller is not owner nor approved"
1571     );
1572 
1573     require(
1574       prevOwnership.addr == from,
1575       "ERC721A: transfer from incorrect owner"
1576     );
1577     require(to != address(0), "ERC721A: transfer to the zero address");
1578 
1579     _beforeTokenTransfers(from, to, tokenId, 1);
1580 
1581     // Clear approvals from the previous owner
1582     _approve(address(0), tokenId, prevOwnership.addr);
1583 
1584     _addressData[from].balance -= 1;
1585     _addressData[to].balance += 1;
1586     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1587 
1588     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1589     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1590     uint256 nextTokenId = tokenId + 1;
1591     if (_ownerships[nextTokenId].addr == address(0)) {
1592       if (_exists(nextTokenId)) {
1593         _ownerships[nextTokenId] = TokenOwnership(
1594           prevOwnership.addr,
1595           prevOwnership.startTimestamp
1596         );
1597       }
1598     }
1599 
1600     emit Transfer(from, to, tokenId);
1601     _afterTokenTransfers(from, to, tokenId, 1);
1602   }
1603 
1604   /**
1605    * @dev Approve `to` to operate on `tokenId`
1606    *
1607    * Emits a {Approval} event.
1608    */
1609   function _approve(
1610     address to,
1611     uint256 tokenId,
1612     address owner
1613   ) private {
1614     _tokenApprovals[tokenId] = to;
1615     emit Approval(owner, to, tokenId);
1616   }
1617 
1618   uint256 public nextOwnerToExplicitlySet = 0;
1619 
1620   /**
1621    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1622    */
1623   function _setOwnersExplicit(uint256 quantity) internal {
1624     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1625     require(quantity > 0, "quantity must be nonzero");
1626     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1627     if (endIndex > collectionSize - 1) {
1628       endIndex = collectionSize - 1;
1629     }
1630     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1631     require(_exists(endIndex), "not enough minted yet for this cleanup");
1632     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1633       if (_ownerships[i].addr == address(0)) {
1634         TokenOwnership memory ownership = ownershipOf(i);
1635         _ownerships[i] = TokenOwnership(
1636           ownership.addr,
1637           ownership.startTimestamp
1638         );
1639       }
1640     }
1641     nextOwnerToExplicitlySet = endIndex + 1;
1642   }
1643 
1644   /**
1645    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1646    * The call is not executed if the target address is not a contract.
1647    *
1648    * @param from address representing the previous owner of the given token ID
1649    * @param to target address that will receive the tokens
1650    * @param tokenId uint256 ID of the token to be transferred
1651    * @param _data bytes optional data to send along with the call
1652    * @return bool whether the call correctly returned the expected magic value
1653    */
1654   function _checkOnERC721Received(
1655     address from,
1656     address to,
1657     uint256 tokenId,
1658     bytes memory _data
1659   ) private returns (bool) {
1660     if (to.isContract()) {
1661       try
1662         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1663       returns (bytes4 retval) {
1664         return retval == IERC721Receiver(to).onERC721Received.selector;
1665       } catch (bytes memory reason) {
1666         if (reason.length == 0) {
1667           revert("ERC721A: transfer to non ERC721Receiver implementer");
1668         } else {
1669           assembly {
1670             revert(add(32, reason), mload(reason))
1671           }
1672         }
1673       }
1674     } else {
1675       return true;
1676     }
1677   }
1678 
1679   /**
1680    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1681    *
1682    * startTokenId - the first token id to be transferred
1683    * quantity - the amount to be transferred
1684    *
1685    * Calling conditions:
1686    *
1687    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1688    * transferred to `to`.
1689    * - When `from` is zero, `tokenId` will be minted for `to`.
1690    */
1691   function _beforeTokenTransfers(
1692     address from,
1693     address to,
1694     uint256 startTokenId,
1695     uint256 quantity
1696   ) internal virtual {}
1697 
1698   /**
1699    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1700    * minting.
1701    *
1702    * startTokenId - the first token id to be transferred
1703    * quantity - the amount to be transferred
1704    *
1705    * Calling conditions:
1706    *
1707    * - when `from` and `to` are both non-zero.
1708    * - `from` and `to` are never both zero.
1709    */
1710   function _afterTokenTransfers(
1711     address from,
1712     address to,
1713     uint256 startTokenId,
1714     uint256 quantity
1715   ) internal virtual {}
1716 }
1717 
1718 //SPDX-License-Identifier: MIT
1719 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1720 
1721 pragma solidity ^0.8.0;
1722 
1723 
1724 
1725 
1726 
1727 
1728 
1729 
1730 
1731 contract ThePoetry is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1732     using Counters for Counters.Counter;
1733     using Strings for uint256;
1734 
1735     Counters.Counter private tokenCounter;
1736 
1737     string private baseURI = "ipfs://QmZyvpkN4kSYgx2wEfQK8s7p1bappcU1dLxKuBE1yCa9FH";
1738     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1739     bool private isOpenSeaProxyActive = true;
1740 
1741     uint256 public constant MAX_MINTS_PER_TX = 3;
1742     uint256 public maxSupply = 1111;
1743 
1744     uint256 public constant PUBLIC_SALE_PRICE = 0 ether;
1745     bool public isPublicSaleActive = true;
1746 
1747 
1748 
1749 
1750     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1751 
1752     modifier publicSaleActive() {
1753         require(isPublicSaleActive, "Public sale is not open");
1754         _;
1755     }
1756 
1757     modifier maxMintsPerTX(uint256 numberOfTokens) {
1758         require(
1759             numberOfTokens <= MAX_MINTS_PER_TX,
1760             "Max mints per transaction exceeded"
1761         );
1762         _;
1763     }
1764 
1765     modifier canMintNFTs(uint256 numberOfTokens) {
1766         require(
1767             totalSupply() + numberOfTokens <=
1768                 maxSupply,
1769             "Not enough mints remaining to mint"
1770         );
1771         _;
1772     }
1773 
1774     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1775         require(
1776             (price * numberOfTokens) == msg.value,
1777             "Incorrect ETH value sent"
1778         );
1779         _;
1780     }
1781 
1782 
1783     constructor(
1784     ) ERC721A("The Poetry", "Poetry", 100, maxSupply) {
1785     }
1786 
1787     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1788 
1789     function mint(uint256 numberOfTokens)
1790         external
1791         payable
1792         nonReentrant
1793         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1794         publicSaleActive
1795         canMintNFTs(numberOfTokens)
1796         maxMintsPerTX(numberOfTokens)
1797     {
1798 
1799         _safeMint(msg.sender, numberOfTokens);
1800     }
1801 
1802 
1803 
1804     //A simple free mint function to avoid confusion
1805     //The normal mint function with a cost of 0 would work too
1806 
1807     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1808 
1809     function getBaseURI() external view returns (string memory) {
1810         return baseURI;
1811     }
1812 
1813     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1814 
1815     function setBaseURI(string memory _baseURI) external onlyOwner {
1816         baseURI = _baseURI;
1817     }
1818 
1819     function withdraw() public onlyOwner {
1820         uint256 balance = address(this).balance;
1821         payable(msg.sender).transfer(balance);
1822     }
1823 
1824     function withdrawTokens(IERC20 token) public onlyOwner {
1825         uint256 balance = token.balanceOf(address(this));
1826         token.transfer(msg.sender, balance);
1827     }
1828 
1829 
1830 
1831     // ============ SUPPORTING FUNCTIONS ============
1832 
1833     function nextTokenId() private returns (uint256) {
1834         tokenCounter.increment();
1835         return tokenCounter.current();
1836     }
1837 
1838     // ============ FUNCTION OVERRIDES ============
1839 
1840     function supportsInterface(bytes4 interfaceId)
1841         public
1842         view
1843         virtual
1844         override(ERC721A, IERC165)
1845         returns (bool)
1846     {
1847         return
1848             interfaceId == type(IERC2981).interfaceId ||
1849             super.supportsInterface(interfaceId);
1850     }
1851 
1852     /**
1853      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1854      */
1855     function isApprovedForAll(address owner, address operator)
1856         public
1857         view
1858         override
1859         returns (bool)
1860     {
1861         // Get a reference to OpenSea's proxy registry contract by instantiating
1862         // the contract using the already existing address.
1863         ProxyRegistry proxyRegistry = ProxyRegistry(
1864             openSeaProxyRegistryAddress
1865         );
1866         if (
1867             isOpenSeaProxyActive &&
1868             address(proxyRegistry.proxies(owner)) == operator
1869         ) {
1870             return true;
1871         }
1872 
1873         return super.isApprovedForAll(owner, operator);
1874     }
1875 
1876     /**
1877      * @dev See {IERC721Metadata-tokenURI}.
1878      */
1879     function tokenURI(uint256 tokenId)
1880         public
1881         view
1882         virtual
1883         override
1884         returns (string memory)
1885     {
1886         require(_exists(tokenId), "Nonexistent token");
1887 
1888         return
1889             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1890     }
1891 
1892     /**
1893      * @dev See {IERC165-royaltyInfo}.
1894      */
1895     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1896         external
1897         view
1898         override
1899         returns (address receiver, uint256 royaltyAmount)
1900     {
1901         require(_exists(tokenId), "Nonexistent token");
1902 
1903         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1904     }
1905 }
1906 
1907 // These contract definitions are used to create a reference to the OpenSea
1908 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1909 contract OwnableDelegateProxy {
1910 
1911 }
1912 
1913 contract ProxyRegistry {
1914     mapping(address => OwnableDelegateProxy) public proxies;
1915 }