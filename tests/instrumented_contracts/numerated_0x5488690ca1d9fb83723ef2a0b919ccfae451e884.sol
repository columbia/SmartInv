1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ██      ██    ██  ██████ ██   ██ ██    ██     ████████ ███████  █████   ██████ ██    ██ ██████      ██████  ██  ██████   ██████  ██ ███████ ███████ 
6 ██      ██    ██ ██      ██  ██   ██  ██         ██    ██      ██   ██ ██      ██    ██ ██   ██     ██   ██ ██ ██       ██       ██ ██      ██      
7 ██      ██    ██ ██      █████     ████          ██    █████   ███████ ██      ██    ██ ██████      ██████  ██ ██   ███ ██   ███ ██ █████   ███████ 
8 ██      ██    ██ ██      ██  ██     ██           ██    ██      ██   ██ ██      ██    ██ ██          ██      ██ ██    ██ ██    ██ ██ ██           ██ 
9 ███████  ██████   ██████ ██   ██    ██           ██    ███████ ██   ██  ██████  ██████  ██          ██      ██  ██████   ██████  ██ ███████ ███████  
10                                                                                                                                                                                
11                                                                                                                                                                                
12 
13 */
14 
15 
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
969 
970 
971 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
972 
973 pragma solidity ^0.8.0;
974 
975 
976 /**
977  * @dev Required interface of an ERC721 compliant contract.
978  */
979 interface IERC721 is IERC165 {
980     /**
981      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
982      */
983     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
984 
985     /**
986      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
987      */
988     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
989 
990     /**
991      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
992      */
993     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
994 
995     /**
996      * @dev Returns the number of tokens in ``owner``'s account.
997      */
998     function balanceOf(address owner) external view returns (uint256 balance);
999 
1000     /**
1001      * @dev Returns the owner of the `tokenId` token.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must exist.
1006      */
1007     function ownerOf(uint256 tokenId) external view returns (address owner);
1008 
1009     /**
1010      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1011      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1012      *
1013      * Requirements:
1014      *
1015      * - `from` cannot be the zero address.
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must exist and be owned by `from`.
1018      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1019      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) external;
1028 
1029     /**
1030      * @dev Transfers `tokenId` token from `from` to `to`.
1031      *
1032      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1033      *
1034      * Requirements:
1035      *
1036      * - `from` cannot be the zero address.
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function transferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) external;
1048 
1049     /**
1050      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1051      * The approval is cleared when the token is transferred.
1052      *
1053      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1054      *
1055      * Requirements:
1056      *
1057      * - The caller must own the token or be an approved operator.
1058      * - `tokenId` must exist.
1059      *
1060      * Emits an {Approval} event.
1061      */
1062     function approve(address to, uint256 tokenId) external;
1063 
1064     /**
1065      * @dev Returns the account approved for `tokenId` token.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must exist.
1070      */
1071     function getApproved(uint256 tokenId) external view returns (address operator);
1072 
1073     /**
1074      * @dev Approve or remove `operator` as an operator for the caller.
1075      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1076      *
1077      * Requirements:
1078      *
1079      * - The `operator` cannot be the caller.
1080      *
1081      * Emits an {ApprovalForAll} event.
1082      */
1083     function setApprovalForAll(address operator, bool _approved) external;
1084 
1085     /**
1086      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1087      *
1088      * See {setApprovalForAll}
1089      */
1090     function isApprovedForAll(address owner, address operator) external view returns (bool);
1091 
1092     /**
1093      * @dev Safely transfers `tokenId` token from `from` to `to`.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must exist and be owned by `from`.
1100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes calldata data
1110     ) external;
1111 }
1112 
1113 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1114 
1115 
1116 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 
1121 /**
1122  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1123  * @dev See https://eips.ethereum.org/EIPS/eip-721
1124  */
1125 interface IERC721Metadata is IERC721 {
1126     /**
1127      * @dev Returns the token collection name.
1128      */
1129     function name() external view returns (string memory);
1130 
1131     /**
1132      * @dev Returns the token collection symbol.
1133      */
1134     function symbol() external view returns (string memory);
1135 
1136     /**
1137      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1138      */
1139     function tokenURI(uint256 tokenId) external view returns (string memory);
1140 }
1141 
1142 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1143 
1144 
1145 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 
1151 
1152 
1153 
1154 
1155 
1156 /**
1157  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1158  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1159  * {ERC721Enumerable}.
1160  */
1161 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1162     using Address for address;
1163     using Strings for uint256;
1164 
1165     // Token name
1166     string private _name;
1167 
1168     // Token symbol
1169     string private _symbol;
1170 
1171     // Mapping from token ID to owner address
1172     mapping(uint256 => address) private _owners;
1173 
1174     // Mapping owner address to token count
1175     mapping(address => uint256) private _balances;
1176 
1177     // Mapping from token ID to approved address
1178     mapping(uint256 => address) private _tokenApprovals;
1179 
1180     // Mapping from owner to operator approvals
1181     mapping(address => mapping(address => bool)) private _operatorApprovals;
1182 
1183     /**
1184      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1185      */
1186     constructor(string memory name_, string memory symbol_) {
1187         _name = name_;
1188         _symbol = symbol_;
1189     }
1190 
1191     /**
1192      * @dev See {IERC165-supportsInterface}.
1193      */
1194     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1195         return
1196             interfaceId == type(IERC721).interfaceId ||
1197             interfaceId == type(IERC721Metadata).interfaceId ||
1198             super.supportsInterface(interfaceId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-balanceOf}.
1203      */
1204     function balanceOf(address owner) public view virtual override returns (uint256) {
1205         require(owner != address(0), "ERC721: balance query for the zero address");
1206         return _balances[owner];
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-ownerOf}.
1211      */
1212     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1213         address owner = _owners[tokenId];
1214         require(owner != address(0), "ERC721: owner query for nonexistent token");
1215         return owner;
1216     }
1217 
1218     /**
1219      * @dev See {IERC721Metadata-name}.
1220      */
1221     function name() public view virtual override returns (string memory) {
1222         return _name;
1223     }
1224 
1225     /**
1226      * @dev See {IERC721Metadata-symbol}.
1227      */
1228     function symbol() public view virtual override returns (string memory) {
1229         return _symbol;
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Metadata-tokenURI}.
1234      */
1235     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1236         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1237 
1238         string memory baseURI = _baseURI();
1239         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1240     }
1241 
1242     /**
1243      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1244      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1245      * by default, can be overriden in child contracts.
1246      */
1247     function _baseURI() internal view virtual returns (string memory) {
1248         return "";
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-approve}.
1253      */
1254     function approve(address to, uint256 tokenId) public virtual override {
1255         address owner = ERC721.ownerOf(tokenId);
1256         require(to != owner, "ERC721: approval to current owner");
1257 
1258         require(
1259             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1260             "ERC721: approve caller is not owner nor approved for all"
1261         );
1262 
1263         _approve(to, tokenId);
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-getApproved}.
1268      */
1269     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1270         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1271 
1272         return _tokenApprovals[tokenId];
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-setApprovalForAll}.
1277      */
1278     function setApprovalForAll(address operator, bool approved) public virtual override {
1279         _setApprovalForAll(_msgSender(), operator, approved);
1280     }
1281 
1282     /**
1283      * @dev See {IERC721-isApprovedForAll}.
1284      */
1285     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1286         return _operatorApprovals[owner][operator];
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-transferFrom}.
1291      */
1292     function transferFrom(
1293         address from,
1294         address to,
1295         uint256 tokenId
1296     ) public virtual override {
1297         //solhint-disable-next-line max-line-length
1298         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1299 
1300         _transfer(from, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-safeTransferFrom}.
1305      */
1306     function safeTransferFrom(
1307         address from,
1308         address to,
1309         uint256 tokenId
1310     ) public virtual override {
1311         safeTransferFrom(from, to, tokenId, "");
1312     }
1313 
1314     /**
1315      * @dev See {IERC721-safeTransferFrom}.
1316      */
1317     function safeTransferFrom(
1318         address from,
1319         address to,
1320         uint256 tokenId,
1321         bytes memory _data
1322     ) public virtual override {
1323         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1324         _safeTransfer(from, to, tokenId, _data);
1325     }
1326 
1327     /**
1328      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1329      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1330      *
1331      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1332      *
1333      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1334      * implement alternative mechanisms to perform token transfer, such as signature-based.
1335      *
1336      * Requirements:
1337      *
1338      * - `from` cannot be the zero address.
1339      * - `to` cannot be the zero address.
1340      * - `tokenId` token must exist and be owned by `from`.
1341      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function _safeTransfer(
1346         address from,
1347         address to,
1348         uint256 tokenId,
1349         bytes memory _data
1350     ) internal virtual {
1351         _transfer(from, to, tokenId);
1352         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1353     }
1354 
1355     /**
1356      * @dev Returns whether `tokenId` exists.
1357      *
1358      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1359      *
1360      * Tokens start existing when they are minted (`_mint`),
1361      * and stop existing when they are burned (`_burn`).
1362      */
1363     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1364         return _owners[tokenId] != address(0);
1365     }
1366 
1367     /**
1368      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1369      *
1370      * Requirements:
1371      *
1372      * - `tokenId` must exist.
1373      */
1374     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1375         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1376         address owner = ERC721.ownerOf(tokenId);
1377         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1378     }
1379 
1380     /**
1381      * @dev Safely mints `tokenId` and transfers it to `to`.
1382      *
1383      * Requirements:
1384      *
1385      * - `tokenId` must not exist.
1386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1387      *
1388      * Emits a {Transfer} event.
1389      */
1390     function _safeMint(address to, uint256 tokenId) internal virtual {
1391         _safeMint(to, tokenId, "");
1392     }
1393 
1394     /**
1395      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1396      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1397      */
1398     function _safeMint(
1399         address to,
1400         uint256 tokenId,
1401         bytes memory _data
1402     ) internal virtual {
1403         _mint(to, tokenId);
1404         require(
1405             _checkOnERC721Received(address(0), to, tokenId, _data),
1406             "ERC721: transfer to non ERC721Receiver implementer"
1407         );
1408     }
1409 
1410     /**
1411      * @dev Mints `tokenId` and transfers it to `to`.
1412      *
1413      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must not exist.
1418      * - `to` cannot be the zero address.
1419      *
1420      * Emits a {Transfer} event.
1421      */
1422     function _mint(address to, uint256 tokenId) internal virtual {
1423         require(to != address(0), "ERC721: mint to the zero address");
1424         require(!_exists(tokenId), "ERC721: token already minted");
1425 
1426         _beforeTokenTransfer(address(0), to, tokenId);
1427 
1428         _balances[to] += 1;
1429         _owners[tokenId] = to;
1430 
1431         emit Transfer(address(0), to, tokenId);
1432     }
1433 
1434     /**
1435      * @dev Destroys `tokenId`.
1436      * The approval is cleared when the token is burned.
1437      *
1438      * Requirements:
1439      *
1440      * - `tokenId` must exist.
1441      *
1442      * Emits a {Transfer} event.
1443      */
1444     function _burn(uint256 tokenId) internal virtual {
1445         address owner = ERC721.ownerOf(tokenId);
1446 
1447         _beforeTokenTransfer(owner, address(0), tokenId);
1448 
1449         // Clear approvals
1450         _approve(address(0), tokenId);
1451 
1452         _balances[owner] -= 1;
1453         delete _owners[tokenId];
1454 
1455         emit Transfer(owner, address(0), tokenId);
1456     }
1457 
1458     /**
1459      * @dev Transfers `tokenId` from `from` to `to`.
1460      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1461      *
1462      * Requirements:
1463      *
1464      * - `to` cannot be the zero address.
1465      * - `tokenId` token must be owned by `from`.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function _transfer(
1470         address from,
1471         address to,
1472         uint256 tokenId
1473     ) internal virtual {
1474         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1475         require(to != address(0), "ERC721: transfer to the zero address");
1476 
1477         _beforeTokenTransfer(from, to, tokenId);
1478 
1479         // Clear approvals from the previous owner
1480         _approve(address(0), tokenId);
1481 
1482         _balances[from] -= 1;
1483         _balances[to] += 1;
1484         _owners[tokenId] = to;
1485 
1486         emit Transfer(from, to, tokenId);
1487     }
1488 
1489     /**
1490      * @dev Approve `to` to operate on `tokenId`
1491      *
1492      * Emits a {Approval} event.
1493      */
1494     function _approve(address to, uint256 tokenId) internal virtual {
1495         _tokenApprovals[tokenId] = to;
1496         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1497     }
1498 
1499     /**
1500      * @dev Approve `operator` to operate on all of `owner` tokens
1501      *
1502      * Emits a {ApprovalForAll} event.
1503      */
1504     function _setApprovalForAll(
1505         address owner,
1506         address operator,
1507         bool approved
1508     ) internal virtual {
1509         require(owner != operator, "ERC721: approve to caller");
1510         _operatorApprovals[owner][operator] = approved;
1511         emit ApprovalForAll(owner, operator, approved);
1512     }
1513 
1514     /**
1515      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1516      * The call is not executed if the target address is not a contract.
1517      *
1518      * @param from address representing the previous owner of the given token ID
1519      * @param to target address that will receive the tokens
1520      * @param tokenId uint256 ID of the token to be transferred
1521      * @param _data bytes optional data to send along with the call
1522      * @return bool whether the call correctly returned the expected magic value
1523      */
1524     function _checkOnERC721Received(
1525         address from,
1526         address to,
1527         uint256 tokenId,
1528         bytes memory _data
1529     ) private returns (bool) {
1530         if (to.isContract()) {
1531             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1532                 return retval == IERC721Receiver.onERC721Received.selector;
1533             } catch (bytes memory reason) {
1534                 if (reason.length == 0) {
1535                     revert("ERC721: transfer to non ERC721Receiver implementer");
1536                 } else {
1537                     assembly {
1538                         revert(add(32, reason), mload(reason))
1539                     }
1540                 }
1541             }
1542         } else {
1543             return true;
1544         }
1545     }
1546 
1547     /**
1548      * @dev Hook that is called before any token transfer. This includes minting
1549      * and burning.
1550      *
1551      * Calling conditions:
1552      *
1553      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1554      * transferred to `to`.
1555      * - When `from` is zero, `tokenId` will be minted for `to`.
1556      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1557      * - `from` and `to` are never both zero.
1558      *
1559      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1560      */
1561     function _beforeTokenTransfer(
1562         address from,
1563         address to,
1564         uint256 tokenId
1565     ) internal virtual {}
1566 }
1567 
1568 /**
1569 
1570                                                                                         
1571                                                                                         
1572 LLLLLLLLLLL             TTTTTTTTTTTTTTTTTTTTTTTPPPPPPPPPPPPPPPPP           CCCCCCCCCCCCC
1573 L:::::::::L             T:::::::::::::::::::::TP::::::::::::::::P       CCC::::::::::::C
1574 L:::::::::L             T:::::::::::::::::::::TP::::::PPPPPP:::::P    CC:::::::::::::::C
1575 LL:::::::LL             T:::::TT:::::::TT:::::TPP:::::P     P:::::P  C:::::CCCCCCCC::::C
1576   L:::::L               TTTTTT  T:::::T  TTTTTT  P::::P     P:::::P C:::::C       CCCCCC
1577   L:::::L                       T:::::T          P::::P     P:::::PC:::::C              
1578   L:::::L                       T:::::T          P::::PPPPPP:::::P C:::::C              
1579   L:::::L                       T:::::T          P:::::::::::::PP  C:::::C              
1580   L:::::L                       T:::::T          P::::PPPPPPPPP    C:::::C              
1581   L:::::L                       T:::::T          P::::P            C:::::C              
1582   L:::::L                       T:::::T          P::::P            C:::::C              
1583   L:::::L         LLLLLL        T:::::T          P::::P             C:::::C       CCCCCC
1584 LL:::::::LLLLLLLLL:::::L      TT:::::::TT      PP::::::PP            C:::::CCCCCCCC::::C
1585 L::::::::::::::::::::::L      T:::::::::T      P::::::::P             CC:::::::::::::::C
1586 L::::::::::::::::::::::L      T:::::::::T      P::::::::P               CCC::::::::::::C
1587 LLLLLLLLLLLLLLLLLLLLLLLL      TTTTTTTTTTT      PPPPPPPPPP                  CCCCCCCCCCCCC
1588                                                                                                                                                                                
1589                                                                                                                                                                                                          
1590                                                                                         
1591                                                                                 
1592 */
1593 
1594 
1595 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1596 
1597 pragma solidity ^0.8.0;
1598 
1599 
1600 contract LuckyTeacupPiggyClub is ERC721, IERC2981, Ownable, ReentrancyGuard {
1601     using Counters for Counters.Counter;
1602     using Strings for uint256;
1603 
1604     Counters.Counter private tokenCounter;
1605 
1606     string private baseURI = "ipfs://QmcCZGqwQAUr6y8Xszia2Bo3dCiUNkhZ3BXm3CDSTbCybY";
1607 
1608 
1609     uint256 public constant MAX_MINTS_PER_TX = 10;
1610     uint256 public maxSupply = 3333;
1611 
1612     uint256 public constant PUBLIC_SALE_PRICE = 0.012 ether;
1613     uint256 public NUM_FREE_MINTS = 777;
1614     bool public isPublicSaleActive = true;
1615 
1616 
1617 
1618 
1619     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1620 
1621     modifier publicSaleActive() {
1622         require(isPublicSaleActive, "Public sale is not open");
1623         _;
1624     }
1625 
1626 
1627 
1628     modifier maxMintsPerTX(uint256 numberOfTokens) {
1629         require(
1630             numberOfTokens <= MAX_MINTS_PER_TX,
1631             "Max mints per transaction exceeded"
1632         );
1633         _;
1634     }
1635 
1636     modifier canMintNFTs(uint256 numberOfTokens) {
1637         require(
1638             tokenCounter.current() + numberOfTokens <=
1639                 maxSupply,
1640             "Not enough mints remaining to mint"
1641         );
1642         _;
1643     }
1644 
1645 
1646 
1647     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1648         if(tokenCounter.current()>NUM_FREE_MINTS){
1649         require(
1650             (price * numberOfTokens) == msg.value,
1651             "Incorrect ETH value sent"
1652         );
1653         }
1654         _;
1655     }
1656 
1657 
1658     constructor(
1659     string memory _name,
1660     string memory _symbol
1661   ) ERC721(_name, _symbol) {
1662   }
1663 
1664     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1665 
1666     function mint(uint256 numberOfTokens)
1667         external
1668         payable
1669         nonReentrant
1670         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1671         publicSaleActive
1672         canMintNFTs(numberOfTokens)
1673         maxMintsPerTX(numberOfTokens)
1674     {
1675         //require(numberOfTokens <= MAX_MINTS_PER_TX);
1676         //if(tokenCounter.current()>NUM_FREE_MINTS){
1677         //    require((PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value);
1678         //}
1679         for (uint256 i = 0; i < numberOfTokens; i++) {
1680             _safeMint(msg.sender, nextTokenId());
1681         }
1682     }
1683 
1684 
1685 
1686 
1687     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1688 
1689     function getBaseURI() external view returns (string memory) {
1690         return baseURI;
1691     }
1692 
1693     function getLastTokenId() external view returns (uint256) {
1694         return tokenCounter.current();
1695     }
1696 
1697     function totalSupply() external view returns (uint256) {
1698         return tokenCounter.current();
1699     }
1700 
1701     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1702 
1703     function setBaseURI(string memory _baseURI) external onlyOwner {
1704         baseURI = _baseURI;
1705     }
1706 
1707 
1708 
1709     function setIsPublicSaleActive(bool _isPublicSaleActive)
1710         external
1711         onlyOwner
1712     {
1713         isPublicSaleActive = _isPublicSaleActive;
1714     }
1715 
1716     function setNumFreeMints(uint256 _numfreemints)
1717         external
1718         onlyOwner
1719     {
1720         NUM_FREE_MINTS = _numfreemints;
1721     }
1722 
1723 
1724     function withdraw() public onlyOwner {
1725         uint256 balance = address(this).balance;
1726         payable(msg.sender).transfer(balance);
1727     }
1728 
1729     function withdrawTokens(IERC20 token) public onlyOwner {
1730         uint256 balance = token.balanceOf(address(this));
1731         token.transfer(msg.sender, balance);
1732     }
1733 
1734 
1735 
1736     // ============ SUPPORTING FUNCTIONS ============
1737 
1738     function nextTokenId() private returns (uint256) {
1739         tokenCounter.increment();
1740         return tokenCounter.current();
1741     }
1742 
1743     // ============ FUNCTION OVERRIDES ============
1744 
1745     function supportsInterface(bytes4 interfaceId)
1746         public
1747         view
1748         virtual
1749         override(ERC721, IERC165)
1750         returns (bool)
1751     {
1752         return
1753             interfaceId == type(IERC2981).interfaceId ||
1754             super.supportsInterface(interfaceId);
1755     }
1756 
1757    
1758     
1759 
1760     /**
1761      * @dev See {IERC721Metadata-tokenURI}.
1762      */
1763     function tokenURI(uint256 tokenId)
1764         public
1765         view
1766         virtual
1767         override
1768         returns (string memory)
1769     {
1770         require(_exists(tokenId), "Nonexistent token");
1771 
1772         return
1773             string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
1774     }
1775 
1776     /**
1777      * @dev See {IERC165-royaltyInfo}.
1778      */
1779     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1780         external
1781         view
1782         override
1783         returns (address receiver, uint256 royaltyAmount)
1784     {
1785         require(_exists(tokenId), "Nonexistent token");
1786 
1787         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1788     }
1789 }