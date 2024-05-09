1 // File: contracts/Degen.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-01-18
5 */
6 
7 // File: contracts/DegenText.sol
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-01-18
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-01-18
15 */
16 
17 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 // CAUTION
25 // This version of SafeMath should only be used with Solidity 0.8 or later,
26 // because it relies on the compiler's built in overflow checks.
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations.
30  *
31  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
32  * now has built in overflow checking.
33  */
34 library SafeMath {
35     /**
36      * @dev Returns the addition of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             uint256 c = a + b;
43             if (c < a) return (false, 0);
44             return (true, c);
45         }
46     }
47 
48     /**
49      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             if (b > a) return (false, 0);
56             return (true, a - b);
57         }
58     }
59 
60     /**
61      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68             // benefit is lost if 'b' is also tested.
69             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
70             if (a == 0) return (true, 0);
71             uint256 c = a * b;
72             if (c / a != b) return (false, 0);
73             return (true, c);
74         }
75     }
76 
77     /**
78      * @dev Returns the division of two unsigned integers, with a division by zero flag.
79      *
80      * _Available since v3.4._
81      */
82     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         unchecked {
84             if (b == 0) return (false, 0);
85             return (true, a / b);
86         }
87     }
88 
89     /**
90      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             if (b == 0) return (false, 0);
97             return (true, a % b);
98         }
99     }
100 
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a + b;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a - b;
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `*` operator.
134      *
135      * Requirements:
136      *
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a * b;
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers, reverting on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator.
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a / b;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * reverting when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a % b;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * CAUTION: This function is deprecated because it requires allocating memory for the error
178      * message unnecessarily. For custom revert reasons use {trySub}.
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(
187         uint256 a,
188         uint256 b,
189         string memory errorMessage
190     ) internal pure returns (uint256) {
191         unchecked {
192             require(b <= a, errorMessage);
193             return a - b;
194         }
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(
210         uint256 a,
211         uint256 b,
212         string memory errorMessage
213     ) internal pure returns (uint256) {
214         unchecked {
215             require(b > 0, errorMessage);
216             return a / b;
217         }
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * reverting with custom message when dividing by zero.
223      *
224      * CAUTION: This function is deprecated because it requires allocating memory for the error
225      * message unnecessarily. For custom revert reasons use {tryMod}.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(
236         uint256 a,
237         uint256 b,
238         string memory errorMessage
239     ) internal pure returns (uint256) {
240         unchecked {
241             require(b > 0, errorMessage);
242             return a % b;
243         }
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Counters.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @title Counters
256  * @author Matt Condon (@shrugs)
257  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
258  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
259  *
260  * Include with `using Counters for Counters.Counter;`
261  */
262 library Counters {
263     struct Counter {
264         // This variable should never be directly accessed by users of the library: interactions must be restricted to
265         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
266         // this feature: see https://github.com/ethereum/solidity/issues/4637
267         uint256 _value; // default: 0
268     }
269 
270     function current(Counter storage counter) internal view returns (uint256) {
271         return counter._value;
272     }
273 
274     function increment(Counter storage counter) internal {
275         unchecked {
276             counter._value += 1;
277         }
278     }
279 
280     function decrement(Counter storage counter) internal {
281         uint256 value = counter._value;
282         require(value > 0, "Counter: decrement overflow");
283         unchecked {
284             counter._value = value - 1;
285         }
286     }
287 
288     function reset(Counter storage counter) internal {
289         counter._value = 0;
290     }
291 }
292 
293 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
294 
295 
296 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Contract module that helps prevent reentrant calls to a function.
302  *
303  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
304  * available, which can be applied to functions to make sure there are no nested
305  * (reentrant) calls to them.
306  *
307  * Note that because there is a single `nonReentrant` guard, functions marked as
308  * `nonReentrant` may not call one another. This can be worked around by making
309  * those functions `private`, and then adding `external` `nonReentrant` entry
310  * points to them.
311  *
312  * TIP: If you would like to learn more about reentrancy and alternative ways
313  * to protect against it, check out our blog post
314  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
315  */
316 abstract contract ReentrancyGuard {
317     // Booleans are more expensive than uint256 or any type that takes up a full
318     // word because each write operation emits an extra SLOAD to first read the
319     // slot's contents, replace the bits taken up by the boolean, and then write
320     // back. This is the compiler's defense against contract upgrades and
321     // pointer aliasing, and it cannot be disabled.
322 
323     // The values being non-zero value makes deployment a bit more expensive,
324     // but in exchange the refund on every call to nonReentrant will be lower in
325     // amount. Since refunds are capped to a percentage of the total
326     // transaction's gas, it is best to keep them low in cases like this one, to
327     // increase the likelihood of the full refund coming into effect.
328     uint256 private constant _NOT_ENTERED = 1;
329     uint256 private constant _ENTERED = 2;
330 
331     uint256 private _status;
332 
333     constructor() {
334         _status = _NOT_ENTERED;
335     }
336 
337     /**
338      * @dev Prevents a contract from calling itself, directly or indirectly.
339      * Calling a `nonReentrant` function from another `nonReentrant`
340      * function is not supported. It is possible to prevent this from happening
341      * by making the `nonReentrant` function external, and making it call a
342      * `private` function that does the actual work.
343      */
344     modifier nonReentrant() {
345         // On the first call to nonReentrant, _notEntered will be true
346         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
347 
348         // Any calls to nonReentrant after this point will fail
349         _status = _ENTERED;
350 
351         _;
352 
353         // By storing the original value once again, a refund is triggered (see
354         // https://eips.ethereum.org/EIPS/eip-2200)
355         _status = _NOT_ENTERED;
356     }
357 }
358 
359 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @dev Interface of the ERC20 standard as defined in the EIP.
368  */
369 interface IERC20 {
370     /**
371      * @dev Returns the amount of tokens in existence.
372      */
373     function totalSupply() external view returns (uint256);
374 
375     /**
376      * @dev Returns the amount of tokens owned by `account`.
377      */
378     function balanceOf(address account) external view returns (uint256);
379 
380     /**
381      * @dev Moves `amount` tokens from the caller's account to `recipient`.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transfer(address recipient, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Returns the remaining number of tokens that `spender` will be
391      * allowed to spend on behalf of `owner` through {transferFrom}. This is
392      * zero by default.
393      *
394      * This value changes when {approve} or {transferFrom} are called.
395      */
396     function allowance(address owner, address spender) external view returns (uint256);
397 
398     /**
399      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * IMPORTANT: Beware that changing an allowance with this method brings the risk
404      * that someone may use both the old and the new allowance by unfortunate
405      * transaction ordering. One possible solution to mitigate this race
406      * condition is to first reduce the spender's allowance to 0 and set the
407      * desired value afterwards:
408      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
409      *
410      * Emits an {Approval} event.
411      */
412     function approve(address spender, uint256 amount) external returns (bool);
413 
414     /**
415      * @dev Moves `amount` tokens from `sender` to `recipient` using the
416      * allowance mechanism. `amount` is then deducted from the caller's
417      * allowance.
418      *
419      * Returns a boolean value indicating whether the operation succeeded.
420      *
421      * Emits a {Transfer} event.
422      */
423     function transferFrom(
424         address sender,
425         address recipient,
426         uint256 amount
427     ) external returns (bool);
428 
429     /**
430      * @dev Emitted when `value` tokens are moved from one account (`from`) to
431      * another (`to`).
432      *
433      * Note that `value` may be zero.
434      */
435     event Transfer(address indexed from, address indexed to, uint256 value);
436 
437     /**
438      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
439      * a call to {approve}. `value` is the new allowance.
440      */
441     event Approval(address indexed owner, address indexed spender, uint256 value);
442 }
443 
444 // File: @openzeppelin/contracts/interfaces/IERC20.sol
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 
452 // File: @openzeppelin/contracts/utils/Strings.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev String operations.
461  */
462 library Strings {
463     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
467      */
468     function toString(uint256 value) internal pure returns (string memory) {
469         // Inspired by OraclizeAPI's implementation - MIT licence
470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
471 
472         if (value == 0) {
473             return "0";
474         }
475         uint256 temp = value;
476         uint256 digits;
477         while (temp != 0) {
478             digits++;
479             temp /= 10;
480         }
481         bytes memory buffer = new bytes(digits);
482         while (value != 0) {
483             digits -= 1;
484             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
485             value /= 10;
486         }
487         return string(buffer);
488     }
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
492      */
493     function toHexString(uint256 value) internal pure returns (string memory) {
494         if (value == 0) {
495             return "0x00";
496         }
497         uint256 temp = value;
498         uint256 length = 0;
499         while (temp != 0) {
500             length++;
501             temp >>= 8;
502         }
503         return toHexString(value, length);
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
508      */
509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
510         bytes memory buffer = new bytes(2 * length + 2);
511         buffer[0] = "0";
512         buffer[1] = "x";
513         for (uint256 i = 2 * length + 1; i > 1; --i) {
514             buffer[i] = _HEX_SYMBOLS[value & 0xf];
515             value >>= 4;
516         }
517         require(value == 0, "Strings: hex length insufficient");
518         return string(buffer);
519     }
520 }
521 
522 // File: @openzeppelin/contracts/utils/Context.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Provides information about the current execution context, including the
531  * sender of the transaction and its data. While these are generally available
532  * via msg.sender and msg.data, they should not be accessed in such a direct
533  * manner, since when dealing with meta-transactions the account sending and
534  * paying for execution may not be the actual sender (as far as an application
535  * is concerned).
536  *
537  * This contract is only required for intermediate, library-like contracts.
538  */
539 abstract contract Context {
540     function _msgSender() internal view virtual returns (address) {
541         return msg.sender;
542     }
543 
544     function _msgData() internal view virtual returns (bytes calldata) {
545         return msg.data;
546     }
547 }
548 
549 // File: @openzeppelin/contracts/access/Ownable.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 /**
558  * @dev Contract module which provides a basic access control mechanism, where
559  * there is an account (an owner) that can be granted exclusive access to
560  * specific functions.
561  *
562  * By default, the owner account will be the one that deploys the contract. This
563  * can later be changed with {transferOwnership}.
564  *
565  * This module is used through inheritance. It will make available the modifier
566  * `onlyOwner`, which can be applied to your functions to restrict their use to
567  * the owner.
568  */
569 abstract contract Ownable is Context {
570     address private _owner;
571 
572     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
573 
574     /**
575      * @dev Initializes the contract setting the deployer as the initial owner.
576      */
577     constructor() {
578         _transferOwnership(_msgSender());
579     }
580 
581     /**
582      * @dev Returns the address of the current owner.
583      */
584     function owner() public view virtual returns (address) {
585         return _owner;
586     }
587 
588     /**
589      * @dev Throws if called by any account other than the owner.
590      */
591     modifier onlyOwner() {
592         require(owner() == _msgSender(), "Ownable: caller is not the owner");
593         _;
594     }
595 
596     /**
597      * @dev Leaves the contract without owner. It will not be possible to call
598      * `onlyOwner` functions anymore. Can only be called by the current owner.
599      *
600      * NOTE: Renouncing ownership will leave the contract without an owner,
601      * thereby removing any functionality that is only available to the owner.
602      */
603     function renounceOwnership() public virtual onlyOwner {
604         _transferOwnership(address(0));
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Can only be called by the current owner.
610      */
611     function transferOwnership(address newOwner) public virtual onlyOwner {
612         require(newOwner != address(0), "Ownable: new owner is the zero address");
613         _transferOwnership(newOwner);
614     }
615 
616     /**
617      * @dev Transfers ownership of the contract to a new account (`newOwner`).
618      * Internal function without access restriction.
619      */
620     function _transferOwnership(address newOwner) internal virtual {
621         address oldOwner = _owner;
622         _owner = newOwner;
623         emit OwnershipTransferred(oldOwner, newOwner);
624     }
625 }
626 
627 // File: @openzeppelin/contracts/utils/Address.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Collection of functions related to the address type
636  */
637 library Address {
638     /**
639      * @dev Returns true if `account` is a contract.
640      *
641      * [IMPORTANT]
642      * ====
643      * It is unsafe to assume that an address for which this function returns
644      * false is an externally-owned account (EOA) and not a contract.
645      *
646      * Among others, `isContract` will return false for the following
647      * types of addresses:
648      *
649      *  - an externally-owned account
650      *  - a contract in construction
651      *  - an address where a contract will be created
652      *  - an address where a contract lived, but was destroyed
653      * ====
654      */
655     function isContract(address account) internal view returns (bool) {
656         // This method relies on extcodesize, which returns 0 for contracts in
657         // construction, since the code is only stored at the end of the
658         // constructor execution.
659 
660         uint256 size;
661         assembly {
662             size := extcodesize(account)
663         }
664         return size > 0;
665     }
666 
667     /**
668      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
669      * `recipient`, forwarding all available gas and reverting on errors.
670      *
671      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
672      * of certain opcodes, possibly making contracts go over the 2300 gas limit
673      * imposed by `transfer`, making them unable to receive funds via
674      * `transfer`. {sendValue} removes this limitation.
675      *
676      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
677      *
678      * IMPORTANT: because control is transferred to `recipient`, care must be
679      * taken to not create reentrancy vulnerabilities. Consider using
680      * {ReentrancyGuard} or the
681      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
682      */
683     function sendValue(address payable recipient, uint256 amount) internal {
684         require(address(this).balance >= amount, "Address: insufficient balance");
685 
686         (bool success, ) = recipient.call{value: amount}("");
687         require(success, "Address: unable to send value, recipient may have reverted");
688     }
689 
690     /**
691      * @dev Performs a Solidity function call using a low level `call`. A
692      * plain `call` is an unsafe replacement for a function call: use this
693      * function instead.
694      *
695      * If `target` reverts with a revert reason, it is bubbled up by this
696      * function (like regular Solidity function calls).
697      *
698      * Returns the raw returned data. To convert to the expected return value,
699      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
700      *
701      * Requirements:
702      *
703      * - `target` must be a contract.
704      * - calling `target` with `data` must not revert.
705      *
706      * _Available since v3.1._
707      */
708     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
709         return functionCall(target, data, "Address: low-level call failed");
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
714      * `errorMessage` as a fallback revert reason when `target` reverts.
715      *
716      * _Available since v3.1._
717      */
718     function functionCall(
719         address target,
720         bytes memory data,
721         string memory errorMessage
722     ) internal returns (bytes memory) {
723         return functionCallWithValue(target, data, 0, errorMessage);
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
728      * but also transferring `value` wei to `target`.
729      *
730      * Requirements:
731      *
732      * - the calling contract must have an ETH balance of at least `value`.
733      * - the called Solidity function must be `payable`.
734      *
735      * _Available since v3.1._
736      */
737     function functionCallWithValue(
738         address target,
739         bytes memory data,
740         uint256 value
741     ) internal returns (bytes memory) {
742         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
747      * with `errorMessage` as a fallback revert reason when `target` reverts.
748      *
749      * _Available since v3.1._
750      */
751     function functionCallWithValue(
752         address target,
753         bytes memory data,
754         uint256 value,
755         string memory errorMessage
756     ) internal returns (bytes memory) {
757         require(address(this).balance >= value, "Address: insufficient balance for call");
758         require(isContract(target), "Address: call to non-contract");
759 
760         (bool success, bytes memory returndata) = target.call{value: value}(data);
761         return verifyCallResult(success, returndata, errorMessage);
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
766      * but performing a static call.
767      *
768      * _Available since v3.3._
769      */
770     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
771         return functionStaticCall(target, data, "Address: low-level static call failed");
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
776      * but performing a static call.
777      *
778      * _Available since v3.3._
779      */
780     function functionStaticCall(
781         address target,
782         bytes memory data,
783         string memory errorMessage
784     ) internal view returns (bytes memory) {
785         require(isContract(target), "Address: static call to non-contract");
786 
787         (bool success, bytes memory returndata) = target.staticcall(data);
788         return verifyCallResult(success, returndata, errorMessage);
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
793      * but performing a delegate call.
794      *
795      * _Available since v3.4._
796      */
797     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
798         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
803      * but performing a delegate call.
804      *
805      * _Available since v3.4._
806      */
807     function functionDelegateCall(
808         address target,
809         bytes memory data,
810         string memory errorMessage
811     ) internal returns (bytes memory) {
812         require(isContract(target), "Address: delegate call to non-contract");
813 
814         (bool success, bytes memory returndata) = target.delegatecall(data);
815         return verifyCallResult(success, returndata, errorMessage);
816     }
817 
818     /**
819      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
820      * revert reason using the provided one.
821      *
822      * _Available since v4.3._
823      */
824     function verifyCallResult(
825         bool success,
826         bytes memory returndata,
827         string memory errorMessage
828     ) internal pure returns (bytes memory) {
829         if (success) {
830             return returndata;
831         } else {
832             // Look for revert reason and bubble it up if present
833             if (returndata.length > 0) {
834                 // The easiest way to bubble the revert reason is using memory via assembly
835 
836                 assembly {
837                     let returndata_size := mload(returndata)
838                     revert(add(32, returndata), returndata_size)
839                 }
840             } else {
841                 revert(errorMessage);
842             }
843         }
844     }
845 }
846 
847 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
848 
849 
850 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
851 
852 pragma solidity ^0.8.0;
853 
854 /**
855  * @title ERC721 token receiver interface
856  * @dev Interface for any contract that wants to support safeTransfers
857  * from ERC721 asset contracts.
858  */
859 interface IERC721Receiver {
860     /**
861      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
862      * by `operator` from `from`, this function is called.
863      *
864      * It must return its Solidity selector to confirm the token transfer.
865      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
866      *
867      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
868      */
869     function onERC721Received(
870         address operator,
871         address from,
872         uint256 tokenId,
873         bytes calldata data
874     ) external returns (bytes4);
875 }
876 
877 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
878 
879 
880 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
881 
882 pragma solidity ^0.8.0;
883 
884 /**
885  * @dev Interface of the ERC165 standard, as defined in the
886  * https://eips.ethereum.org/EIPS/eip-165[EIP].
887  *
888  * Implementers can declare support of contract interfaces, which can then be
889  * queried by others ({ERC165Checker}).
890  *
891  * For an implementation, see {ERC165}.
892  */
893 interface IERC165 {
894     /**
895      * @dev Returns true if this contract implements the interface defined by
896      * `interfaceId`. See the corresponding
897      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
898      * to learn more about how these ids are created.
899      *
900      * This function call must use less than 30 000 gas.
901      */
902     function supportsInterface(bytes4 interfaceId) external view returns (bool);
903 }
904 
905 // File: @openzeppelin/contracts/interfaces/IERC165.sol
906 
907 
908 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 
913 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
914 
915 
916 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
917 
918 pragma solidity ^0.8.0;
919 
920 
921 /**
922  * @dev Interface for the NFT Royalty Standard
923  */
924 interface IERC2981 is IERC165 {
925     /**
926      * @dev Called with the sale price to determine how much royalty is owed and to whom.
927      * @param tokenId - the NFT asset queried for royalty information
928      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
929      * @return receiver - address of who should be sent the royalty payment
930      * @return royaltyAmount - the royalty payment amount for `salePrice`
931      */
932     function royaltyInfo(uint256 tokenId, uint256 salePrice)
933         external
934         view
935         returns (address receiver, uint256 royaltyAmount);
936 }
937 
938 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
939 
940 
941 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 
946 /**
947  * @dev Implementation of the {IERC165} interface.
948  *
949  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
950  * for the additional interface id that will be supported. For example:
951  *
952  * ```solidity
953  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
954  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
955  * }
956  * ```
957  *
958  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
959  */
960 abstract contract ERC165 is IERC165 {
961     /**
962      * @dev See {IERC165-supportsInterface}.
963      */
964     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
965         return interfaceId == type(IERC165).interfaceId;
966     }
967 }
968 
969 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
970 
971 
972 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 
977 /**
978  * @dev Required interface of an ERC721 compliant contract.
979  */
980 interface IERC721 is IERC165 {
981     /**
982      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
983      */
984     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
985 
986     /**
987      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
988      */
989     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
990 
991     /**
992      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
993      */
994     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
995 
996     /**
997      * @dev Returns the number of tokens in ``owner``'s account.
998      */
999     function balanceOf(address owner) external view returns (uint256 balance);
1000 
1001     /**
1002      * @dev Returns the owner of the `tokenId` token.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      */
1008     function ownerOf(uint256 tokenId) external view returns (address owner);
1009 
1010     /**
1011      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1012      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must exist and be owned by `from`.
1019      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) external;
1029 
1030     /**
1031      * @dev Transfers `tokenId` token from `from` to `to`.
1032      *
1033      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1034      *
1035      * Requirements:
1036      *
1037      * - `from` cannot be the zero address.
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must be owned by `from`.
1040      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function transferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) external;
1049 
1050     /**
1051      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1052      * The approval is cleared when the token is transferred.
1053      *
1054      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1055      *
1056      * Requirements:
1057      *
1058      * - The caller must own the token or be an approved operator.
1059      * - `tokenId` must exist.
1060      *
1061      * Emits an {Approval} event.
1062      */
1063     function approve(address to, uint256 tokenId) external;
1064 
1065     /**
1066      * @dev Returns the account approved for `tokenId` token.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      */
1072     function getApproved(uint256 tokenId) external view returns (address operator);
1073 
1074     /**
1075      * @dev Approve or remove `operator` as an operator for the caller.
1076      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1077      *
1078      * Requirements:
1079      *
1080      * - The `operator` cannot be the caller.
1081      *
1082      * Emits an {ApprovalForAll} event.
1083      */
1084     function setApprovalForAll(address operator, bool _approved) external;
1085 
1086     /**
1087      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1088      *
1089      * See {setApprovalForAll}
1090      */
1091     function isApprovedForAll(address owner, address operator) external view returns (bool);
1092 
1093     /**
1094      * @dev Safely transfers `tokenId` token from `from` to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100      * - `tokenId` token must exist and be owned by `from`.
1101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes calldata data
1111     ) external;
1112 }
1113 
1114 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1115 
1116 
1117 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 
1122 /**
1123  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1124  * @dev See https://eips.ethereum.org/EIPS/eip-721
1125  */
1126 interface IERC721Enumerable is IERC721 {
1127     /**
1128      * @dev Returns the total amount of tokens stored by the contract.
1129      */
1130     function totalSupply() external view returns (uint256);
1131 
1132     /**
1133      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1134      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1135      */
1136     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1137 
1138     /**
1139      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1140      * Use along with {totalSupply} to enumerate all tokens.
1141      */
1142     function tokenByIndex(uint256 index) external view returns (uint256);
1143 }
1144 
1145 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1146 
1147 
1148 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1149 
1150 pragma solidity ^0.8.0;
1151 
1152 
1153 /**
1154  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1155  * @dev See https://eips.ethereum.org/EIPS/eip-721
1156  */
1157 interface IERC721Metadata is IERC721 {
1158     /**
1159      * @dev Returns the token collection name.
1160      */
1161     function name() external view returns (string memory);
1162 
1163     /**
1164      * @dev Returns the token collection symbol.
1165      */
1166     function symbol() external view returns (string memory);
1167 
1168     /**
1169      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1170      */
1171     function tokenURI(uint256 tokenId) external view returns (string memory);
1172 }
1173 
1174 // File: contracts/ERC721A.sol
1175 
1176 
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 
1182 
1183 
1184 
1185 
1186 
1187 
1188 /**
1189  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1190  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1191  *
1192  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1193  *
1194  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1195  *
1196  * Does not support burning tokens to address(0).
1197  */
1198 contract ERC721A is
1199   Context,
1200   ERC165,
1201   IERC721,
1202   IERC721Metadata,
1203   IERC721Enumerable
1204 {
1205   using Address for address;
1206   using Strings for uint256;
1207 
1208   struct TokenOwnership {
1209     address addr;
1210     uint64 startTimestamp;
1211   }
1212 
1213   struct AddressData {
1214     uint128 balance;
1215     uint128 numberMinted;
1216   }
1217 
1218   uint256 private currentIndex = 0;
1219 
1220   uint256 internal immutable collectionSize;
1221   uint256 internal immutable maxBatchSize;
1222 
1223   // Token name
1224   string private _name;
1225 
1226   // Token symbol
1227   string private _symbol;
1228 
1229   // Mapping from token ID to ownership details
1230   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1231   mapping(uint256 => TokenOwnership) private _ownerships;
1232 
1233   // Mapping owner address to address data
1234   mapping(address => AddressData) private _addressData;
1235 
1236   // Mapping from token ID to approved address
1237   mapping(uint256 => address) private _tokenApprovals;
1238 
1239   // Mapping from owner to operator approvals
1240   mapping(address => mapping(address => bool)) private _operatorApprovals;
1241 
1242   /**
1243    * @dev
1244    * `maxBatchSize` refers to how much a minter can mint at a time.
1245    * `collectionSize_` refers to how many tokens are in the collection.
1246    */
1247   constructor(
1248     string memory name_,
1249     string memory symbol_,
1250     uint256 maxBatchSize_,
1251     uint256 collectionSize_
1252   ) {
1253     require(
1254       collectionSize_ > 0,
1255       "ERC721A: collection must have a nonzero supply"
1256     );
1257     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1258     _name = name_;
1259     _symbol = symbol_;
1260     maxBatchSize = maxBatchSize_;
1261     collectionSize = collectionSize_;
1262   }
1263 
1264   /**
1265    * @dev See {IERC721Enumerable-totalSupply}.
1266    */
1267   function totalSupply() public view override returns (uint256) {
1268     return currentIndex;
1269   }
1270 
1271   /**
1272    * @dev See {IERC721Enumerable-tokenByIndex}.
1273    */
1274   function tokenByIndex(uint256 index) public view override returns (uint256) {
1275     require(index < totalSupply(), "ERC721A: global index out of bounds");
1276     return index;
1277   }
1278 
1279   /**
1280    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1281    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1282    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1283    */
1284   function tokenOfOwnerByIndex(address owner, uint256 index)
1285     public
1286     view
1287     override
1288     returns (uint256)
1289   {
1290     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1291     uint256 numMintedSoFar = totalSupply();
1292     uint256 tokenIdsIdx = 0;
1293     address currOwnershipAddr = address(0);
1294     for (uint256 i = 0; i < numMintedSoFar; i++) {
1295       TokenOwnership memory ownership = _ownerships[i];
1296       if (ownership.addr != address(0)) {
1297         currOwnershipAddr = ownership.addr;
1298       }
1299       if (currOwnershipAddr == owner) {
1300         if (tokenIdsIdx == index) {
1301           return i;
1302         }
1303         tokenIdsIdx++;
1304       }
1305     }
1306     revert("ERC721A: unable to get token of owner by index");
1307   }
1308 
1309   /**
1310    * @dev See {IERC165-supportsInterface}.
1311    */
1312   function supportsInterface(bytes4 interfaceId)
1313     public
1314     view
1315     virtual
1316     override(ERC165, IERC165)
1317     returns (bool)
1318   {
1319     return
1320       interfaceId == type(IERC721).interfaceId ||
1321       interfaceId == type(IERC721Metadata).interfaceId ||
1322       interfaceId == type(IERC721Enumerable).interfaceId ||
1323       super.supportsInterface(interfaceId);
1324   }
1325 
1326   /**
1327    * @dev See {IERC721-balanceOf}.
1328    */
1329   function balanceOf(address owner) public view override returns (uint256) {
1330     require(owner != address(0), "ERC721A: balance query for the zero address");
1331     return uint256(_addressData[owner].balance);
1332   }
1333 
1334   function _numberMinted(address owner) internal view returns (uint256) {
1335     require(
1336       owner != address(0),
1337       "ERC721A: number minted query for the zero address"
1338     );
1339     return uint256(_addressData[owner].numberMinted);
1340   }
1341 
1342   function ownershipOf(uint256 tokenId)
1343     internal
1344     view
1345     returns (TokenOwnership memory)
1346   {
1347     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1348 
1349     uint256 lowestTokenToCheck;
1350     if (tokenId >= maxBatchSize) {
1351       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1352     }
1353 
1354     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1355       TokenOwnership memory ownership = _ownerships[curr];
1356       if (ownership.addr != address(0)) {
1357         return ownership;
1358       }
1359     }
1360 
1361     revert("ERC721A: unable to determine the owner of token");
1362   }
1363 
1364   /**
1365    * @dev See {IERC721-ownerOf}.
1366    */
1367   function ownerOf(uint256 tokenId) public view override returns (address) {
1368     return ownershipOf(tokenId).addr;
1369   }
1370 
1371   /**
1372    * @dev See {IERC721Metadata-name}.
1373    */
1374   function name() public view virtual override returns (string memory) {
1375     return _name;
1376   }
1377 
1378   /**
1379    * @dev See {IERC721Metadata-symbol}.
1380    */
1381   function symbol() public view virtual override returns (string memory) {
1382     return _symbol;
1383   }
1384 
1385   /**
1386    * @dev See {IERC721Metadata-tokenURI}.
1387    */
1388   function tokenURI(uint256 tokenId)
1389     public
1390     view
1391     virtual
1392     override
1393     returns (string memory)
1394   {
1395     require(
1396       _exists(tokenId),
1397       "ERC721Metadata: URI query for nonexistent token"
1398     );
1399 
1400     string memory baseURI = _baseURI();
1401     return
1402       bytes(baseURI).length > 0
1403         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1404         : "";
1405   }
1406 
1407   /**
1408    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1409    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1410    * by default, can be overriden in child contracts.
1411    */
1412   function _baseURI() internal view virtual returns (string memory) {
1413     return "";
1414   }
1415 
1416   /**
1417    * @dev See {IERC721-approve}.
1418    */
1419   function approve(address to, uint256 tokenId) public override {
1420     address owner = ERC721A.ownerOf(tokenId);
1421     require(to != owner, "ERC721A: approval to current owner");
1422 
1423     require(
1424       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1425       "ERC721A: approve caller is not owner nor approved for all"
1426     );
1427 
1428     _approve(to, tokenId, owner);
1429   }
1430 
1431   /**
1432    * @dev See {IERC721-getApproved}.
1433    */
1434   function getApproved(uint256 tokenId) public view override returns (address) {
1435     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1436 
1437     return _tokenApprovals[tokenId];
1438   }
1439 
1440   /**
1441    * @dev See {IERC721-setApprovalForAll}.
1442    */
1443   function setApprovalForAll(address operator, bool approved) public override {
1444     require(operator != _msgSender(), "ERC721A: approve to caller");
1445 
1446     _operatorApprovals[_msgSender()][operator] = approved;
1447     emit ApprovalForAll(_msgSender(), operator, approved);
1448   }
1449 
1450   /**
1451    * @dev See {IERC721-isApprovedForAll}.
1452    */
1453   function isApprovedForAll(address owner, address operator)
1454     public
1455     view
1456     virtual
1457     override
1458     returns (bool)
1459   {
1460     return _operatorApprovals[owner][operator];
1461   }
1462 
1463   /**
1464    * @dev See {IERC721-transferFrom}.
1465    */
1466   function transferFrom(
1467     address from,
1468     address to,
1469     uint256 tokenId
1470   ) public override {
1471     _transfer(from, to, tokenId);
1472   }
1473 
1474   /**
1475    * @dev See {IERC721-safeTransferFrom}.
1476    */
1477   function safeTransferFrom(
1478     address from,
1479     address to,
1480     uint256 tokenId
1481   ) public override {
1482     safeTransferFrom(from, to, tokenId, "");
1483   }
1484 
1485   /**
1486    * @dev See {IERC721-safeTransferFrom}.
1487    */
1488   function safeTransferFrom(
1489     address from,
1490     address to,
1491     uint256 tokenId,
1492     bytes memory _data
1493   ) public override {
1494     _transfer(from, to, tokenId);
1495     require(
1496       _checkOnERC721Received(from, to, tokenId, _data),
1497       "ERC721A: transfer to non ERC721Receiver implementer"
1498     );
1499   }
1500 
1501   /**
1502    * @dev Returns whether `tokenId` exists.
1503    *
1504    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1505    *
1506    * Tokens start existing when they are minted (`_mint`),
1507    */
1508   function _exists(uint256 tokenId) internal view returns (bool) {
1509     return tokenId < currentIndex;
1510   }
1511 
1512   function _safeMint(address to, uint256 quantity) internal {
1513     _safeMint(to, quantity, "");
1514   }
1515 
1516   /**
1517    * @dev Mints `quantity` tokens and transfers them to `to`.
1518    *
1519    * Requirements:
1520    *
1521    * - there must be `quantity` tokens remaining unminted in the total collection.
1522    * - `to` cannot be the zero address.
1523    * - `quantity` cannot be larger than the max batch size.
1524    *
1525    * Emits a {Transfer} event.
1526    */
1527   function _safeMint(
1528     address to,
1529     uint256 quantity,
1530     bytes memory _data
1531   ) internal {
1532     uint256 startTokenId = currentIndex;
1533     require(to != address(0), "ERC721A: mint to the zero address");
1534     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1535     require(!_exists(startTokenId), "ERC721A: token already minted");
1536     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1537 
1538     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1539 
1540     AddressData memory addressData = _addressData[to];
1541     _addressData[to] = AddressData(
1542       addressData.balance + uint128(quantity),
1543       addressData.numberMinted + uint128(quantity)
1544     );
1545     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1546 
1547     uint256 updatedIndex = startTokenId;
1548 
1549     for (uint256 i = 0; i < quantity; i++) {
1550       emit Transfer(address(0), to, updatedIndex);
1551       require(
1552         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1553         "ERC721A: transfer to non ERC721Receiver implementer"
1554       );
1555       updatedIndex++;
1556     }
1557 
1558     currentIndex = updatedIndex;
1559     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1560   }
1561 
1562   /**
1563    * @dev Transfers `tokenId` from `from` to `to`.
1564    *
1565    * Requirements:
1566    *
1567    * - `to` cannot be the zero address.
1568    * - `tokenId` token must be owned by `from`.
1569    *
1570    * Emits a {Transfer} event.
1571    */
1572   function _transfer(
1573     address from,
1574     address to,
1575     uint256 tokenId
1576   ) private {
1577     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1578 
1579     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1580       getApproved(tokenId) == _msgSender() ||
1581       isApprovedForAll(prevOwnership.addr, _msgSender()));
1582 
1583     require(
1584       isApprovedOrOwner,
1585       "ERC721A: transfer caller is not owner nor approved"
1586     );
1587 
1588     require(
1589       prevOwnership.addr == from,
1590       "ERC721A: transfer from incorrect owner"
1591     );
1592     require(to != address(0), "ERC721A: transfer to the zero address");
1593 
1594     _beforeTokenTransfers(from, to, tokenId, 1);
1595 
1596     // Clear approvals from the previous owner
1597     _approve(address(0), tokenId, prevOwnership.addr);
1598 
1599     _addressData[from].balance -= 1;
1600     _addressData[to].balance += 1;
1601     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1602 
1603     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1604     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1605     uint256 nextTokenId = tokenId + 1;
1606     if (_ownerships[nextTokenId].addr == address(0)) {
1607       if (_exists(nextTokenId)) {
1608         _ownerships[nextTokenId] = TokenOwnership(
1609           prevOwnership.addr,
1610           prevOwnership.startTimestamp
1611         );
1612       }
1613     }
1614 
1615     emit Transfer(from, to, tokenId);
1616     _afterTokenTransfers(from, to, tokenId, 1);
1617   }
1618 
1619   /**
1620    * @dev Approve `to` to operate on `tokenId`
1621    *
1622    * Emits a {Approval} event.
1623    */
1624   function _approve(
1625     address to,
1626     uint256 tokenId,
1627     address owner
1628   ) private {
1629     _tokenApprovals[tokenId] = to;
1630     emit Approval(owner, to, tokenId);
1631   }
1632 
1633   uint256 public nextOwnerToExplicitlySet = 0;
1634 
1635   /**
1636    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1637    */
1638   function _setOwnersExplicit(uint256 quantity) internal {
1639     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1640     require(quantity > 0, "quantity must be nonzero");
1641     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1642     if (endIndex > collectionSize - 1) {
1643       endIndex = collectionSize - 1;
1644     }
1645     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1646     require(_exists(endIndex), "not enough minted yet for this cleanup");
1647     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1648       if (_ownerships[i].addr == address(0)) {
1649         TokenOwnership memory ownership = ownershipOf(i);
1650         _ownerships[i] = TokenOwnership(
1651           ownership.addr,
1652           ownership.startTimestamp
1653         );
1654       }
1655     }
1656     nextOwnerToExplicitlySet = endIndex + 1;
1657   }
1658 
1659   /**
1660    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1661    * The call is not executed if the target address is not a contract.
1662    *
1663    * @param from address representing the previous owner of the given token ID
1664    * @param to target address that will receive the tokens
1665    * @param tokenId uint256 ID of the token to be transferred
1666    * @param _data bytes optional data to send along with the call
1667    * @return bool whether the call correctly returned the expected magic value
1668    */
1669   function _checkOnERC721Received(
1670     address from,
1671     address to,
1672     uint256 tokenId,
1673     bytes memory _data
1674   ) private returns (bool) {
1675     if (to.isContract()) {
1676       try
1677         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1678       returns (bytes4 retval) {
1679         return retval == IERC721Receiver(to).onERC721Received.selector;
1680       } catch (bytes memory reason) {
1681         if (reason.length == 0) {
1682           revert("ERC721A: transfer to non ERC721Receiver implementer");
1683         } else {
1684           assembly {
1685             revert(add(32, reason), mload(reason))
1686           }
1687         }
1688       }
1689     } else {
1690       return true;
1691     }
1692   }
1693 
1694   /**
1695    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1696    *
1697    * startTokenId - the first token id to be transferred
1698    * quantity - the amount to be transferred
1699    *
1700    * Calling conditions:
1701    *
1702    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1703    * transferred to `to`.
1704    * - When `from` is zero, `tokenId` will be minted for `to`.
1705    */
1706   function _beforeTokenTransfers(
1707     address from,
1708     address to,
1709     uint256 startTokenId,
1710     uint256 quantity
1711   ) internal virtual {}
1712 
1713   /**
1714    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1715    * minting.
1716    *
1717    * startTokenId - the first token id to be transferred
1718    * quantity - the amount to be transferred
1719    *
1720    * Calling conditions:
1721    *
1722    * - when `from` and `to` are both non-zero.
1723    * - `from` and `to` are never both zero.
1724    */
1725   function _afterTokenTransfers(
1726     address from,
1727     address to,
1728     uint256 startTokenId,
1729     uint256 quantity
1730   ) internal virtual {}
1731 }
1732 // File: contracts/DegenText.sol
1733 
1734 //SPDX-License-Identifier: MIT
1735 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1736 
1737 pragma solidity ^0.8.0;
1738 
1739 
1740 
1741 
1742 
1743 
1744 
1745 
1746 
1747 contract DegenText is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1748     using Counters for Counters.Counter;
1749     using Strings for uint256;
1750 
1751     Counters.Counter private tokenCounter;
1752 
1753     string private baseURI = "ipfs://Qmf5WhUVpJS5opxpLZFDq6xTp9dcCGjExYKTkn4Ctm7A81";
1754 
1755     uint256 public constant MAX_MINTS_PER_TX = 10;
1756     uint256 public maxSupply = 1999;
1757 
1758     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1759     uint256 public NUM_FREE_MINTS = 1666;
1760     bool public isPublicSaleActive = true;
1761 
1762 
1763 
1764 
1765     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1766 
1767     modifier publicSaleActive() {
1768         require(isPublicSaleActive, "Public sale is not open");
1769         _;
1770     }
1771 
1772 
1773 
1774     modifier maxMintsPerTX(uint256 numberOfTokens) {
1775         require(
1776             numberOfTokens <= MAX_MINTS_PER_TX,
1777             "Max mints per transaction exceeded"
1778         );
1779         _;
1780     }
1781 
1782     modifier canMintNFTs(uint256 numberOfTokens) {
1783         require(
1784             totalSupply() + numberOfTokens <=
1785                 maxSupply,
1786             "Not enough mints remaining to mint"
1787         );
1788         _;
1789     }
1790 
1791     modifier freeMintsAvailable() {
1792         require(
1793             totalSupply() <=
1794                 NUM_FREE_MINTS,
1795             "Not enough free mints remain"
1796         );
1797         _;
1798     }
1799 
1800 
1801 
1802     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1803         if(totalSupply()>NUM_FREE_MINTS){
1804         require(
1805             (price * numberOfTokens) == msg.value,
1806             "Incorrect ETH value sent"
1807         );
1808         }
1809         _;
1810     }
1811 
1812 
1813     constructor(
1814     ) ERC721A("DegenText", "DEGEN", 100, maxSupply) {
1815     }
1816 
1817     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1818 
1819     function mint(uint256 numberOfTokens)
1820         external
1821         payable
1822         nonReentrant
1823         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1824         publicSaleActive
1825         canMintNFTs(numberOfTokens)
1826         maxMintsPerTX(numberOfTokens)
1827     {
1828 
1829         _safeMint(msg.sender, numberOfTokens);
1830     }
1831 
1832 
1833 
1834     //A simple free mint function to avoid confusion
1835     //The normal mint function with a cost of 0 would work too
1836     function freeMint(uint256 numberOfTokens)
1837         external
1838         nonReentrant
1839         publicSaleActive
1840         canMintNFTs(numberOfTokens)
1841         maxMintsPerTX(numberOfTokens)
1842         freeMintsAvailable()
1843     {
1844         _safeMint(msg.sender, numberOfTokens);
1845     }
1846 
1847 
1848 
1849 
1850     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1851 
1852     function getBaseURI() external view returns (string memory) {
1853         return baseURI;
1854     }
1855 
1856     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1857 
1858     function setBaseURI(string memory _baseURI) external onlyOwner {
1859         baseURI = _baseURI;
1860     }
1861 
1862 
1863     function setIsPublicSaleActive(bool _isPublicSaleActive)
1864         external
1865         onlyOwner
1866     {
1867         isPublicSaleActive = _isPublicSaleActive;
1868     }
1869 
1870     function setNumFreeMints(uint256 _numfreemints)
1871         external
1872         onlyOwner
1873     {
1874         NUM_FREE_MINTS = _numfreemints;
1875     }
1876 
1877 
1878     function withdraw() public onlyOwner {
1879         uint256 balance = address(this).balance;
1880         payable(msg.sender).transfer(balance);
1881     }
1882 
1883     function withdrawTokens(IERC20 token) public onlyOwner {
1884         uint256 balance = token.balanceOf(address(this));
1885         token.transfer(msg.sender, balance);
1886     }
1887 
1888 
1889 
1890     // ============ SUPPORTING FUNCTIONS ============
1891 
1892     function nextTokenId() private returns (uint256) {
1893         tokenCounter.increment();
1894         return tokenCounter.current();
1895     }
1896 
1897     // ============ FUNCTION OVERRIDES ============
1898 
1899     function supportsInterface(bytes4 interfaceId)
1900         public
1901         view
1902         virtual
1903         override(ERC721A, IERC165)
1904         returns (bool)
1905     {
1906         return
1907             interfaceId == type(IERC2981).interfaceId ||
1908             super.supportsInterface(interfaceId);
1909     }
1910 
1911     /**
1912      * @dev See {IERC721Metadata-tokenURI}.
1913      */
1914     function tokenURI(uint256 tokenId)
1915         public
1916         view
1917         virtual
1918         override
1919         returns (string memory)
1920     {
1921         require(_exists(tokenId), "Nonexistent token");
1922 
1923         return
1924             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1925     }
1926 
1927     /**
1928      * @dev See {IERC165-royaltyInfo}.
1929      */
1930     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1931         external
1932         view
1933         override
1934         returns (address receiver, uint256 royaltyAmount)
1935     {
1936         require(_exists(tokenId), "Nonexistent token");
1937 
1938         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1939     }
1940 }
1941 
1942 // These contract definitions are used to create a reference to the OpenSea
1943 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1944 contract OwnableDelegateProxy {
1945 
1946 }
1947 
1948 contract ProxyRegistry {
1949     mapping(address => OwnableDelegateProxy) public proxies;
1950 }