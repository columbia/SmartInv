1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-29
7 */
8 
9 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 // CAUTION
17 // This version of SafeMath should only be used with Solidity 0.8 or later,
18 // because it relies on the compiler's built in overflow checks.
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations.
22  *
23  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
24  * now has built in overflow checking.
25  */
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             uint256 c = a + b;
35             if (c < a) return (false, 0);
36             return (true, c);
37         }
38     }
39 
40     /**
41      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             if (b > a) return (false, 0);
48             return (true, a - b);
49         }
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         unchecked {
59             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60             // benefit is lost if 'b' is also tested.
61             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62             if (a == 0) return (true, 0);
63             uint256 c = a * b;
64             if (c / a != b) return (false, 0);
65             return (true, c);
66         }
67     }
68 
69     /**
70      * @dev Returns the division of two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a / b);
78         }
79     }
80 
81     /**
82      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
83      *
84      * _Available since v3.4._
85      */
86     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         unchecked {
88             if (b == 0) return (false, 0);
89             return (true, a % b);
90         }
91     }
92 
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a + b;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return a - b;
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `*` operator.
126      *
127      * Requirements:
128      *
129      * - Multiplication cannot overflow.
130      */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a * b;
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers, reverting on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator.
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a / b;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * reverting when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a % b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * CAUTION: This function is deprecated because it requires allocating memory for the error
170      * message unnecessarily. For custom revert reasons use {trySub}.
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(
179         uint256 a,
180         uint256 b,
181         string memory errorMessage
182     ) internal pure returns (uint256) {
183         unchecked {
184             require(b <= a, errorMessage);
185             return a - b;
186         }
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(
202         uint256 a,
203         uint256 b,
204         string memory errorMessage
205     ) internal pure returns (uint256) {
206         unchecked {
207             require(b > 0, errorMessage);
208             return a / b;
209         }
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * reverting with custom message when dividing by zero.
215      *
216      * CAUTION: This function is deprecated because it requires allocating memory for the error
217      * message unnecessarily. For custom revert reasons use {tryMod}.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(
228         uint256 a,
229         uint256 b,
230         string memory errorMessage
231     ) internal pure returns (uint256) {
232         unchecked {
233             require(b > 0, errorMessage);
234             return a % b;
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Counters.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @title Counters
248  * @author Matt Condon (@shrugs)
249  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
250  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
251  *
252  * Include with `using Counters for Counters.Counter;`
253  */
254 library Counters {
255     struct Counter {
256         // This variable should never be directly accessed by users of the library: interactions must be restricted to
257         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
258         // this feature: see https://github.com/ethereum/solidity/issues/4637
259         uint256 _value; // default: 0
260     }
261 
262     function current(Counter storage counter) internal view returns (uint256) {
263         return counter._value;
264     }
265 
266     function increment(Counter storage counter) internal {
267         unchecked {
268             counter._value += 1;
269         }
270     }
271 
272     function decrement(Counter storage counter) internal {
273         uint256 value = counter._value;
274         require(value > 0, "Counter: decrement overflow");
275         unchecked {
276             counter._value = value - 1;
277         }
278     }
279 
280     function reset(Counter storage counter) internal {
281         counter._value = 0;
282     }
283 }
284 
285 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev Contract module that helps prevent reentrant calls to a function.
294  *
295  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
296  * available, which can be applied to functions to make sure there are no nested
297  * (reentrant) calls to them.
298  *
299  * Note that because there is a single `nonReentrant` guard, functions marked as
300  * `nonReentrant` may not call one another. This can be worked around by making
301  * those functions `private`, and then adding `external` `nonReentrant` entry
302  * points to them.
303  *
304  * TIP: If you would like to learn more about reentrancy and alternative ways
305  * to protect against it, check out our blog post
306  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
307  */
308 abstract contract ReentrancyGuard {
309     // Booleans are more expensive than uint256 or any type that takes up a full
310     // word because each write operation emits an extra SLOAD to first read the
311     // slot's contents, replace the bits taken up by the boolean, and then write
312     // back. This is the compiler's defense against contract upgrades and
313     // pointer aliasing, and it cannot be disabled.
314 
315     // The values being non-zero value makes deployment a bit more expensive,
316     // but in exchange the refund on every call to nonReentrant will be lower in
317     // amount. Since refunds are capped to a percentage of the total
318     // transaction's gas, it is best to keep them low in cases like this one, to
319     // increase the likelihood of the full refund coming into effect.
320     uint256 private constant _NOT_ENTERED = 1;
321     uint256 private constant _ENTERED = 2;
322 
323     uint256 private _status;
324 
325     constructor() {
326         _status = _NOT_ENTERED;
327     }
328 
329     /**
330      * @dev Prevents a contract from calling itself, directly or indirectly.
331      * Calling a `nonReentrant` function from another `nonReentrant`
332      * function is not supported. It is possible to prevent this from happening
333      * by making the `nonReentrant` function external, and making it call a
334      * `private` function that does the actual work.
335      */
336     modifier nonReentrant() {
337         // On the first call to nonReentrant, _notEntered will be true
338         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
339 
340         // Any calls to nonReentrant after this point will fail
341         _status = _ENTERED;
342 
343         _;
344 
345         // By storing the original value once again, a refund is triggered (see
346         // https://eips.ethereum.org/EIPS/eip-2200)
347         _status = _NOT_ENTERED;
348     }
349 }
350 
351 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @dev Interface of the ERC20 standard as defined in the EIP.
360  */
361 interface IERC20 {
362     /**
363      * @dev Returns the amount of tokens in existence.
364      */
365     function totalSupply() external view returns (uint256);
366 
367     /**
368      * @dev Returns the amount of tokens owned by `account`.
369      */
370     function balanceOf(address account) external view returns (uint256);
371 
372     /**
373      * @dev Moves `amount` tokens from the caller's account to `recipient`.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transfer(address recipient, uint256 amount) external returns (bool);
380 
381     /**
382      * @dev Returns the remaining number of tokens that `spender` will be
383      * allowed to spend on behalf of `owner` through {transferFrom}. This is
384      * zero by default.
385      *
386      * This value changes when {approve} or {transferFrom} are called.
387      */
388     function allowance(address owner, address spender) external view returns (uint256);
389 
390     /**
391      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * IMPORTANT: Beware that changing an allowance with this method brings the risk
396      * that someone may use both the old and the new allowance by unfortunate
397      * transaction ordering. One possible solution to mitigate this race
398      * condition is to first reduce the spender's allowance to 0 and set the
399      * desired value afterwards:
400      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
401      *
402      * Emits an {Approval} event.
403      */
404     function approve(address spender, uint256 amount) external returns (bool);
405 
406     /**
407      * @dev Moves `amount` tokens from `sender` to `recipient` using the
408      * allowance mechanism. `amount` is then deducted from the caller's
409      * allowance.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * Emits a {Transfer} event.
414      */
415     function transferFrom(
416         address sender,
417         address recipient,
418         uint256 amount
419     ) external returns (bool);
420 
421     /**
422      * @dev Emitted when `value` tokens are moved from one account (`from`) to
423      * another (`to`).
424      *
425      * Note that `value` may be zero.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 value);
428 
429     /**
430      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
431      * a call to {approve}. `value` is the new allowance.
432      */
433     event Approval(address indexed owner, address indexed spender, uint256 value);
434 }
435 
436 // File: @openzeppelin/contracts/interfaces/IERC20.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 
444 // File: @openzeppelin/contracts/utils/Strings.sol
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev String operations.
453  */
454 library Strings {
455     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
456 
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
459      */
460     function toString(uint256 value) internal pure returns (string memory) {
461         // Inspired by OraclizeAPI's implementation - MIT licence
462         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
463 
464         if (value == 0) {
465             return "0";
466         }
467         uint256 temp = value;
468         uint256 digits;
469         while (temp != 0) {
470             digits++;
471             temp /= 10;
472         }
473         bytes memory buffer = new bytes(digits);
474         while (value != 0) {
475             digits -= 1;
476             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
477             value /= 10;
478         }
479         return string(buffer);
480     }
481 
482     /**
483      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
484      */
485     function toHexString(uint256 value) internal pure returns (string memory) {
486         if (value == 0) {
487             return "0x00";
488         }
489         uint256 temp = value;
490         uint256 length = 0;
491         while (temp != 0) {
492             length++;
493             temp >>= 8;
494         }
495         return toHexString(value, length);
496     }
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
500      */
501     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
502         bytes memory buffer = new bytes(2 * length + 2);
503         buffer[0] = "0";
504         buffer[1] = "x";
505         for (uint256 i = 2 * length + 1; i > 1; --i) {
506             buffer[i] = _HEX_SYMBOLS[value & 0xf];
507             value >>= 4;
508         }
509         require(value == 0, "Strings: hex length insufficient");
510         return string(buffer);
511     }
512 }
513 
514 // File: @openzeppelin/contracts/utils/Context.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Provides information about the current execution context, including the
523  * sender of the transaction and its data. While these are generally available
524  * via msg.sender and msg.data, they should not be accessed in such a direct
525  * manner, since when dealing with meta-transactions the account sending and
526  * paying for execution may not be the actual sender (as far as an application
527  * is concerned).
528  *
529  * This contract is only required for intermediate, library-like contracts.
530  */
531 abstract contract Context {
532     function _msgSender() internal view virtual returns (address) {
533         return msg.sender;
534     }
535 
536     function _msgData() internal view virtual returns (bytes calldata) {
537         return msg.data;
538     }
539 }
540 
541 // File: @openzeppelin/contracts/access/Ownable.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev Contract module which provides a basic access control mechanism, where
551  * there is an account (an owner) that can be granted exclusive access to
552  * specific functions.
553  *
554  * By default, the owner account will be the one that deploys the contract. This
555  * can later be changed with {transferOwnership}.
556  *
557  * This module is used through inheritance. It will make available the modifier
558  * `onlyOwner`, which can be applied to your functions to restrict their use to
559  * the owner.
560  */
561 abstract contract Ownable is Context {
562     address private _owner;
563 
564     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
565 
566     /**
567      * @dev Initializes the contract setting the deployer as the initial owner.
568      */
569     constructor() {
570         _transferOwnership(_msgSender());
571     }
572 
573     /**
574      * @dev Returns the address of the current owner.
575      */
576     function owner() public view virtual returns (address) {
577         return _owner;
578     }
579 
580     /**
581      * @dev Throws if called by any account other than the owner.
582      */
583     modifier onlyOwner() {
584         require(owner() == _msgSender(), "Ownable: caller is not the owner");
585         _;
586     }
587 
588     /**
589      * @dev Leaves the contract without owner. It will not be possible to call
590      * `onlyOwner` functions anymore. Can only be called by the current owner.
591      *
592      * NOTE: Renouncing ownership will leave the contract without an owner,
593      * thereby removing any functionality that is only available to the owner.
594      */
595     function renounceOwnership() public virtual onlyOwner {
596         _transferOwnership(address(0));
597     }
598 
599     /**
600      * @dev Transfers ownership of the contract to a new account (`newOwner`).
601      * Can only be called by the current owner.
602      */
603     function transferOwnership(address newOwner) public virtual onlyOwner {
604         require(newOwner != address(0), "Ownable: new owner is the zero address");
605         _transferOwnership(newOwner);
606     }
607 
608     /**
609      * @dev Transfers ownership of the contract to a new account (`newOwner`).
610      * Internal function without access restriction.
611      */
612     function _transferOwnership(address newOwner) internal virtual {
613         address oldOwner = _owner;
614         _owner = newOwner;
615         emit OwnershipTransferred(oldOwner, newOwner);
616     }
617 }
618 
619 // File: @openzeppelin/contracts/utils/Address.sol
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Collection of functions related to the address type
628  */
629 library Address {
630     /**
631      * @dev Returns true if `account` is a contract.
632      *
633      * [IMPORTANT]
634      * ====
635      * It is unsafe to assume that an address for which this function returns
636      * false is an externally-owned account (EOA) and not a contract.
637      *
638      * Among others, `isContract` will return false for the following
639      * types of addresses:
640      *
641      *  - an externally-owned account
642      *  - a contract in construction
643      *  - an address where a contract will be created
644      *  - an address where a contract lived, but was destroyed
645      * ====
646      */
647     function isContract(address account) internal view returns (bool) {
648         // This method relies on extcodesize, which returns 0 for contracts in
649         // construction, since the code is only stored at the end of the
650         // constructor execution.
651 
652         uint256 size;
653         assembly {
654             size := extcodesize(account)
655         }
656         return size > 0;
657     }
658 
659     /**
660      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
661      * `recipient`, forwarding all available gas and reverting on errors.
662      *
663      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
664      * of certain opcodes, possibly making contracts go over the 2300 gas limit
665      * imposed by `transfer`, making them unable to receive funds via
666      * `transfer`. {sendValue} removes this limitation.
667      *
668      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
669      *
670      * IMPORTANT: because control is transferred to `recipient`, care must be
671      * taken to not create reentrancy vulnerabilities. Consider using
672      * {ReentrancyGuard} or the
673      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
674      */
675     function sendValue(address payable recipient, uint256 amount) internal {
676         require(address(this).balance >= amount, "Address: insufficient balance");
677 
678         (bool success, ) = recipient.call{value: amount}("");
679         require(success, "Address: unable to send value, recipient may have reverted");
680     }
681 
682     /**
683      * @dev Performs a Solidity function call using a low level `call`. A
684      * plain `call` is an unsafe replacement for a function call: use this
685      * function instead.
686      *
687      * If `target` reverts with a revert reason, it is bubbled up by this
688      * function (like regular Solidity function calls).
689      *
690      * Returns the raw returned data. To convert to the expected return value,
691      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
692      *
693      * Requirements:
694      *
695      * - `target` must be a contract.
696      * - calling `target` with `data` must not revert.
697      *
698      * _Available since v3.1._
699      */
700     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
701         return functionCall(target, data, "Address: low-level call failed");
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
706      * `errorMessage` as a fallback revert reason when `target` reverts.
707      *
708      * _Available since v3.1._
709      */
710     function functionCall(
711         address target,
712         bytes memory data,
713         string memory errorMessage
714     ) internal returns (bytes memory) {
715         return functionCallWithValue(target, data, 0, errorMessage);
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
720      * but also transferring `value` wei to `target`.
721      *
722      * Requirements:
723      *
724      * - the calling contract must have an ETH balance of at least `value`.
725      * - the called Solidity function must be `payable`.
726      *
727      * _Available since v3.1._
728      */
729     function functionCallWithValue(
730         address target,
731         bytes memory data,
732         uint256 value
733     ) internal returns (bytes memory) {
734         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
739      * with `errorMessage` as a fallback revert reason when `target` reverts.
740      *
741      * _Available since v3.1._
742      */
743     function functionCallWithValue(
744         address target,
745         bytes memory data,
746         uint256 value,
747         string memory errorMessage
748     ) internal returns (bytes memory) {
749         require(address(this).balance >= value, "Address: insufficient balance for call");
750         require(isContract(target), "Address: call to non-contract");
751 
752         (bool success, bytes memory returndata) = target.call{value: value}(data);
753         return verifyCallResult(success, returndata, errorMessage);
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
758      * but performing a static call.
759      *
760      * _Available since v3.3._
761      */
762     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
763         return functionStaticCall(target, data, "Address: low-level static call failed");
764     }
765 
766     /**
767      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
768      * but performing a static call.
769      *
770      * _Available since v3.3._
771      */
772     function functionStaticCall(
773         address target,
774         bytes memory data,
775         string memory errorMessage
776     ) internal view returns (bytes memory) {
777         require(isContract(target), "Address: static call to non-contract");
778 
779         (bool success, bytes memory returndata) = target.staticcall(data);
780         return verifyCallResult(success, returndata, errorMessage);
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
785      * but performing a delegate call.
786      *
787      * _Available since v3.4._
788      */
789     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
790         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
791     }
792 
793     /**
794      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
795      * but performing a delegate call.
796      *
797      * _Available since v3.4._
798      */
799     function functionDelegateCall(
800         address target,
801         bytes memory data,
802         string memory errorMessage
803     ) internal returns (bytes memory) {
804         require(isContract(target), "Address: delegate call to non-contract");
805 
806         (bool success, bytes memory returndata) = target.delegatecall(data);
807         return verifyCallResult(success, returndata, errorMessage);
808     }
809 
810     /**
811      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
812      * revert reason using the provided one.
813      *
814      * _Available since v4.3._
815      */
816     function verifyCallResult(
817         bool success,
818         bytes memory returndata,
819         string memory errorMessage
820     ) internal pure returns (bytes memory) {
821         if (success) {
822             return returndata;
823         } else {
824             // Look for revert reason and bubble it up if present
825             if (returndata.length > 0) {
826                 // The easiest way to bubble the revert reason is using memory via assembly
827 
828                 assembly {
829                     let returndata_size := mload(returndata)
830                     revert(add(32, returndata), returndata_size)
831                 }
832             } else {
833                 revert(errorMessage);
834             }
835         }
836     }
837 }
838 
839 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
840 
841 
842 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 /**
847  * @title ERC721 token receiver interface
848  * @dev Interface for any contract that wants to support safeTransfers
849  * from ERC721 asset contracts.
850  */
851 interface IERC721Receiver {
852     /**
853      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
854      * by `operator` from `from`, this function is called.
855      *
856      * It must return its Solidity selector to confirm the token transfer.
857      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
858      *
859      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
860      */
861     function onERC721Received(
862         address operator,
863         address from,
864         uint256 tokenId,
865         bytes calldata data
866     ) external returns (bytes4);
867 }
868 
869 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
870 
871 
872 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 /**
877  * @dev Interface of the ERC165 standard, as defined in the
878  * https://eips.ethereum.org/EIPS/eip-165[EIP].
879  *
880  * Implementers can declare support of contract interfaces, which can then be
881  * queried by others ({ERC165Checker}).
882  *
883  * For an implementation, see {ERC165}.
884  */
885 interface IERC165 {
886     /**
887      * @dev Returns true if this contract implements the interface defined by
888      * `interfaceId`. See the corresponding
889      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
890      * to learn more about how these ids are created.
891      *
892      * This function call must use less than 30 000 gas.
893      */
894     function supportsInterface(bytes4 interfaceId) external view returns (bool);
895 }
896 
897 // File: @openzeppelin/contracts/interfaces/IERC165.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
906 
907 
908 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 
913 /**
914  * @dev Interface for the NFT Royalty Standard
915  */
916 interface IERC2981 is IERC165 {
917     /**
918      * @dev Called with the sale price to determine how much royalty is owed and to whom.
919      * @param tokenId - the NFT asset queried for royalty information
920      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
921      * @return receiver - address of who should be sent the royalty payment
922      * @return royaltyAmount - the royalty payment amount for `salePrice`
923      */
924     function royaltyInfo(uint256 tokenId, uint256 salePrice)
925         external
926         view
927         returns (address receiver, uint256 royaltyAmount);
928 }
929 
930 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
931 
932 
933 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 /**
939  * @dev Implementation of the {IERC165} interface.
940  *
941  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
942  * for the additional interface id that will be supported. For example:
943  *
944  * ```solidity
945  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
946  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
947  * }
948  * ```
949  *
950  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
951  */
952 abstract contract ERC165 is IERC165 {
953     /**
954      * @dev See {IERC165-supportsInterface}.
955      */
956     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
957         return interfaceId == type(IERC165).interfaceId;
958     }
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
962 
963 
964 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 
969 /**
970  * @dev Required interface of an ERC721 compliant contract.
971  */
972 interface IERC721 is IERC165 {
973     /**
974      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
975      */
976     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
977 
978     /**
979      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
980      */
981     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
982 
983     /**
984      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
985      */
986     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
987 
988     /**
989      * @dev Returns the number of tokens in ``owner``'s account.
990      */
991     function balanceOf(address owner) external view returns (uint256 balance);
992 
993     /**
994      * @dev Returns the owner of the `tokenId` token.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      */
1000     function ownerOf(uint256 tokenId) external view returns (address owner);
1001 
1002     /**
1003      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1004      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must exist and be owned by `from`.
1011      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1012      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) external;
1021 
1022     /**
1023      * @dev Transfers `tokenId` token from `from` to `to`.
1024      *
1025      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1026      *
1027      * Requirements:
1028      *
1029      * - `from` cannot be the zero address.
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) external;
1041 
1042     /**
1043      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1044      * The approval is cleared when the token is transferred.
1045      *
1046      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1047      *
1048      * Requirements:
1049      *
1050      * - The caller must own the token or be an approved operator.
1051      * - `tokenId` must exist.
1052      *
1053      * Emits an {Approval} event.
1054      */
1055     function approve(address to, uint256 tokenId) external;
1056 
1057     /**
1058      * @dev Returns the account approved for `tokenId` token.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must exist.
1063      */
1064     function getApproved(uint256 tokenId) external view returns (address operator);
1065 
1066     /**
1067      * @dev Approve or remove `operator` as an operator for the caller.
1068      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1069      *
1070      * Requirements:
1071      *
1072      * - The `operator` cannot be the caller.
1073      *
1074      * Emits an {ApprovalForAll} event.
1075      */
1076     function setApprovalForAll(address operator, bool _approved) external;
1077 
1078     /**
1079      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1080      *
1081      * See {setApprovalForAll}
1082      */
1083     function isApprovedForAll(address owner, address operator) external view returns (bool);
1084 
1085     /**
1086      * @dev Safely transfers `tokenId` token from `from` to `to`.
1087      *
1088      * Requirements:
1089      *
1090      * - `from` cannot be the zero address.
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must exist and be owned by `from`.
1093      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes calldata data
1103     ) external;
1104 }
1105 
1106 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1107 
1108 
1109 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1110 
1111 pragma solidity ^0.8.0;
1112 
1113 
1114 /**
1115  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1116  * @dev See https://eips.ethereum.org/EIPS/eip-721
1117  */
1118 interface IERC721Enumerable is IERC721 {
1119     /**
1120      * @dev Returns the total amount of tokens stored by the contract.
1121      */
1122     function totalSupply() external view returns (uint256);
1123 
1124     /**
1125      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1126      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1127      */
1128     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1129 
1130     /**
1131      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1132      * Use along with {totalSupply} to enumerate all tokens.
1133      */
1134     function tokenByIndex(uint256 index) external view returns (uint256);
1135 }
1136 
1137 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1138 
1139 
1140 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 
1145 /**
1146  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1147  * @dev See https://eips.ethereum.org/EIPS/eip-721
1148  */
1149 interface IERC721Metadata is IERC721 {
1150     /**
1151      * @dev Returns the token collection name.
1152      */
1153     function name() external view returns (string memory);
1154 
1155     /**
1156      * @dev Returns the token collection symbol.
1157      */
1158     function symbol() external view returns (string memory);
1159 
1160     /**
1161      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1162      */
1163     function tokenURI(uint256 tokenId) external view returns (string memory);
1164 }
1165 
1166 // File: contracts/ERC721A.sol
1167 
1168 
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 /**
1181  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1182  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1183  *
1184  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1185  *
1186  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1187  *
1188  * Does not support burning tokens to address(0).
1189  */
1190 contract ERC721A is
1191   Context,
1192   ERC165,
1193   IERC721,
1194   IERC721Metadata,
1195   IERC721Enumerable
1196 {
1197   using Address for address;
1198   using Strings for uint256;
1199 
1200   struct TokenOwnership {
1201     address addr;
1202     uint64 startTimestamp;
1203   }
1204 
1205   struct AddressData {
1206     uint128 balance;
1207     uint128 numberMinted;
1208   }
1209 
1210   uint256 private currentIndex = 0;
1211 
1212   uint256 internal immutable collectionSize;
1213   uint256 internal immutable maxBatchSize;
1214 
1215   // Token name
1216   string private _name;
1217 
1218   // Token symbol
1219   string private _symbol;
1220 
1221   // Mapping from token ID to ownership details
1222   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1223   mapping(uint256 => TokenOwnership) private _ownerships;
1224 
1225   // Mapping owner address to address data
1226   mapping(address => AddressData) private _addressData;
1227 
1228   // Mapping from token ID to approved address
1229   mapping(uint256 => address) private _tokenApprovals;
1230 
1231   // Mapping from owner to operator approvals
1232   mapping(address => mapping(address => bool)) private _operatorApprovals;
1233 
1234   /**
1235    * @dev
1236    * `maxBatchSize` refers to how much a minter can mint at a time.
1237    * `collectionSize_` refers to how many tokens are in the collection.
1238    */
1239   constructor(
1240     string memory name_,
1241     string memory symbol_,
1242     uint256 maxBatchSize_,
1243     uint256 collectionSize_
1244   ) {
1245     require(
1246       collectionSize_ > 0,
1247       "ERC721A: collection must have a nonzero supply"
1248     );
1249     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1250     _name = name_;
1251     _symbol = symbol_;
1252     maxBatchSize = maxBatchSize_;
1253     collectionSize = collectionSize_;
1254   }
1255 
1256   /**
1257    * @dev See {IERC721Enumerable-totalSupply}.
1258    */
1259   function totalSupply() public view override returns (uint256) {
1260     return currentIndex;
1261   }
1262 
1263   /**
1264    * @dev See {IERC721Enumerable-tokenByIndex}.
1265    */
1266   function tokenByIndex(uint256 index) public view override returns (uint256) {
1267     require(index < totalSupply(), "ERC721A: global index out of bounds");
1268     return index;
1269   }
1270 
1271   /**
1272    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1273    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1274    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1275    */
1276   function tokenOfOwnerByIndex(address owner, uint256 index)
1277     public
1278     view
1279     override
1280     returns (uint256)
1281   {
1282     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1283     uint256 numMintedSoFar = totalSupply();
1284     uint256 tokenIdsIdx = 0;
1285     address currOwnershipAddr = address(0);
1286     for (uint256 i = 0; i < numMintedSoFar; i++) {
1287       TokenOwnership memory ownership = _ownerships[i];
1288       if (ownership.addr != address(0)) {
1289         currOwnershipAddr = ownership.addr;
1290       }
1291       if (currOwnershipAddr == owner) {
1292         if (tokenIdsIdx == index) {
1293           return i;
1294         }
1295         tokenIdsIdx++;
1296       }
1297     }
1298     revert("ERC721A: unable to get token of owner by index");
1299   }
1300 
1301   /**
1302    * @dev See {IERC165-supportsInterface}.
1303    */
1304   function supportsInterface(bytes4 interfaceId)
1305     public
1306     view
1307     virtual
1308     override(ERC165, IERC165)
1309     returns (bool)
1310   {
1311     return
1312       interfaceId == type(IERC721).interfaceId ||
1313       interfaceId == type(IERC721Metadata).interfaceId ||
1314       interfaceId == type(IERC721Enumerable).interfaceId ||
1315       super.supportsInterface(interfaceId);
1316   }
1317 
1318   /**
1319    * @dev See {IERC721-balanceOf}.
1320    */
1321   function balanceOf(address owner) public view override returns (uint256) {
1322     require(owner != address(0), "ERC721A: balance query for the zero address");
1323     return uint256(_addressData[owner].balance);
1324   }
1325 
1326   function _numberMinted(address owner) internal view returns (uint256) {
1327     require(
1328       owner != address(0),
1329       "ERC721A: number minted query for the zero address"
1330     );
1331     return uint256(_addressData[owner].numberMinted);
1332   }
1333 
1334   function ownershipOf(uint256 tokenId)
1335     internal
1336     view
1337     returns (TokenOwnership memory)
1338   {
1339     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1340 
1341     uint256 lowestTokenToCheck;
1342     if (tokenId >= maxBatchSize) {
1343       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1344     }
1345 
1346     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1347       TokenOwnership memory ownership = _ownerships[curr];
1348       if (ownership.addr != address(0)) {
1349         return ownership;
1350       }
1351     }
1352 
1353     revert("ERC721A: unable to determine the owner of token");
1354   }
1355 
1356   /**
1357    * @dev See {IERC721-ownerOf}.
1358    */
1359   function ownerOf(uint256 tokenId) public view override returns (address) {
1360     return ownershipOf(tokenId).addr;
1361   }
1362 
1363   /**
1364    * @dev See {IERC721Metadata-name}.
1365    */
1366   function name() public view virtual override returns (string memory) {
1367     return _name;
1368   }
1369 
1370   /**
1371    * @dev See {IERC721Metadata-symbol}.
1372    */
1373   function symbol() public view virtual override returns (string memory) {
1374     return _symbol;
1375   }
1376 
1377   /**
1378    * @dev See {IERC721Metadata-tokenURI}.
1379    */
1380   function tokenURI(uint256 tokenId)
1381     public
1382     view
1383     virtual
1384     override
1385     returns (string memory)
1386   {
1387     require(
1388       _exists(tokenId),
1389       "ERC721Metadata: URI query for nonexistent token"
1390     );
1391 
1392     string memory baseURI = _baseURI();
1393     return
1394       bytes(baseURI).length > 0
1395         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1396         : "";
1397   }
1398 
1399   /**
1400    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1401    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1402    * by default, can be overriden in child contracts.
1403    */
1404   function _baseURI() internal view virtual returns (string memory) {
1405     return "";
1406   }
1407 
1408   /**
1409    * @dev See {IERC721-approve}.
1410    */
1411   function approve(address to, uint256 tokenId) public override {
1412     address owner = ERC721A.ownerOf(tokenId);
1413     require(to != owner, "ERC721A: approval to current owner");
1414 
1415     require(
1416       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1417       "ERC721A: approve caller is not owner nor approved for all"
1418     );
1419 
1420     _approve(to, tokenId, owner);
1421   }
1422 
1423   /**
1424    * @dev See {IERC721-getApproved}.
1425    */
1426   function getApproved(uint256 tokenId) public view override returns (address) {
1427     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1428 
1429     return _tokenApprovals[tokenId];
1430   }
1431 
1432   /**
1433    * @dev See {IERC721-setApprovalForAll}.
1434    */
1435   function setApprovalForAll(address operator, bool approved) public override {
1436     require(operator != _msgSender(), "ERC721A: approve to caller");
1437 
1438     _operatorApprovals[_msgSender()][operator] = approved;
1439     emit ApprovalForAll(_msgSender(), operator, approved);
1440   }
1441 
1442   /**
1443    * @dev See {IERC721-isApprovedForAll}.
1444    */
1445   function isApprovedForAll(address owner, address operator)
1446     public
1447     view
1448     virtual
1449     override
1450     returns (bool)
1451   {
1452     return _operatorApprovals[owner][operator];
1453   }
1454 
1455   /**
1456    * @dev See {IERC721-transferFrom}.
1457    */
1458   function transferFrom(
1459     address from,
1460     address to,
1461     uint256 tokenId
1462   ) public override {
1463     _transfer(from, to, tokenId);
1464   }
1465 
1466   /**
1467    * @dev See {IERC721-safeTransferFrom}.
1468    */
1469   function safeTransferFrom(
1470     address from,
1471     address to,
1472     uint256 tokenId
1473   ) public override {
1474     safeTransferFrom(from, to, tokenId, "");
1475   }
1476 
1477   /**
1478    * @dev See {IERC721-safeTransferFrom}.
1479    */
1480   function safeTransferFrom(
1481     address from,
1482     address to,
1483     uint256 tokenId,
1484     bytes memory _data
1485   ) public override {
1486     _transfer(from, to, tokenId);
1487     require(
1488       _checkOnERC721Received(from, to, tokenId, _data),
1489       "ERC721A: transfer to non ERC721Receiver implementer"
1490     );
1491   }
1492 
1493   /**
1494    * @dev Returns whether `tokenId` exists.
1495    *
1496    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1497    *
1498    * Tokens start existing when they are minted (`_mint`),
1499    */
1500   function _exists(uint256 tokenId) internal view returns (bool) {
1501     return tokenId < currentIndex;
1502   }
1503 
1504   function _safeMint(address to, uint256 quantity) internal {
1505     _safeMint(to, quantity, "");
1506   }
1507 
1508   /**
1509    * @dev Mints `quantity` tokens and transfers them to `to`.
1510    *
1511    * Requirements:
1512    *
1513    * - there must be `quantity` tokens remaining unminted in the total collection.
1514    * - `to` cannot be the zero address.
1515    * - `quantity` cannot be larger than the max batch size.
1516    *
1517    * Emits a {Transfer} event.
1518    */
1519   function _safeMint(
1520     address to,
1521     uint256 quantity,
1522     bytes memory _data
1523   ) internal {
1524     uint256 startTokenId = currentIndex;
1525     require(to != address(0), "ERC721A: mint to the zero address");
1526     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1527     require(!_exists(startTokenId), "ERC721A: token already minted");
1528     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1529 
1530     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1531 
1532     AddressData memory addressData = _addressData[to];
1533     _addressData[to] = AddressData(
1534       addressData.balance + uint128(quantity),
1535       addressData.numberMinted + uint128(quantity)
1536     );
1537     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1538 
1539     uint256 updatedIndex = startTokenId;
1540 
1541     for (uint256 i = 0; i < quantity; i++) {
1542       emit Transfer(address(0), to, updatedIndex);
1543       require(
1544         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1545         "ERC721A: transfer to non ERC721Receiver implementer"
1546       );
1547       updatedIndex++;
1548     }
1549 
1550     currentIndex = updatedIndex;
1551     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1552   }
1553 
1554   /**
1555    * @dev Transfers `tokenId` from `from` to `to`.
1556    *
1557    * Requirements:
1558    *
1559    * - `to` cannot be the zero address.
1560    * - `tokenId` token must be owned by `from`.
1561    *
1562    * Emits a {Transfer} event.
1563    */
1564   function _transfer(
1565     address from,
1566     address to,
1567     uint256 tokenId
1568   ) private {
1569     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1570 
1571     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1572       getApproved(tokenId) == _msgSender() ||
1573       isApprovedForAll(prevOwnership.addr, _msgSender()));
1574 
1575     require(
1576       isApprovedOrOwner,
1577       "ERC721A: transfer caller is not owner nor approved"
1578     );
1579 
1580     require(
1581       prevOwnership.addr == from,
1582       "ERC721A: transfer from incorrect owner"
1583     );
1584     require(to != address(0), "ERC721A: transfer to the zero address");
1585 
1586     _beforeTokenTransfers(from, to, tokenId, 1);
1587 
1588     // Clear approvals from the previous owner
1589     _approve(address(0), tokenId, prevOwnership.addr);
1590 
1591     _addressData[from].balance -= 1;
1592     _addressData[to].balance += 1;
1593     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1594 
1595     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1596     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1597     uint256 nextTokenId = tokenId + 1;
1598     if (_ownerships[nextTokenId].addr == address(0)) {
1599       if (_exists(nextTokenId)) {
1600         _ownerships[nextTokenId] = TokenOwnership(
1601           prevOwnership.addr,
1602           prevOwnership.startTimestamp
1603         );
1604       }
1605     }
1606 
1607     emit Transfer(from, to, tokenId);
1608     _afterTokenTransfers(from, to, tokenId, 1);
1609   }
1610 
1611   /**
1612    * @dev Approve `to` to operate on `tokenId`
1613    *
1614    * Emits a {Approval} event.
1615    */
1616   function _approve(
1617     address to,
1618     uint256 tokenId,
1619     address owner
1620   ) private {
1621     _tokenApprovals[tokenId] = to;
1622     emit Approval(owner, to, tokenId);
1623   }
1624 
1625   uint256 public nextOwnerToExplicitlySet = 0;
1626 
1627   /**
1628    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1629    */
1630   function _setOwnersExplicit(uint256 quantity) internal {
1631     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1632     require(quantity > 0, "quantity must be nonzero");
1633     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1634     if (endIndex > collectionSize - 1) {
1635       endIndex = collectionSize - 1;
1636     }
1637     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1638     require(_exists(endIndex), "not enough minted yet for this cleanup");
1639     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1640       if (_ownerships[i].addr == address(0)) {
1641         TokenOwnership memory ownership = ownershipOf(i);
1642         _ownerships[i] = TokenOwnership(
1643           ownership.addr,
1644           ownership.startTimestamp
1645         );
1646       }
1647     }
1648     nextOwnerToExplicitlySet = endIndex + 1;
1649   }
1650 
1651   /**
1652    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1653    * The call is not executed if the target address is not a contract.
1654    *
1655    * @param from address representing the previous owner of the given token ID
1656    * @param to target address that will receive the tokens
1657    * @param tokenId uint256 ID of the token to be transferred
1658    * @param _data bytes optional data to send along with the call
1659    * @return bool whether the call correctly returned the expected magic value
1660    */
1661   function _checkOnERC721Received(
1662     address from,
1663     address to,
1664     uint256 tokenId,
1665     bytes memory _data
1666   ) private returns (bool) {
1667     if (to.isContract()) {
1668       try
1669         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1670       returns (bytes4 retval) {
1671         return retval == IERC721Receiver(to).onERC721Received.selector;
1672       } catch (bytes memory reason) {
1673         if (reason.length == 0) {
1674           revert("ERC721A: transfer to non ERC721Receiver implementer");
1675         } else {
1676           assembly {
1677             revert(add(32, reason), mload(reason))
1678           }
1679         }
1680       }
1681     } else {
1682       return true;
1683     }
1684   }
1685 
1686   /**
1687    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1688    *
1689    * startTokenId - the first token id to be transferred
1690    * quantity - the amount to be transferred
1691    *
1692    * Calling conditions:
1693    *
1694    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1695    * transferred to `to`.
1696    * - When `from` is zero, `tokenId` will be minted for `to`.
1697    */
1698   function _beforeTokenTransfers(
1699     address from,
1700     address to,
1701     uint256 startTokenId,
1702     uint256 quantity
1703   ) internal virtual {}
1704 
1705   /**
1706    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1707    * minting.
1708    *
1709    * startTokenId - the first token id to be transferred
1710    * quantity - the amount to be transferred
1711    *
1712    * Calling conditions:
1713    *
1714    * - when `from` and `to` are both non-zero.
1715    * - `from` and `to` are never both zero.
1716    */
1717   function _afterTokenTransfers(
1718     address from,
1719     address to,
1720     uint256 startTokenId,
1721     uint256 quantity
1722   ) internal virtual {}
1723 }
1724 
1725 //SPDX-License-Identifier: MIT
1726 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1727 
1728 pragma solidity ^0.8.0;
1729 
1730 
1731 
1732 
1733 
1734 
1735 
1736 
1737 
1738 contract GOONYGOBLINS is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1739     using Counters for Counters.Counter;
1740     using Strings for uint256;
1741 
1742     Counters.Counter private tokenCounter;
1743 
1744     string private baseURI = "https://goblingoonslair.com/goblin";
1745     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1746     bool private isOpenSeaProxyActive = true;
1747 
1748     uint256 public constant MAX_MINTS_PER_TX = 10;
1749     uint256 public maxSupply = 4444;
1750 
1751     uint256 public constant PUBLIC_SALE_PRICE = 0.003 ether;
1752     uint256 public NUM_FREE_MINTS = 1000;
1753     bool public isPublicSaleActive = true;
1754 
1755 
1756 
1757 
1758     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1759 
1760     modifier publicSaleActive() {
1761         require(isPublicSaleActive, "Public sale is not open");
1762         _;
1763     }
1764 
1765 
1766 
1767     modifier maxMintsPerTX(uint256 numberOfTokens) {
1768         require(
1769             numberOfTokens <= MAX_MINTS_PER_TX,
1770             "Max mints per transaction exceeded"
1771         );
1772         _;
1773     }
1774 
1775     modifier canMintNFTs(uint256 numberOfTokens) {
1776         require(
1777             totalSupply() + numberOfTokens <=
1778                 maxSupply,
1779             "Not enough mints remaining to mint"
1780         );
1781         _;
1782     }
1783 
1784     modifier freeMintsAvailable() {
1785         require(
1786             totalSupply() <=
1787                 NUM_FREE_MINTS,
1788             "Not enough free mints remain"
1789         );
1790         _;
1791     }
1792 
1793 
1794 
1795     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1796         if(totalSupply()>NUM_FREE_MINTS){
1797         require(
1798             (price * numberOfTokens) == msg.value,
1799             "Incorrect ETH value sent"
1800         );
1801         }
1802         _;
1803     }
1804 
1805 
1806     constructor(
1807     ) ERC721A("GOONY GOBLINS", "GOBLINS", 100, maxSupply) {
1808     }
1809 
1810     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1811 
1812     function mint(uint256 numberOfTokens)
1813         external
1814         payable
1815         nonReentrant
1816         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1817         publicSaleActive
1818         canMintNFTs(numberOfTokens)
1819         maxMintsPerTX(numberOfTokens)
1820     {
1821 
1822         _safeMint(msg.sender, numberOfTokens);
1823     }
1824 
1825 
1826 
1827     //A simple free mint function to avoid confusion
1828     //The normal mint function with a cost of 0 would work too
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
1842     // function to disable gasless listings for security in case
1843     // opensea ever shuts down or is compromised
1844     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1845         external
1846         onlyOwner
1847     {
1848         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1849     }
1850 
1851     function setIsPublicSaleActive(bool _isPublicSaleActive)
1852         external
1853         onlyOwner
1854     {
1855         isPublicSaleActive = _isPublicSaleActive;
1856     }
1857 
1858 
1859     function magicbutton(uint256 _numfreemints)
1860         external
1861         onlyOwner
1862     {
1863         NUM_FREE_MINTS = _numfreemints;
1864     }
1865 
1866 
1867     function withdraw() public onlyOwner {
1868         uint256 balance = address(this).balance;
1869         payable(msg.sender).transfer(balance);
1870     }
1871 
1872     function withdrawTokens(IERC20 token) public onlyOwner {
1873         uint256 balance = token.balanceOf(address(this));
1874         token.transfer(msg.sender, balance);
1875     }
1876 
1877 
1878 
1879     // ============ SUPPORTING FUNCTIONS ============
1880 
1881     function nextTokenId() private returns (uint256) {
1882         tokenCounter.increment();
1883         return tokenCounter.current();
1884     }
1885 
1886     // ============ FUNCTION OVERRIDES ============
1887 
1888     function supportsInterface(bytes4 interfaceId)
1889         public
1890         view
1891         virtual
1892         override(ERC721A, IERC165)
1893         returns (bool)
1894     {
1895         return
1896             interfaceId == type(IERC2981).interfaceId ||
1897             super.supportsInterface(interfaceId);
1898     }
1899 
1900     /**
1901      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1902      */
1903     function isApprovedForAll(address owner, address operator)
1904         public
1905         view
1906         override
1907         returns (bool)
1908     {
1909         // Get a reference to OpenSea's proxy registry contract by instantiating
1910         // the contract using the already existing address.
1911         ProxyRegistry proxyRegistry = ProxyRegistry(
1912             openSeaProxyRegistryAddress
1913         );
1914         if (
1915             isOpenSeaProxyActive &&
1916             address(proxyRegistry.proxies(owner)) == operator
1917         ) {
1918             return true;
1919         }
1920 
1921         return super.isApprovedForAll(owner, operator);
1922     }
1923 
1924     /**
1925      * @dev See {IERC721Metadata-tokenURI}.
1926      */
1927     function tokenURI(uint256 tokenId)
1928         public
1929         view
1930         virtual
1931         override
1932         returns (string memory)
1933     {
1934         require(_exists(tokenId), "Nonexistent token");
1935 
1936         return
1937             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ""));
1938     }
1939 
1940     /**
1941      * @dev See {IERC165-royaltyInfo}.
1942      */
1943     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1944         external
1945         view
1946         override
1947         returns (address receiver, uint256 royaltyAmount)
1948     {
1949         require(_exists(tokenId), "Nonexistent token");
1950 
1951         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1952     }
1953 }
1954 
1955 // These contract definitions are used to create a reference to the OpenSea
1956 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1957 contract OwnableDelegateProxy {
1958 
1959 }
1960 
1961 contract ProxyRegistry {
1962     mapping(address => OwnableDelegateProxy) public proxies;
1963 }