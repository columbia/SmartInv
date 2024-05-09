1 /*
2 ███    ██       ██     ██  ██████  ██████  ██████      ██████   █████  ███████ ███████ 
3 ████   ██       ██     ██ ██    ██ ██   ██ ██   ██     ██   ██ ██   ██ ██      ██      
4 ██ ██  ██ █████ ██  █  ██ ██    ██ ██████  ██   ██     ██████  ███████ ███████ ███████ 
5 ██  ██ ██       ██ ███ ██ ██    ██ ██   ██ ██   ██     ██      ██   ██      ██      ██ 
6 ██   ████        ███ ███   ██████  ██   ██ ██████      ██      ██   ██ ███████ ███████                                                                                                                                                                             
7  */
8 
9 
10 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 // CAUTION
18 // This version of SafeMath should only be used with Solidity 0.8 or later,
19 // because it relies on the compiler's built in overflow checks.
20 
21 /**
22  * @dev Wrappers over Solidity's arithmetic operations.
23  *
24  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
25  * now has built in overflow checking.
26  */
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             uint256 c = a + b;
36             if (c < a) return (false, 0);
37             return (true, c);
38         }
39     }
40 
41     /**
42      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b > a) return (false, 0);
49             return (true, a - b);
50         }
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61             // benefit is lost if 'b' is also tested.
62             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63             if (a == 0) return (true, 0);
64             uint256 c = a * b;
65             if (c / a != b) return (false, 0);
66             return (true, c);
67         }
68     }
69 
70     /**
71      * @dev Returns the division of two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a / b);
79         }
80     }
81 
82     /**
83      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a % b);
91         }
92     }
93 
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a + b;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a - b;
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `*` operator.
127      *
128      * Requirements:
129      *
130      * - Multiplication cannot overflow.
131      */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a * b;
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers, reverting on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator.
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a / b;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * reverting when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a % b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * CAUTION: This function is deprecated because it requires allocating memory for the error
171      * message unnecessarily. For custom revert reasons use {trySub}.
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         unchecked {
185             require(b <= a, errorMessage);
186             return a - b;
187         }
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         unchecked {
208             require(b > 0, errorMessage);
209             return a / b;
210         }
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * reverting with custom message when dividing by zero.
216      *
217      * CAUTION: This function is deprecated because it requires allocating memory for the error
218      * message unnecessarily. For custom revert reasons use {tryMod}.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(
229         uint256 a,
230         uint256 b,
231         string memory errorMessage
232     ) internal pure returns (uint256) {
233         unchecked {
234             require(b > 0, errorMessage);
235             return a % b;
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Counters.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @title Counters
249  * @author Matt Condon (@shrugs)
250  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
251  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
252  *
253  * Include with `using Counters for Counters.Counter;`
254  */
255 library Counters {
256     struct Counter {
257         // This variable should never be directly accessed by users of the library: interactions must be restricted to
258         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
259         // this feature: see https://github.com/ethereum/solidity/issues/4637
260         uint256 _value; // default: 0
261     }
262 
263     function current(Counter storage counter) internal view returns (uint256) {
264         return counter._value;
265     }
266 
267     function increment(Counter storage counter) internal {
268         unchecked {
269             counter._value += 1;
270         }
271     }
272 
273     function decrement(Counter storage counter) internal {
274         uint256 value = counter._value;
275         require(value > 0, "Counter: decrement overflow");
276         unchecked {
277             counter._value = value - 1;
278         }
279     }
280 
281     function reset(Counter storage counter) internal {
282         counter._value = 0;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Contract module that helps prevent reentrant calls to a function.
295  *
296  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
297  * available, which can be applied to functions to make sure there are no nested
298  * (reentrant) calls to them.
299  *
300  * Note that because there is a single `nonReentrant` guard, functions marked as
301  * `nonReentrant` may not call one another. This can be worked around by making
302  * those functions `private`, and then adding `external` `nonReentrant` entry
303  * points to them.
304  *
305  * TIP: If you would like to learn more about reentrancy and alternative ways
306  * to protect against it, check out our blog post
307  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
308  */
309 abstract contract ReentrancyGuard {
310     // Booleans are more expensive than uint256 or any type that takes up a full
311     // word because each write operation emits an extra SLOAD to first read the
312     // slot's contents, replace the bits taken up by the boolean, and then write
313     // back. This is the compiler's defense against contract upgrades and
314     // pointer aliasing, and it cannot be disabled.
315 
316     // The values being non-zero value makes deployment a bit more expensive,
317     // but in exchange the refund on every call to nonReentrant will be lower in
318     // amount. Since refunds are capped to a percentage of the total
319     // transaction's gas, it is best to keep them low in cases like this one, to
320     // increase the likelihood of the full refund coming into effect.
321     uint256 private constant _NOT_ENTERED = 1;
322     uint256 private constant _ENTERED = 2;
323 
324     uint256 private _status;
325 
326     constructor() {
327         _status = _NOT_ENTERED;
328     }
329 
330     /**
331      * @dev Prevents a contract from calling itself, directly or indirectly.
332      * Calling a `nonReentrant` function from another `nonReentrant`
333      * function is not supported. It is possible to prevent this from happening
334      * by making the `nonReentrant` function external, and making it call a
335      * `private` function that does the actual work.
336      */
337     modifier nonReentrant() {
338         // On the first call to nonReentrant, _notEntered will be true
339         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
340 
341         // Any calls to nonReentrant after this point will fail
342         _status = _ENTERED;
343 
344         _;
345 
346         // By storing the original value once again, a refund is triggered (see
347         // https://eips.ethereum.org/EIPS/eip-2200)
348         _status = _NOT_ENTERED;
349     }
350 }
351 
352 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP.
361  */
362 interface IERC20 {
363     /**
364      * @dev Returns the amount of tokens in existence.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     /**
369      * @dev Returns the amount of tokens owned by `account`.
370      */
371     function balanceOf(address account) external view returns (uint256);
372 
373     /**
374      * @dev Moves `amount` tokens from the caller's account to `recipient`.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transfer(address recipient, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Returns the remaining number of tokens that `spender` will be
384      * allowed to spend on behalf of `owner` through {transferFrom}. This is
385      * zero by default.
386      *
387      * This value changes when {approve} or {transferFrom} are called.
388      */
389     function allowance(address owner, address spender) external view returns (uint256);
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * IMPORTANT: Beware that changing an allowance with this method brings the risk
397      * that someone may use both the old and the new allowance by unfortunate
398      * transaction ordering. One possible solution to mitigate this race
399      * condition is to first reduce the spender's allowance to 0 and set the
400      * desired value afterwards:
401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address spender, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Moves `amount` tokens from `sender` to `recipient` using the
409      * allowance mechanism. `amount` is then deducted from the caller's
410      * allowance.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(
417         address sender,
418         address recipient,
419         uint256 amount
420     ) external returns (bool);
421 
422     /**
423      * @dev Emitted when `value` tokens are moved from one account (`from`) to
424      * another (`to`).
425      *
426      * Note that `value` may be zero.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 value);
429 
430     /**
431      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
432      * a call to {approve}. `value` is the new allowance.
433      */
434     event Approval(address indexed owner, address indexed spender, uint256 value);
435 }
436 
437 // File: @openzeppelin/contracts/interfaces/IERC20.sol
438 
439 
440 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 
445 // File: @openzeppelin/contracts/utils/Strings.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev String operations.
454  */
455 library Strings {
456     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
460      */
461     function toString(uint256 value) internal pure returns (string memory) {
462         // Inspired by OraclizeAPI's implementation - MIT licence
463         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
464 
465         if (value == 0) {
466             return "0";
467         }
468         uint256 temp = value;
469         uint256 digits;
470         while (temp != 0) {
471             digits++;
472             temp /= 10;
473         }
474         bytes memory buffer = new bytes(digits);
475         while (value != 0) {
476             digits -= 1;
477             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
478             value /= 10;
479         }
480         return string(buffer);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
485      */
486     function toHexString(uint256 value) internal pure returns (string memory) {
487         if (value == 0) {
488             return "0x00";
489         }
490         uint256 temp = value;
491         uint256 length = 0;
492         while (temp != 0) {
493             length++;
494             temp >>= 8;
495         }
496         return toHexString(value, length);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
501      */
502     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
503         bytes memory buffer = new bytes(2 * length + 2);
504         buffer[0] = "0";
505         buffer[1] = "x";
506         for (uint256 i = 2 * length + 1; i > 1; --i) {
507             buffer[i] = _HEX_SYMBOLS[value & 0xf];
508             value >>= 4;
509         }
510         require(value == 0, "Strings: hex length insufficient");
511         return string(buffer);
512     }
513 }
514 
515 // File: @openzeppelin/contracts/utils/Context.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Provides information about the current execution context, including the
524  * sender of the transaction and its data. While these are generally available
525  * via msg.sender and msg.data, they should not be accessed in such a direct
526  * manner, since when dealing with meta-transactions the account sending and
527  * paying for execution may not be the actual sender (as far as an application
528  * is concerned).
529  *
530  * This contract is only required for intermediate, library-like contracts.
531  */
532 abstract contract Context {
533     function _msgSender() internal view virtual returns (address) {
534         return msg.sender;
535     }
536 
537     function _msgData() internal view virtual returns (bytes calldata) {
538         return msg.data;
539     }
540 }
541 
542 // File: @openzeppelin/contracts/access/Ownable.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Contract module which provides a basic access control mechanism, where
552  * there is an account (an owner) that can be granted exclusive access to
553  * specific functions.
554  *
555  * By default, the owner account will be the one that deploys the contract. This
556  * can later be changed with {transferOwnership}.
557  *
558  * This module is used through inheritance. It will make available the modifier
559  * `onlyOwner`, which can be applied to your functions to restrict their use to
560  * the owner.
561  */
562 abstract contract Ownable is Context {
563     address private _owner;
564 
565     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
566 
567     /**
568      * @dev Initializes the contract setting the deployer as the initial owner.
569      */
570     constructor() {
571         _transferOwnership(_msgSender());
572     }
573 
574     /**
575      * @dev Returns the address of the current owner.
576      */
577     function owner() public view virtual returns (address) {
578         return _owner;
579     }
580 
581     /**
582      * @dev Throws if called by any account other than the owner.
583      */
584     modifier onlyOwner() {
585         require(owner() == _msgSender(), "Ownable: caller is not the owner");
586         _;
587     }
588 
589     /**
590      * @dev Leaves the contract without owner. It will not be possible to call
591      * `onlyOwner` functions anymore. Can only be called by the current owner.
592      *
593      * NOTE: Renouncing ownership will leave the contract without an owner,
594      * thereby removing any functionality that is only available to the owner.
595      */
596     function renounceOwnership() public virtual onlyOwner {
597         _transferOwnership(address(0));
598     }
599 
600     /**
601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
602      * Can only be called by the current owner.
603      */
604     function transferOwnership(address newOwner) public virtual onlyOwner {
605         require(newOwner != address(0), "Ownable: new owner is the zero address");
606         _transferOwnership(newOwner);
607     }
608 
609     /**
610      * @dev Transfers ownership of the contract to a new account (`newOwner`).
611      * Internal function without access restriction.
612      */
613     function _transferOwnership(address newOwner) internal virtual {
614         address oldOwner = _owner;
615         _owner = newOwner;
616         emit OwnershipTransferred(oldOwner, newOwner);
617     }
618 }
619 
620 // File: @openzeppelin/contracts/utils/Address.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Collection of functions related to the address type
629  */
630 library Address {
631     /**
632      * @dev Returns true if `account` is a contract.
633      *
634      * [IMPORTANT]
635      * ====
636      * It is unsafe to assume that an address for which this function returns
637      * false is an externally-owned account (EOA) and not a contract.
638      *
639      * Among others, `isContract` will return false for the following
640      * types of addresses:
641      *
642      *  - an externally-owned account
643      *  - a contract in construction
644      *  - an address where a contract will be created
645      *  - an address where a contract lived, but was destroyed
646      * ====
647      */
648     function isContract(address account) internal view returns (bool) {
649         // This method relies on extcodesize, which returns 0 for contracts in
650         // construction, since the code is only stored at the end of the
651         // constructor execution.
652 
653         uint256 size;
654         assembly {
655             size := extcodesize(account)
656         }
657         return size > 0;
658     }
659 
660     /**
661      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
662      * `recipient`, forwarding all available gas and reverting on errors.
663      *
664      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
665      * of certain opcodes, possibly making contracts go over the 2300 gas limit
666      * imposed by `transfer`, making them unable to receive funds via
667      * `transfer`. {sendValue} removes this limitation.
668      *
669      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
670      *
671      * IMPORTANT: because control is transferred to `recipient`, care must be
672      * taken to not create reentrancy vulnerabilities. Consider using
673      * {ReentrancyGuard} or the
674      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
675      */
676     function sendValue(address payable recipient, uint256 amount) internal {
677         require(address(this).balance >= amount, "Address: insufficient balance");
678 
679         (bool success, ) = recipient.call{value: amount}("");
680         require(success, "Address: unable to send value, recipient may have reverted");
681     }
682 
683     /**
684      * @dev Performs a Solidity function call using a low level `call`. A
685      * plain `call` is an unsafe replacement for a function call: use this
686      * function instead.
687      *
688      * If `target` reverts with a revert reason, it is bubbled up by this
689      * function (like regular Solidity function calls).
690      *
691      * Returns the raw returned data. To convert to the expected return value,
692      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
693      *
694      * Requirements:
695      *
696      * - `target` must be a contract.
697      * - calling `target` with `data` must not revert.
698      *
699      * _Available since v3.1._
700      */
701     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
702         return functionCall(target, data, "Address: low-level call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
707      * `errorMessage` as a fallback revert reason when `target` reverts.
708      *
709      * _Available since v3.1._
710      */
711     function functionCall(
712         address target,
713         bytes memory data,
714         string memory errorMessage
715     ) internal returns (bytes memory) {
716         return functionCallWithValue(target, data, 0, errorMessage);
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
721      * but also transferring `value` wei to `target`.
722      *
723      * Requirements:
724      *
725      * - the calling contract must have an ETH balance of at least `value`.
726      * - the called Solidity function must be `payable`.
727      *
728      * _Available since v3.1._
729      */
730     function functionCallWithValue(
731         address target,
732         bytes memory data,
733         uint256 value
734     ) internal returns (bytes memory) {
735         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
740      * with `errorMessage` as a fallback revert reason when `target` reverts.
741      *
742      * _Available since v3.1._
743      */
744     function functionCallWithValue(
745         address target,
746         bytes memory data,
747         uint256 value,
748         string memory errorMessage
749     ) internal returns (bytes memory) {
750         require(address(this).balance >= value, "Address: insufficient balance for call");
751         require(isContract(target), "Address: call to non-contract");
752 
753         (bool success, bytes memory returndata) = target.call{value: value}(data);
754         return verifyCallResult(success, returndata, errorMessage);
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
759      * but performing a static call.
760      *
761      * _Available since v3.3._
762      */
763     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
764         return functionStaticCall(target, data, "Address: low-level static call failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
769      * but performing a static call.
770      *
771      * _Available since v3.3._
772      */
773     function functionStaticCall(
774         address target,
775         bytes memory data,
776         string memory errorMessage
777     ) internal view returns (bytes memory) {
778         require(isContract(target), "Address: static call to non-contract");
779 
780         (bool success, bytes memory returndata) = target.staticcall(data);
781         return verifyCallResult(success, returndata, errorMessage);
782     }
783 
784     /**
785      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
786      * but performing a delegate call.
787      *
788      * _Available since v3.4._
789      */
790     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
791         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
792     }
793 
794     /**
795      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
796      * but performing a delegate call.
797      *
798      * _Available since v3.4._
799      */
800     function functionDelegateCall(
801         address target,
802         bytes memory data,
803         string memory errorMessage
804     ) internal returns (bytes memory) {
805         require(isContract(target), "Address: delegate call to non-contract");
806 
807         (bool success, bytes memory returndata) = target.delegatecall(data);
808         return verifyCallResult(success, returndata, errorMessage);
809     }
810 
811     /**
812      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
813      * revert reason using the provided one.
814      *
815      * _Available since v4.3._
816      */
817     function verifyCallResult(
818         bool success,
819         bytes memory returndata,
820         string memory errorMessage
821     ) internal pure returns (bytes memory) {
822         if (success) {
823             return returndata;
824         } else {
825             // Look for revert reason and bubble it up if present
826             if (returndata.length > 0) {
827                 // The easiest way to bubble the revert reason is using memory via assembly
828 
829                 assembly {
830                     let returndata_size := mload(returndata)
831                     revert(add(32, returndata), returndata_size)
832                 }
833             } else {
834                 revert(errorMessage);
835             }
836         }
837     }
838 }
839 
840 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @title ERC721 token receiver interface
849  * @dev Interface for any contract that wants to support safeTransfers
850  * from ERC721 asset contracts.
851  */
852 interface IERC721Receiver {
853     /**
854      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
855      * by `operator` from `from`, this function is called.
856      *
857      * It must return its Solidity selector to confirm the token transfer.
858      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
859      *
860      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
861      */
862     function onERC721Received(
863         address operator,
864         address from,
865         uint256 tokenId,
866         bytes calldata data
867     ) external returns (bytes4);
868 }
869 
870 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
871 
872 
873 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
874 
875 pragma solidity ^0.8.0;
876 
877 /**
878  * @dev Interface of the ERC165 standard, as defined in the
879  * https://eips.ethereum.org/EIPS/eip-165[EIP].
880  *
881  * Implementers can declare support of contract interfaces, which can then be
882  * queried by others ({ERC165Checker}).
883  *
884  * For an implementation, see {ERC165}.
885  */
886 interface IERC165 {
887     /**
888      * @dev Returns true if this contract implements the interface defined by
889      * `interfaceId`. See the corresponding
890      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
891      * to learn more about how these ids are created.
892      *
893      * This function call must use less than 30 000 gas.
894      */
895     function supportsInterface(bytes4 interfaceId) external view returns (bool);
896 }
897 
898 // File: @openzeppelin/contracts/interfaces/IERC165.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 
906 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
907 
908 
909 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
910 
911 pragma solidity ^0.8.0;
912 
913 
914 /**
915  * @dev Interface for the NFT Royalty Standard
916  */
917 interface IERC2981 is IERC165 {
918     /**
919      * @dev Called with the sale price to determine how much royalty is owed and to whom.
920      * @param tokenId - the NFT asset queried for royalty information
921      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
922      * @return receiver - address of who should be sent the royalty payment
923      * @return royaltyAmount - the royalty payment amount for `salePrice`
924      */
925     function royaltyInfo(uint256 tokenId, uint256 salePrice)
926         external
927         view
928         returns (address receiver, uint256 royaltyAmount);
929 }
930 
931 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
932 
933 
934 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @dev Implementation of the {IERC165} interface.
941  *
942  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
943  * for the additional interface id that will be supported. For example:
944  *
945  * ```solidity
946  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
947  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
948  * }
949  * ```
950  *
951  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
952  */
953 abstract contract ERC165 is IERC165 {
954     /**
955      * @dev See {IERC165-supportsInterface}.
956      */
957     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
958         return interfaceId == type(IERC165).interfaceId;
959     }
960 }
961 
962 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 
970 /**
971  * @dev Required interface of an ERC721 compliant contract.
972  */
973 interface IERC721 is IERC165 {
974     /**
975      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
976      */
977     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
978 
979     /**
980      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
981      */
982     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
983 
984     /**
985      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
986      */
987     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
988 
989     /**
990      * @dev Returns the number of tokens in ``owner``'s account.
991      */
992     function balanceOf(address owner) external view returns (uint256 balance);
993 
994     /**
995      * @dev Returns the owner of the `tokenId` token.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function ownerOf(uint256 tokenId) external view returns (address owner);
1002 
1003     /**
1004      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1005      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1006      *
1007      * Requirements:
1008      *
1009      * - `from` cannot be the zero address.
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must exist and be owned by `from`.
1012      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1013      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) external;
1022 
1023     /**
1024      * @dev Transfers `tokenId` token from `from` to `to`.
1025      *
1026      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function transferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) external;
1042 
1043     /**
1044      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1045      * The approval is cleared when the token is transferred.
1046      *
1047      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1048      *
1049      * Requirements:
1050      *
1051      * - The caller must own the token or be an approved operator.
1052      * - `tokenId` must exist.
1053      *
1054      * Emits an {Approval} event.
1055      */
1056     function approve(address to, uint256 tokenId) external;
1057 
1058     /**
1059      * @dev Returns the account approved for `tokenId` token.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      */
1065     function getApproved(uint256 tokenId) external view returns (address operator);
1066 
1067     /**
1068      * @dev Approve or remove `operator` as an operator for the caller.
1069      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1070      *
1071      * Requirements:
1072      *
1073      * - The `operator` cannot be the caller.
1074      *
1075      * Emits an {ApprovalForAll} event.
1076      */
1077     function setApprovalForAll(address operator, bool _approved) external;
1078 
1079     /**
1080      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1081      *
1082      * See {setApprovalForAll}
1083      */
1084     function isApprovedForAll(address owner, address operator) external view returns (bool);
1085 
1086     /**
1087      * @dev Safely transfers `tokenId` token from `from` to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `from` cannot be the zero address.
1092      * - `to` cannot be the zero address.
1093      * - `tokenId` token must exist and be owned by `from`.
1094      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1095      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function safeTransferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes calldata data
1104     ) external;
1105 }
1106 
1107 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1108 
1109 
1110 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 
1115 /**
1116  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1117  * @dev See https://eips.ethereum.org/EIPS/eip-721
1118  */
1119 interface IERC721Enumerable is IERC721 {
1120     /**
1121      * @dev Returns the total amount of tokens stored by the contract.
1122      */
1123     function totalSupply() external view returns (uint256);
1124 
1125     /**
1126      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1127      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1128      */
1129     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1130 
1131     /**
1132      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1133      * Use along with {totalSupply} to enumerate all tokens.
1134      */
1135     function tokenByIndex(uint256 index) external view returns (uint256);
1136 }
1137 
1138 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1139 
1140 
1141 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 
1146 /**
1147  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1148  * @dev See https://eips.ethereum.org/EIPS/eip-721
1149  */
1150 interface IERC721Metadata is IERC721 {
1151     /**
1152      * @dev Returns the token collection name.
1153      */
1154     function name() external view returns (string memory);
1155 
1156     /**
1157      * @dev Returns the token collection symbol.
1158      */
1159     function symbol() external view returns (string memory);
1160 
1161     /**
1162      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1163      */
1164     function tokenURI(uint256 tokenId) external view returns (string memory);
1165 }
1166 
1167 // File: contracts/ERC721A.sol
1168 
1169 
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 
1181 /**
1182  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1183  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1184  *
1185  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1186  *
1187  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1188  *
1189  * Does not support burning tokens to address(0).
1190  */
1191 contract ERC721A is
1192   Context,
1193   ERC165,
1194   IERC721,
1195   IERC721Metadata,
1196   IERC721Enumerable
1197 {
1198   using Address for address;
1199   using Strings for uint256;
1200 
1201   struct TokenOwnership {
1202     address addr;
1203     uint64 startTimestamp;
1204   }
1205 
1206   struct AddressData {
1207     uint128 balance;
1208     uint128 numberMinted;
1209   }
1210 
1211   uint256 private currentIndex = 0;
1212 
1213   uint256 internal immutable collectionSize;
1214   uint256 internal immutable maxBatchSize;
1215 
1216   // Token name
1217   string private _name;
1218 
1219   // Token symbol
1220   string private _symbol;
1221 
1222   // Mapping from token ID to ownership details
1223   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1224   mapping(uint256 => TokenOwnership) private _ownerships;
1225 
1226   // Mapping owner address to address data
1227   mapping(address => AddressData) private _addressData;
1228 
1229   // Mapping from token ID to approved address
1230   mapping(uint256 => address) private _tokenApprovals;
1231 
1232   // Mapping from owner to operator approvals
1233   mapping(address => mapping(address => bool)) private _operatorApprovals;
1234 
1235   /**
1236    * @dev
1237    * `maxBatchSize` refers to how much a minter can mint at a time.
1238    * `collectionSize_` refers to how many tokens are in the collection.
1239    */
1240   constructor(
1241     string memory name_,
1242     string memory symbol_,
1243     uint256 maxBatchSize_,
1244     uint256 collectionSize_
1245   ) {
1246     require(
1247       collectionSize_ > 0,
1248       "ERC721A: collection must have a nonzero supply"
1249     );
1250     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1251     _name = name_;
1252     _symbol = symbol_;
1253     maxBatchSize = maxBatchSize_;
1254     collectionSize = collectionSize_;
1255   }
1256 
1257   /**
1258    * @dev See {IERC721Enumerable-totalSupply}.
1259    */
1260   function totalSupply() public view override returns (uint256) {
1261     return currentIndex;
1262   }
1263 
1264   /**
1265    * @dev See {IERC721Enumerable-tokenByIndex}.
1266    */
1267   function tokenByIndex(uint256 index) public view override returns (uint256) {
1268     require(index < totalSupply(), "ERC721A: global index out of bounds");
1269     return index;
1270   }
1271 
1272   /**
1273    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1274    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1275    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1276    */
1277   function tokenOfOwnerByIndex(address owner, uint256 index)
1278     public
1279     view
1280     override
1281     returns (uint256)
1282   {
1283     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1284     uint256 numMintedSoFar = totalSupply();
1285     uint256 tokenIdsIdx = 0;
1286     address currOwnershipAddr = address(0);
1287     for (uint256 i = 0; i < numMintedSoFar; i++) {
1288       TokenOwnership memory ownership = _ownerships[i];
1289       if (ownership.addr != address(0)) {
1290         currOwnershipAddr = ownership.addr;
1291       }
1292       if (currOwnershipAddr == owner) {
1293         if (tokenIdsIdx == index) {
1294           return i;
1295         }
1296         tokenIdsIdx++;
1297       }
1298     }
1299     revert("ERC721A: unable to get token of owner by index");
1300   }
1301 
1302   /**
1303    * @dev See {IERC165-supportsInterface}.
1304    */
1305   function supportsInterface(bytes4 interfaceId)
1306     public
1307     view
1308     virtual
1309     override(ERC165, IERC165)
1310     returns (bool)
1311   {
1312     return
1313       interfaceId == type(IERC721).interfaceId ||
1314       interfaceId == type(IERC721Metadata).interfaceId ||
1315       interfaceId == type(IERC721Enumerable).interfaceId ||
1316       super.supportsInterface(interfaceId);
1317   }
1318 
1319   /**
1320    * @dev See {IERC721-balanceOf}.
1321    */
1322   function balanceOf(address owner) public view override returns (uint256) {
1323     require(owner != address(0), "ERC721A: balance query for the zero address");
1324     return uint256(_addressData[owner].balance);
1325   }
1326 
1327   function _numberMinted(address owner) internal view returns (uint256) {
1328     require(
1329       owner != address(0),
1330       "ERC721A: number minted query for the zero address"
1331     );
1332     return uint256(_addressData[owner].numberMinted);
1333   }
1334 
1335   function ownershipOf(uint256 tokenId)
1336     internal
1337     view
1338     returns (TokenOwnership memory)
1339   {
1340     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1341 
1342     uint256 lowestTokenToCheck;
1343     if (tokenId >= maxBatchSize) {
1344       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1345     }
1346 
1347     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1348       TokenOwnership memory ownership = _ownerships[curr];
1349       if (ownership.addr != address(0)) {
1350         return ownership;
1351       }
1352     }
1353 
1354     revert("ERC721A: unable to determine the owner of token");
1355   }
1356 
1357   /**
1358    * @dev See {IERC721-ownerOf}.
1359    */
1360   function ownerOf(uint256 tokenId) public view override returns (address) {
1361     return ownershipOf(tokenId).addr;
1362   }
1363 
1364   /**
1365    * @dev See {IERC721Metadata-name}.
1366    */
1367   function name() public view virtual override returns (string memory) {
1368     return _name;
1369   }
1370 
1371   /**
1372    * @dev See {IERC721Metadata-symbol}.
1373    */
1374   function symbol() public view virtual override returns (string memory) {
1375     return _symbol;
1376   }
1377 
1378   /**
1379    * @dev See {IERC721Metadata-tokenURI}.
1380    */
1381   function tokenURI(uint256 tokenId)
1382     public
1383     view
1384     virtual
1385     override
1386     returns (string memory)
1387   {
1388     require(
1389       _exists(tokenId),
1390       "ERC721Metadata: URI query for nonexistent token"
1391     );
1392 
1393     string memory baseURI = _baseURI();
1394     return
1395       bytes(baseURI).length > 0
1396         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1397         : "";
1398   }
1399 
1400   /**
1401    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1402    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1403    * by default, can be overriden in child contracts.
1404    */
1405   function _baseURI() internal view virtual returns (string memory) {
1406     return "";
1407   }
1408 
1409   /**
1410    * @dev See {IERC721-approve}.
1411    */
1412   function approve(address to, uint256 tokenId) public override {
1413     address owner = ERC721A.ownerOf(tokenId);
1414     require(to != owner, "ERC721A: approval to current owner");
1415 
1416     require(
1417       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1418       "ERC721A: approve caller is not owner nor approved for all"
1419     );
1420 
1421     _approve(to, tokenId, owner);
1422   }
1423 
1424   /**
1425    * @dev See {IERC721-getApproved}.
1426    */
1427   function getApproved(uint256 tokenId) public view override returns (address) {
1428     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1429 
1430     return _tokenApprovals[tokenId];
1431   }
1432 
1433   /**
1434    * @dev See {IERC721-setApprovalForAll}.
1435    */
1436   function setApprovalForAll(address operator, bool approved) public override {
1437     require(operator != _msgSender(), "ERC721A: approve to caller");
1438 
1439     _operatorApprovals[_msgSender()][operator] = approved;
1440     emit ApprovalForAll(_msgSender(), operator, approved);
1441   }
1442 
1443   /**
1444    * @dev See {IERC721-isApprovedForAll}.
1445    */
1446   function isApprovedForAll(address owner, address operator)
1447     public
1448     view
1449     virtual
1450     override
1451     returns (bool)
1452   {
1453     return _operatorApprovals[owner][operator];
1454   }
1455 
1456   /**
1457    * @dev See {IERC721-transferFrom}.
1458    */
1459   function transferFrom(
1460     address from,
1461     address to,
1462     uint256 tokenId
1463   ) public override {
1464     _transfer(from, to, tokenId);
1465   }
1466 
1467   /**
1468    * @dev See {IERC721-safeTransferFrom}.
1469    */
1470   function safeTransferFrom(
1471     address from,
1472     address to,
1473     uint256 tokenId
1474   ) public override {
1475     safeTransferFrom(from, to, tokenId, "");
1476   }
1477 
1478   /**
1479    * @dev See {IERC721-safeTransferFrom}.
1480    */
1481   function safeTransferFrom(
1482     address from,
1483     address to,
1484     uint256 tokenId,
1485     bytes memory _data
1486   ) public override {
1487     _transfer(from, to, tokenId);
1488     require(
1489       _checkOnERC721Received(from, to, tokenId, _data),
1490       "ERC721A: transfer to non ERC721Receiver implementer"
1491     );
1492   }
1493 
1494   /**
1495    * @dev Returns whether `tokenId` exists.
1496    *
1497    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1498    *
1499    * Tokens start existing when they are minted (`_mint`),
1500    */
1501   function _exists(uint256 tokenId) internal view returns (bool) {
1502     return tokenId < currentIndex;
1503   }
1504 
1505   function _safeMint(address to, uint256 quantity) internal {
1506     _safeMint(to, quantity, "");
1507   }
1508 
1509   /**
1510    * @dev Mints `quantity` tokens and transfers them to `to`.
1511    *
1512    * Requirements:
1513    *
1514    * - there must be `quantity` tokens remaining unminted in the total collection.
1515    * - `to` cannot be the zero address.
1516    * - `quantity` cannot be larger than the max batch size.
1517    *
1518    * Emits a {Transfer} event.
1519    */
1520   function _safeMint(
1521     address to,
1522     uint256 quantity,
1523     bytes memory _data
1524   ) internal {
1525     uint256 startTokenId = currentIndex;
1526     require(to != address(0), "ERC721A: mint to the zero address");
1527     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1528     require(!_exists(startTokenId), "ERC721A: token already minted");
1529     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1530 
1531     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1532 
1533     AddressData memory addressData = _addressData[to];
1534     _addressData[to] = AddressData(
1535       addressData.balance + uint128(quantity),
1536       addressData.numberMinted + uint128(quantity)
1537     );
1538     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1539 
1540     uint256 updatedIndex = startTokenId;
1541 
1542     for (uint256 i = 0; i < quantity; i++) {
1543       emit Transfer(address(0), to, updatedIndex);
1544       require(
1545         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1546         "ERC721A: transfer to non ERC721Receiver implementer"
1547       );
1548       updatedIndex++;
1549     }
1550 
1551     currentIndex = updatedIndex;
1552     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1553   }
1554 
1555   /**
1556    * @dev Transfers `tokenId` from `from` to `to`.
1557    *
1558    * Requirements:
1559    *
1560    * - `to` cannot be the zero address.
1561    * - `tokenId` token must be owned by `from`.
1562    *
1563    * Emits a {Transfer} event.
1564    */
1565   function _transfer(
1566     address from,
1567     address to,
1568     uint256 tokenId
1569   ) private {
1570     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1571 
1572     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1573       getApproved(tokenId) == _msgSender() ||
1574       isApprovedForAll(prevOwnership.addr, _msgSender()));
1575 
1576     require(
1577       isApprovedOrOwner,
1578       "ERC721A: transfer caller is not owner nor approved"
1579     );
1580 
1581     require(
1582       prevOwnership.addr == from,
1583       "ERC721A: transfer from incorrect owner"
1584     );
1585     require(to != address(0), "ERC721A: transfer to the zero address");
1586 
1587     _beforeTokenTransfers(from, to, tokenId, 1);
1588 
1589     // Clear approvals from the previous owner
1590     _approve(address(0), tokenId, prevOwnership.addr);
1591 
1592     _addressData[from].balance -= 1;
1593     _addressData[to].balance += 1;
1594     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1595 
1596     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1597     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1598     uint256 nextTokenId = tokenId + 1;
1599     if (_ownerships[nextTokenId].addr == address(0)) {
1600       if (_exists(nextTokenId)) {
1601         _ownerships[nextTokenId] = TokenOwnership(
1602           prevOwnership.addr,
1603           prevOwnership.startTimestamp
1604         );
1605       }
1606     }
1607 
1608     emit Transfer(from, to, tokenId);
1609     _afterTokenTransfers(from, to, tokenId, 1);
1610   }
1611 
1612   /**
1613    * @dev Approve `to` to operate on `tokenId`
1614    *
1615    * Emits a {Approval} event.
1616    */
1617   function _approve(
1618     address to,
1619     uint256 tokenId,
1620     address owner
1621   ) private {
1622     _tokenApprovals[tokenId] = to;
1623     emit Approval(owner, to, tokenId);
1624   }
1625 
1626   uint256 public nextOwnerToExplicitlySet = 0;
1627 
1628   /**
1629    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1630    */
1631   function _setOwnersExplicit(uint256 quantity) internal {
1632     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1633     require(quantity > 0, "quantity must be nonzero");
1634     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1635     if (endIndex > collectionSize - 1) {
1636       endIndex = collectionSize - 1;
1637     }
1638     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1639     require(_exists(endIndex), "not enough minted yet for this cleanup");
1640     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1641       if (_ownerships[i].addr == address(0)) {
1642         TokenOwnership memory ownership = ownershipOf(i);
1643         _ownerships[i] = TokenOwnership(
1644           ownership.addr,
1645           ownership.startTimestamp
1646         );
1647       }
1648     }
1649     nextOwnerToExplicitlySet = endIndex + 1;
1650   }
1651 
1652   /**
1653    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1654    * The call is not executed if the target address is not a contract.
1655    *
1656    * @param from address representing the previous owner of the given token ID
1657    * @param to target address that will receive the tokens
1658    * @param tokenId uint256 ID of the token to be transferred
1659    * @param _data bytes optional data to send along with the call
1660    * @return bool whether the call correctly returned the expected magic value
1661    */
1662   function _checkOnERC721Received(
1663     address from,
1664     address to,
1665     uint256 tokenId,
1666     bytes memory _data
1667   ) private returns (bool) {
1668     if (to.isContract()) {
1669       try
1670         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1671       returns (bytes4 retval) {
1672         return retval == IERC721Receiver(to).onERC721Received.selector;
1673       } catch (bytes memory reason) {
1674         if (reason.length == 0) {
1675           revert("ERC721A: transfer to non ERC721Receiver implementer");
1676         } else {
1677           assembly {
1678             revert(add(32, reason), mload(reason))
1679           }
1680         }
1681       }
1682     } else {
1683       return true;
1684     }
1685   }
1686 
1687   /**
1688    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1689    *
1690    * startTokenId - the first token id to be transferred
1691    * quantity - the amount to be transferred
1692    *
1693    * Calling conditions:
1694    *
1695    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1696    * transferred to `to`.
1697    * - When `from` is zero, `tokenId` will be minted for `to`.
1698    */
1699   function _beforeTokenTransfers(
1700     address from,
1701     address to,
1702     uint256 startTokenId,
1703     uint256 quantity
1704   ) internal virtual {}
1705 
1706   /**
1707    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1708    * minting.
1709    *
1710    * startTokenId - the first token id to be transferred
1711    * quantity - the amount to be transferred
1712    *
1713    * Calling conditions:
1714    *
1715    * - when `from` and `to` are both non-zero.
1716    * - `from` and `to` are never both zero.
1717    */
1718   function _afterTokenTransfers(
1719     address from,
1720     address to,
1721     uint256 startTokenId,
1722     uint256 quantity
1723   ) internal virtual {}
1724 }
1725 
1726 //SPDX-License-Identifier: MIT
1727 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1728 
1729 pragma solidity ^0.8.0;
1730 
1731 
1732 
1733 
1734 
1735 
1736 
1737 
1738 
1739 contract NWordPass is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1740     using Counters for Counters.Counter;
1741     using Strings for uint256;
1742 
1743     Counters.Counter private tokenCounter;
1744 
1745     string private baseURI = "ipfs://Qmek4EEUzP22GEsqSaWXpeGgt2eCfDB8mDQHzTjdK9XRkJ";
1746     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1747     bool private isOpenSeaProxyActive = true;
1748 
1749     uint256 public constant MAX_MINTS_PER_TX = 1;
1750     uint256 public maxSupply = 999;
1751 
1752     uint256 public constant PUBLIC_SALE_PRICE = 0.00 ether;
1753     uint256 public NUM_FREE_MINTS = 999;
1754     bool public isPublicSaleActive = true;
1755 
1756 
1757 
1758 
1759     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1760 
1761     modifier publicSaleActive() {
1762         require(isPublicSaleActive, "Public sale is not open");
1763         _;
1764     }
1765 
1766 
1767 
1768     modifier maxMintsPerTX(uint256 numberOfTokens) {
1769         require(
1770             numberOfTokens <= MAX_MINTS_PER_TX,
1771             "Max mints per transaction exceeded"
1772         );
1773         _;
1774     }
1775 
1776     modifier canMintNFTs(uint256 numberOfTokens) {
1777         require(
1778             totalSupply() + numberOfTokens <=
1779                 maxSupply,
1780             "Not enough mints remaining to mint"
1781         );
1782         _;
1783     }
1784 
1785     modifier freeMintsAvailable() {
1786         require(
1787             totalSupply() <=
1788                 NUM_FREE_MINTS,
1789             "Not enough free mints remain"
1790         );
1791         _;
1792     }
1793 
1794 
1795 
1796     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1797         if(totalSupply()>NUM_FREE_MINTS){
1798         require(
1799             (price * numberOfTokens) == msg.value,
1800             "Incorrect ETH value sent"
1801         );
1802         }
1803         _;
1804     }
1805 
1806 
1807     constructor(
1808     ) ERC721A("N-Word Pass", "N", 100, maxSupply) {
1809     }
1810 
1811     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1812 
1813     function mint(uint256 numberOfTokens)
1814         external
1815         payable
1816         nonReentrant
1817         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1818         publicSaleActive
1819         canMintNFTs(numberOfTokens)
1820         maxMintsPerTX(numberOfTokens)
1821     {
1822 
1823         _safeMint(msg.sender, numberOfTokens);
1824     }
1825 
1826 
1827 
1828     //A simple free mint function to avoid confusion
1829     //The normal mint function with a cost of 0 would work too
1830 
1831     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1832 
1833     function getBaseURI() external view returns (string memory) {
1834         return baseURI;
1835     }
1836 
1837     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1838 
1839     function setBaseURI(string memory _baseURI) external onlyOwner {
1840         baseURI = _baseURI;
1841     }
1842 
1843     // function to disable gasless listings for security in case
1844     // opensea ever shuts down or is compromised
1845     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1846         external
1847         onlyOwner
1848     {
1849         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1850     }
1851 
1852     function setIsPublicSaleActive(bool _isPublicSaleActive)
1853         external
1854         onlyOwner
1855     {
1856         isPublicSaleActive = _isPublicSaleActive;
1857     }
1858 
1859 
1860     function setnumfree(uint256 _numfreemints)
1861         external
1862         onlyOwner
1863     {
1864         NUM_FREE_MINTS = _numfreemints;
1865     }
1866 
1867 
1868     function withdraw() public onlyOwner {
1869         uint256 balance = address(this).balance;
1870         payable(msg.sender).transfer(balance);
1871     }
1872 
1873     function withdrawTokens(IERC20 token) public onlyOwner {
1874         uint256 balance = token.balanceOf(address(this));
1875         token.transfer(msg.sender, balance);
1876     }
1877 
1878 
1879 
1880     // ============ SUPPORTING FUNCTIONS ============
1881 
1882     function nextTokenId() private returns (uint256) {
1883         tokenCounter.increment();
1884         return tokenCounter.current();
1885     }
1886 
1887     // ============ FUNCTION OVERRIDES ============
1888 
1889     function supportsInterface(bytes4 interfaceId)
1890         public
1891         view
1892         virtual
1893         override(ERC721A, IERC165)
1894         returns (bool)
1895     {
1896         return
1897             interfaceId == type(IERC2981).interfaceId ||
1898             super.supportsInterface(interfaceId);
1899     }
1900 
1901     /**
1902      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1903      */
1904     function isApprovedForAll(address owner, address operator)
1905         public
1906         view
1907         override
1908         returns (bool)
1909     {
1910         // Get a reference to OpenSea's proxy registry contract by instantiating
1911         // the contract using the already existing address.
1912         ProxyRegistry proxyRegistry = ProxyRegistry(
1913             openSeaProxyRegistryAddress
1914         );
1915         if (
1916             isOpenSeaProxyActive &&
1917             address(proxyRegistry.proxies(owner)) == operator
1918         ) {
1919             return true;
1920         }
1921 
1922         return super.isApprovedForAll(owner, operator);
1923     }
1924 
1925     /**
1926      * @dev See {IERC721Metadata-tokenURI}.
1927      */
1928     function tokenURI(uint256 tokenId)
1929         public
1930         view
1931         virtual
1932         override
1933         returns (string memory)
1934     {
1935         require(_exists(tokenId), "Nonexistent token");
1936 
1937         return
1938             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1939     }
1940 
1941     /**
1942      * @dev See {IERC165-royaltyInfo}.
1943      */
1944     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1945         external
1946         view
1947         override
1948         returns (address receiver, uint256 royaltyAmount)
1949     {
1950         require(_exists(tokenId), "Nonexistent token");
1951 
1952         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1953     }
1954 }
1955 
1956 // These contract definitions are used to create a reference to the OpenSea
1957 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1958 contract OwnableDelegateProxy {
1959 
1960 }
1961 
1962 contract ProxyRegistry {
1963     mapping(address => OwnableDelegateProxy) public proxies;
1964 }