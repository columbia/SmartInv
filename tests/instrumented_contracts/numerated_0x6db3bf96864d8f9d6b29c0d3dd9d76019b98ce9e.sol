1 /*
2 
3 ████████╗██████╗░██╗░░░██╗░██████╗████████╗  ███╗░░░███╗███████╗░█████╗░
4 ╚══██╔══╝██╔══██╗██║░░░██║██╔════╝╚══██╔══╝  ████╗░████║██╔════╝██╔══██╗
5 ░░░██║░░░██████╔╝██║░░░██║╚█████╗░░░░██║░░░  ██╔████╔██║█████╗░░╚═╝███╔╝
6 ░░░██║░░░██╔══██╗██║░░░██║░╚═══██╗░░░██║░░░  ██║╚██╔╝██║██╔══╝░░░░░╚══╝░
7 ░░░██║░░░██║░░██║╚██████╔╝██████╔╝░░░██║░░░  ██║░╚═╝░██║███████╗░░░██╗░░
8 ░░░╚═╝░░░╚═╝░░╚═╝░╚═════╝░╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░
9 
10 */
11 
12 
13 pragma solidity ^0.8.0;
14 
15 // CAUTION
16 // This version of SafeMath should only be used with Solidity 0.8 or later,
17 // because it relies on the compiler's built in overflow checks.
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations.
21  *
22  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
23  * now has built in overflow checking.
24  */
25 library SafeMath {
26     /**
27      * @dev Returns the addition of two unsigned integers, with an overflow flag.
28      *
29      * _Available since v3.4._
30      */
31     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {
33             uint256 c = a + b;
34             if (c < a) return (false, 0);
35             return (true, c);
36         }
37     }
38 
39     /**
40      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b > a) return (false, 0);
47             return (true, a - b);
48         }
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
53      *
54      * _Available since v3.4._
55      */
56     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59             // benefit is lost if 'b' is also tested.
60             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
61             if (a == 0) return (true, 0);
62             uint256 c = a * b;
63             if (c / a != b) return (false, 0);
64             return (true, c);
65         }
66     }
67 
68     /**
69      * @dev Returns the division of two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b == 0) return (false, 0);
76             return (true, a / b);
77         }
78     }
79 
80     /**
81      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
82      *
83      * _Available since v3.4._
84      */
85     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             if (b == 0) return (false, 0);
88             return (true, a % b);
89         }
90     }
91 
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a + b;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      *
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a - b;
118     }
119 
120     /**
121      * @dev Returns the multiplication of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `*` operator.
125      *
126      * Requirements:
127      *
128      * - Multiplication cannot overflow.
129      */
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a * b;
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers, reverting on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator.
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function div(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a / b;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * reverting when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         return a % b;
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * CAUTION: This function is deprecated because it requires allocating memory for the error
169      * message unnecessarily. For custom revert reasons use {trySub}.
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(
178         uint256 a,
179         uint256 b,
180         string memory errorMessage
181     ) internal pure returns (uint256) {
182         unchecked {
183             require(b <= a, errorMessage);
184             return a - b;
185         }
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(
201         uint256 a,
202         uint256 b,
203         string memory errorMessage
204     ) internal pure returns (uint256) {
205         unchecked {
206             require(b > 0, errorMessage);
207             return a / b;
208         }
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * reverting with custom message when dividing by zero.
214      *
215      * CAUTION: This function is deprecated because it requires allocating memory for the error
216      * message unnecessarily. For custom revert reasons use {tryMod}.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(
227         uint256 a,
228         uint256 b,
229         string memory errorMessage
230     ) internal pure returns (uint256) {
231         unchecked {
232             require(b > 0, errorMessage);
233             return a % b;
234         }
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Counters.sol
239 
240 
241 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @title Counters
247  * @author Matt Condon (@shrugs)
248  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
249  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
250  *
251  * Include with `using Counters for Counters.Counter;`
252  */
253 library Counters {
254     struct Counter {
255         // This variable should never be directly accessed by users of the library: interactions must be restricted to
256         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
257         // this feature: see https://github.com/ethereum/solidity/issues/4637
258         uint256 _value; // default: 0
259     }
260 
261     function current(Counter storage counter) internal view returns (uint256) {
262         return counter._value;
263     }
264 
265     function increment(Counter storage counter) internal {
266         unchecked {
267             counter._value += 1;
268         }
269     }
270 
271     function decrement(Counter storage counter) internal {
272         uint256 value = counter._value;
273         require(value > 0, "Counter: decrement overflow");
274         unchecked {
275             counter._value = value - 1;
276         }
277     }
278 
279     function reset(Counter storage counter) internal {
280         counter._value = 0;
281     }
282 }
283 
284 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Contract module that helps prevent reentrant calls to a function.
293  *
294  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
295  * available, which can be applied to functions to make sure there are no nested
296  * (reentrant) calls to them.
297  *
298  * Note that because there is a single `nonReentrant` guard, functions marked as
299  * `nonReentrant` may not call one another. This can be worked around by making
300  * those functions `private`, and then adding `external` `nonReentrant` entry
301  * points to them.
302  *
303  * TIP: If you would like to learn more about reentrancy and alternative ways
304  * to protect against it, check out our blog post
305  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
306  */
307 abstract contract ReentrancyGuard {
308     // Booleans are more expensive than uint256 or any type that takes up a full
309     // word because each write operation emits an extra SLOAD to first read the
310     // slot's contents, replace the bits taken up by the boolean, and then write
311     // back. This is the compiler's defense against contract upgrades and
312     // pointer aliasing, and it cannot be disabled.
313 
314     // The values being non-zero value makes deployment a bit more expensive,
315     // but in exchange the refund on every call to nonReentrant will be lower in
316     // amount. Since refunds are capped to a percentage of the total
317     // transaction's gas, it is best to keep them low in cases like this one, to
318     // increase the likelihood of the full refund coming into effect.
319     uint256 private constant _NOT_ENTERED = 1;
320     uint256 private constant _ENTERED = 2;
321 
322     uint256 private _status;
323 
324     constructor() {
325         _status = _NOT_ENTERED;
326     }
327 
328     /**
329      * @dev Prevents a contract from calling itself, directly or indirectly.
330      * Calling a `nonReentrant` function from another `nonReentrant`
331      * function is not supported. It is possible to prevent this from happening
332      * by making the `nonReentrant` function external, and making it call a
333      * `private` function that does the actual work.
334      */
335     modifier nonReentrant() {
336         // On the first call to nonReentrant, _notEntered will be true
337         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
338 
339         // Any calls to nonReentrant after this point will fail
340         _status = _ENTERED;
341 
342         _;
343 
344         // By storing the original value once again, a refund is triggered (see
345         // https://eips.ethereum.org/EIPS/eip-2200)
346         _status = _NOT_ENTERED;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Interface of the ERC20 standard as defined in the EIP.
359  */
360 interface IERC20 {
361     /**
362      * @dev Returns the amount of tokens in existence.
363      */
364     function totalSupply() external view returns (uint256);
365 
366     /**
367      * @dev Returns the amount of tokens owned by `account`.
368      */
369     function balanceOf(address account) external view returns (uint256);
370 
371     /**
372      * @dev Moves `amount` tokens from the caller's account to `recipient`.
373      *
374      * Returns a boolean value indicating whether the operation succeeded.
375      *
376      * Emits a {Transfer} event.
377      */
378     function transfer(address recipient, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Returns the remaining number of tokens that `spender` will be
382      * allowed to spend on behalf of `owner` through {transferFrom}. This is
383      * zero by default.
384      *
385      * This value changes when {approve} or {transferFrom} are called.
386      */
387     function allowance(address owner, address spender) external view returns (uint256);
388 
389     /**
390      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
391      *
392      * Returns a boolean value indicating whether the operation succeeded.
393      *
394      * IMPORTANT: Beware that changing an allowance with this method brings the risk
395      * that someone may use both the old and the new allowance by unfortunate
396      * transaction ordering. One possible solution to mitigate this race
397      * condition is to first reduce the spender's allowance to 0 and set the
398      * desired value afterwards:
399      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
400      *
401      * Emits an {Approval} event.
402      */
403     function approve(address spender, uint256 amount) external returns (bool);
404 
405     /**
406      * @dev Moves `amount` tokens from `sender` to `recipient` using the
407      * allowance mechanism. `amount` is then deducted from the caller's
408      * allowance.
409      *
410      * Returns a boolean value indicating whether the operation succeeded.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transferFrom(
415         address sender,
416         address recipient,
417         uint256 amount
418     ) external returns (bool);
419 
420     /**
421      * @dev Emitted when `value` tokens are moved from one account (`from`) to
422      * another (`to`).
423      *
424      * Note that `value` may be zero.
425      */
426     event Transfer(address indexed from, address indexed to, uint256 value);
427 
428     /**
429      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
430      * a call to {approve}. `value` is the new allowance.
431      */
432     event Approval(address indexed owner, address indexed spender, uint256 value);
433 }
434 
435 // File: @openzeppelin/contracts/interfaces/IERC20.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 
443 // File: @openzeppelin/contracts/utils/Strings.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev String operations.
452  */
453 library Strings {
454     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
455 
456     /**
457      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
458      */
459     function toString(uint256 value) internal pure returns (string memory) {
460         // Inspired by OraclizeAPI's implementation - MIT licence
461         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
462 
463         if (value == 0) {
464             return "0";
465         }
466         uint256 temp = value;
467         uint256 digits;
468         while (temp != 0) {
469             digits++;
470             temp /= 10;
471         }
472         bytes memory buffer = new bytes(digits);
473         while (value != 0) {
474             digits -= 1;
475             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
476             value /= 10;
477         }
478         return string(buffer);
479     }
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
483      */
484     function toHexString(uint256 value) internal pure returns (string memory) {
485         if (value == 0) {
486             return "0x00";
487         }
488         uint256 temp = value;
489         uint256 length = 0;
490         while (temp != 0) {
491             length++;
492             temp >>= 8;
493         }
494         return toHexString(value, length);
495     }
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
499      */
500     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
501         bytes memory buffer = new bytes(2 * length + 2);
502         buffer[0] = "0";
503         buffer[1] = "x";
504         for (uint256 i = 2 * length + 1; i > 1; --i) {
505             buffer[i] = _HEX_SYMBOLS[value & 0xf];
506             value >>= 4;
507         }
508         require(value == 0, "Strings: hex length insufficient");
509         return string(buffer);
510     }
511 }
512 
513 // File: @openzeppelin/contracts/utils/Context.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Provides information about the current execution context, including the
522  * sender of the transaction and its data. While these are generally available
523  * via msg.sender and msg.data, they should not be accessed in such a direct
524  * manner, since when dealing with meta-transactions the account sending and
525  * paying for execution may not be the actual sender (as far as an application
526  * is concerned).
527  *
528  * This contract is only required for intermediate, library-like contracts.
529  */
530 abstract contract Context {
531     function _msgSender() internal view virtual returns (address) {
532         return msg.sender;
533     }
534 
535     function _msgData() internal view virtual returns (bytes calldata) {
536         return msg.data;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/access/Ownable.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Contract module which provides a basic access control mechanism, where
550  * there is an account (an owner) that can be granted exclusive access to
551  * specific functions.
552  *
553  * By default, the owner account will be the one that deploys the contract. This
554  * can later be changed with {transferOwnership}.
555  *
556  * This module is used through inheritance. It will make available the modifier
557  * `onlyOwner`, which can be applied to your functions to restrict their use to
558  * the owner.
559  */
560 abstract contract Ownable is Context {
561     address private _owner;
562 
563     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
564 
565     /**
566      * @dev Initializes the contract setting the deployer as the initial owner.
567      */
568     constructor() {
569         _transferOwnership(_msgSender());
570     }
571 
572     /**
573      * @dev Returns the address of the current owner.
574      */
575     function owner() public view virtual returns (address) {
576         return _owner;
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         require(owner() == _msgSender(), "Ownable: caller is not the owner");
584         _;
585     }
586 
587     /**
588      * @dev Leaves the contract without owner. It will not be possible to call
589      * `onlyOwner` functions anymore. Can only be called by the current owner.
590      *
591      * NOTE: Renouncing ownership will leave the contract without an owner,
592      * thereby removing any functionality that is only available to the owner.
593      */
594     function renounceOwnership() public virtual onlyOwner {
595         _transferOwnership(address(0));
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Can only be called by the current owner.
601      */
602     function transferOwnership(address newOwner) public virtual onlyOwner {
603         require(newOwner != address(0), "Ownable: new owner is the zero address");
604         _transferOwnership(newOwner);
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Internal function without access restriction.
610      */
611     function _transferOwnership(address newOwner) internal virtual {
612         address oldOwner = _owner;
613         _owner = newOwner;
614         emit OwnershipTransferred(oldOwner, newOwner);
615     }
616 }
617 
618 // File: @openzeppelin/contracts/utils/Address.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @dev Collection of functions related to the address type
627  */
628 library Address {
629     /**
630      * @dev Returns true if `account` is a contract.
631      *
632      * [IMPORTANT]
633      * ====
634      * It is unsafe to assume that an address for which this function returns
635      * false is an externally-owned account (EOA) and not a contract.
636      *
637      * Among others, `isContract` will return false for the following
638      * types of addresses:
639      *
640      *  - an externally-owned account
641      *  - a contract in construction
642      *  - an address where a contract will be created
643      *  - an address where a contract lived, but was destroyed
644      * ====
645      */
646     function isContract(address account) internal view returns (bool) {
647         // This method relies on extcodesize, which returns 0 for contracts in
648         // construction, since the code is only stored at the end of the
649         // constructor execution.
650 
651         uint256 size;
652         assembly {
653             size := extcodesize(account)
654         }
655         return size > 0;
656     }
657 
658     /**
659      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
660      * `recipient`, forwarding all available gas and reverting on errors.
661      *
662      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
663      * of certain opcodes, possibly making contracts go over the 2300 gas limit
664      * imposed by `transfer`, making them unable to receive funds via
665      * `transfer`. {sendValue} removes this limitation.
666      *
667      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
668      *
669      * IMPORTANT: because control is transferred to `recipient`, care must be
670      * taken to not create reentrancy vulnerabilities. Consider using
671      * {ReentrancyGuard} or the
672      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
673      */
674     function sendValue(address payable recipient, uint256 amount) internal {
675         require(address(this).balance >= amount, "Address: insufficient balance");
676 
677         (bool success, ) = recipient.call{value: amount}("");
678         require(success, "Address: unable to send value, recipient may have reverted");
679     }
680 
681     /**
682      * @dev Performs a Solidity function call using a low level `call`. A
683      * plain `call` is an unsafe replacement for a function call: use this
684      * function instead.
685      *
686      * If `target` reverts with a revert reason, it is bubbled up by this
687      * function (like regular Solidity function calls).
688      *
689      * Returns the raw returned data. To convert to the expected return value,
690      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
691      *
692      * Requirements:
693      *
694      * - `target` must be a contract.
695      * - calling `target` with `data` must not revert.
696      *
697      * _Available since v3.1._
698      */
699     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
700         return functionCall(target, data, "Address: low-level call failed");
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
705      * `errorMessage` as a fallback revert reason when `target` reverts.
706      *
707      * _Available since v3.1._
708      */
709     function functionCall(
710         address target,
711         bytes memory data,
712         string memory errorMessage
713     ) internal returns (bytes memory) {
714         return functionCallWithValue(target, data, 0, errorMessage);
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
719      * but also transferring `value` wei to `target`.
720      *
721      * Requirements:
722      *
723      * - the calling contract must have an ETH balance of at least `value`.
724      * - the called Solidity function must be `payable`.
725      *
726      * _Available since v3.1._
727      */
728     function functionCallWithValue(
729         address target,
730         bytes memory data,
731         uint256 value
732     ) internal returns (bytes memory) {
733         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
738      * with `errorMessage` as a fallback revert reason when `target` reverts.
739      *
740      * _Available since v3.1._
741      */
742     function functionCallWithValue(
743         address target,
744         bytes memory data,
745         uint256 value,
746         string memory errorMessage
747     ) internal returns (bytes memory) {
748         require(address(this).balance >= value, "Address: insufficient balance for call");
749         require(isContract(target), "Address: call to non-contract");
750 
751         (bool success, bytes memory returndata) = target.call{value: value}(data);
752         return verifyCallResult(success, returndata, errorMessage);
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
757      * but performing a static call.
758      *
759      * _Available since v3.3._
760      */
761     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
762         return functionStaticCall(target, data, "Address: low-level static call failed");
763     }
764 
765     /**
766      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
767      * but performing a static call.
768      *
769      * _Available since v3.3._
770      */
771     function functionStaticCall(
772         address target,
773         bytes memory data,
774         string memory errorMessage
775     ) internal view returns (bytes memory) {
776         require(isContract(target), "Address: static call to non-contract");
777 
778         (bool success, bytes memory returndata) = target.staticcall(data);
779         return verifyCallResult(success, returndata, errorMessage);
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
784      * but performing a delegate call.
785      *
786      * _Available since v3.4._
787      */
788     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
789         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
790     }
791 
792     /**
793      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
794      * but performing a delegate call.
795      *
796      * _Available since v3.4._
797      */
798     function functionDelegateCall(
799         address target,
800         bytes memory data,
801         string memory errorMessage
802     ) internal returns (bytes memory) {
803         require(isContract(target), "Address: delegate call to non-contract");
804 
805         (bool success, bytes memory returndata) = target.delegatecall(data);
806         return verifyCallResult(success, returndata, errorMessage);
807     }
808 
809     /**
810      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
811      * revert reason using the provided one.
812      *
813      * _Available since v4.3._
814      */
815     function verifyCallResult(
816         bool success,
817         bytes memory returndata,
818         string memory errorMessage
819     ) internal pure returns (bytes memory) {
820         if (success) {
821             return returndata;
822         } else {
823             // Look for revert reason and bubble it up if present
824             if (returndata.length > 0) {
825                 // The easiest way to bubble the revert reason is using memory via assembly
826 
827                 assembly {
828                     let returndata_size := mload(returndata)
829                     revert(add(32, returndata), returndata_size)
830                 }
831             } else {
832                 revert(errorMessage);
833             }
834         }
835     }
836 }
837 
838 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
839 
840 
841 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
842 
843 pragma solidity ^0.8.0;
844 
845 /**
846  * @title ERC721 token receiver interface
847  * @dev Interface for any contract that wants to support safeTransfers
848  * from ERC721 asset contracts.
849  */
850 interface IERC721Receiver {
851     /**
852      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
853      * by `operator` from `from`, this function is called.
854      *
855      * It must return its Solidity selector to confirm the token transfer.
856      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
857      *
858      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
859      */
860     function onERC721Received(
861         address operator,
862         address from,
863         uint256 tokenId,
864         bytes calldata data
865     ) external returns (bytes4);
866 }
867 
868 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
869 
870 
871 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 /**
876  * @dev Interface of the ERC165 standard, as defined in the
877  * https://eips.ethereum.org/EIPS/eip-165[EIP].
878  *
879  * Implementers can declare support of contract interfaces, which can then be
880  * queried by others ({ERC165Checker}).
881  *
882  * For an implementation, see {ERC165}.
883  */
884 interface IERC165 {
885     /**
886      * @dev Returns true if this contract implements the interface defined by
887      * `interfaceId`. See the corresponding
888      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
889      * to learn more about how these ids are created.
890      *
891      * This function call must use less than 30 000 gas.
892      */
893     function supportsInterface(bytes4 interfaceId) external view returns (bool);
894 }
895 
896 // File: @openzeppelin/contracts/interfaces/IERC165.sol
897 
898 
899 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 
904 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
905 
906 
907 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @dev Interface for the NFT Royalty Standard
914  */
915 interface IERC2981 is IERC165 {
916     /**
917      * @dev Called with the sale price to determine how much royalty is owed and to whom.
918      * @param tokenId - the NFT asset queried for royalty information
919      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
920      * @return receiver - address of who should be sent the royalty payment
921      * @return royaltyAmount - the royalty payment amount for `salePrice`
922      */
923     function royaltyInfo(uint256 tokenId, uint256 salePrice)
924         external
925         view
926         returns (address receiver, uint256 royaltyAmount);
927 }
928 
929 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 /**
938  * @dev Implementation of the {IERC165} interface.
939  *
940  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
941  * for the additional interface id that will be supported. For example:
942  *
943  * ```solidity
944  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
945  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
946  * }
947  * ```
948  *
949  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
950  */
951 abstract contract ERC165 is IERC165 {
952     /**
953      * @dev See {IERC165-supportsInterface}.
954      */
955     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
956         return interfaceId == type(IERC165).interfaceId;
957     }
958 }
959 
960 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
961 
962 
963 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 
968 /**
969  * @dev Required interface of an ERC721 compliant contract.
970  */
971 interface IERC721 is IERC165 {
972     /**
973      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
974      */
975     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
976 
977     /**
978      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
979      */
980     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
981 
982     /**
983      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
984      */
985     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
986 
987     /**
988      * @dev Returns the number of tokens in ``owner``'s account.
989      */
990     function balanceOf(address owner) external view returns (uint256 balance);
991 
992     /**
993      * @dev Returns the owner of the `tokenId` token.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      */
999     function ownerOf(uint256 tokenId) external view returns (address owner);
1000 
1001     /**
1002      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1003      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1004      *
1005      * Requirements:
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must exist and be owned by `from`.
1010      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1011      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) external;
1020 
1021     /**
1022      * @dev Transfers `tokenId` token from `from` to `to`.
1023      *
1024      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function transferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) external;
1040 
1041     /**
1042      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1043      * The approval is cleared when the token is transferred.
1044      *
1045      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1046      *
1047      * Requirements:
1048      *
1049      * - The caller must own the token or be an approved operator.
1050      * - `tokenId` must exist.
1051      *
1052      * Emits an {Approval} event.
1053      */
1054     function approve(address to, uint256 tokenId) external;
1055 
1056     /**
1057      * @dev Returns the account approved for `tokenId` token.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function getApproved(uint256 tokenId) external view returns (address operator);
1064 
1065     /**
1066      * @dev Approve or remove `operator` as an operator for the caller.
1067      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1068      *
1069      * Requirements:
1070      *
1071      * - The `operator` cannot be the caller.
1072      *
1073      * Emits an {ApprovalForAll} event.
1074      */
1075     function setApprovalForAll(address operator, bool _approved) external;
1076 
1077     /**
1078      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1079      *
1080      * See {setApprovalForAll}
1081      */
1082     function isApprovedForAll(address owner, address operator) external view returns (bool);
1083 
1084     /**
1085      * @dev Safely transfers `tokenId` token from `from` to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must exist and be owned by `from`.
1092      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes calldata data
1102     ) external;
1103 }
1104 
1105 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1106 
1107 
1108 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1109 
1110 pragma solidity ^0.8.0;
1111 
1112 
1113 /**
1114  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1115  * @dev See https://eips.ethereum.org/EIPS/eip-721
1116  */
1117 interface IERC721Enumerable is IERC721 {
1118     /**
1119      * @dev Returns the total amount of tokens stored by the contract.
1120      */
1121     function totalSupply() external view returns (uint256);
1122 
1123     /**
1124      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1125      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1126      */
1127     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1128 
1129     /**
1130      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1131      * Use along with {totalSupply} to enumerate all tokens.
1132      */
1133     function tokenByIndex(uint256 index) external view returns (uint256);
1134 }
1135 
1136 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1137 
1138 
1139 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 
1144 /**
1145  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1146  * @dev See https://eips.ethereum.org/EIPS/eip-721
1147  */
1148 interface IERC721Metadata is IERC721 {
1149     /**
1150      * @dev Returns the token collection name.
1151      */
1152     function name() external view returns (string memory);
1153 
1154     /**
1155      * @dev Returns the token collection symbol.
1156      */
1157     function symbol() external view returns (string memory);
1158 
1159     /**
1160      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1161      */
1162     function tokenURI(uint256 tokenId) external view returns (string memory);
1163 }
1164 
1165 // File: contracts/ERC721A.sol
1166 
1167 
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 /**
1180  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1181  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1182  *
1183  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1184  *
1185  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1186  *
1187  * Does not support burning tokens to address(0).
1188  */
1189 contract ERC721A is
1190   Context,
1191   ERC165,
1192   IERC721,
1193   IERC721Metadata,
1194   IERC721Enumerable
1195 {
1196   using Address for address;
1197   using Strings for uint256;
1198 
1199   struct TokenOwnership {
1200     address addr;
1201     uint64 startTimestamp;
1202   }
1203 
1204   struct AddressData {
1205     uint128 balance;
1206     uint128 numberMinted;
1207   }
1208 
1209   uint256 private currentIndex = 0;
1210 
1211   uint256 internal immutable collectionSize;
1212   uint256 internal immutable maxBatchSize;
1213 
1214   // Token name
1215   string private _name;
1216 
1217   // Token symbol
1218   string private _symbol;
1219 
1220   // Mapping from token ID to ownership details
1221   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1222   mapping(uint256 => TokenOwnership) private _ownerships;
1223 
1224   // Mapping owner address to address data
1225   mapping(address => AddressData) private _addressData;
1226 
1227   // Mapping from token ID to approved address
1228   mapping(uint256 => address) private _tokenApprovals;
1229 
1230   // Mapping from owner to operator approvals
1231   mapping(address => mapping(address => bool)) private _operatorApprovals;
1232 
1233   /**
1234    * @dev
1235    * `maxBatchSize` refers to how much a minter can mint at a time.
1236    * `collectionSize_` refers to how many tokens are in the collection.
1237    */
1238   constructor(
1239     string memory name_,
1240     string memory symbol_,
1241     uint256 maxBatchSize_,
1242     uint256 collectionSize_
1243   ) {
1244     require(
1245       collectionSize_ > 0,
1246       "ERC721A: collection must have a nonzero supply"
1247     );
1248     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1249     _name = name_;
1250     _symbol = symbol_;
1251     maxBatchSize = maxBatchSize_;
1252     collectionSize = collectionSize_;
1253   }
1254 
1255   /**
1256    * @dev See {IERC721Enumerable-totalSupply}.
1257    */
1258   function totalSupply() public view override returns (uint256) {
1259     return currentIndex;
1260   }
1261 
1262   /**
1263    * @dev See {IERC721Enumerable-tokenByIndex}.
1264    */
1265   function tokenByIndex(uint256 index) public view override returns (uint256) {
1266     require(index < totalSupply(), "ERC721A: global index out of bounds");
1267     return index;
1268   }
1269 
1270   /**
1271    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1272    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1273    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1274    */
1275   function tokenOfOwnerByIndex(address owner, uint256 index)
1276     public
1277     view
1278     override
1279     returns (uint256)
1280   {
1281     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1282     uint256 numMintedSoFar = totalSupply();
1283     uint256 tokenIdsIdx = 0;
1284     address currOwnershipAddr = address(0);
1285     for (uint256 i = 0; i < numMintedSoFar; i++) {
1286       TokenOwnership memory ownership = _ownerships[i];
1287       if (ownership.addr != address(0)) {
1288         currOwnershipAddr = ownership.addr;
1289       }
1290       if (currOwnershipAddr == owner) {
1291         if (tokenIdsIdx == index) {
1292           return i;
1293         }
1294         tokenIdsIdx++;
1295       }
1296     }
1297     revert("ERC721A: unable to get token of owner by index");
1298   }
1299 
1300   /**
1301    * @dev See {IERC165-supportsInterface}.
1302    */
1303   function supportsInterface(bytes4 interfaceId)
1304     public
1305     view
1306     virtual
1307     override(ERC165, IERC165)
1308     returns (bool)
1309   {
1310     return
1311       interfaceId == type(IERC721).interfaceId ||
1312       interfaceId == type(IERC721Metadata).interfaceId ||
1313       interfaceId == type(IERC721Enumerable).interfaceId ||
1314       super.supportsInterface(interfaceId);
1315   }
1316 
1317   /**
1318    * @dev See {IERC721-balanceOf}.
1319    */
1320   function balanceOf(address owner) public view override returns (uint256) {
1321     require(owner != address(0), "ERC721A: balance query for the zero address");
1322     return uint256(_addressData[owner].balance);
1323   }
1324 
1325   function _numberMinted(address owner) internal view returns (uint256) {
1326     require(
1327       owner != address(0),
1328       "ERC721A: number minted query for the zero address"
1329     );
1330     return uint256(_addressData[owner].numberMinted);
1331   }
1332 
1333   function ownershipOf(uint256 tokenId)
1334     internal
1335     view
1336     returns (TokenOwnership memory)
1337   {
1338     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1339 
1340     uint256 lowestTokenToCheck;
1341     if (tokenId >= maxBatchSize) {
1342       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1343     }
1344 
1345     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1346       TokenOwnership memory ownership = _ownerships[curr];
1347       if (ownership.addr != address(0)) {
1348         return ownership;
1349       }
1350     }
1351 
1352     revert("ERC721A: unable to determine the owner of token");
1353   }
1354 
1355   /**
1356    * @dev See {IERC721-ownerOf}.
1357    */
1358   function ownerOf(uint256 tokenId) public view override returns (address) {
1359     return ownershipOf(tokenId).addr;
1360   }
1361 
1362   /**
1363    * @dev See {IERC721Metadata-name}.
1364    */
1365   function name() public view virtual override returns (string memory) {
1366     return _name;
1367   }
1368 
1369   /**
1370    * @dev See {IERC721Metadata-symbol}.
1371    */
1372   function symbol() public view virtual override returns (string memory) {
1373     return _symbol;
1374   }
1375 
1376   /**
1377    * @dev See {IERC721Metadata-tokenURI}.
1378    */
1379   function tokenURI(uint256 tokenId)
1380     public
1381     view
1382     virtual
1383     override
1384     returns (string memory)
1385   {
1386     require(
1387       _exists(tokenId),
1388       "ERC721Metadata: URI query for nonexistent token"
1389     );
1390 
1391     string memory baseURI = _baseURI();
1392     return
1393       bytes(baseURI).length > 0
1394         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1395         : "";
1396   }
1397 
1398   /**
1399    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1400    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1401    * by default, can be overriden in child contracts.
1402    */
1403   function _baseURI() internal view virtual returns (string memory) {
1404     return "";
1405   }
1406 
1407   /**
1408    * @dev See {IERC721-approve}.
1409    */
1410   function approve(address to, uint256 tokenId) public override {
1411     address owner = ERC721A.ownerOf(tokenId);
1412     require(to != owner, "ERC721A: approval to current owner");
1413 
1414     require(
1415       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1416       "ERC721A: approve caller is not owner nor approved for all"
1417     );
1418 
1419     _approve(to, tokenId, owner);
1420   }
1421 
1422   /**
1423    * @dev See {IERC721-getApproved}.
1424    */
1425   function getApproved(uint256 tokenId) public view override returns (address) {
1426     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1427 
1428     return _tokenApprovals[tokenId];
1429   }
1430 
1431   /**
1432    * @dev See {IERC721-setApprovalForAll}.
1433    */
1434   function setApprovalForAll(address operator, bool approved) public override {
1435     require(operator != _msgSender(), "ERC721A: approve to caller");
1436 
1437     _operatorApprovals[_msgSender()][operator] = approved;
1438     emit ApprovalForAll(_msgSender(), operator, approved);
1439   }
1440 
1441   /**
1442    * @dev See {IERC721-isApprovedForAll}.
1443    */
1444   function isApprovedForAll(address owner, address operator)
1445     public
1446     view
1447     virtual
1448     override
1449     returns (bool)
1450   {
1451     return _operatorApprovals[owner][operator];
1452   }
1453 
1454   /**
1455    * @dev See {IERC721-transferFrom}.
1456    */
1457   function transferFrom(
1458     address from,
1459     address to,
1460     uint256 tokenId
1461   ) public override {
1462     _transfer(from, to, tokenId);
1463   }
1464 
1465   /**
1466    * @dev See {IERC721-safeTransferFrom}.
1467    */
1468   function safeTransferFrom(
1469     address from,
1470     address to,
1471     uint256 tokenId
1472   ) public override {
1473     safeTransferFrom(from, to, tokenId, "");
1474   }
1475 
1476   /**
1477    * @dev See {IERC721-safeTransferFrom}.
1478    */
1479   function safeTransferFrom(
1480     address from,
1481     address to,
1482     uint256 tokenId,
1483     bytes memory _data
1484   ) public override {
1485     _transfer(from, to, tokenId);
1486     require(
1487       _checkOnERC721Received(from, to, tokenId, _data),
1488       "ERC721A: transfer to non ERC721Receiver implementer"
1489     );
1490   }
1491 
1492   /**
1493    * @dev Returns whether `tokenId` exists.
1494    *
1495    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1496    *
1497    * Tokens start existing when they are minted (`_mint`),
1498    */
1499   function _exists(uint256 tokenId) internal view returns (bool) {
1500     return tokenId < currentIndex;
1501   }
1502 
1503   function _safeMint(address to, uint256 quantity) internal {
1504     _safeMint(to, quantity, "");
1505   }
1506 
1507   /**
1508    * @dev Mints `quantity` tokens and transfers them to `to`.
1509    *
1510    * Requirements:
1511    *
1512    * - there must be `quantity` tokens remaining unminted in the total collection.
1513    * - `to` cannot be the zero address.
1514    * - `quantity` cannot be larger than the max batch size.
1515    *
1516    * Emits a {Transfer} event.
1517    */
1518   function _safeMint(
1519     address to,
1520     uint256 quantity,
1521     bytes memory _data
1522   ) internal {
1523     uint256 startTokenId = currentIndex;
1524     require(to != address(0), "ERC721A: mint to the zero address");
1525     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1526     require(!_exists(startTokenId), "ERC721A: token already minted");
1527     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1528 
1529     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1530 
1531     AddressData memory addressData = _addressData[to];
1532     _addressData[to] = AddressData(
1533       addressData.balance + uint128(quantity),
1534       addressData.numberMinted + uint128(quantity)
1535     );
1536     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1537 
1538     uint256 updatedIndex = startTokenId;
1539 
1540     for (uint256 i = 0; i < quantity; i++) {
1541       emit Transfer(address(0), to, updatedIndex);
1542       require(
1543         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1544         "ERC721A: transfer to non ERC721Receiver implementer"
1545       );
1546       updatedIndex++;
1547     }
1548 
1549     currentIndex = updatedIndex;
1550     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1551   }
1552 
1553   /**
1554    * @dev Transfers `tokenId` from `from` to `to`.
1555    *
1556    * Requirements:
1557    *
1558    * - `to` cannot be the zero address.
1559    * - `tokenId` token must be owned by `from`.
1560    *
1561    * Emits a {Transfer} event.
1562    */
1563   function _transfer(
1564     address from,
1565     address to,
1566     uint256 tokenId
1567   ) private {
1568     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1569 
1570     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1571       getApproved(tokenId) == _msgSender() ||
1572       isApprovedForAll(prevOwnership.addr, _msgSender()));
1573 
1574     require(
1575       isApprovedOrOwner,
1576       "ERC721A: transfer caller is not owner nor approved"
1577     );
1578 
1579     require(
1580       prevOwnership.addr == from,
1581       "ERC721A: transfer from incorrect owner"
1582     );
1583     require(to != address(0), "ERC721A: transfer to the zero address");
1584 
1585     _beforeTokenTransfers(from, to, tokenId, 1);
1586 
1587     // Clear approvals from the previous owner
1588     _approve(address(0), tokenId, prevOwnership.addr);
1589 
1590     _addressData[from].balance -= 1;
1591     _addressData[to].balance += 1;
1592     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1593 
1594     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1595     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1596     uint256 nextTokenId = tokenId + 1;
1597     if (_ownerships[nextTokenId].addr == address(0)) {
1598       if (_exists(nextTokenId)) {
1599         _ownerships[nextTokenId] = TokenOwnership(
1600           prevOwnership.addr,
1601           prevOwnership.startTimestamp
1602         );
1603       }
1604     }
1605 
1606     emit Transfer(from, to, tokenId);
1607     _afterTokenTransfers(from, to, tokenId, 1);
1608   }
1609 
1610   /**
1611    * @dev Approve `to` to operate on `tokenId`
1612    *
1613    * Emits a {Approval} event.
1614    */
1615   function _approve(
1616     address to,
1617     uint256 tokenId,
1618     address owner
1619   ) private {
1620     _tokenApprovals[tokenId] = to;
1621     emit Approval(owner, to, tokenId);
1622   }
1623 
1624   uint256 public nextOwnerToExplicitlySet = 0;
1625 
1626   /**
1627    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1628    */
1629   function _setOwnersExplicit(uint256 quantity) internal {
1630     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1631     require(quantity > 0, "quantity must be nonzero");
1632     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1633     if (endIndex > collectionSize - 1) {
1634       endIndex = collectionSize - 1;
1635     }
1636     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1637     require(_exists(endIndex), "not enough minted yet for this cleanup");
1638     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1639       if (_ownerships[i].addr == address(0)) {
1640         TokenOwnership memory ownership = ownershipOf(i);
1641         _ownerships[i] = TokenOwnership(
1642           ownership.addr,
1643           ownership.startTimestamp
1644         );
1645       }
1646     }
1647     nextOwnerToExplicitlySet = endIndex + 1;
1648   }
1649 
1650   /**
1651    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1652    * The call is not executed if the target address is not a contract.
1653    *
1654    * @param from address representing the previous owner of the given token ID
1655    * @param to target address that will receive the tokens
1656    * @param tokenId uint256 ID of the token to be transferred
1657    * @param _data bytes optional data to send along with the call
1658    * @return bool whether the call correctly returned the expected magic value
1659    */
1660   function _checkOnERC721Received(
1661     address from,
1662     address to,
1663     uint256 tokenId,
1664     bytes memory _data
1665   ) private returns (bool) {
1666     if (to.isContract()) {
1667       try
1668         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1669       returns (bytes4 retval) {
1670         return retval == IERC721Receiver(to).onERC721Received.selector;
1671       } catch (bytes memory reason) {
1672         if (reason.length == 0) {
1673           revert("ERC721A: transfer to non ERC721Receiver implementer");
1674         } else {
1675           assembly {
1676             revert(add(32, reason), mload(reason))
1677           }
1678         }
1679       }
1680     } else {
1681       return true;
1682     }
1683   }
1684 
1685   /**
1686    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1687    *
1688    * startTokenId - the first token id to be transferred
1689    * quantity - the amount to be transferred
1690    *
1691    * Calling conditions:
1692    *
1693    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1694    * transferred to `to`.
1695    * - When `from` is zero, `tokenId` will be minted for `to`.
1696    */
1697   function _beforeTokenTransfers(
1698     address from,
1699     address to,
1700     uint256 startTokenId,
1701     uint256 quantity
1702   ) internal virtual {}
1703 
1704   /**
1705    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1706    * minting.
1707    *
1708    * startTokenId - the first token id to be transferred
1709    * quantity - the amount to be transferred
1710    *
1711    * Calling conditions:
1712    *
1713    * - when `from` and `to` are both non-zero.
1714    * - `from` and `to` are never both zero.
1715    */
1716   function _afterTokenTransfers(
1717     address from,
1718     address to,
1719     uint256 startTokenId,
1720     uint256 quantity
1721   ) internal virtual {}
1722 }
1723 
1724 //SPDX-License-Identifier: MIT
1725 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1726 
1727 pragma solidity ^0.8.0;
1728 
1729 contract TRUST is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1730     using Counters for Counters.Counter;
1731     using Strings for uint256;
1732 
1733     Counters.Counter private tokenCounter;
1734 
1735     string private baseURI = "ipfs://QmP5m7zYGVjxq75MZJ2hA1MQuSD6rs87SckjZWV2iJtksh";
1736     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1737     bool private isOpenSeaProxyActive = true;
1738 
1739     uint256 public constant MAX_MINTS_PER_TX = 3;
1740     uint256 public maxSupply = 2500;
1741 
1742     uint256 public constant PUBLIC_SALE_PRICE = 0.005 ether;
1743     uint256 public NUM_FREE_MINTS = 444;
1744     bool public isPublicSaleActive = true;
1745 
1746 
1747 
1748 
1749     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1750 
1751     modifier publicSaleActive() {
1752         require(isPublicSaleActive, "Public sale is not open");
1753         _;
1754     }
1755 
1756 
1757 
1758     modifier maxMintsPerTX(uint256 numberOfTokens) {
1759         require(
1760             numberOfTokens <= MAX_MINTS_PER_TX,
1761             "Max mints per transaction exceeded"
1762         );
1763         _;
1764     }
1765 
1766     modifier canMintNFTs(uint256 numberOfTokens) {
1767         require(
1768             totalSupply() + numberOfTokens <=
1769                 maxSupply,
1770             "Not enough mints remaining to mint"
1771         );
1772         _;
1773     }
1774 
1775     modifier freeMintsAvailable() {
1776         require(
1777             totalSupply() <=
1778                 NUM_FREE_MINTS,
1779             "Not enough free mints remain"
1780         );
1781         _;
1782     }
1783 
1784 
1785 
1786     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1787         if(totalSupply()>NUM_FREE_MINTS){
1788         require(
1789             (price * numberOfTokens) == msg.value,
1790             "Incorrect ETH value sent"
1791         );
1792         }
1793         _;
1794     }
1795 
1796 
1797     constructor(
1798     ) ERC721A("dude trust me", "TRUST", 100, maxSupply) {
1799     }
1800 
1801     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1802 
1803     function mint(uint256 numberOfTokens)
1804         external
1805         payable
1806         nonReentrant
1807         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1808         publicSaleActive
1809         canMintNFTs(numberOfTokens)
1810         maxMintsPerTX(numberOfTokens)
1811     {
1812 
1813         _safeMint(msg.sender, numberOfTokens);
1814     }
1815 
1816 
1817 
1818     //A simple free mint function to avoid confusion
1819     //The normal mint function with a cost of 0 would work too
1820 
1821     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1822 
1823     function getBaseURI() external view returns (string memory) {
1824         return baseURI;
1825     }
1826 
1827     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1828 
1829     function setBaseURI(string memory _baseURI) external onlyOwner {
1830         baseURI = _baseURI;
1831     }
1832 
1833     // function to disable gasless listings for security in case
1834     // opensea ever shuts down or is compromised
1835     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1836         external
1837         onlyOwner
1838     {
1839         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1840     }
1841 
1842     function setIsPublicSaleActive(bool _isPublicSaleActive)
1843         external
1844         onlyOwner
1845     {
1846         isPublicSaleActive = _isPublicSaleActive;
1847     }
1848 
1849 
1850     function  SetNumFree(uint256 _numfreemints)
1851         external
1852         onlyOwner
1853     {
1854         NUM_FREE_MINTS = _numfreemints;
1855     }
1856 
1857 
1858     function withdraw() public onlyOwner {
1859         uint256 balance = address(this).balance;
1860         payable(msg.sender).transfer(balance);
1861     }
1862 
1863     function withdrawTokens(IERC20 token) public onlyOwner {
1864         uint256 balance = token.balanceOf(address(this));
1865         token.transfer(msg.sender, balance);
1866     }
1867 
1868 
1869     // ============ SUPPORTING FUNCTIONS ============
1870 
1871     function nextTokenId() private returns (uint256) {
1872         tokenCounter.increment();
1873         return tokenCounter.current();
1874     }
1875 
1876     // ============ FUNCTION OVERRIDES ============
1877 
1878     function supportsInterface(bytes4 interfaceId)
1879         public
1880         view
1881         virtual
1882         override(ERC721A, IERC165)
1883         returns (bool)
1884     {
1885         return
1886             interfaceId == type(IERC2981).interfaceId ||
1887             super.supportsInterface(interfaceId);
1888     }
1889 
1890     /**
1891      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1892      */
1893     function isApprovedForAll(address owner, address operator)
1894         public
1895         view
1896         override
1897         returns (bool)
1898     {
1899         // Get a reference to OpenSea's proxy registry contract by instantiating
1900         // the contract using the already existing address.
1901         ProxyRegistry proxyRegistry = ProxyRegistry(
1902             openSeaProxyRegistryAddress
1903         );
1904         if (
1905             isOpenSeaProxyActive &&
1906             address(proxyRegistry.proxies(owner)) == operator
1907         ) {
1908             return true;
1909         }
1910 
1911         return super.isApprovedForAll(owner, operator);
1912     }
1913 
1914     /**
1915      * @dev See {IERC721Metadata-tokenURI}.
1916      */
1917     function tokenURI(uint256 tokenId)
1918         public
1919         view
1920         virtual
1921         override
1922         returns (string memory)
1923     {
1924         require(_exists(tokenId), "Nonexistent token");
1925 
1926         return
1927             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1928     }
1929 
1930     /**
1931      * @dev See {IERC165-royaltyInfo}.
1932      */
1933     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1934         external
1935         view
1936         override
1937         returns (address receiver, uint256 royaltyAmount)
1938     {
1939         require(_exists(tokenId), "Nonexistent token");
1940 
1941         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1942     }
1943 }
1944 
1945 // These contract definitions are used to create a reference to the OpenSea
1946 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1947 contract OwnableDelegateProxy {
1948 
1949 }
1950 
1951 contract ProxyRegistry {
1952     mapping(address => OwnableDelegateProxy) public proxies;
1953 }