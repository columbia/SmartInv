1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-26
3 */
4 
5 /*
6 ascii 
7 */
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Counters.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @title Counters
242  * @author Matt Condon (@shrugs)
243  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
244  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
245  *
246  * Include with `using Counters for Counters.Counter;`
247  */
248 library Counters {
249     struct Counter {
250         // This variable should never be directly accessed by users of the library: interactions must be restricted to
251         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
252         // this feature: see https://github.com/ethereum/solidity/issues/4637
253         uint256 _value; // default: 0
254     }
255 
256     function current(Counter storage counter) internal view returns (uint256) {
257         return counter._value;
258     }
259 
260     function increment(Counter storage counter) internal {
261         unchecked {
262             counter._value += 1;
263         }
264     }
265 
266     function decrement(Counter storage counter) internal {
267         uint256 value = counter._value;
268         require(value > 0, "Counter: decrement overflow");
269         unchecked {
270             counter._value = value - 1;
271         }
272     }
273 
274     function reset(Counter storage counter) internal {
275         counter._value = 0;
276     }
277 }
278 
279 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 /**
287  * @dev Contract module that helps prevent reentrant calls to a function.
288  *
289  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
290  * available, which can be applied to functions to make sure there are no nested
291  * (reentrant) calls to them.
292  *
293  * Note that because there is a single `nonReentrant` guard, functions marked as
294  * `nonReentrant` may not call one another. This can be worked around by making
295  * those functions `private`, and then adding `external` `nonReentrant` entry
296  * points to them.
297  *
298  * TIP: If you would like to learn more about reentrancy and alternative ways
299  * to protect against it, check out our blog post
300  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
301  */
302 abstract contract ReentrancyGuard {
303     // Booleans are more expensive than uint256 or any type that takes up a full
304     // word because each write operation emits an extra SLOAD to first read the
305     // slot's contents, replace the bits taken up by the boolean, and then write
306     // back. This is the compiler's defense against contract upgrades and
307     // pointer aliasing, and it cannot be disabled.
308 
309     // The values being non-zero value makes deployment a bit more expensive,
310     // but in exchange the refund on every call to nonReentrant will be lower in
311     // amount. Since refunds are capped to a percentage of the total
312     // transaction's gas, it is best to keep them low in cases like this one, to
313     // increase the likelihood of the full refund coming into effect.
314     uint256 private constant _NOT_ENTERED = 1;
315     uint256 private constant _ENTERED = 2;
316 
317     uint256 private _status;
318 
319     constructor() {
320         _status = _NOT_ENTERED;
321     }
322 
323     /**
324      * @dev Prevents a contract from calling itself, directly or indirectly.
325      * Calling a `nonReentrant` function from another `nonReentrant`
326      * function is not supported. It is possible to prevent this from happening
327      * by making the `nonReentrant` function external, and making it call a
328      * `private` function that does the actual work.
329      */
330     modifier nonReentrant() {
331         // On the first call to nonReentrant, _notEntered will be true
332         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
333 
334         // Any calls to nonReentrant after this point will fail
335         _status = _ENTERED;
336 
337         _;
338 
339         // By storing the original value once again, a refund is triggered (see
340         // https://eips.ethereum.org/EIPS/eip-2200)
341         _status = _NOT_ENTERED;
342     }
343 }
344 
345 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev Interface of the ERC20 standard as defined in the EIP.
354  */
355 interface IERC20 {
356     /**
357      * @dev Returns the amount of tokens in existence.
358      */
359     function totalSupply() external view returns (uint256);
360 
361     /**
362      * @dev Returns the amount of tokens owned by `account`.
363      */
364     function balanceOf(address account) external view returns (uint256);
365 
366     /**
367      * @dev Moves `amount` tokens from the caller's account to `recipient`.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transfer(address recipient, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Returns the remaining number of tokens that `spender` will be
377      * allowed to spend on behalf of `owner` through {transferFrom}. This is
378      * zero by default.
379      *
380      * This value changes when {approve} or {transferFrom} are called.
381      */
382     function allowance(address owner, address spender) external view returns (uint256);
383 
384     /**
385      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * IMPORTANT: Beware that changing an allowance with this method brings the risk
390      * that someone may use both the old and the new allowance by unfortunate
391      * transaction ordering. One possible solution to mitigate this race
392      * condition is to first reduce the spender's allowance to 0 and set the
393      * desired value afterwards:
394      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
395      *
396      * Emits an {Approval} event.
397      */
398     function approve(address spender, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Moves `amount` tokens from `sender` to `recipient` using the
402      * allowance mechanism. `amount` is then deducted from the caller's
403      * allowance.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transferFrom(
410         address sender,
411         address recipient,
412         uint256 amount
413     ) external returns (bool);
414 
415     /**
416      * @dev Emitted when `value` tokens are moved from one account (`from`) to
417      * another (`to`).
418      *
419      * Note that `value` may be zero.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 value);
422 
423     /**
424      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
425      * a call to {approve}. `value` is the new allowance.
426      */
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 }
429 
430 // File: @openzeppelin/contracts/interfaces/IERC20.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 
438 // File: @openzeppelin/contracts/utils/Strings.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev String operations.
447  */
448 library Strings {
449     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
450 
451     /**
452      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
453      */
454     function toString(uint256 value) internal pure returns (string memory) {
455         // Inspired by OraclizeAPI's implementation - MIT licence
456         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
457 
458         if (value == 0) {
459             return "0";
460         }
461         uint256 temp = value;
462         uint256 digits;
463         while (temp != 0) {
464             digits++;
465             temp /= 10;
466         }
467         bytes memory buffer = new bytes(digits);
468         while (value != 0) {
469             digits -= 1;
470             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
471             value /= 10;
472         }
473         return string(buffer);
474     }
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
478      */
479     function toHexString(uint256 value) internal pure returns (string memory) {
480         if (value == 0) {
481             return "0x00";
482         }
483         uint256 temp = value;
484         uint256 length = 0;
485         while (temp != 0) {
486             length++;
487             temp >>= 8;
488         }
489         return toHexString(value, length);
490     }
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
494      */
495     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
496         bytes memory buffer = new bytes(2 * length + 2);
497         buffer[0] = "0";
498         buffer[1] = "x";
499         for (uint256 i = 2 * length + 1; i > 1; --i) {
500             buffer[i] = _HEX_SYMBOLS[value & 0xf];
501             value >>= 4;
502         }
503         require(value == 0, "Strings: hex length insufficient");
504         return string(buffer);
505     }
506 }
507 
508 // File: @openzeppelin/contracts/utils/Context.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Provides information about the current execution context, including the
517  * sender of the transaction and its data. While these are generally available
518  * via msg.sender and msg.data, they should not be accessed in such a direct
519  * manner, since when dealing with meta-transactions the account sending and
520  * paying for execution may not be the actual sender (as far as an application
521  * is concerned).
522  *
523  * This contract is only required for intermediate, library-like contracts.
524  */
525 abstract contract Context {
526     function _msgSender() internal view virtual returns (address) {
527         return msg.sender;
528     }
529 
530     function _msgData() internal view virtual returns (bytes calldata) {
531         return msg.data;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/access/Ownable.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Contract module which provides a basic access control mechanism, where
545  * there is an account (an owner) that can be granted exclusive access to
546  * specific functions.
547  *
548  * By default, the owner account will be the one that deploys the contract. This
549  * can later be changed with {transferOwnership}.
550  *
551  * This module is used through inheritance. It will make available the modifier
552  * `onlyOwner`, which can be applied to your functions to restrict their use to
553  * the owner.
554  */
555 abstract contract Ownable is Context {
556     address private _owner;
557 
558     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
559 
560     /**
561      * @dev Initializes the contract setting the deployer as the initial owner.
562      */
563     constructor() {
564         _transferOwnership(_msgSender());
565     }
566 
567     /**
568      * @dev Returns the address of the current owner.
569      */
570     function owner() public view virtual returns (address) {
571         return _owner;
572     }
573 
574     /**
575      * @dev Throws if called by any account other than the owner.
576      */
577     modifier onlyOwner() {
578         require(owner() == _msgSender(), "Ownable: caller is not the owner");
579         _;
580     }
581 
582     /**
583      * @dev Leaves the contract without owner. It will not be possible to call
584      * `onlyOwner` functions anymore. Can only be called by the current owner.
585      *
586      * NOTE: Renouncing ownership will leave the contract without an owner,
587      * thereby removing any functionality that is only available to the owner.
588      */
589     function renounceOwnership() public virtual onlyOwner {
590         _transferOwnership(address(0));
591     }
592 
593     /**
594      * @dev Transfers ownership of the contract to a new account (`newOwner`).
595      * Can only be called by the current owner.
596      */
597     function transferOwnership(address newOwner) public virtual onlyOwner {
598         require(newOwner != address(0), "Ownable: new owner is the zero address");
599         _transferOwnership(newOwner);
600     }
601 
602     /**
603      * @dev Transfers ownership of the contract to a new account (`newOwner`).
604      * Internal function without access restriction.
605      */
606     function _transferOwnership(address newOwner) internal virtual {
607         address oldOwner = _owner;
608         _owner = newOwner;
609         emit OwnershipTransferred(oldOwner, newOwner);
610     }
611 }
612 
613 // File: @openzeppelin/contracts/utils/Address.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Collection of functions related to the address type
622  */
623 library Address {
624     /**
625      * @dev Returns true if `account` is a contract.
626      *
627      * [IMPORTANT]
628      * ====
629      * It is unsafe to assume that an address for which this function returns
630      * false is an externally-owned account (EOA) and not a contract.
631      *
632      * Among others, `isContract` will return false for the following
633      * types of addresses:
634      *
635      *  - an externally-owned account
636      *  - a contract in construction
637      *  - an address where a contract will be created
638      *  - an address where a contract lived, but was destroyed
639      * ====
640      */
641     function isContract(address account) internal view returns (bool) {
642         // This method relies on extcodesize, which returns 0 for contracts in
643         // construction, since the code is only stored at the end of the
644         // constructor execution.
645 
646         uint256 size;
647         assembly {
648             size := extcodesize(account)
649         }
650         return size > 0;
651     }
652 
653     /**
654      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
655      * `recipient`, forwarding all available gas and reverting on errors.
656      *
657      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
658      * of certain opcodes, possibly making contracts go over the 2300 gas limit
659      * imposed by `transfer`, making them unable to receive funds via
660      * `transfer`. {sendValue} removes this limitation.
661      *
662      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
663      *
664      * IMPORTANT: because control is transferred to `recipient`, care must be
665      * taken to not create reentrancy vulnerabilities. Consider using
666      * {ReentrancyGuard} or the
667      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
668      */
669     function sendValue(address payable recipient, uint256 amount) internal {
670         require(address(this).balance >= amount, "Address: insufficient balance");
671 
672         (bool success, ) = recipient.call{value: amount}("");
673         require(success, "Address: unable to send value, recipient may have reverted");
674     }
675 
676     /**
677      * @dev Performs a Solidity function call using a low level `call`. A
678      * plain `call` is an unsafe replacement for a function call: use this
679      * function instead.
680      *
681      * If `target` reverts with a revert reason, it is bubbled up by this
682      * function (like regular Solidity function calls).
683      *
684      * Returns the raw returned data. To convert to the expected return value,
685      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
686      *
687      * Requirements:
688      *
689      * - `target` must be a contract.
690      * - calling `target` with `data` must not revert.
691      *
692      * _Available since v3.1._
693      */
694     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
695         return functionCall(target, data, "Address: low-level call failed");
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
700      * `errorMessage` as a fallback revert reason when `target` reverts.
701      *
702      * _Available since v3.1._
703      */
704     function functionCall(
705         address target,
706         bytes memory data,
707         string memory errorMessage
708     ) internal returns (bytes memory) {
709         return functionCallWithValue(target, data, 0, errorMessage);
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
714      * but also transferring `value` wei to `target`.
715      *
716      * Requirements:
717      *
718      * - the calling contract must have an ETH balance of at least `value`.
719      * - the called Solidity function must be `payable`.
720      *
721      * _Available since v3.1._
722      */
723     function functionCallWithValue(
724         address target,
725         bytes memory data,
726         uint256 value
727     ) internal returns (bytes memory) {
728         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
733      * with `errorMessage` as a fallback revert reason when `target` reverts.
734      *
735      * _Available since v3.1._
736      */
737     function functionCallWithValue(
738         address target,
739         bytes memory data,
740         uint256 value,
741         string memory errorMessage
742     ) internal returns (bytes memory) {
743         require(address(this).balance >= value, "Address: insufficient balance for call");
744         require(isContract(target), "Address: call to non-contract");
745 
746         (bool success, bytes memory returndata) = target.call{value: value}(data);
747         return verifyCallResult(success, returndata, errorMessage);
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
752      * but performing a static call.
753      *
754      * _Available since v3.3._
755      */
756     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
757         return functionStaticCall(target, data, "Address: low-level static call failed");
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
762      * but performing a static call.
763      *
764      * _Available since v3.3._
765      */
766     function functionStaticCall(
767         address target,
768         bytes memory data,
769         string memory errorMessage
770     ) internal view returns (bytes memory) {
771         require(isContract(target), "Address: static call to non-contract");
772 
773         (bool success, bytes memory returndata) = target.staticcall(data);
774         return verifyCallResult(success, returndata, errorMessage);
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
779      * but performing a delegate call.
780      *
781      * _Available since v3.4._
782      */
783     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
784         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
789      * but performing a delegate call.
790      *
791      * _Available since v3.4._
792      */
793     function functionDelegateCall(
794         address target,
795         bytes memory data,
796         string memory errorMessage
797     ) internal returns (bytes memory) {
798         require(isContract(target), "Address: delegate call to non-contract");
799 
800         (bool success, bytes memory returndata) = target.delegatecall(data);
801         return verifyCallResult(success, returndata, errorMessage);
802     }
803 
804     /**
805      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
806      * revert reason using the provided one.
807      *
808      * _Available since v4.3._
809      */
810     function verifyCallResult(
811         bool success,
812         bytes memory returndata,
813         string memory errorMessage
814     ) internal pure returns (bytes memory) {
815         if (success) {
816             return returndata;
817         } else {
818             // Look for revert reason and bubble it up if present
819             if (returndata.length > 0) {
820                 // The easiest way to bubble the revert reason is using memory via assembly
821 
822                 assembly {
823                     let returndata_size := mload(returndata)
824                     revert(add(32, returndata), returndata_size)
825                 }
826             } else {
827                 revert(errorMessage);
828             }
829         }
830     }
831 }
832 
833 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
834 
835 
836 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @title ERC721 token receiver interface
842  * @dev Interface for any contract that wants to support safeTransfers
843  * from ERC721 asset contracts.
844  */
845 interface IERC721Receiver {
846     /**
847      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
848      * by `operator` from `from`, this function is called.
849      *
850      * It must return its Solidity selector to confirm the token transfer.
851      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
852      *
853      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
854      */
855     function onERC721Received(
856         address operator,
857         address from,
858         uint256 tokenId,
859         bytes calldata data
860     ) external returns (bytes4);
861 }
862 
863 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
864 
865 
866 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 /**
871  * @dev Interface of the ERC165 standard, as defined in the
872  * https://eips.ethereum.org/EIPS/eip-165[EIP].
873  *
874  * Implementers can declare support of contract interfaces, which can then be
875  * queried by others ({ERC165Checker}).
876  *
877  * For an implementation, see {ERC165}.
878  */
879 interface IERC165 {
880     /**
881      * @dev Returns true if this contract implements the interface defined by
882      * `interfaceId`. See the corresponding
883      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
884      * to learn more about how these ids are created.
885      *
886      * This function call must use less than 30 000 gas.
887      */
888     function supportsInterface(bytes4 interfaceId) external view returns (bool);
889 }
890 
891 // File: @openzeppelin/contracts/interfaces/IERC165.sol
892 
893 
894 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 
899 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 
907 /**
908  * @dev Interface for the NFT Royalty Standard
909  */
910 interface IERC2981 is IERC165 {
911     /**
912      * @dev Called with the sale price to determine how much royalty is owed and to whom.
913      * @param tokenId - the NFT asset queried for royalty information
914      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
915      * @return receiver - address of who should be sent the royalty payment
916      * @return royaltyAmount - the royalty payment amount for `salePrice`
917      */
918     function royaltyInfo(uint256 tokenId, uint256 salePrice)
919         external
920         view
921         returns (address receiver, uint256 royaltyAmount);
922 }
923 
924 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
925 
926 
927 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 
932 /**
933  * @dev Implementation of the {IERC165} interface.
934  *
935  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
936  * for the additional interface id that will be supported. For example:
937  *
938  * ```solidity
939  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
940  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
941  * }
942  * ```
943  *
944  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
945  */
946 abstract contract ERC165 is IERC165 {
947     /**
948      * @dev See {IERC165-supportsInterface}.
949      */
950     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
951         return interfaceId == type(IERC165).interfaceId;
952     }
953 }
954 
955 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
956 
957 
958 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
959 
960 pragma solidity ^0.8.0;
961 
962 
963 /**
964  * @dev Required interface of an ERC721 compliant contract.
965  */
966 interface IERC721 is IERC165 {
967     /**
968      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
969      */
970     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
971 
972     /**
973      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
974      */
975     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
976 
977     /**
978      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
979      */
980     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
981 
982     /**
983      * @dev Returns the number of tokens in ``owner``'s account.
984      */
985     function balanceOf(address owner) external view returns (uint256 balance);
986 
987     /**
988      * @dev Returns the owner of the `tokenId` token.
989      *
990      * Requirements:
991      *
992      * - `tokenId` must exist.
993      */
994     function ownerOf(uint256 tokenId) external view returns (address owner);
995 
996     /**
997      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
998      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
999      *
1000      * Requirements:
1001      *
1002      * - `from` cannot be the zero address.
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must exist and be owned by `from`.
1005      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) external;
1015 
1016     /**
1017      * @dev Transfers `tokenId` token from `from` to `to`.
1018      *
1019      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1020      *
1021      * Requirements:
1022      *
1023      * - `from` cannot be the zero address.
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) external;
1035 
1036     /**
1037      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1038      * The approval is cleared when the token is transferred.
1039      *
1040      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1041      *
1042      * Requirements:
1043      *
1044      * - The caller must own the token or be an approved operator.
1045      * - `tokenId` must exist.
1046      *
1047      * Emits an {Approval} event.
1048      */
1049     function approve(address to, uint256 tokenId) external;
1050 
1051     /**
1052      * @dev Returns the account approved for `tokenId` token.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      */
1058     function getApproved(uint256 tokenId) external view returns (address operator);
1059 
1060     /**
1061      * @dev Approve or remove `operator` as an operator for the caller.
1062      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1063      *
1064      * Requirements:
1065      *
1066      * - The `operator` cannot be the caller.
1067      *
1068      * Emits an {ApprovalForAll} event.
1069      */
1070     function setApprovalForAll(address operator, bool _approved) external;
1071 
1072     /**
1073      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1074      *
1075      * See {setApprovalForAll}
1076      */
1077     function isApprovedForAll(address owner, address operator) external view returns (bool);
1078 
1079     /**
1080      * @dev Safely transfers `tokenId` token from `from` to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      * - `tokenId` token must exist and be owned by `from`.
1087      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function safeTransferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes calldata data
1097     ) external;
1098 }
1099 
1100 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1101 
1102 
1103 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 
1108 /**
1109  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1110  * @dev See https://eips.ethereum.org/EIPS/eip-721
1111  */
1112 interface IERC721Enumerable is IERC721 {
1113     /**
1114      * @dev Returns the total amount of tokens stored by the contract.
1115      */
1116     function totalSupply() external view returns (uint256);
1117 
1118     /**
1119      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1120      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1121      */
1122     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1123 
1124     /**
1125      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1126      * Use along with {totalSupply} to enumerate all tokens.
1127      */
1128     function tokenByIndex(uint256 index) external view returns (uint256);
1129 }
1130 
1131 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1132 
1133 
1134 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1135 
1136 pragma solidity ^0.8.0;
1137 
1138 
1139 /**
1140  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1141  * @dev See https://eips.ethereum.org/EIPS/eip-721
1142  */
1143 interface IERC721Metadata is IERC721 {
1144     /**
1145      * @dev Returns the token collection name.
1146      */
1147     function name() external view returns (string memory);
1148 
1149     /**
1150      * @dev Returns the token collection symbol.
1151      */
1152     function symbol() external view returns (string memory);
1153 
1154     /**
1155      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1156      */
1157     function tokenURI(uint256 tokenId) external view returns (string memory);
1158 }
1159 
1160 // File: contracts/ERC721A.sol
1161 
1162 
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 
1174 /**
1175  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1176  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1177  *
1178  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1179  *
1180  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1181  *
1182  * Does not support burning tokens to address(0).
1183  */
1184 contract ERC721A is
1185   Context,
1186   ERC165,
1187   IERC721,
1188   IERC721Metadata,
1189   IERC721Enumerable
1190 {
1191   using Address for address;
1192   using Strings for uint256;
1193 
1194   struct TokenOwnership {
1195     address addr;
1196     uint64 startTimestamp;
1197   }
1198 
1199   struct AddressData {
1200     uint128 balance;
1201     uint128 numberMinted;
1202   }
1203 
1204   uint256 private currentIndex = 0;
1205 
1206   uint256 internal immutable collectionSize;
1207   uint256 internal immutable maxBatchSize;
1208 
1209   // Token name
1210   string private _name;
1211 
1212   // Token symbol
1213   string private _symbol;
1214 
1215   // Mapping from token ID to ownership details
1216   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1217   mapping(uint256 => TokenOwnership) private _ownerships;
1218 
1219   // Mapping owner address to address data
1220   mapping(address => AddressData) private _addressData;
1221 
1222   // Mapping from token ID to approved address
1223   mapping(uint256 => address) private _tokenApprovals;
1224 
1225   // Mapping from owner to operator approvals
1226   mapping(address => mapping(address => bool)) private _operatorApprovals;
1227 
1228   /**
1229    * @dev
1230    * `maxBatchSize` refers to how much a minter can mint at a time.
1231    * `collectionSize_` refers to how many tokens are in the collection.
1232    */
1233   constructor(
1234     string memory name_,
1235     string memory symbol_,
1236     uint256 maxBatchSize_,
1237     uint256 collectionSize_
1238   ) {
1239     require(
1240       collectionSize_ > 0,
1241       "ERC721A: collection must have a nonzero supply"
1242     );
1243     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1244     _name = name_;
1245     _symbol = symbol_;
1246     maxBatchSize = maxBatchSize_;
1247     collectionSize = collectionSize_;
1248   }
1249 
1250   /**
1251    * @dev See {IERC721Enumerable-totalSupply}.
1252    */
1253   function totalSupply() public view override returns (uint256) {
1254     return currentIndex;
1255   }
1256 
1257   /**
1258    * @dev See {IERC721Enumerable-tokenByIndex}.
1259    */
1260   function tokenByIndex(uint256 index) public view override returns (uint256) {
1261     require(index < totalSupply(), "ERC721A: global index out of bounds");
1262     return index;
1263   }
1264 
1265   /**
1266    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1267    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1268    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1269    */
1270   function tokenOfOwnerByIndex(address owner, uint256 index)
1271     public
1272     view
1273     override
1274     returns (uint256)
1275   {
1276     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1277     uint256 numMintedSoFar = totalSupply();
1278     uint256 tokenIdsIdx = 0;
1279     address currOwnershipAddr = address(0);
1280     for (uint256 i = 0; i < numMintedSoFar; i++) {
1281       TokenOwnership memory ownership = _ownerships[i];
1282       if (ownership.addr != address(0)) {
1283         currOwnershipAddr = ownership.addr;
1284       }
1285       if (currOwnershipAddr == owner) {
1286         if (tokenIdsIdx == index) {
1287           return i;
1288         }
1289         tokenIdsIdx++;
1290       }
1291     }
1292     revert("ERC721A: unable to get token of owner by index");
1293   }
1294 
1295   /**
1296    * @dev See {IERC165-supportsInterface}.
1297    */
1298   function supportsInterface(bytes4 interfaceId)
1299     public
1300     view
1301     virtual
1302     override(ERC165, IERC165)
1303     returns (bool)
1304   {
1305     return
1306       interfaceId == type(IERC721).interfaceId ||
1307       interfaceId == type(IERC721Metadata).interfaceId ||
1308       interfaceId == type(IERC721Enumerable).interfaceId ||
1309       super.supportsInterface(interfaceId);
1310   }
1311 
1312   /**
1313    * @dev See {IERC721-balanceOf}.
1314    */
1315   function balanceOf(address owner) public view override returns (uint256) {
1316     require(owner != address(0), "ERC721A: balance query for the zero address");
1317     return uint256(_addressData[owner].balance);
1318   }
1319 
1320   function _numberMinted(address owner) internal view returns (uint256) {
1321     require(
1322       owner != address(0),
1323       "ERC721A: number minted query for the zero address"
1324     );
1325     return uint256(_addressData[owner].numberMinted);
1326   }
1327 
1328   function ownershipOf(uint256 tokenId)
1329     internal
1330     view
1331     returns (TokenOwnership memory)
1332   {
1333     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1334 
1335     uint256 lowestTokenToCheck;
1336     if (tokenId >= maxBatchSize) {
1337       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1338     }
1339 
1340     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1341       TokenOwnership memory ownership = _ownerships[curr];
1342       if (ownership.addr != address(0)) {
1343         return ownership;
1344       }
1345     }
1346 
1347     revert("ERC721A: unable to determine the owner of token");
1348   }
1349 
1350   /**
1351    * @dev See {IERC721-ownerOf}.
1352    */
1353   function ownerOf(uint256 tokenId) public view override returns (address) {
1354     return ownershipOf(tokenId).addr;
1355   }
1356 
1357   /**
1358    * @dev See {IERC721Metadata-name}.
1359    */
1360   function name() public view virtual override returns (string memory) {
1361     return _name;
1362   }
1363 
1364   /**
1365    * @dev See {IERC721Metadata-symbol}.
1366    */
1367   function symbol() public view virtual override returns (string memory) {
1368     return _symbol;
1369   }
1370 
1371   /**
1372    * @dev See {IERC721Metadata-tokenURI}.
1373    */
1374   function tokenURI(uint256 tokenId)
1375     public
1376     view
1377     virtual
1378     override
1379     returns (string memory)
1380   {
1381     require(
1382       _exists(tokenId),
1383       "ERC721Metadata: URI query for nonexistent token"
1384     );
1385 
1386     string memory baseURI = _baseURI();
1387     return
1388       bytes(baseURI).length > 0
1389         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1390         : "";
1391   }
1392 
1393   /**
1394    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1395    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1396    * by default, can be overriden in child contracts.
1397    */
1398   function _baseURI() internal view virtual returns (string memory) {
1399     return "";
1400   }
1401 
1402   /**
1403    * @dev See {IERC721-approve}.
1404    */
1405   function approve(address to, uint256 tokenId) public override {
1406     address owner = ERC721A.ownerOf(tokenId);
1407     require(to != owner, "ERC721A: approval to current owner");
1408 
1409     require(
1410       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1411       "ERC721A: approve caller is not owner nor approved for all"
1412     );
1413 
1414     _approve(to, tokenId, owner);
1415   }
1416 
1417   /**
1418    * @dev See {IERC721-getApproved}.
1419    */
1420   function getApproved(uint256 tokenId) public view override returns (address) {
1421     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1422 
1423     return _tokenApprovals[tokenId];
1424   }
1425 
1426   /**
1427    * @dev See {IERC721-setApprovalForAll}.
1428    */
1429   function setApprovalForAll(address operator, bool approved) public override {
1430     require(operator != _msgSender(), "ERC721A: approve to caller");
1431 
1432     _operatorApprovals[_msgSender()][operator] = approved;
1433     emit ApprovalForAll(_msgSender(), operator, approved);
1434   }
1435 
1436   /**
1437    * @dev See {IERC721-isApprovedForAll}.
1438    */
1439   function isApprovedForAll(address owner, address operator)
1440     public
1441     view
1442     virtual
1443     override
1444     returns (bool)
1445   {
1446     return _operatorApprovals[owner][operator];
1447   }
1448 
1449   /**
1450    * @dev See {IERC721-transferFrom}.
1451    */
1452   function transferFrom(
1453     address from,
1454     address to,
1455     uint256 tokenId
1456   ) public override {
1457     _transfer(from, to, tokenId);
1458   }
1459 
1460   /**
1461    * @dev See {IERC721-safeTransferFrom}.
1462    */
1463   function safeTransferFrom(
1464     address from,
1465     address to,
1466     uint256 tokenId
1467   ) public override {
1468     safeTransferFrom(from, to, tokenId, "");
1469   }
1470 
1471   /**
1472    * @dev See {IERC721-safeTransferFrom}.
1473    */
1474   function safeTransferFrom(
1475     address from,
1476     address to,
1477     uint256 tokenId,
1478     bytes memory _data
1479   ) public override {
1480     _transfer(from, to, tokenId);
1481     require(
1482       _checkOnERC721Received(from, to, tokenId, _data),
1483       "ERC721A: transfer to non ERC721Receiver implementer"
1484     );
1485   }
1486 
1487   /**
1488    * @dev Returns whether `tokenId` exists.
1489    *
1490    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1491    *
1492    * Tokens start existing when they are minted (`_mint`),
1493    */
1494   function _exists(uint256 tokenId) internal view returns (bool) {
1495     return tokenId < currentIndex;
1496   }
1497 
1498   function _safeMint(address to, uint256 quantity) internal {
1499     _safeMint(to, quantity, "");
1500   }
1501 
1502   /**
1503    * @dev Mints `quantity` tokens and transfers them to `to`.
1504    *
1505    * Requirements:
1506    *
1507    * - there must be `quantity` tokens remaining unminted in the total collection.
1508    * - `to` cannot be the zero address.
1509    * - `quantity` cannot be larger than the max batch size.
1510    *
1511    * Emits a {Transfer} event.
1512    */
1513   function _safeMint(
1514     address to,
1515     uint256 quantity,
1516     bytes memory _data
1517   ) internal {
1518     uint256 startTokenId = currentIndex;
1519     require(to != address(0), "ERC721A: mint to the zero address");
1520     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1521     require(!_exists(startTokenId), "ERC721A: token already minted");
1522     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1523 
1524     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1525 
1526     AddressData memory addressData = _addressData[to];
1527     _addressData[to] = AddressData(
1528       addressData.balance + uint128(quantity),
1529       addressData.numberMinted + uint128(quantity)
1530     );
1531     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1532 
1533     uint256 updatedIndex = startTokenId;
1534 
1535     for (uint256 i = 0; i < quantity; i++) {
1536       emit Transfer(address(0), to, updatedIndex);
1537       require(
1538         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1539         "ERC721A: transfer to non ERC721Receiver implementer"
1540       );
1541       updatedIndex++;
1542     }
1543 
1544     currentIndex = updatedIndex;
1545     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1546   }
1547 
1548   /**
1549    * @dev Transfers `tokenId` from `from` to `to`.
1550    *
1551    * Requirements:
1552    *
1553    * - `to` cannot be the zero address.
1554    * - `tokenId` token must be owned by `from`.
1555    *
1556    * Emits a {Transfer} event.
1557    */
1558   function _transfer(
1559     address from,
1560     address to,
1561     uint256 tokenId
1562   ) private {
1563     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1564 
1565     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1566       getApproved(tokenId) == _msgSender() ||
1567       isApprovedForAll(prevOwnership.addr, _msgSender()));
1568 
1569     require(
1570       isApprovedOrOwner,
1571       "ERC721A: transfer caller is not owner nor approved"
1572     );
1573 
1574     require(
1575       prevOwnership.addr == from,
1576       "ERC721A: transfer from incorrect owner"
1577     );
1578     require(to != address(0), "ERC721A: transfer to the zero address");
1579 
1580     _beforeTokenTransfers(from, to, tokenId, 1);
1581 
1582     // Clear approvals from the previous owner
1583     _approve(address(0), tokenId, prevOwnership.addr);
1584 
1585     _addressData[from].balance -= 1;
1586     _addressData[to].balance += 1;
1587     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1588 
1589     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1590     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1591     uint256 nextTokenId = tokenId + 1;
1592     if (_ownerships[nextTokenId].addr == address(0)) {
1593       if (_exists(nextTokenId)) {
1594         _ownerships[nextTokenId] = TokenOwnership(
1595           prevOwnership.addr,
1596           prevOwnership.startTimestamp
1597         );
1598       }
1599     }
1600 
1601     emit Transfer(from, to, tokenId);
1602     _afterTokenTransfers(from, to, tokenId, 1);
1603   }
1604 
1605   /**
1606    * @dev Approve `to` to operate on `tokenId`
1607    *
1608    * Emits a {Approval} event.
1609    */
1610   function _approve(
1611     address to,
1612     uint256 tokenId,
1613     address owner
1614   ) private {
1615     _tokenApprovals[tokenId] = to;
1616     emit Approval(owner, to, tokenId);
1617   }
1618 
1619   uint256 public nextOwnerToExplicitlySet = 0;
1620 
1621   /**
1622    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1623    */
1624   function _setOwnersExplicit(uint256 quantity) internal {
1625     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1626     require(quantity > 0, "quantity must be nonzero");
1627     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1628     if (endIndex > collectionSize - 1) {
1629       endIndex = collectionSize - 1;
1630     }
1631     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1632     require(_exists(endIndex), "not enough minted yet for this cleanup");
1633     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1634       if (_ownerships[i].addr == address(0)) {
1635         TokenOwnership memory ownership = ownershipOf(i);
1636         _ownerships[i] = TokenOwnership(
1637           ownership.addr,
1638           ownership.startTimestamp
1639         );
1640       }
1641     }
1642     nextOwnerToExplicitlySet = endIndex + 1;
1643   }
1644 
1645   /**
1646    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1647    * The call is not executed if the target address is not a contract.
1648    *
1649    * @param from address representing the previous owner of the given token ID
1650    * @param to target address that will receive the tokens
1651    * @param tokenId uint256 ID of the token to be transferred
1652    * @param _data bytes optional data to send along with the call
1653    * @return bool whether the call correctly returned the expected magic value
1654    */
1655   function _checkOnERC721Received(
1656     address from,
1657     address to,
1658     uint256 tokenId,
1659     bytes memory _data
1660   ) private returns (bool) {
1661     if (to.isContract()) {
1662       try
1663         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1664       returns (bytes4 retval) {
1665         return retval == IERC721Receiver(to).onERC721Received.selector;
1666       } catch (bytes memory reason) {
1667         if (reason.length == 0) {
1668           revert("ERC721A: transfer to non ERC721Receiver implementer");
1669         } else {
1670           assembly {
1671             revert(add(32, reason), mload(reason))
1672           }
1673         }
1674       }
1675     } else {
1676       return true;
1677     }
1678   }
1679 
1680   /**
1681    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1682    *
1683    * startTokenId - the first token id to be transferred
1684    * quantity - the amount to be transferred
1685    *
1686    * Calling conditions:
1687    *
1688    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1689    * transferred to `to`.
1690    * - When `from` is zero, `tokenId` will be minted for `to`.
1691    */
1692   function _beforeTokenTransfers(
1693     address from,
1694     address to,
1695     uint256 startTokenId,
1696     uint256 quantity
1697   ) internal virtual {}
1698 
1699   /**
1700    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1701    * minting.
1702    *
1703    * startTokenId - the first token id to be transferred
1704    * quantity - the amount to be transferred
1705    *
1706    * Calling conditions:
1707    *
1708    * - when `from` and `to` are both non-zero.
1709    * - `from` and `to` are never both zero.
1710    */
1711   function _afterTokenTransfers(
1712     address from,
1713     address to,
1714     uint256 startTokenId,
1715     uint256 quantity
1716   ) internal virtual {}
1717 }
1718 
1719 //SPDX-License-Identifier: MIT
1720 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1721 
1722 pragma solidity ^0.8.0;
1723 
1724 contract Bullrunners is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1725     using Counters for Counters.Counter;
1726     using Strings for uint256;
1727 
1728     Counters.Counter private tokenCounter;
1729 
1730     string private baseURI = "";
1731     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1732     bool private isOpenSeaProxyActive = true;
1733 
1734     uint256 public constant MAX_MINTS_PER_TX = 5;
1735     uint256 public maxSupply = 10000;
1736 
1737     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1738     uint256 public NUM_FREE_MINTS = 5000;
1739     bool public isPublicSaleActive = true;
1740 
1741 
1742 
1743 
1744     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1745 
1746     modifier publicSaleActive() {
1747         require(isPublicSaleActive, "Public sale is not open");
1748         _;
1749     }
1750 
1751 
1752 
1753     modifier maxMintsPerTX(uint256 numberOfTokens) {
1754         require(
1755             numberOfTokens <= MAX_MINTS_PER_TX,
1756             "Max mints per transaction exceeded"
1757         );
1758         _;
1759     }
1760 
1761     modifier canMintNFTs(uint256 numberOfTokens) {
1762         require(
1763             totalSupply() + numberOfTokens <=
1764                 maxSupply,
1765             "Not enough mints remaining to mint"
1766         );
1767         _;
1768     }
1769 
1770     modifier freeMintsAvailable() {
1771         require(
1772             totalSupply() <=
1773                 NUM_FREE_MINTS,
1774             "Not enough free mints remain"
1775         );
1776         _;
1777     }
1778 
1779 
1780 
1781     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1782         if(totalSupply()>NUM_FREE_MINTS){
1783         require(
1784             (price * numberOfTokens) == msg.value,
1785             "Incorrect ETH value sent"
1786         );
1787         }
1788         _;
1789     }
1790 
1791 
1792     constructor(
1793     ) ERC721A("Bullrunners", "Bullrunners", 100, maxSupply) {
1794     }
1795 
1796     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1797 
1798     function mint(uint256 numberOfTokens)
1799         external
1800         payable
1801         nonReentrant
1802         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1803         publicSaleActive
1804         canMintNFTs(numberOfTokens)
1805         maxMintsPerTX(numberOfTokens)
1806     {
1807 
1808         _safeMint(msg.sender, numberOfTokens);
1809     }
1810 
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
1845     function mints(uint256 _numfreemints)
1846         external
1847         onlyOwner
1848     {
1849         NUM_FREE_MINTS = _numfreemints;
1850     }
1851 
1852 
1853     function withdraw() public onlyOwner {
1854         uint256 balance = address(this).balance;
1855         payable(msg.sender).transfer(balance);
1856     }
1857 
1858     function withdrawTokens(IERC20 token) public onlyOwner {
1859         uint256 balance = token.balanceOf(address(this));
1860         token.transfer(msg.sender, balance);
1861     }
1862 
1863 
1864 
1865     // ============ SUPPORTING FUNCTIONS ============
1866 
1867     function nextTokenId() private returns (uint256) {
1868         tokenCounter.increment();
1869         return tokenCounter.current();
1870     }
1871 
1872     // ============ FUNCTION OVERRIDES ============
1873 
1874     function supportsInterface(bytes4 interfaceId)
1875         public
1876         view
1877         virtual
1878         override(ERC721A, IERC165)
1879         returns (bool)
1880     {
1881         return
1882             interfaceId == type(IERC2981).interfaceId ||
1883             super.supportsInterface(interfaceId);
1884     }
1885 
1886     /**
1887      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1888      */
1889     function isApprovedForAll(address owner, address operator)
1890         public
1891         view
1892         override
1893         returns (bool)
1894     {
1895         // Get a reference to OpenSea's proxy registry contract by instantiating
1896         // the contract using the already existing address.
1897         ProxyRegistry proxyRegistry = ProxyRegistry(
1898             openSeaProxyRegistryAddress
1899         );
1900         if (
1901             isOpenSeaProxyActive &&
1902             address(proxyRegistry.proxies(owner)) == operator
1903         ) {
1904             return true;
1905         }
1906 
1907         return super.isApprovedForAll(owner, operator);
1908     }
1909 
1910     /**
1911      * @dev See {IERC721Metadata-tokenURI}.
1912      */
1913     function tokenURI(uint256 tokenId)
1914         public
1915         view
1916         virtual
1917         override
1918         returns (string memory)
1919     {
1920         require(_exists(tokenId), "Nonexistent token");
1921 
1922         return
1923             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1924     }
1925 
1926     /**
1927      * @dev See {IERC165-royaltyInfo}.
1928      */
1929     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1930         external
1931         view
1932         override
1933         returns (address receiver, uint256 royaltyAmount)
1934     {
1935         require(_exists(tokenId), "Nonexistent token");
1936 
1937         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1938     }
1939 }
1940 
1941 // These contract definitions are used to create a reference to the OpenSea
1942 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1943 contract OwnableDelegateProxy {
1944 
1945 }
1946 
1947 contract ProxyRegistry {
1948     mapping(address => OwnableDelegateProxy) public proxies;
1949 }