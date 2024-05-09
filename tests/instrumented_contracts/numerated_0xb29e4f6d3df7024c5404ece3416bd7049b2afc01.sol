1 /*
2 .______     ______   .______       __  .__   __.   _______         ___      .______    _______     _______.
3 |   _  \   /  __  \  |   _  \     |  | |  \ |  |  /  _____|       /   \     |   _  \  |   ____|   /       |
4 |  |_)  | |  |  |  | |  |_)  |    |  | |   \|  | |  |  __        /  ^  \    |  |_)  | |  |__     |   (----`
5 |   _  <  |  |  |  | |      /     |  | |  . `  | |  | |_ |      /  /_\  \   |   ___/  |   __|     \   \    
6 |  |_)  | |  `--'  | |  |\  \----.|  | |  |\   | |  |__| |     /  _____  \  |  |      |  |____.----)   |   
7 |______/   \______/  | _| `._____||__| |__| \__|  \______|    /__/     \__\ | _|      |_______|_______/   
8 */
9 
10 
11 
12 
13 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
14 
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 // CAUTION
21 // This version of SafeMath should only be used with Solidity 0.8 or later,
22 // because it relies on the compiler's built in overflow checks.
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations.
26  *
27  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
28  * now has built in overflow checking.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             uint256 c = a + b;
39             if (c < a) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     /**
45      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b > a) return (false, 0);
52             return (true, a - b);
53         }
54     }
55 
56     /**
57      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64             // benefit is lost if 'b' is also tested.
65             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66             if (a == 0) return (true, 0);
67             uint256 c = a * b;
68             if (c / a != b) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the division of two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a / b);
82         }
83     }
84 
85     /**
86      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a % b);
94         }
95     }
96 
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a + b;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a - b;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a * b;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers, reverting on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator.
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a / b;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * reverting when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a % b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * CAUTION: This function is deprecated because it requires allocating memory for the error
174      * message unnecessarily. For custom revert reasons use {trySub}.
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(
183         uint256 a,
184         uint256 b,
185         string memory errorMessage
186     ) internal pure returns (uint256) {
187         unchecked {
188             require(b <= a, errorMessage);
189             return a - b;
190         }
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         unchecked {
211             require(b > 0, errorMessage);
212             return a / b;
213         }
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * reverting with custom message when dividing by zero.
219      *
220      * CAUTION: This function is deprecated because it requires allocating memory for the error
221      * message unnecessarily. For custom revert reasons use {tryMod}.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a % b;
239         }
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Counters.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @title Counters
252  * @author Matt Condon (@shrugs)
253  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
254  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
255  *
256  * Include with `using Counters for Counters.Counter;`
257  */
258 library Counters {
259     struct Counter {
260         // This variable should never be directly accessed by users of the library: interactions must be restricted to
261         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
262         // this feature: see https://github.com/ethereum/solidity/issues/4637
263         uint256 _value; // default: 0
264     }
265 
266     function current(Counter storage counter) internal view returns (uint256) {
267         return counter._value;
268     }
269 
270     function increment(Counter storage counter) internal {
271         unchecked {
272             counter._value += 1;
273         }
274     }
275 
276     function decrement(Counter storage counter) internal {
277         uint256 value = counter._value;
278         require(value > 0, "Counter: decrement overflow");
279         unchecked {
280             counter._value = value - 1;
281         }
282     }
283 
284     function reset(Counter storage counter) internal {
285         counter._value = 0;
286     }
287 }
288 
289 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
290 
291 
292 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Contract module that helps prevent reentrant calls to a function.
298  *
299  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
300  * available, which can be applied to functions to make sure there are no nested
301  * (reentrant) calls to them.
302  *
303  * Note that because there is a single `nonReentrant` guard, functions marked as
304  * `nonReentrant` may not call one another. This can be worked around by making
305  * those functions `private`, and then adding `external` `nonReentrant` entry
306  * points to them.
307  *
308  * TIP: If you would like to learn more about reentrancy and alternative ways
309  * to protect against it, check out our blog post
310  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
311  */
312 abstract contract ReentrancyGuard {
313     // Booleans are more expensive than uint256 or any type that takes up a full
314     // word because each write operation emits an extra SLOAD to first read the
315     // slot's contents, replace the bits taken up by the boolean, and then write
316     // back. This is the compiler's defense against contract upgrades and
317     // pointer aliasing, and it cannot be disabled.
318 
319     // The values being non-zero value makes deployment a bit more expensive,
320     // but in exchange the refund on every call to nonReentrant will be lower in
321     // amount. Since refunds are capped to a percentage of the total
322     // transaction's gas, it is best to keep them low in cases like this one, to
323     // increase the likelihood of the full refund coming into effect.
324     uint256 private constant _NOT_ENTERED = 1;
325     uint256 private constant _ENTERED = 2;
326 
327     uint256 private _status;
328 
329     constructor() {
330         _status = _NOT_ENTERED;
331     }
332 
333     /**
334      * @dev Prevents a contract from calling itself, directly or indirectly.
335      * Calling a `nonReentrant` function from another `nonReentrant`
336      * function is not supported. It is possible to prevent this from happening
337      * by making the `nonReentrant` function external, and making it call a
338      * `private` function that does the actual work.
339      */
340     modifier nonReentrant() {
341         // On the first call to nonReentrant, _notEntered will be true
342         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
343 
344         // Any calls to nonReentrant after this point will fail
345         _status = _ENTERED;
346 
347         _;
348 
349         // By storing the original value once again, a refund is triggered (see
350         // https://eips.ethereum.org/EIPS/eip-2200)
351         _status = _NOT_ENTERED;
352     }
353 }
354 
355 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Interface of the ERC20 standard as defined in the EIP.
364  */
365 interface IERC20 {
366     /**
367      * @dev Returns the amount of tokens in existence.
368      */
369     function totalSupply() external view returns (uint256);
370 
371     /**
372      * @dev Returns the amount of tokens owned by `account`.
373      */
374     function balanceOf(address account) external view returns (uint256);
375 
376     /**
377      * @dev Moves `amount` tokens from the caller's account to `recipient`.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * Emits a {Transfer} event.
382      */
383     function transfer(address recipient, uint256 amount) external returns (bool);
384 
385     /**
386      * @dev Returns the remaining number of tokens that `spender` will be
387      * allowed to spend on behalf of `owner` through {transferFrom}. This is
388      * zero by default.
389      *
390      * This value changes when {approve} or {transferFrom} are called.
391      */
392     function allowance(address owner, address spender) external view returns (uint256);
393 
394     /**
395      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * IMPORTANT: Beware that changing an allowance with this method brings the risk
400      * that someone may use both the old and the new allowance by unfortunate
401      * transaction ordering. One possible solution to mitigate this race
402      * condition is to first reduce the spender's allowance to 0 and set the
403      * desired value afterwards:
404      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
405      *
406      * Emits an {Approval} event.
407      */
408     function approve(address spender, uint256 amount) external returns (bool);
409 
410     /**
411      * @dev Moves `amount` tokens from `sender` to `recipient` using the
412      * allowance mechanism. `amount` is then deducted from the caller's
413      * allowance.
414      *
415      * Returns a boolean value indicating whether the operation succeeded.
416      *
417      * Emits a {Transfer} event.
418      */
419     function transferFrom(
420         address sender,
421         address recipient,
422         uint256 amount
423     ) external returns (bool);
424 
425     /**
426      * @dev Emitted when `value` tokens are moved from one account (`from`) to
427      * another (`to`).
428      *
429      * Note that `value` may be zero.
430      */
431     event Transfer(address indexed from, address indexed to, uint256 value);
432 
433     /**
434      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
435      * a call to {approve}. `value` is the new allowance.
436      */
437     event Approval(address indexed owner, address indexed spender, uint256 value);
438 }
439 
440 // File: @openzeppelin/contracts/interfaces/IERC20.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 
448 // File: @openzeppelin/contracts/utils/Strings.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev String operations.
457  */
458 library Strings {
459     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
460 
461     /**
462      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
463      */
464     function toString(uint256 value) internal pure returns (string memory) {
465         // Inspired by OraclizeAPI's implementation - MIT licence
466         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
467 
468         if (value == 0) {
469             return "0";
470         }
471         uint256 temp = value;
472         uint256 digits;
473         while (temp != 0) {
474             digits++;
475             temp /= 10;
476         }
477         bytes memory buffer = new bytes(digits);
478         while (value != 0) {
479             digits -= 1;
480             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
481             value /= 10;
482         }
483         return string(buffer);
484     }
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
488      */
489     function toHexString(uint256 value) internal pure returns (string memory) {
490         if (value == 0) {
491             return "0x00";
492         }
493         uint256 temp = value;
494         uint256 length = 0;
495         while (temp != 0) {
496             length++;
497             temp >>= 8;
498         }
499         return toHexString(value, length);
500     }
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
504      */
505     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
506         bytes memory buffer = new bytes(2 * length + 2);
507         buffer[0] = "0";
508         buffer[1] = "x";
509         for (uint256 i = 2 * length + 1; i > 1; --i) {
510             buffer[i] = _HEX_SYMBOLS[value & 0xf];
511             value >>= 4;
512         }
513         require(value == 0, "Strings: hex length insufficient");
514         return string(buffer);
515     }
516 }
517 
518 // File: @openzeppelin/contracts/utils/Context.sol
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Provides information about the current execution context, including the
527  * sender of the transaction and its data. While these are generally available
528  * via msg.sender and msg.data, they should not be accessed in such a direct
529  * manner, since when dealing with meta-transactions the account sending and
530  * paying for execution may not be the actual sender (as far as an application
531  * is concerned).
532  *
533  * This contract is only required for intermediate, library-like contracts.
534  */
535 abstract contract Context {
536     function _msgSender() internal view virtual returns (address) {
537         return msg.sender;
538     }
539 
540     function _msgData() internal view virtual returns (bytes calldata) {
541         return msg.data;
542     }
543 }
544 
545 // File: @openzeppelin/contracts/access/Ownable.sol
546 
547 
548 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 
553 /**
554  * @dev Contract module which provides a basic access control mechanism, where
555  * there is an account (an owner) that can be granted exclusive access to
556  * specific functions.
557  *
558  * By default, the owner account will be the one that deploys the contract. This
559  * can later be changed with {transferOwnership}.
560  *
561  * This module is used through inheritance. It will make available the modifier
562  * `onlyOwner`, which can be applied to your functions to restrict their use to
563  * the owner.
564  */
565 abstract contract Ownable is Context {
566     address private _owner;
567 
568     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
569 
570     /**
571      * @dev Initializes the contract setting the deployer as the initial owner.
572      */
573     constructor() {
574         _transferOwnership(_msgSender());
575     }
576 
577     /**
578      * @dev Returns the address of the current owner.
579      */
580     function owner() public view virtual returns (address) {
581         return _owner;
582     }
583 
584     /**
585      * @dev Throws if called by any account other than the owner.
586      */
587     modifier onlyOwner() {
588         require(owner() == _msgSender(), "Ownable: caller is not the owner");
589         _;
590     }
591 
592     /**
593      * @dev Leaves the contract without owner. It will not be possible to call
594      * `onlyOwner` functions anymore. Can only be called by the current owner.
595      *
596      * NOTE: Renouncing ownership will leave the contract without an owner,
597      * thereby removing any functionality that is only available to the owner.
598      */
599     function renounceOwnership() public virtual onlyOwner {
600         _transferOwnership(address(0));
601     }
602 
603     /**
604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
605      * Can only be called by the current owner.
606      */
607     function transferOwnership(address newOwner) public virtual onlyOwner {
608         require(newOwner != address(0), "Ownable: new owner is the zero address");
609         _transferOwnership(newOwner);
610     }
611 
612     /**
613      * @dev Transfers ownership of the contract to a new account (`newOwner`).
614      * Internal function without access restriction.
615      */
616     function _transferOwnership(address newOwner) internal virtual {
617         address oldOwner = _owner;
618         _owner = newOwner;
619         emit OwnershipTransferred(oldOwner, newOwner);
620     }
621 }
622 
623 // File: @openzeppelin/contracts/utils/Address.sol
624 
625 
626 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @dev Collection of functions related to the address type
632  */
633 library Address {
634     /**
635      * @dev Returns true if `account` is a contract.
636      *
637      * [IMPORTANT]
638      * ====
639      * It is unsafe to assume that an address for which this function returns
640      * false is an externally-owned account (EOA) and not a contract.
641      *
642      * Among others, `isContract` will return false for the following
643      * types of addresses:
644      *
645      *  - an externally-owned account
646      *  - a contract in construction
647      *  - an address where a contract will be created
648      *  - an address where a contract lived, but was destroyed
649      * ====
650      */
651     function isContract(address account) internal view returns (bool) {
652         // This method relies on extcodesize, which returns 0 for contracts in
653         // construction, since the code is only stored at the end of the
654         // constructor execution.
655 
656         uint256 size;
657         assembly {
658             size := extcodesize(account)
659         }
660         return size > 0;
661     }
662 
663     /**
664      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
665      * `recipient`, forwarding all available gas and reverting on errors.
666      *
667      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
668      * of certain opcodes, possibly making contracts go over the 2300 gas limit
669      * imposed by `transfer`, making them unable to receive funds via
670      * `transfer`. {sendValue} removes this limitation.
671      *
672      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
673      *
674      * IMPORTANT: because control is transferred to `recipient`, care must be
675      * taken to not create reentrancy vulnerabilities. Consider using
676      * {ReentrancyGuard} or the
677      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
678      */
679     function sendValue(address payable recipient, uint256 amount) internal {
680         require(address(this).balance >= amount, "Address: insufficient balance");
681 
682         (bool success, ) = recipient.call{value: amount}("");
683         require(success, "Address: unable to send value, recipient may have reverted");
684     }
685 
686     /**
687      * @dev Performs a Solidity function call using a low level `call`. A
688      * plain `call` is an unsafe replacement for a function call: use this
689      * function instead.
690      *
691      * If `target` reverts with a revert reason, it is bubbled up by this
692      * function (like regular Solidity function calls).
693      *
694      * Returns the raw returned data. To convert to the expected return value,
695      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
696      *
697      * Requirements:
698      *
699      * - `target` must be a contract.
700      * - calling `target` with `data` must not revert.
701      *
702      * _Available since v3.1._
703      */
704     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
705         return functionCall(target, data, "Address: low-level call failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
710      * `errorMessage` as a fallback revert reason when `target` reverts.
711      *
712      * _Available since v3.1._
713      */
714     function functionCall(
715         address target,
716         bytes memory data,
717         string memory errorMessage
718     ) internal returns (bytes memory) {
719         return functionCallWithValue(target, data, 0, errorMessage);
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
724      * but also transferring `value` wei to `target`.
725      *
726      * Requirements:
727      *
728      * - the calling contract must have an ETH balance of at least `value`.
729      * - the called Solidity function must be `payable`.
730      *
731      * _Available since v3.1._
732      */
733     function functionCallWithValue(
734         address target,
735         bytes memory data,
736         uint256 value
737     ) internal returns (bytes memory) {
738         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
743      * with `errorMessage` as a fallback revert reason when `target` reverts.
744      *
745      * _Available since v3.1._
746      */
747     function functionCallWithValue(
748         address target,
749         bytes memory data,
750         uint256 value,
751         string memory errorMessage
752     ) internal returns (bytes memory) {
753         require(address(this).balance >= value, "Address: insufficient balance for call");
754         require(isContract(target), "Address: call to non-contract");
755 
756         (bool success, bytes memory returndata) = target.call{value: value}(data);
757         return verifyCallResult(success, returndata, errorMessage);
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
762      * but performing a static call.
763      *
764      * _Available since v3.3._
765      */
766     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
767         return functionStaticCall(target, data, "Address: low-level static call failed");
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
772      * but performing a static call.
773      *
774      * _Available since v3.3._
775      */
776     function functionStaticCall(
777         address target,
778         bytes memory data,
779         string memory errorMessage
780     ) internal view returns (bytes memory) {
781         require(isContract(target), "Address: static call to non-contract");
782 
783         (bool success, bytes memory returndata) = target.staticcall(data);
784         return verifyCallResult(success, returndata, errorMessage);
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
789      * but performing a delegate call.
790      *
791      * _Available since v3.4._
792      */
793     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
794         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
799      * but performing a delegate call.
800      *
801      * _Available since v3.4._
802      */
803     function functionDelegateCall(
804         address target,
805         bytes memory data,
806         string memory errorMessage
807     ) internal returns (bytes memory) {
808         require(isContract(target), "Address: delegate call to non-contract");
809 
810         (bool success, bytes memory returndata) = target.delegatecall(data);
811         return verifyCallResult(success, returndata, errorMessage);
812     }
813 
814     /**
815      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
816      * revert reason using the provided one.
817      *
818      * _Available since v4.3._
819      */
820     function verifyCallResult(
821         bool success,
822         bytes memory returndata,
823         string memory errorMessage
824     ) internal pure returns (bytes memory) {
825         if (success) {
826             return returndata;
827         } else {
828             // Look for revert reason and bubble it up if present
829             if (returndata.length > 0) {
830                 // The easiest way to bubble the revert reason is using memory via assembly
831 
832                 assembly {
833                     let returndata_size := mload(returndata)
834                     revert(add(32, returndata), returndata_size)
835                 }
836             } else {
837                 revert(errorMessage);
838             }
839         }
840     }
841 }
842 
843 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
844 
845 
846 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
847 
848 pragma solidity ^0.8.0;
849 
850 /**
851  * @title ERC721 token receiver interface
852  * @dev Interface for any contract that wants to support safeTransfers
853  * from ERC721 asset contracts.
854  */
855 interface IERC721Receiver {
856     /**
857      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
858      * by `operator` from `from`, this function is called.
859      *
860      * It must return its Solidity selector to confirm the token transfer.
861      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
862      *
863      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
864      */
865     function onERC721Received(
866         address operator,
867         address from,
868         uint256 tokenId,
869         bytes calldata data
870     ) external returns (bytes4);
871 }
872 
873 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
874 
875 
876 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
877 
878 pragma solidity ^0.8.0;
879 
880 /**
881  * @dev Interface of the ERC165 standard, as defined in the
882  * https://eips.ethereum.org/EIPS/eip-165[EIP].
883  *
884  * Implementers can declare support of contract interfaces, which can then be
885  * queried by others ({ERC165Checker}).
886  *
887  * For an implementation, see {ERC165}.
888  */
889 interface IERC165 {
890     /**
891      * @dev Returns true if this contract implements the interface defined by
892      * `interfaceId`. See the corresponding
893      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
894      * to learn more about how these ids are created.
895      *
896      * This function call must use less than 30 000 gas.
897      */
898     function supportsInterface(bytes4 interfaceId) external view returns (bool);
899 }
900 
901 // File: @openzeppelin/contracts/interfaces/IERC165.sol
902 
903 
904 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 
909 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
910 
911 
912 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
913 
914 pragma solidity ^0.8.0;
915 
916 
917 /**
918  * @dev Interface for the NFT Royalty Standard
919  */
920 interface IERC2981 is IERC165 {
921     /**
922      * @dev Called with the sale price to determine how much royalty is owed and to whom.
923      * @param tokenId - the NFT asset queried for royalty information
924      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
925      * @return receiver - address of who should be sent the royalty payment
926      * @return royaltyAmount - the royalty payment amount for `salePrice`
927      */
928     function royaltyInfo(uint256 tokenId, uint256 salePrice)
929         external
930         view
931         returns (address receiver, uint256 royaltyAmount);
932 }
933 
934 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
935 
936 
937 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 
942 /**
943  * @dev Implementation of the {IERC165} interface.
944  *
945  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
946  * for the additional interface id that will be supported. For example:
947  *
948  * ```solidity
949  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
950  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
951  * }
952  * ```
953  *
954  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
955  */
956 abstract contract ERC165 is IERC165 {
957     /**
958      * @dev See {IERC165-supportsInterface}.
959      */
960     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
961         return interfaceId == type(IERC165).interfaceId;
962     }
963 }
964 
965 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
966 
967 
968 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
969 
970 pragma solidity ^0.8.0;
971 
972 
973 /**
974  * @dev Required interface of an ERC721 compliant contract.
975  */
976 interface IERC721 is IERC165 {
977     /**
978      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
979      */
980     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
981 
982     /**
983      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
984      */
985     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
986 
987     /**
988      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
989      */
990     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
991 
992     /**
993      * @dev Returns the number of tokens in ``owner``'s account.
994      */
995     function balanceOf(address owner) external view returns (uint256 balance);
996 
997     /**
998      * @dev Returns the owner of the `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function ownerOf(uint256 tokenId) external view returns (address owner);
1005 
1006     /**
1007      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1008      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1009      *
1010      * Requirements:
1011      *
1012      * - `from` cannot be the zero address.
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must exist and be owned by `from`.
1015      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1016      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) external;
1025 
1026     /**
1027      * @dev Transfers `tokenId` token from `from` to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1030      *
1031      * Requirements:
1032      *
1033      * - `from` cannot be the zero address.
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must be owned by `from`.
1036      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function transferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) external;
1045 
1046     /**
1047      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1048      * The approval is cleared when the token is transferred.
1049      *
1050      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1051      *
1052      * Requirements:
1053      *
1054      * - The caller must own the token or be an approved operator.
1055      * - `tokenId` must exist.
1056      *
1057      * Emits an {Approval} event.
1058      */
1059     function approve(address to, uint256 tokenId) external;
1060 
1061     /**
1062      * @dev Returns the account approved for `tokenId` token.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must exist.
1067      */
1068     function getApproved(uint256 tokenId) external view returns (address operator);
1069 
1070     /**
1071      * @dev Approve or remove `operator` as an operator for the caller.
1072      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1073      *
1074      * Requirements:
1075      *
1076      * - The `operator` cannot be the caller.
1077      *
1078      * Emits an {ApprovalForAll} event.
1079      */
1080     function setApprovalForAll(address operator, bool _approved) external;
1081 
1082     /**
1083      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1084      *
1085      * See {setApprovalForAll}
1086      */
1087     function isApprovedForAll(address owner, address operator) external view returns (bool);
1088 
1089     /**
1090      * @dev Safely transfers `tokenId` token from `from` to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `from` cannot be the zero address.
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must exist and be owned by `from`.
1097      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1098      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes calldata data
1107     ) external;
1108 }
1109 
1110 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1111 
1112 
1113 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1114 
1115 pragma solidity ^0.8.0;
1116 
1117 
1118 /**
1119  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1120  * @dev See https://eips.ethereum.org/EIPS/eip-721
1121  */
1122 interface IERC721Enumerable is IERC721 {
1123     /**
1124      * @dev Returns the total amount of tokens stored by the contract.
1125      */
1126     function totalSupply() external view returns (uint256);
1127 
1128     /**
1129      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1130      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1131      */
1132     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1133 
1134     /**
1135      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1136      * Use along with {totalSupply} to enumerate all tokens.
1137      */
1138     function tokenByIndex(uint256 index) external view returns (uint256);
1139 }
1140 
1141 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1142 
1143 
1144 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1145 
1146 pragma solidity ^0.8.0;
1147 
1148 
1149 /**
1150  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1151  * @dev See https://eips.ethereum.org/EIPS/eip-721
1152  */
1153 interface IERC721Metadata is IERC721 {
1154     /**
1155      * @dev Returns the token collection name.
1156      */
1157     function name() external view returns (string memory);
1158 
1159     /**
1160      * @dev Returns the token collection symbol.
1161      */
1162     function symbol() external view returns (string memory);
1163 
1164     /**
1165      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1166      */
1167     function tokenURI(uint256 tokenId) external view returns (string memory);
1168 }
1169 
1170 // File: contracts/ERC721A.sol
1171 
1172 
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 
1177 
1178 
1179 
1180 
1181 
1182 
1183 
1184 /**
1185  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1186  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1187  *
1188  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1189  *
1190  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1191  *
1192  * Does not support burning tokens to address(0).
1193  */
1194 contract ERC721A is
1195   Context,
1196   ERC165,
1197   IERC721,
1198   IERC721Metadata,
1199   IERC721Enumerable
1200 {
1201   using Address for address;
1202   using Strings for uint256;
1203 
1204   struct TokenOwnership {
1205     address addr;
1206     uint64 startTimestamp;
1207   }
1208 
1209   struct AddressData {
1210     uint128 balance;
1211     uint128 numberMinted;
1212   }
1213 
1214   uint256 private currentIndex = 0;
1215 
1216   uint256 internal immutable collectionSize;
1217   uint256 internal immutable maxBatchSize;
1218 
1219   // Token name
1220   string private _name;
1221 
1222   // Token symbol
1223   string private _symbol;
1224 
1225   // Mapping from token ID to ownership details
1226   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1227   mapping(uint256 => TokenOwnership) private _ownerships;
1228 
1229   // Mapping owner address to address data
1230   mapping(address => AddressData) private _addressData;
1231 
1232   // Mapping from token ID to approved address
1233   mapping(uint256 => address) private _tokenApprovals;
1234 
1235   // Mapping from owner to operator approvals
1236   mapping(address => mapping(address => bool)) private _operatorApprovals;
1237 
1238   /**
1239    * @dev
1240    * `maxBatchSize` refers to how much a minter can mint at a time.
1241    * `collectionSize_` refers to how many tokens are in the collection.
1242    */
1243   constructor(
1244     string memory name_,
1245     string memory symbol_,
1246     uint256 maxBatchSize_,
1247     uint256 collectionSize_
1248   ) {
1249     require(
1250       collectionSize_ > 0,
1251       "ERC721A: collection must have a nonzero supply"
1252     );
1253     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1254     _name = name_;
1255     _symbol = symbol_;
1256     maxBatchSize = maxBatchSize_;
1257     collectionSize = collectionSize_;
1258   }
1259 
1260   /**
1261    * @dev See {IERC721Enumerable-totalSupply}.
1262    */
1263   function totalSupply() public view override returns (uint256) {
1264     return currentIndex;
1265   }
1266 
1267   /**
1268    * @dev See {IERC721Enumerable-tokenByIndex}.
1269    */
1270   function tokenByIndex(uint256 index) public view override returns (uint256) {
1271     require(index < totalSupply(), "ERC721A: global index out of bounds");
1272     return index;
1273   }
1274 
1275   /**
1276    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1277    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1278    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1279    */
1280   function tokenOfOwnerByIndex(address owner, uint256 index)
1281     public
1282     view
1283     override
1284     returns (uint256)
1285   {
1286     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1287     uint256 numMintedSoFar = totalSupply();
1288     uint256 tokenIdsIdx = 0;
1289     address currOwnershipAddr = address(0);
1290     for (uint256 i = 0; i < numMintedSoFar; i++) {
1291       TokenOwnership memory ownership = _ownerships[i];
1292       if (ownership.addr != address(0)) {
1293         currOwnershipAddr = ownership.addr;
1294       }
1295       if (currOwnershipAddr == owner) {
1296         if (tokenIdsIdx == index) {
1297           return i;
1298         }
1299         tokenIdsIdx++;
1300       }
1301     }
1302     revert("ERC721A: unable to get token of owner by index");
1303   }
1304 
1305   /**
1306    * @dev See {IERC165-supportsInterface}.
1307    */
1308   function supportsInterface(bytes4 interfaceId)
1309     public
1310     view
1311     virtual
1312     override(ERC165, IERC165)
1313     returns (bool)
1314   {
1315     return
1316       interfaceId == type(IERC721).interfaceId ||
1317       interfaceId == type(IERC721Metadata).interfaceId ||
1318       interfaceId == type(IERC721Enumerable).interfaceId ||
1319       super.supportsInterface(interfaceId);
1320   }
1321 
1322   /**
1323    * @dev See {IERC721-balanceOf}.
1324    */
1325   function balanceOf(address owner) public view override returns (uint256) {
1326     require(owner != address(0), "ERC721A: balance query for the zero address");
1327     return uint256(_addressData[owner].balance);
1328   }
1329 
1330   function _numberMinted(address owner) internal view returns (uint256) {
1331     require(
1332       owner != address(0),
1333       "ERC721A: number minted query for the zero address"
1334     );
1335     return uint256(_addressData[owner].numberMinted);
1336   }
1337 
1338   function ownershipOf(uint256 tokenId)
1339     internal
1340     view
1341     returns (TokenOwnership memory)
1342   {
1343     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1344 
1345     uint256 lowestTokenToCheck;
1346     if (tokenId >= maxBatchSize) {
1347       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1348     }
1349 
1350     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1351       TokenOwnership memory ownership = _ownerships[curr];
1352       if (ownership.addr != address(0)) {
1353         return ownership;
1354       }
1355     }
1356 
1357     revert("ERC721A: unable to determine the owner of token");
1358   }
1359 
1360   /**
1361    * @dev See {IERC721-ownerOf}.
1362    */
1363   function ownerOf(uint256 tokenId) public view override returns (address) {
1364     return ownershipOf(tokenId).addr;
1365   }
1366 
1367   /**
1368    * @dev See {IERC721Metadata-name}.
1369    */
1370   function name() public view virtual override returns (string memory) {
1371     return _name;
1372   }
1373 
1374   /**
1375    * @dev See {IERC721Metadata-symbol}.
1376    */
1377   function symbol() public view virtual override returns (string memory) {
1378     return _symbol;
1379   }
1380 
1381   /**
1382    * @dev See {IERC721Metadata-tokenURI}.
1383    */
1384   function tokenURI(uint256 tokenId)
1385     public
1386     view
1387     virtual
1388     override
1389     returns (string memory)
1390   {
1391     require(
1392       _exists(tokenId),
1393       "ERC721Metadata: URI query for nonexistent token"
1394     );
1395 
1396     string memory baseURI = _baseURI();
1397     return
1398       bytes(baseURI).length > 0
1399         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1400         : "";
1401   }
1402 
1403   /**
1404    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1405    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1406    * by default, can be overriden in child contracts.
1407    */
1408   function _baseURI() internal view virtual returns (string memory) {
1409     return "";
1410   }
1411 
1412   /**
1413    * @dev See {IERC721-approve}.
1414    */
1415   function approve(address to, uint256 tokenId) public override {
1416     address owner = ERC721A.ownerOf(tokenId);
1417     require(to != owner, "ERC721A: approval to current owner");
1418 
1419     require(
1420       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1421       "ERC721A: approve caller is not owner nor approved for all"
1422     );
1423 
1424     _approve(to, tokenId, owner);
1425   }
1426 
1427   /**
1428    * @dev See {IERC721-getApproved}.
1429    */
1430   function getApproved(uint256 tokenId) public view override returns (address) {
1431     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1432 
1433     return _tokenApprovals[tokenId];
1434   }
1435 
1436   /**
1437    * @dev See {IERC721-setApprovalForAll}.
1438    */
1439   function setApprovalForAll(address operator, bool approved) public override {
1440     require(operator != _msgSender(), "ERC721A: approve to caller");
1441 
1442     _operatorApprovals[_msgSender()][operator] = approved;
1443     emit ApprovalForAll(_msgSender(), operator, approved);
1444   }
1445 
1446   /**
1447    * @dev See {IERC721-isApprovedForAll}.
1448    */
1449   function isApprovedForAll(address owner, address operator)
1450     public
1451     view
1452     virtual
1453     override
1454     returns (bool)
1455   {
1456     return _operatorApprovals[owner][operator];
1457   }
1458 
1459   /**
1460    * @dev See {IERC721-transferFrom}.
1461    */
1462   function transferFrom(
1463     address from,
1464     address to,
1465     uint256 tokenId
1466   ) public override {
1467     _transfer(from, to, tokenId);
1468   }
1469 
1470   /**
1471    * @dev See {IERC721-safeTransferFrom}.
1472    */
1473   function safeTransferFrom(
1474     address from,
1475     address to,
1476     uint256 tokenId
1477   ) public override {
1478     safeTransferFrom(from, to, tokenId, "");
1479   }
1480 
1481   /**
1482    * @dev See {IERC721-safeTransferFrom}.
1483    */
1484   function safeTransferFrom(
1485     address from,
1486     address to,
1487     uint256 tokenId,
1488     bytes memory _data
1489   ) public override {
1490     _transfer(from, to, tokenId);
1491     require(
1492       _checkOnERC721Received(from, to, tokenId, _data),
1493       "ERC721A: transfer to non ERC721Receiver implementer"
1494     );
1495   }
1496 
1497   /**
1498    * @dev Returns whether `tokenId` exists.
1499    *
1500    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1501    *
1502    * Tokens start existing when they are minted (`_mint`),
1503    */
1504   function _exists(uint256 tokenId) internal view returns (bool) {
1505     return tokenId < currentIndex;
1506   }
1507 
1508   function _safeMint(address to, uint256 quantity) internal {
1509     _safeMint(to, quantity, "");
1510   }
1511 
1512   /**
1513    * @dev Mints `quantity` tokens and transfers them to `to`.
1514    *
1515    * Requirements:
1516    *
1517    * - there must be `quantity` tokens remaining unminted in the total collection.
1518    * - `to` cannot be the zero address.
1519    * - `quantity` cannot be larger than the max batch size.
1520    *
1521    * Emits a {Transfer} event.
1522    */
1523   function _safeMint(
1524     address to,
1525     uint256 quantity,
1526     bytes memory _data
1527   ) internal {
1528     uint256 startTokenId = currentIndex;
1529     require(to != address(0), "ERC721A: mint to the zero address");
1530     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1531     require(!_exists(startTokenId), "ERC721A: token already minted");
1532     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1533 
1534     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1535 
1536     AddressData memory addressData = _addressData[to];
1537     _addressData[to] = AddressData(
1538       addressData.balance + uint128(quantity),
1539       addressData.numberMinted + uint128(quantity)
1540     );
1541     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1542 
1543     uint256 updatedIndex = startTokenId;
1544 
1545     for (uint256 i = 0; i < quantity; i++) {
1546       emit Transfer(address(0), to, updatedIndex);
1547       require(
1548         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1549         "ERC721A: transfer to non ERC721Receiver implementer"
1550       );
1551       updatedIndex++;
1552     }
1553 
1554     currentIndex = updatedIndex;
1555     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1556   }
1557 
1558   /**
1559    * @dev Transfers `tokenId` from `from` to `to`.
1560    *
1561    * Requirements:
1562    *
1563    * - `to` cannot be the zero address.
1564    * - `tokenId` token must be owned by `from`.
1565    *
1566    * Emits a {Transfer} event.
1567    */
1568   function _transfer(
1569     address from,
1570     address to,
1571     uint256 tokenId
1572   ) private {
1573     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1574 
1575     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1576       getApproved(tokenId) == _msgSender() ||
1577       isApprovedForAll(prevOwnership.addr, _msgSender()));
1578 
1579     require(
1580       isApprovedOrOwner,
1581       "ERC721A: transfer caller is not owner nor approved"
1582     );
1583 
1584     require(
1585       prevOwnership.addr == from,
1586       "ERC721A: transfer from incorrect owner"
1587     );
1588     require(to != address(0), "ERC721A: transfer to the zero address");
1589 
1590     _beforeTokenTransfers(from, to, tokenId, 1);
1591 
1592     // Clear approvals from the previous owner
1593     _approve(address(0), tokenId, prevOwnership.addr);
1594 
1595     _addressData[from].balance -= 1;
1596     _addressData[to].balance += 1;
1597     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1598 
1599     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1600     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1601     uint256 nextTokenId = tokenId + 1;
1602     if (_ownerships[nextTokenId].addr == address(0)) {
1603       if (_exists(nextTokenId)) {
1604         _ownerships[nextTokenId] = TokenOwnership(
1605           prevOwnership.addr,
1606           prevOwnership.startTimestamp
1607         );
1608       }
1609     }
1610 
1611     emit Transfer(from, to, tokenId);
1612     _afterTokenTransfers(from, to, tokenId, 1);
1613   }
1614 
1615   /**
1616    * @dev Approve `to` to operate on `tokenId`
1617    *
1618    * Emits a {Approval} event.
1619    */
1620   function _approve(
1621     address to,
1622     uint256 tokenId,
1623     address owner
1624   ) private {
1625     _tokenApprovals[tokenId] = to;
1626     emit Approval(owner, to, tokenId);
1627   }
1628 
1629   uint256 public nextOwnerToExplicitlySet = 0;
1630 
1631   /**
1632    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1633    */
1634   function _setOwnersExplicit(uint256 quantity) internal {
1635     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1636     require(quantity > 0, "quantity must be nonzero");
1637     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1638     if (endIndex > collectionSize - 1) {
1639       endIndex = collectionSize - 1;
1640     }
1641     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1642     require(_exists(endIndex), "not enough minted yet for this cleanup");
1643     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1644       if (_ownerships[i].addr == address(0)) {
1645         TokenOwnership memory ownership = ownershipOf(i);
1646         _ownerships[i] = TokenOwnership(
1647           ownership.addr,
1648           ownership.startTimestamp
1649         );
1650       }
1651     }
1652     nextOwnerToExplicitlySet = endIndex + 1;
1653   }
1654 
1655   /**
1656    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1657    * The call is not executed if the target address is not a contract.
1658    *
1659    * @param from address representing the previous owner of the given token ID
1660    * @param to target address that will receive the tokens
1661    * @param tokenId uint256 ID of the token to be transferred
1662    * @param _data bytes optional data to send along with the call
1663    * @return bool whether the call correctly returned the expected magic value
1664    */
1665   function _checkOnERC721Received(
1666     address from,
1667     address to,
1668     uint256 tokenId,
1669     bytes memory _data
1670   ) private returns (bool) {
1671     if (to.isContract()) {
1672       try
1673         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1674       returns (bytes4 retval) {
1675         return retval == IERC721Receiver(to).onERC721Received.selector;
1676       } catch (bytes memory reason) {
1677         if (reason.length == 0) {
1678           revert("ERC721A: transfer to non ERC721Receiver implementer");
1679         } else {
1680           assembly {
1681             revert(add(32, reason), mload(reason))
1682           }
1683         }
1684       }
1685     } else {
1686       return true;
1687     }
1688   }
1689 
1690   /**
1691    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1692    *
1693    * startTokenId - the first token id to be transferred
1694    * quantity - the amount to be transferred
1695    *
1696    * Calling conditions:
1697    *
1698    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1699    * transferred to `to`.
1700    * - When `from` is zero, `tokenId` will be minted for `to`.
1701    */
1702   function _beforeTokenTransfers(
1703     address from,
1704     address to,
1705     uint256 startTokenId,
1706     uint256 quantity
1707   ) internal virtual {}
1708 
1709   /**
1710    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1711    * minting.
1712    *
1713    * startTokenId - the first token id to be transferred
1714    * quantity - the amount to be transferred
1715    *
1716    * Calling conditions:
1717    *
1718    * - when `from` and `to` are both non-zero.
1719    * - `from` and `to` are never both zero.
1720    */
1721   function _afterTokenTransfers(
1722     address from,
1723     address to,
1724     uint256 startTokenId,
1725     uint256 quantity
1726   ) internal virtual {}
1727 }
1728 
1729 //SPDX-License-Identifier: MIT
1730 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1731 
1732 pragma solidity ^0.8.0;
1733 
1734 
1735 
1736 
1737 
1738 
1739 
1740 
1741 
1742 contract BoringApes is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1743     using Counters for Counters.Counter;
1744     using Strings for uint256;
1745 
1746     Counters.Counter private tokenCounter;
1747 
1748     string private baseURI = "ipfs://QmPtGEuJ7EkxNzkp9sDu1epkfSEYfkpSzzxismPHuezczu";
1749     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1750     bool private isOpenSeaProxyActive = true;
1751 
1752     uint256 public constant MAX_MINTS_PER_TX = 5;
1753     uint256 public maxSupply = 5555;
1754 
1755     uint256 public constant PUBLIC_SALE_PRICE = 0.002 ether;
1756     uint256 public NUM_FREE_MINTS = 2000;
1757     bool public isPublicSaleActive = true;
1758 
1759 
1760 
1761 
1762     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1763 
1764     modifier publicSaleActive() {
1765         require(isPublicSaleActive, "Public sale is not open");
1766         _;
1767     }
1768 
1769 
1770 
1771     modifier maxMintsPerTX(uint256 numberOfTokens) {
1772         require(
1773             numberOfTokens <= MAX_MINTS_PER_TX,
1774             "Max mints per transaction exceeded"
1775         );
1776         _;
1777     }
1778 
1779     modifier canMintNFTs(uint256 numberOfTokens) {
1780         require(
1781             totalSupply() + numberOfTokens <=
1782                 maxSupply,
1783             "Not enough mints remaining to mint"
1784         );
1785         _;
1786     }
1787 
1788     modifier freeMintsAvailable() {
1789         require(
1790             totalSupply() <=
1791                 NUM_FREE_MINTS,
1792             "Not enough free mints remain"
1793         );
1794         _;
1795     }
1796 
1797 
1798 
1799     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1800         if(totalSupply()>NUM_FREE_MINTS){
1801         require(
1802             (price * numberOfTokens) == msg.value,
1803             "Incorrect ETH value sent"
1804         );
1805         }
1806         _;
1807     }
1808 
1809 
1810     constructor(
1811     ) ERC721A("BoringApes", "BA", 100, maxSupply) {
1812     }
1813 
1814     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1815 
1816     function mint(uint256 numberOfTokens)
1817         external
1818         payable
1819         nonReentrant
1820         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1821         publicSaleActive
1822         canMintNFTs(numberOfTokens)
1823         maxMintsPerTX(numberOfTokens)
1824     {
1825 
1826         _safeMint(msg.sender, numberOfTokens);
1827     }
1828 
1829 
1830 
1831     //A simple free mint function to avoid confusion
1832     //The normal mint function with a cost of 0 would work too
1833 
1834     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1835 
1836     function getBaseURI() external view returns (string memory) {
1837         return baseURI;
1838     }
1839 
1840     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1841 
1842     function setBaseURI(string memory _baseURI) external onlyOwner {
1843         baseURI = _baseURI;
1844     }
1845 
1846     // function to disable gasless listings for security in case
1847     // opensea ever shuts down or is compromised
1848     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1849         external
1850         onlyOwner
1851     {
1852         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1853     }
1854 
1855     function setIsPublicSaleActive(bool _isPublicSaleActive)
1856         external
1857         onlyOwner
1858     {
1859         isPublicSaleActive = _isPublicSaleActive;
1860     }
1861 
1862 
1863     function mints(uint256 _numfreemints)
1864         external
1865         onlyOwner
1866     {
1867         NUM_FREE_MINTS = _numfreemints;
1868     }
1869 
1870 
1871     function withdraw() public onlyOwner {
1872         uint256 balance = address(this).balance;
1873         payable(msg.sender).transfer(balance);
1874     }
1875 
1876     function withdrawTokens(IERC20 token) public onlyOwner {
1877         uint256 balance = token.balanceOf(address(this));
1878         token.transfer(msg.sender, balance);
1879     }
1880 
1881 
1882 
1883     // ============ SUPPORTING FUNCTIONS ============
1884 
1885     function nextTokenId() private returns (uint256) {
1886         tokenCounter.increment();
1887         return tokenCounter.current();
1888     }
1889 
1890     // ============ FUNCTION OVERRIDES ============
1891 
1892     function supportsInterface(bytes4 interfaceId)
1893         public
1894         view
1895         virtual
1896         override(ERC721A, IERC165)
1897         returns (bool)
1898     {
1899         return
1900             interfaceId == type(IERC2981).interfaceId ||
1901             super.supportsInterface(interfaceId);
1902     }
1903 
1904     /**
1905      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1906      */
1907     function isApprovedForAll(address owner, address operator)
1908         public
1909         view
1910         override
1911         returns (bool)
1912     {
1913         // Get a reference to OpenSea's proxy registry contract by instantiating
1914         // the contract using the already existing address.
1915         ProxyRegistry proxyRegistry = ProxyRegistry(
1916             openSeaProxyRegistryAddress
1917         );
1918         if (
1919             isOpenSeaProxyActive &&
1920             address(proxyRegistry.proxies(owner)) == operator
1921         ) {
1922             return true;
1923         }
1924 
1925         return super.isApprovedForAll(owner, operator);
1926     }
1927 
1928     /**
1929      * @dev See {IERC721Metadata-tokenURI}.
1930      */
1931     function tokenURI(uint256 tokenId)
1932         public
1933         view
1934         virtual
1935         override
1936         returns (string memory)
1937     {
1938         require(_exists(tokenId), "Nonexistent token");
1939 
1940         return
1941             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1942     }
1943 
1944     /**
1945      * @dev See {IERC165-royaltyInfo}.
1946      */
1947     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1948         external
1949         view
1950         override
1951         returns (address receiver, uint256 royaltyAmount)
1952     {
1953         require(_exists(tokenId), "Nonexistent token");
1954 
1955         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1956     }
1957 }
1958 
1959 // These contract definitions are used to create a reference to the OpenSea
1960 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1961 contract OwnableDelegateProxy {
1962 
1963 }
1964 
1965 contract ProxyRegistry {
1966     mapping(address => OwnableDelegateProxy) public proxies;
1967 }