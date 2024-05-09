1 // File: contracts/DoodsVerse.sol
2 
3 /**
4  *
5 */
6 
7 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 // CAUTION
15 // This version of SafeMath should only be used with Solidity 0.8 or later,
16 // because it relies on the compiler's built in overflow checks.
17 
18 /**
19  * @dev Wrappers over Solidity's arithmetic operations.
20  *
21  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
22  * now has built in overflow checking.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, with an overflow flag.
27      *
28      * _Available since v3.4._
29      */
30     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             uint256 c = a + b;
33             if (c < a) return (false, 0);
34             return (true, c);
35         }
36     }
37 
38     /**
39      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b > a) return (false, 0);
46             return (true, a - b);
47         }
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
52      *
53      * _Available since v3.4._
54      */
55     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         unchecked {
57             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58             // benefit is lost if 'b' is also tested.
59             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
60             if (a == 0) return (true, 0);
61             uint256 c = a * b;
62             if (c / a != b) return (false, 0);
63             return (true, c);
64         }
65     }
66 
67     /**
68      * @dev Returns the division of two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         unchecked {
74             if (b == 0) return (false, 0);
75             return (true, a / b);
76         }
77     }
78 
79     /**
80      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
81      *
82      * _Available since v3.4._
83      */
84     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         unchecked {
86             if (b == 0) return (false, 0);
87             return (true, a % b);
88         }
89     }
90 
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a + b;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a - b;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a * b;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers, reverting on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator.
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a / b;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * reverting when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a % b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {trySub}.
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(
177         uint256 a,
178         uint256 b,
179         string memory errorMessage
180     ) internal pure returns (uint256) {
181         unchecked {
182             require(b <= a, errorMessage);
183             return a - b;
184         }
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         unchecked {
205             require(b > 0, errorMessage);
206             return a / b;
207         }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * reverting with custom message when dividing by zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryMod}.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a % b;
233         }
234     }
235 }
236 
237 // File: @openzeppelin/contracts/utils/Counters.sol
238 
239 
240 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @title Counters
246  * @author Matt Condon (@shrugs)
247  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
248  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
249  *
250  * Include with `using Counters for Counters.Counter;`
251  */
252 library Counters {
253     struct Counter {
254         // This variable should never be directly accessed by users of the library: interactions must be restricted to
255         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
256         // this feature: see https://github.com/ethereum/solidity/issues/4637
257         uint256 _value; // default: 0
258     }
259 
260     function current(Counter storage counter) internal view returns (uint256) {
261         return counter._value;
262     }
263 
264     function increment(Counter storage counter) internal {
265         unchecked {
266             counter._value += 1;
267         }
268     }
269 
270     function decrement(Counter storage counter) internal {
271         uint256 value = counter._value;
272         require(value > 0, "Counter: decrement overflow");
273         unchecked {
274             counter._value = value - 1;
275         }
276     }
277 
278     function reset(Counter storage counter) internal {
279         counter._value = 0;
280     }
281 }
282 
283 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Contract module that helps prevent reentrant calls to a function.
292  *
293  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
294  * available, which can be applied to functions to make sure there are no nested
295  * (reentrant) calls to them.
296  *
297  * Note that because there is a single `nonReentrant` guard, functions marked as
298  * `nonReentrant` may not call one another. This can be worked around by making
299  * those functions `private`, and then adding `external` `nonReentrant` entry
300  * points to them.
301  *
302  * TIP: If you would like to learn more about reentrancy and alternative ways
303  * to protect against it, check out our blog post
304  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
305  */
306 abstract contract ReentrancyGuard {
307     // Booleans are more expensive than uint256 or any type that takes up a full
308     // word because each write operation emits an extra SLOAD to first read the
309     // slot's contents, replace the bits taken up by the boolean, and then write
310     // back. This is the compiler's defense against contract upgrades and
311     // pointer aliasing, and it cannot be disabled.
312 
313     // The values being non-zero value makes deployment a bit more expensive,
314     // but in exchange the refund on every call to nonReentrant will be lower in
315     // amount. Since refunds are capped to a percentage of the total
316     // transaction's gas, it is best to keep them low in cases like this one, to
317     // increase the likelihood of the full refund coming into effect.
318     uint256 private constant _NOT_ENTERED = 1;
319     uint256 private constant _ENTERED = 2;
320 
321     uint256 private _status;
322 
323     constructor() {
324         _status = _NOT_ENTERED;
325     }
326 
327     /**
328      * @dev Prevents a contract from calling itself, directly or indirectly.
329      * Calling a `nonReentrant` function from another `nonReentrant`
330      * function is not supported. It is possible to prevent this from happening
331      * by making the `nonReentrant` function external, and making it call a
332      * `private` function that does the actual work.
333      */
334     modifier nonReentrant() {
335         // On the first call to nonReentrant, _notEntered will be true
336         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
337 
338         // Any calls to nonReentrant after this point will fail
339         _status = _ENTERED;
340 
341         _;
342 
343         // By storing the original value once again, a refund is triggered (see
344         // https://eips.ethereum.org/EIPS/eip-2200)
345         _status = _NOT_ENTERED;
346     }
347 }
348 
349 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Interface of the ERC20 standard as defined in the EIP.
358  */
359 interface IERC20 {
360     /**
361      * @dev Returns the amount of tokens in existence.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns the amount of tokens owned by `account`.
367      */
368     function balanceOf(address account) external view returns (uint256);
369 
370     /**
371      * @dev Moves `amount` tokens from the caller's account to `recipient`.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transfer(address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Returns the remaining number of tokens that `spender` will be
381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
382      * zero by default.
383      *
384      * This value changes when {approve} or {transferFrom} are called.
385      */
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
394      * that someone may use both the old and the new allowance by unfortunate
395      * transaction ordering. One possible solution to mitigate this race
396      * condition is to first reduce the spender's allowance to 0 and set the
397      * desired value afterwards:
398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      *
400      * Emits an {Approval} event.
401      */
402     function approve(address spender, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Moves `amount` tokens from `sender` to `recipient` using the
406      * allowance mechanism. `amount` is then deducted from the caller's
407      * allowance.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(
414         address sender,
415         address recipient,
416         uint256 amount
417     ) external returns (bool);
418 
419     /**
420      * @dev Emitted when `value` tokens are moved from one account (`from`) to
421      * another (`to`).
422      *
423      * Note that `value` may be zero.
424      */
425     event Transfer(address indexed from, address indexed to, uint256 value);
426 
427     /**
428      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
429      * a call to {approve}. `value` is the new allowance.
430      */
431     event Approval(address indexed owner, address indexed spender, uint256 value);
432 }
433 
434 // File: @openzeppelin/contracts/interfaces/IERC20.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 
442 // File: @openzeppelin/contracts/utils/Strings.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev String operations.
451  */
452 library Strings {
453     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
454 
455     /**
456      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
457      */
458     function toString(uint256 value) internal pure returns (string memory) {
459         // Inspired by OraclizeAPI's implementation - MIT licence
460         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
461 
462         if (value == 0) {
463             return "0";
464         }
465         uint256 temp = value;
466         uint256 digits;
467         while (temp != 0) {
468             digits++;
469             temp /= 10;
470         }
471         bytes memory buffer = new bytes(digits);
472         while (value != 0) {
473             digits -= 1;
474             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
475             value /= 10;
476         }
477         return string(buffer);
478     }
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
482      */
483     function toHexString(uint256 value) internal pure returns (string memory) {
484         if (value == 0) {
485             return "0x00";
486         }
487         uint256 temp = value;
488         uint256 length = 0;
489         while (temp != 0) {
490             length++;
491             temp >>= 8;
492         }
493         return toHexString(value, length);
494     }
495 
496     /**
497      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
498      */
499     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
500         bytes memory buffer = new bytes(2 * length + 2);
501         buffer[0] = "0";
502         buffer[1] = "x";
503         for (uint256 i = 2 * length + 1; i > 1; --i) {
504             buffer[i] = _HEX_SYMBOLS[value & 0xf];
505             value >>= 4;
506         }
507         require(value == 0, "Strings: hex length insufficient");
508         return string(buffer);
509     }
510 }
511 
512 // File: @openzeppelin/contracts/utils/Context.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Provides information about the current execution context, including the
521  * sender of the transaction and its data. While these are generally available
522  * via msg.sender and msg.data, they should not be accessed in such a direct
523  * manner, since when dealing with meta-transactions the account sending and
524  * paying for execution may not be the actual sender (as far as an application
525  * is concerned).
526  *
527  * This contract is only required for intermediate, library-like contracts.
528  */
529 abstract contract Context {
530     function _msgSender() internal view virtual returns (address) {
531         return msg.sender;
532     }
533 
534     function _msgData() internal view virtual returns (bytes calldata) {
535         return msg.data;
536     }
537 }
538 
539 // File: @openzeppelin/contracts/access/Ownable.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev Contract module which provides a basic access control mechanism, where
549  * there is an account (an owner) that can be granted exclusive access to
550  * specific functions.
551  *
552  * By default, the owner account will be the one that deploys the contract. This
553  * can later be changed with {transferOwnership}.
554  *
555  * This module is used through inheritance. It will make available the modifier
556  * `onlyOwner`, which can be applied to your functions to restrict their use to
557  * the owner.
558  */
559 abstract contract Ownable is Context {
560     address private _owner;
561 
562     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
563 
564     /**
565      * @dev Initializes the contract setting the deployer as the initial owner.
566      */
567     constructor() {
568         _transferOwnership(_msgSender());
569     }
570 
571     /**
572      * @dev Returns the address of the current owner.
573      */
574     function owner() public view virtual returns (address) {
575         return _owner;
576     }
577 
578     /**
579      * @dev Throws if called by any account other than the owner.
580      */
581     modifier onlyOwner() {
582         require(owner() == _msgSender(), "Ownable: caller is not the owner");
583         _;
584     }
585 
586     /**
587      * @dev Leaves the contract without owner. It will not be possible to call
588      * `onlyOwner` functions anymore. Can only be called by the current owner.
589      *
590      * NOTE: Renouncing ownership will leave the contract without an owner,
591      * thereby removing any functionality that is only available to the owner.
592      */
593     function renounceOwnership() public virtual onlyOwner {
594         _transferOwnership(address(0));
595     }
596 
597     /**
598      * @dev Transfers ownership of the contract to a new account (`newOwner`).
599      * Can only be called by the current owner.
600      */
601     function transferOwnership(address newOwner) public virtual onlyOwner {
602         require(newOwner != address(0), "Ownable: new owner is the zero address");
603         _transferOwnership(newOwner);
604     }
605 
606     /**
607      * @dev Transfers ownership of the contract to a new account (`newOwner`).
608      * Internal function without access restriction.
609      */
610     function _transferOwnership(address newOwner) internal virtual {
611         address oldOwner = _owner;
612         _owner = newOwner;
613         emit OwnershipTransferred(oldOwner, newOwner);
614     }
615 }
616 
617 // File: @openzeppelin/contracts/utils/Address.sol
618 
619 
620 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Collection of functions related to the address type
626  */
627 library Address {
628     /**
629      * @dev Returns true if `account` is a contract.
630      *
631      * [IMPORTANT]
632      * ====
633      * It is unsafe to assume that an address for which this function returns
634      * false is an externally-owned account (EOA) and not a contract.
635      *
636      * Among others, `isContract` will return false for the following
637      * types of addresses:
638      *
639      *  - an externally-owned account
640      *  - a contract in construction
641      *  - an address where a contract will be created
642      *  - an address where a contract lived, but was destroyed
643      * ====
644      */
645     function isContract(address account) internal view returns (bool) {
646         // This method relies on extcodesize, which returns 0 for contracts in
647         // construction, since the code is only stored at the end of the
648         // constructor execution.
649 
650         uint256 size;
651         assembly {
652             size := extcodesize(account)
653         }
654         return size > 0;
655     }
656 
657     /**
658      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
659      * `recipient`, forwarding all available gas and reverting on errors.
660      *
661      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
662      * of certain opcodes, possibly making contracts go over the 2300 gas limit
663      * imposed by `transfer`, making them unable to receive funds via
664      * `transfer`. {sendValue} removes this limitation.
665      *
666      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
667      *
668      * IMPORTANT: because control is transferred to `recipient`, care must be
669      * taken to not create reentrancy vulnerabilities. Consider using
670      * {ReentrancyGuard} or the
671      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
672      */
673     function sendValue(address payable recipient, uint256 amount) internal {
674         require(address(this).balance >= amount, "Address: insufficient balance");
675 
676         (bool success, ) = recipient.call{value: amount}("");
677         require(success, "Address: unable to send value, recipient may have reverted");
678     }
679 
680     /**
681      * @dev Performs a Solidity function call using a low level `call`. A
682      * plain `call` is an unsafe replacement for a function call: use this
683      * function instead.
684      *
685      * If `target` reverts with a revert reason, it is bubbled up by this
686      * function (like regular Solidity function calls).
687      *
688      * Returns the raw returned data. To convert to the expected return value,
689      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
690      *
691      * Requirements:
692      *
693      * - `target` must be a contract.
694      * - calling `target` with `data` must not revert.
695      *
696      * _Available since v3.1._
697      */
698     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
699         return functionCall(target, data, "Address: low-level call failed");
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
704      * `errorMessage` as a fallback revert reason when `target` reverts.
705      *
706      * _Available since v3.1._
707      */
708     function functionCall(
709         address target,
710         bytes memory data,
711         string memory errorMessage
712     ) internal returns (bytes memory) {
713         return functionCallWithValue(target, data, 0, errorMessage);
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
718      * but also transferring `value` wei to `target`.
719      *
720      * Requirements:
721      *
722      * - the calling contract must have an ETH balance of at least `value`.
723      * - the called Solidity function must be `payable`.
724      *
725      * _Available since v3.1._
726      */
727     function functionCallWithValue(
728         address target,
729         bytes memory data,
730         uint256 value
731     ) internal returns (bytes memory) {
732         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
737      * with `errorMessage` as a fallback revert reason when `target` reverts.
738      *
739      * _Available since v3.1._
740      */
741     function functionCallWithValue(
742         address target,
743         bytes memory data,
744         uint256 value,
745         string memory errorMessage
746     ) internal returns (bytes memory) {
747         require(address(this).balance >= value, "Address: insufficient balance for call");
748         require(isContract(target), "Address: call to non-contract");
749 
750         (bool success, bytes memory returndata) = target.call{value: value}(data);
751         return verifyCallResult(success, returndata, errorMessage);
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
756      * but performing a static call.
757      *
758      * _Available since v3.3._
759      */
760     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
761         return functionStaticCall(target, data, "Address: low-level static call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
766      * but performing a static call.
767      *
768      * _Available since v3.3._
769      */
770     function functionStaticCall(
771         address target,
772         bytes memory data,
773         string memory errorMessage
774     ) internal view returns (bytes memory) {
775         require(isContract(target), "Address: static call to non-contract");
776 
777         (bool success, bytes memory returndata) = target.staticcall(data);
778         return verifyCallResult(success, returndata, errorMessage);
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
783      * but performing a delegate call.
784      *
785      * _Available since v3.4._
786      */
787     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
788         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
793      * but performing a delegate call.
794      *
795      * _Available since v3.4._
796      */
797     function functionDelegateCall(
798         address target,
799         bytes memory data,
800         string memory errorMessage
801     ) internal returns (bytes memory) {
802         require(isContract(target), "Address: delegate call to non-contract");
803 
804         (bool success, bytes memory returndata) = target.delegatecall(data);
805         return verifyCallResult(success, returndata, errorMessage);
806     }
807 
808     /**
809      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
810      * revert reason using the provided one.
811      *
812      * _Available since v4.3._
813      */
814     function verifyCallResult(
815         bool success,
816         bytes memory returndata,
817         string memory errorMessage
818     ) internal pure returns (bytes memory) {
819         if (success) {
820             return returndata;
821         } else {
822             // Look for revert reason and bubble it up if present
823             if (returndata.length > 0) {
824                 // The easiest way to bubble the revert reason is using memory via assembly
825 
826                 assembly {
827                     let returndata_size := mload(returndata)
828                     revert(add(32, returndata), returndata_size)
829                 }
830             } else {
831                 revert(errorMessage);
832             }
833         }
834     }
835 }
836 
837 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
838 
839 
840 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @title ERC721 token receiver interface
846  * @dev Interface for any contract that wants to support safeTransfers
847  * from ERC721 asset contracts.
848  */
849 interface IERC721Receiver {
850     /**
851      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
852      * by `operator` from `from`, this function is called.
853      *
854      * It must return its Solidity selector to confirm the token transfer.
855      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
856      *
857      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
858      */
859     function onERC721Received(
860         address operator,
861         address from,
862         uint256 tokenId,
863         bytes calldata data
864     ) external returns (bytes4);
865 }
866 
867 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
868 
869 
870 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 /**
875  * @dev Interface of the ERC165 standard, as defined in the
876  * https://eips.ethereum.org/EIPS/eip-165[EIP].
877  *
878  * Implementers can declare support of contract interfaces, which can then be
879  * queried by others ({ERC165Checker}).
880  *
881  * For an implementation, see {ERC165}.
882  */
883 interface IERC165 {
884     /**
885      * @dev Returns true if this contract implements the interface defined by
886      * `interfaceId`. See the corresponding
887      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
888      * to learn more about how these ids are created.
889      *
890      * This function call must use less than 30 000 gas.
891      */
892     function supportsInterface(bytes4 interfaceId) external view returns (bool);
893 }
894 
895 // File: @openzeppelin/contracts/interfaces/IERC165.sol
896 
897 
898 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 
903 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
904 
905 
906 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 
911 /**
912  * @dev Interface for the NFT Royalty Standard
913  */
914 interface IERC2981 is IERC165 {
915     /**
916      * @dev Called with the sale price to determine how much royalty is owed and to whom.
917      * @param tokenId - the NFT asset queried for royalty information
918      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
919      * @return receiver - address of who should be sent the royalty payment
920      * @return royaltyAmount - the royalty payment amount for `salePrice`
921      */
922     function royaltyInfo(uint256 tokenId, uint256 salePrice)
923         external
924         view
925         returns (address receiver, uint256 royaltyAmount);
926 }
927 
928 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
929 
930 
931 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 
936 /**
937  * @dev Implementation of the {IERC165} interface.
938  *
939  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
940  * for the additional interface id that will be supported. For example:
941  *
942  * ```solidity
943  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
944  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
945  * }
946  * ```
947  *
948  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
949  */
950 abstract contract ERC165 is IERC165 {
951     /**
952      * @dev See {IERC165-supportsInterface}.
953      */
954     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
955         return interfaceId == type(IERC165).interfaceId;
956     }
957 }
958 
959 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
960 
961 
962 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
963 
964 pragma solidity ^0.8.0;
965 
966 
967 /**
968  * @dev Required interface of an ERC721 compliant contract.
969  */
970 interface IERC721 is IERC165 {
971     /**
972      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
973      */
974     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
975 
976     /**
977      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
978      */
979     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
980 
981     /**
982      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
983      */
984     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
985 
986     /**
987      * @dev Returns the number of tokens in ``owner``'s account.
988      */
989     function balanceOf(address owner) external view returns (uint256 balance);
990 
991     /**
992      * @dev Returns the owner of the `tokenId` token.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must exist.
997      */
998     function ownerOf(uint256 tokenId) external view returns (address owner);
999 
1000     /**
1001      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1002      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1003      *
1004      * Requirements:
1005      *
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must exist and be owned by `from`.
1009      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1010      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) external;
1019 
1020     /**
1021      * @dev Transfers `tokenId` token from `from` to `to`.
1022      *
1023      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1024      *
1025      * Requirements:
1026      *
1027      * - `from` cannot be the zero address.
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must be owned by `from`.
1030      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) external;
1039 
1040     /**
1041      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1042      * The approval is cleared when the token is transferred.
1043      *
1044      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1045      *
1046      * Requirements:
1047      *
1048      * - The caller must own the token or be an approved operator.
1049      * - `tokenId` must exist.
1050      *
1051      * Emits an {Approval} event.
1052      */
1053     function approve(address to, uint256 tokenId) external;
1054 
1055     /**
1056      * @dev Returns the account approved for `tokenId` token.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must exist.
1061      */
1062     function getApproved(uint256 tokenId) external view returns (address operator);
1063 
1064     /**
1065      * @dev Approve or remove `operator` as an operator for the caller.
1066      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1067      *
1068      * Requirements:
1069      *
1070      * - The `operator` cannot be the caller.
1071      *
1072      * Emits an {ApprovalForAll} event.
1073      */
1074     function setApprovalForAll(address operator, bool _approved) external;
1075 
1076     /**
1077      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1078      *
1079      * See {setApprovalForAll}
1080      */
1081     function isApprovedForAll(address owner, address operator) external view returns (bool);
1082 
1083     /**
1084      * @dev Safely transfers `tokenId` token from `from` to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      * - `tokenId` token must exist and be owned by `from`.
1091      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1092      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function safeTransferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId,
1100         bytes calldata data
1101     ) external;
1102 }
1103 
1104 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1105 
1106 
1107 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 
1112 /**
1113  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1114  * @dev See https://eips.ethereum.org/EIPS/eip-721
1115  */
1116 interface IERC721Enumerable is IERC721 {
1117     /**
1118      * @dev Returns the total amount of tokens stored by the contract.
1119      */
1120     function totalSupply() external view returns (uint256);
1121 
1122     /**
1123      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1124      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1125      */
1126     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1127 
1128     /**
1129      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1130      * Use along with {totalSupply} to enumerate all tokens.
1131      */
1132     function tokenByIndex(uint256 index) external view returns (uint256);
1133 }
1134 
1135 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1136 
1137 
1138 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1139 
1140 pragma solidity ^0.8.0;
1141 
1142 
1143 /**
1144  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1145  * @dev See https://eips.ethereum.org/EIPS/eip-721
1146  */
1147 interface IERC721Metadata is IERC721 {
1148     /**
1149      * @dev Returns the token collection name.
1150      */
1151     function name() external view returns (string memory);
1152 
1153     /**
1154      * @dev Returns the token collection symbol.
1155      */
1156     function symbol() external view returns (string memory);
1157 
1158     /**
1159      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1160      */
1161     function tokenURI(uint256 tokenId) external view returns (string memory);
1162 }
1163 
1164 // File: contracts/ERC721A.sol
1165 
1166 
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 /**
1179  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1180  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1181  *
1182  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1183  *
1184  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1185  *
1186  * Does not support burning tokens to address(0).
1187  */
1188 contract ERC721A is
1189   Context,
1190   ERC165,
1191   IERC721,
1192   IERC721Metadata,
1193   IERC721Enumerable
1194 {
1195   using Address for address;
1196   using Strings for uint256;
1197 
1198   struct TokenOwnership {
1199     address addr;
1200     uint64 startTimestamp;
1201   }
1202 
1203   struct AddressData {
1204     uint128 balance;
1205     uint128 numberMinted;
1206   }
1207 
1208   uint256 private currentIndex = 0;
1209 
1210   uint256 internal immutable collectionSize;
1211   uint256 internal immutable maxBatchSize;
1212 
1213   // Token name
1214   string private _name;
1215 
1216   // Token symbol
1217   string private _symbol;
1218 
1219   // Mapping from token ID to ownership details
1220   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1221   mapping(uint256 => TokenOwnership) private _ownerships;
1222 
1223   // Mapping owner address to address data
1224   mapping(address => AddressData) private _addressData;
1225 
1226   // Mapping from token ID to approved address
1227   mapping(uint256 => address) private _tokenApprovals;
1228 
1229   // Mapping from owner to operator approvals
1230   mapping(address => mapping(address => bool)) private _operatorApprovals;
1231 
1232   /**
1233    * @dev
1234    * `maxBatchSize` refers to how much a minter can mint at a time.
1235    * `collectionSize_` refers to how many tokens are in the collection.
1236    */
1237   constructor(
1238     string memory name_,
1239     string memory symbol_,
1240     uint256 maxBatchSize_,
1241     uint256 collectionSize_
1242   ) {
1243     require(
1244       collectionSize_ > 0,
1245       "ERC721A: collection must have a nonzero supply"
1246     );
1247     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1248     _name = name_;
1249     _symbol = symbol_;
1250     maxBatchSize = maxBatchSize_;
1251     collectionSize = collectionSize_;
1252   }
1253 
1254   /**
1255    * @dev See {IERC721Enumerable-totalSupply}.
1256    */
1257   function totalSupply() public view override returns (uint256) {
1258     return currentIndex;
1259   }
1260 
1261   /**
1262    * @dev See {IERC721Enumerable-tokenByIndex}.
1263    */
1264   function tokenByIndex(uint256 index) public view override returns (uint256) {
1265     require(index < totalSupply(), "ERC721A: global index out of bounds");
1266     return index;
1267   }
1268 
1269   /**
1270    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1271    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1272    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1273    */
1274   function tokenOfOwnerByIndex(address owner, uint256 index)
1275     public
1276     view
1277     override
1278     returns (uint256)
1279   {
1280     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1281     uint256 numMintedSoFar = totalSupply();
1282     uint256 tokenIdsIdx = 0;
1283     address currOwnershipAddr = address(0);
1284     for (uint256 i = 0; i < numMintedSoFar; i++) {
1285       TokenOwnership memory ownership = _ownerships[i];
1286       if (ownership.addr != address(0)) {
1287         currOwnershipAddr = ownership.addr;
1288       }
1289       if (currOwnershipAddr == owner) {
1290         if (tokenIdsIdx == index) {
1291           return i;
1292         }
1293         tokenIdsIdx++;
1294       }
1295     }
1296     revert("ERC721A: unable to get token of owner by index");
1297   }
1298 
1299   /**
1300    * @dev See {IERC165-supportsInterface}.
1301    */
1302   function supportsInterface(bytes4 interfaceId)
1303     public
1304     view
1305     virtual
1306     override(ERC165, IERC165)
1307     returns (bool)
1308   {
1309     return
1310       interfaceId == type(IERC721).interfaceId ||
1311       interfaceId == type(IERC721Metadata).interfaceId ||
1312       interfaceId == type(IERC721Enumerable).interfaceId ||
1313       super.supportsInterface(interfaceId);
1314   }
1315 
1316   /**
1317    * @dev See {IERC721-balanceOf}.
1318    */
1319   function balanceOf(address owner) public view override returns (uint256) {
1320     require(owner != address(0), "ERC721A: balance query for the zero address");
1321     return uint256(_addressData[owner].balance);
1322   }
1323 
1324   function _numberMinted(address owner) internal view returns (uint256) {
1325     require(
1326       owner != address(0),
1327       "ERC721A: number minted query for the zero address"
1328     );
1329     return uint256(_addressData[owner].numberMinted);
1330   }
1331 
1332   function ownershipOf(uint256 tokenId)
1333     internal
1334     view
1335     returns (TokenOwnership memory)
1336   {
1337     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1338 
1339     uint256 lowestTokenToCheck;
1340     if (tokenId >= maxBatchSize) {
1341       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1342     }
1343 
1344     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1345       TokenOwnership memory ownership = _ownerships[curr];
1346       if (ownership.addr != address(0)) {
1347         return ownership;
1348       }
1349     }
1350 
1351     revert("ERC721A: unable to determine the owner of token");
1352   }
1353 
1354   /**
1355    * @dev See {IERC721-ownerOf}.
1356    */
1357   function ownerOf(uint256 tokenId) public view override returns (address) {
1358     return ownershipOf(tokenId).addr;
1359   }
1360 
1361   /**
1362    * @dev See {IERC721Metadata-name}.
1363    */
1364   function name() public view virtual override returns (string memory) {
1365     return _name;
1366   }
1367 
1368   /**
1369    * @dev See {IERC721Metadata-symbol}.
1370    */
1371   function symbol() public view virtual override returns (string memory) {
1372     return _symbol;
1373   }
1374 
1375   /**
1376    * @dev See {IERC721Metadata-tokenURI}.
1377    */
1378   function tokenURI(uint256 tokenId)
1379     public
1380     view
1381     virtual
1382     override
1383     returns (string memory)
1384   {
1385     require(
1386       _exists(tokenId),
1387       "ERC721Metadata: URI query for nonexistent token"
1388     );
1389 
1390     string memory baseURI = _baseURI();
1391     return
1392       bytes(baseURI).length > 0
1393         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1394         : "";
1395   }
1396 
1397   /**
1398    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1399    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1400    * by default, can be overriden in child contracts.
1401    */
1402   function _baseURI() internal view virtual returns (string memory) {
1403     return "";
1404   }
1405 
1406   /**
1407    * @dev See {IERC721-approve}.
1408    */
1409   function approve(address to, uint256 tokenId) public override {
1410     address owner = ERC721A.ownerOf(tokenId);
1411     require(to != owner, "ERC721A: approval to current owner");
1412 
1413     require(
1414       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1415       "ERC721A: approve caller is not owner nor approved for all"
1416     );
1417 
1418     _approve(to, tokenId, owner);
1419   }
1420 
1421   /**
1422    * @dev See {IERC721-getApproved}.
1423    */
1424   function getApproved(uint256 tokenId) public view override returns (address) {
1425     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1426 
1427     return _tokenApprovals[tokenId];
1428   }
1429 
1430   /**
1431    * @dev See {IERC721-setApprovalForAll}.
1432    */
1433   function setApprovalForAll(address operator, bool approved) public override {
1434     require(operator != _msgSender(), "ERC721A: approve to caller");
1435 
1436     _operatorApprovals[_msgSender()][operator] = approved;
1437     emit ApprovalForAll(_msgSender(), operator, approved);
1438   }
1439 
1440   /**
1441    * @dev See {IERC721-isApprovedForAll}.
1442    */
1443   function isApprovedForAll(address owner, address operator)
1444     public
1445     view
1446     virtual
1447     override
1448     returns (bool)
1449   {
1450     return _operatorApprovals[owner][operator];
1451   }
1452 
1453   /**
1454    * @dev See {IERC721-transferFrom}.
1455    */
1456   function transferFrom(
1457     address from,
1458     address to,
1459     uint256 tokenId
1460   ) public override {
1461     _transfer(from, to, tokenId);
1462   }
1463 
1464   /**
1465    * @dev See {IERC721-safeTransferFrom}.
1466    */
1467   function safeTransferFrom(
1468     address from,
1469     address to,
1470     uint256 tokenId
1471   ) public override {
1472     safeTransferFrom(from, to, tokenId, "");
1473   }
1474 
1475   /**
1476    * @dev See {IERC721-safeTransferFrom}.
1477    */
1478   function safeTransferFrom(
1479     address from,
1480     address to,
1481     uint256 tokenId,
1482     bytes memory _data
1483   ) public override {
1484     _transfer(from, to, tokenId);
1485     require(
1486       _checkOnERC721Received(from, to, tokenId, _data),
1487       "ERC721A: transfer to non ERC721Receiver implementer"
1488     );
1489   }
1490 
1491   /**
1492    * @dev Returns whether `tokenId` exists.
1493    *
1494    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1495    *
1496    * Tokens start existing when they are minted (`_mint`),
1497    */
1498   function _exists(uint256 tokenId) internal view returns (bool) {
1499     return tokenId < currentIndex;
1500   }
1501 
1502   function _safeMint(address to, uint256 quantity) internal {
1503     _safeMint(to, quantity, "");
1504   }
1505 
1506   /**
1507    * @dev Mints `quantity` tokens and transfers them to `to`.
1508    *
1509    * Requirements:
1510    *
1511    * - there must be `quantity` tokens remaining unminted in the total collection.
1512    * - `to` cannot be the zero address.
1513    * - `quantity` cannot be larger than the max batch size.
1514    *
1515    * Emits a {Transfer} event.
1516    */
1517   function _safeMint(
1518     address to,
1519     uint256 quantity,
1520     bytes memory _data
1521   ) internal {
1522     uint256 startTokenId = currentIndex;
1523     require(to != address(0), "ERC721A: mint to the zero address");
1524     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1525     require(!_exists(startTokenId), "ERC721A: token already minted");
1526     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1527 
1528     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1529 
1530     AddressData memory addressData = _addressData[to];
1531     _addressData[to] = AddressData(
1532       addressData.balance + uint128(quantity),
1533       addressData.numberMinted + uint128(quantity)
1534     );
1535     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1536 
1537     uint256 updatedIndex = startTokenId;
1538 
1539     for (uint256 i = 0; i < quantity; i++) {
1540       emit Transfer(address(0), to, updatedIndex);
1541       require(
1542         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1543         "ERC721A: transfer to non ERC721Receiver implementer"
1544       );
1545       updatedIndex++;
1546     }
1547 
1548     currentIndex = updatedIndex;
1549     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1550   }
1551 
1552   /**
1553    * @dev Transfers `tokenId` from `from` to `to`.
1554    *
1555    * Requirements:
1556    *
1557    * - `to` cannot be the zero address.
1558    * - `tokenId` token must be owned by `from`.
1559    *
1560    * Emits a {Transfer} event.
1561    */
1562   function _transfer(
1563     address from,
1564     address to,
1565     uint256 tokenId
1566   ) private {
1567     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1568 
1569     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1570       getApproved(tokenId) == _msgSender() ||
1571       isApprovedForAll(prevOwnership.addr, _msgSender()));
1572 
1573     require(
1574       isApprovedOrOwner,
1575       "ERC721A: transfer caller is not owner nor approved"
1576     );
1577 
1578     require(
1579       prevOwnership.addr == from,
1580       "ERC721A: transfer from incorrect owner"
1581     );
1582     require(to != address(0), "ERC721A: transfer to the zero address");
1583 
1584     _beforeTokenTransfers(from, to, tokenId, 1);
1585 
1586     // Clear approvals from the previous owner
1587     _approve(address(0), tokenId, prevOwnership.addr);
1588 
1589     _addressData[from].balance -= 1;
1590     _addressData[to].balance += 1;
1591     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1592 
1593     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1594     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1595     uint256 nextTokenId = tokenId + 1;
1596     if (_ownerships[nextTokenId].addr == address(0)) {
1597       if (_exists(nextTokenId)) {
1598         _ownerships[nextTokenId] = TokenOwnership(
1599           prevOwnership.addr,
1600           prevOwnership.startTimestamp
1601         );
1602       }
1603     }
1604 
1605     emit Transfer(from, to, tokenId);
1606     _afterTokenTransfers(from, to, tokenId, 1);
1607   }
1608 
1609   /**
1610    * @dev Approve `to` to operate on `tokenId`
1611    *
1612    * Emits a {Approval} event.
1613    */
1614   function _approve(
1615     address to,
1616     uint256 tokenId,
1617     address owner
1618   ) private {
1619     _tokenApprovals[tokenId] = to;
1620     emit Approval(owner, to, tokenId);
1621   }
1622 
1623   uint256 public nextOwnerToExplicitlySet = 0;
1624 
1625   /**
1626    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1627    */
1628   function _setOwnersExplicit(uint256 quantity) internal {
1629     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1630     require(quantity > 0, "quantity must be nonzero");
1631     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1632     if (endIndex > collectionSize - 1) {
1633       endIndex = collectionSize - 1;
1634     }
1635     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1636     require(_exists(endIndex), "not enough minted yet for this cleanup");
1637     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1638       if (_ownerships[i].addr == address(0)) {
1639         TokenOwnership memory ownership = ownershipOf(i);
1640         _ownerships[i] = TokenOwnership(
1641           ownership.addr,
1642           ownership.startTimestamp
1643         );
1644       }
1645     }
1646     nextOwnerToExplicitlySet = endIndex + 1;
1647   }
1648 
1649   /**
1650    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1651    * The call is not executed if the target address is not a contract.
1652    *
1653    * @param from address representing the previous owner of the given token ID
1654    * @param to target address that will receive the tokens
1655    * @param tokenId uint256 ID of the token to be transferred
1656    * @param _data bytes optional data to send along with the call
1657    * @return bool whether the call correctly returned the expected magic value
1658    */
1659   function _checkOnERC721Received(
1660     address from,
1661     address to,
1662     uint256 tokenId,
1663     bytes memory _data
1664   ) private returns (bool) {
1665     if (to.isContract()) {
1666       try
1667         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1668       returns (bytes4 retval) {
1669         return retval == IERC721Receiver(to).onERC721Received.selector;
1670       } catch (bytes memory reason) {
1671         if (reason.length == 0) {
1672           revert("ERC721A: transfer to non ERC721Receiver implementer");
1673         } else {
1674           assembly {
1675             revert(add(32, reason), mload(reason))
1676           }
1677         }
1678       }
1679     } else {
1680       return true;
1681     }
1682   }
1683 
1684   /**
1685    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1686    *
1687    * startTokenId - the first token id to be transferred
1688    * quantity - the amount to be transferred
1689    *
1690    * Calling conditions:
1691    *
1692    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1693    * transferred to `to`.
1694    * - When `from` is zero, `tokenId` will be minted for `to`.
1695    */
1696   function _beforeTokenTransfers(
1697     address from,
1698     address to,
1699     uint256 startTokenId,
1700     uint256 quantity
1701   ) internal virtual {}
1702 
1703   /**
1704    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1705    * minting.
1706    *
1707    * startTokenId - the first token id to be transferred
1708    * quantity - the amount to be transferred
1709    *
1710    * Calling conditions:
1711    *
1712    * - when `from` and `to` are both non-zero.
1713    * - `from` and `to` are never both zero.
1714    */
1715   function _afterTokenTransfers(
1716     address from,
1717     address to,
1718     uint256 startTokenId,
1719     uint256 quantity
1720   ) internal virtual {}
1721 }
1722 
1723 //SPDX-License-Identifier: MIT
1724 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1725 
1726 pragma solidity ^0.8.0;
1727 
1728 
1729 
1730 
1731 
1732 
1733 
1734 
1735 
1736 contract DoodsVerse is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1737     using Counters for Counters.Counter;
1738     using Strings for uint256;
1739 
1740     Counters.Counter private tokenCounter;
1741 
1742     string private baseURI = "ipfs://QmedDJCRuZW5Bpj433X6vZvcnf2Tk1KpXLNHLHFwRb2pn5";
1743     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1744     bool private isOpenSeaProxyActive = true;
1745 
1746     uint256 public constant MAX_MINTS_PER_TX = 5;
1747     uint256 public maxSupply = 4444;
1748 
1749     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1750     uint256 public NUM_FREE_MINTS = 3000;
1751     bool public isPublicSaleActive = true;
1752 
1753 
1754 
1755 
1756     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1757 
1758     modifier publicSaleActive() {
1759         require(isPublicSaleActive, "Public sale is not open");
1760         _;
1761     }
1762 
1763 
1764 
1765     modifier maxMintsPerTX(uint256 numberOfTokens) {
1766         require(
1767             numberOfTokens <= MAX_MINTS_PER_TX,
1768             "Max mints per transaction exceeded"
1769         );
1770         _;
1771     }
1772 
1773     modifier canMintNFTs(uint256 numberOfTokens) {
1774         require(
1775             totalSupply() + numberOfTokens <=
1776                 maxSupply,
1777             "Not enough mints remaining to mint"
1778         );
1779         _;
1780     }
1781 
1782     modifier freeMintsAvailable() {
1783         require(
1784             totalSupply() <=
1785                 NUM_FREE_MINTS,
1786             "Not enough free mints remain"
1787         );
1788         _;
1789     }
1790 
1791 
1792 
1793     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1794         if(totalSupply()>NUM_FREE_MINTS){
1795         require(
1796             (price * numberOfTokens) == msg.value,
1797             "Incorrect ETH value sent"
1798         );
1799         }
1800         _;
1801     }
1802 
1803 
1804     constructor(
1805     ) ERC721A("DoodsVerse", "Doods", 100, maxSupply) {
1806     }
1807 
1808     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1809 
1810     function mint(uint256 numberOfTokens)
1811         external
1812         payable
1813         nonReentrant
1814         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1815         publicSaleActive
1816         canMintNFTs(numberOfTokens)
1817         maxMintsPerTX(numberOfTokens)
1818     {
1819 
1820         _safeMint(msg.sender, numberOfTokens);
1821     }
1822 
1823 
1824 
1825     //A simple free mint function to avoid confusion
1826     //The normal mint function with a cost of 0 would work too
1827 
1828     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1829 
1830     function getBaseURI() external view returns (string memory) {
1831         return baseURI;
1832     }
1833 
1834     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1835 
1836     function setBaseURI(string memory _baseURI) external onlyOwner {
1837         baseURI = _baseURI;
1838     }
1839 
1840     // function to disable gasless listings for security in case
1841     // opensea ever shuts down or is compromised
1842     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1843         external
1844         onlyOwner
1845     {
1846         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1847     }
1848 
1849     function setIsPublicSaleActive(bool _isPublicSaleActive)
1850         external
1851         onlyOwner
1852     {
1853         isPublicSaleActive = _isPublicSaleActive;
1854     }
1855 
1856     function setNumFreeMints(uint256 _numfreemints)
1857         external
1858         onlyOwner
1859     {
1860         NUM_FREE_MINTS = _numfreemints;
1861     }
1862 
1863 
1864     function withdraw() public onlyOwner {
1865         uint256 balance = address(this).balance;
1866         payable(msg.sender).transfer(balance);
1867     }
1868 
1869     function withdrawTokens(IERC20 token) public onlyOwner {
1870         uint256 balance = token.balanceOf(address(this));
1871         token.transfer(msg.sender, balance);
1872     }
1873 
1874 
1875 
1876     // ============ SUPPORTING FUNCTIONS ============
1877 
1878     function nextTokenId() private returns (uint256) {
1879         tokenCounter.increment();
1880         return tokenCounter.current();
1881     }
1882 
1883     // ============ FUNCTION OVERRIDES ============
1884 
1885     function supportsInterface(bytes4 interfaceId)
1886         public
1887         view
1888         virtual
1889         override(ERC721A, IERC165)
1890         returns (bool)
1891     {
1892         return
1893             interfaceId == type(IERC2981).interfaceId ||
1894             super.supportsInterface(interfaceId);
1895     }
1896 
1897     /**
1898      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1899      */
1900     function isApprovedForAll(address owner, address operator)
1901         public
1902         view
1903         override
1904         returns (bool)
1905     {
1906         // Get a reference to OpenSea's proxy registry contract by instantiating
1907         // the contract using the already existing address.
1908         ProxyRegistry proxyRegistry = ProxyRegistry(
1909             openSeaProxyRegistryAddress
1910         );
1911         if (
1912             isOpenSeaProxyActive &&
1913             address(proxyRegistry.proxies(owner)) == operator
1914         ) {
1915             return true;
1916         }
1917 
1918         return super.isApprovedForAll(owner, operator);
1919     }
1920 
1921     /**
1922      * @dev See {IERC721Metadata-tokenURI}.
1923      */
1924     function tokenURI(uint256 tokenId)
1925         public
1926         view
1927         virtual
1928         override
1929         returns (string memory)
1930     {
1931         require(_exists(tokenId), "Nonexistent token");
1932 
1933         return
1934             string(abi.encodePacked(baseURI, "/" ,(tokenId+1).toString(), ".json"));
1935     }
1936 
1937     /**
1938      * @dev See {IERC165-royaltyInfo}.
1939      */
1940     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1941         external
1942         view
1943         override
1944         returns (address receiver, uint256 royaltyAmount)
1945     {
1946         require(_exists(tokenId), "Nonexistent token");
1947 
1948         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1949     }
1950 }
1951 
1952 // These contract definitions are used to create a reference to the OpenSea
1953 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1954 contract OwnableDelegateProxy {
1955 
1956 }
1957 
1958 contract ProxyRegistry {
1959     mapping(address => OwnableDelegateProxy) public proxies;
1960 }