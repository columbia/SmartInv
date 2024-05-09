1 /*
2 
3 +------+.      +------+       +------+       +------+      .+------+
4 |`.    | `.    |\     |\      |      |      /|     /|    .' |    .'|
5 |  `+--+---+   | +----+-+     +------+     +-+----+ |   +---+--+'  |
6 |   |  |   |   | |    | |     |      |     | |    | |   |   |  |   |
7 +---+--+.  |   +-+----+ |     +------+     | +----+-+   |  .+--+---+
8  `. |    `.|    \|     \|     |      |     |/     |/    |.'    | .'
9    `+------+     +------+     +------+     +------+     +------+'
10    
11 */
12 
13 
14 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 // CAUTION////////
22 // This version of SafeMath should only be used with Solidity 0.8 or later,
23 // because it relies on the compiler's built in overflow checks.
24 
25 /**
26  * @dev Wrappers over Solidity's arithmetic operations.
27  ////
28  *
29  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
30  * now has built in overflow checking.
31  //
32  */
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             uint256 c = a + b;
42             if (c < a) return (false, 0);
43             return (true, c);
44         }
45     }
46 
47     /**
48      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b > a) return (false, 0);
55             return (true, a - b);
56         }
57     }
58 
59     /**
60      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67             // benefit is lost if 'b' is also tested.
68             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
69             if (a == 0) return (true, 0);
70             uint256 c = a * b;
71             if (c / a != b) return (false, 0);
72             return (true, c);
73         }
74     }
75 
76     /**
77      * @dev Returns the division of two unsigned integers, with a division by zero flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a / b);
85         }
86     }
87 
88     /**
89      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
90      *
91      * _Available since v3.4._
92      */
93     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         unchecked {
95             if (b == 0) return (false, 0);
96             return (true, a % b);
97         }
98     }
99 
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a + b;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a - b;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      *
136      * - Multiplication cannot overflow.
137      */
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a * b;
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers, reverting on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator.
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a / b;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * reverting when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return a % b;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
174      * overflow (when the result is negative).
175      *
176      * CAUTION: This function is deprecated because it requires allocating memory for the error
177      * message unnecessarily. For custom revert reasons use {trySub}.
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(
186         uint256 a,
187         uint256 b,
188         string memory errorMessage
189     ) internal pure returns (uint256) {
190         unchecked {
191             require(b <= a, errorMessage);
192             return a - b;
193         }
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         unchecked {
214             require(b > 0, errorMessage);
215             return a / b;
216         }
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * reverting with custom message when dividing by zero.
222      *
223      * CAUTION: This function is deprecated because it requires allocating memory for the error
224      * message unnecessarily. For custom revert reasons use {tryMod}.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         unchecked {
240             require(b > 0, errorMessage);
241             return a % b;
242         }
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Counters.sol
247 
248 
249 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @title Counters
255  * @author Matt Condon (@shrugs)
256  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
257  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
258  *
259  * Include with `using Counters for Counters.Counter;`
260  */
261 library Counters {
262     struct Counter {
263         // This variable should never be directly accessed by users of the library: interactions must be restricted to
264         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
265         // this feature: see https://github.com/ethereum/solidity/issues/4637
266         uint256 _value; // default: 0
267     }
268 
269     function current(Counter storage counter) internal view returns (uint256) {
270         return counter._value;
271     }
272 
273     function increment(Counter storage counter) internal {
274         unchecked {
275             counter._value += 1;
276         }
277     }
278 
279     function decrement(Counter storage counter) internal {
280         uint256 value = counter._value;
281         require(value > 0, "Counter: decrement overflow");
282         unchecked {
283             counter._value = value - 1;
284         }
285     }
286 
287     function reset(Counter storage counter) internal {
288         counter._value = 0;
289     }
290 }
291 
292 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @dev Contract module that helps prevent reentrant calls to a function.
301  *
302  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
303  * available, which can be applied to functions to make sure there are no nested
304  * (reentrant) calls to them.
305  *
306  * Note that because there is a single `nonReentrant` guard, functions marked as
307  * `nonReentrant` may not call one another. This can be worked around by making
308  * those functions `private`, and then adding `external` `nonReentrant` entry
309  * points to them.
310  *
311  * TIP: If you would like to learn more about reentrancy and alternative ways
312  * to protect against it, check out our blog post
313  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
314  */
315 abstract contract ReentrancyGuard {
316     // Booleans are more expensive than uint256 or any type that takes up a full
317     // word because each write operation emits an extra SLOAD to first read the
318     // slot's contents, replace the bits taken up by the boolean, and then write
319     // back. This is the compiler's defense against contract upgrades and
320     // pointer aliasing, and it cannot be disabled.
321 
322     // The values being non-zero value makes deployment a bit more expensive,
323     // but in exchange the refund on every call to nonReentrant will be lower in
324     // amount. Since refunds are capped to a percentage of the total
325     // transaction's gas, it is best to keep them low in cases like this one, to
326     // increase the likelihood of the full refund coming into effect.
327     uint256 private constant _NOT_ENTERED = 1;
328     uint256 private constant _ENTERED = 2;
329 
330     uint256 private _status;
331 
332     constructor() {
333         _status = _NOT_ENTERED;
334     }
335 
336     /**
337      * @dev Prevents a contract from calling itself, directly or indirectly.
338      * Calling a `nonReentrant` function from another `nonReentrant`
339      * function is not supported. It is possible to prevent this from happening
340      * by making the `nonReentrant` function external, and making it call a
341      * `private` function that does the actual work.
342      */
343     modifier nonReentrant() {
344         // On the first call to nonReentrant, _notEntered will be true
345         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
346 
347         // Any calls to nonReentrant after this point will fail
348         _status = _ENTERED;
349 
350         _;
351 
352         // By storing the original value once again, a refund is triggered (see
353         // https://eips.ethereum.org/EIPS/eip-2200)
354         _status = _NOT_ENTERED;
355     }
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 /**
366  * @dev Interface of the ERC20 standard as defined in the EIP.
367  */
368 interface IERC20 {
369     /**
370      * @dev Returns the amount of tokens in existence.
371      */
372     function totalSupply() external view returns (uint256);
373 
374     /**
375      * @dev Returns the amount of tokens owned by `account`.
376      */
377     function balanceOf(address account) external view returns (uint256);
378 
379     /**
380      * @dev Moves `amount` tokens from the caller's account to `recipient`.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * Emits a {Transfer} event.
385      */
386     function transfer(address recipient, uint256 amount) external returns (bool);
387 
388     /**
389      * @dev Returns the remaining number of tokens that `spender` will be
390      * allowed to spend on behalf of `owner` through {transferFrom}. This is
391      * zero by default.
392      *
393      * This value changes when {approve} or {transferFrom} are called.
394      */
395     function allowance(address owner, address spender) external view returns (uint256);
396 
397     /**
398      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
399      *
400      * Returns a boolean value indicating whether the operation succeeded.
401      *
402      * IMPORTANT: Beware that changing an allowance with this method brings the risk
403      * that someone may use both the old and the new allowance by unfortunate
404      * transaction ordering. One possible solution to mitigate this race
405      * condition is to first reduce the spender's allowance to 0 and set the
406      * desired value afterwards:
407      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
408      *
409      * Emits an {Approval} event.
410      */
411     function approve(address spender, uint256 amount) external returns (bool);
412 
413     /**
414      * @dev Moves `amount` tokens from `sender` to `recipient` using the
415      * allowance mechanism. `amount` is then deducted from the caller's
416      * allowance.
417      *
418      * Returns a boolean value indicating whether the operation succeeded.
419      *
420      * Emits a {Transfer} event.
421      */
422     function transferFrom(
423         address sender,
424         address recipient,
425         uint256 amount
426     ) external returns (bool);
427 
428     /**
429      * @dev Emitted when `value` tokens are moved from one account (`from`) to
430      * another (`to`).
431      *
432      * Note that `value` may be zero.
433      */
434     event Transfer(address indexed from, address indexed to, uint256 value);
435 
436     /**
437      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
438      * a call to {approve}. `value` is the new allowance.
439      */
440     event Approval(address indexed owner, address indexed spender, uint256 value);
441 }
442 
443 // File: @openzeppelin/contracts/interfaces/IERC20.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 // File: @openzeppelin/contracts/utils/Strings.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev String operations.
460  */
461 library Strings {
462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
466      */
467     function toString(uint256 value) internal pure returns (string memory) {
468         // Inspired by OraclizeAPI's implementation - MIT licence
469         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
470 
471         if (value == 0) {
472             return "0";
473         }
474         uint256 temp = value;
475         uint256 digits;
476         while (temp != 0) {
477             digits++;
478             temp /= 10;
479         }
480         bytes memory buffer = new bytes(digits);
481         while (value != 0) {
482             digits -= 1;
483             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
484             value /= 10;
485         }
486         return string(buffer);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
491      */
492     function toHexString(uint256 value) internal pure returns (string memory) {
493         if (value == 0) {
494             return "0x00";
495         }
496         uint256 temp = value;
497         uint256 length = 0;
498         while (temp != 0) {
499             length++;
500             temp >>= 8;
501         }
502         return toHexString(value, length);
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
507      */
508     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
509         bytes memory buffer = new bytes(2 * length + 2);
510         buffer[0] = "0";
511         buffer[1] = "x";
512         for (uint256 i = 2 * length + 1; i > 1; --i) {
513             buffer[i] = _HEX_SYMBOLS[value & 0xf];
514             value >>= 4;
515         }
516         require(value == 0, "Strings: hex length insufficient");
517         return string(buffer);
518     }
519 }
520 
521 // File: @openzeppelin/contracts/utils/Context.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Provides information about the current execution context, including the
530  * sender of the transaction and its data. While these are generally available
531  * via msg.sender and msg.data, they should not be accessed in such a direct
532  * manner, since when dealing with meta-transactions the account sending and
533  * paying for execution may not be the actual sender (as far as an application
534  * is concerned).
535  *
536  * This contract is only required for intermediate, library-like contracts.
537  */
538 abstract contract Context {
539     function _msgSender() internal view virtual returns (address) {
540         return msg.sender;
541     }
542 
543     function _msgData() internal view virtual returns (bytes calldata) {
544         return msg.data;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/access/Ownable.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Contract module which provides a basic access control mechanism, where
558  * there is an account (an owner) that can be granted exclusive access to
559  * specific functions.
560  *
561  * By default, the owner account will be the one that deploys the contract. This
562  * can later be changed with {transferOwnership}.
563  *
564  * This module is used through inheritance. It will make available the modifier
565  * `onlyOwner`, which can be applied to your functions to restrict their use to
566  * the owner.
567  */
568 abstract contract Ownable is Context {
569     address private _owner;
570 
571     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
572 
573     /**
574      * @dev Initializes the contract setting the deployer as the initial owner.
575      */
576     constructor() {
577         _transferOwnership(_msgSender());
578     }
579 
580     /**
581      * @dev Returns the address of the current owner.
582      */
583     function owner() public view virtual returns (address) {
584         return _owner;
585     }
586 
587     /**
588      * @dev Throws if called by any account other than the owner.
589      */
590     modifier onlyOwner() {
591         require(owner() == _msgSender(), "Ownable: caller is not the owner");
592         _;
593     }
594 
595     /**
596      * @dev Leaves the contract without owner. It will not be possible to call
597      * `onlyOwner` functions anymore. Can only be called by the current owner.
598      *
599      * NOTE: Renouncing ownership will leave the contract without an owner,
600      * thereby removing any functionality that is only available to the owner.
601      */
602     function renounceOwnership() public virtual onlyOwner {
603         _transferOwnership(address(0));
604     }
605 
606     /**
607      * @dev Transfers ownership of the contract to a new account (`newOwner`).
608      * Can only be called by the current owner.
609      */
610     function transferOwnership(address newOwner) public virtual onlyOwner {
611         require(newOwner != address(0), "Ownable: new owner is the zero address");
612         _transferOwnership(newOwner);
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Internal function without access restriction.
618      */
619     function _transferOwnership(address newOwner) internal virtual {
620         address oldOwner = _owner;
621         _owner = newOwner;
622         emit OwnershipTransferred(oldOwner, newOwner);
623     }
624 }
625 
626 // File: @openzeppelin/contracts/utils/Address.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Collection of functions related to the address type
635  */
636 library Address {
637     /**
638      * @dev Returns true if `account` is a contract.
639      *
640      * [IMPORTANT]
641      * ====
642      * It is unsafe to assume that an address for which this function returns
643      * false is an externally-owned account (EOA) and not a contract.
644      *
645      * Among others, `isContract` will return false for the following
646      * types of addresses:
647      *
648      *  - an externally-owned account
649      *  - a contract in construction
650      *  - an address where a contract will be created
651      *  - an address where a contract lived, but was destroyed
652      * ====
653      */
654     function isContract(address account) internal view returns (bool) {
655         // This method relies on extcodesize, which returns 0 for contracts in
656         // construction, since the code is only stored at the end of the
657         // constructor execution.
658 
659         uint256 size;
660         assembly {
661             size := extcodesize(account)
662         }
663         return size > 0;
664     }
665 
666     /**
667      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
668      * `recipient`, forwarding all available gas and reverting on errors.
669      *
670      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
671      * of certain opcodes, possibly making contracts go over the 2300 gas limit
672      * imposed by `transfer`, making them unable to receive funds via
673      * `transfer`. {sendValue} removes this limitation.
674      *
675      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
676      *
677      * IMPORTANT: because control is transferred to `recipient`, care must be
678      * taken to not create reentrancy vulnerabilities. Consider using
679      * {ReentrancyGuard} or the
680      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
681      */
682     function sendValue(address payable recipient, uint256 amount) internal {
683         require(address(this).balance >= amount, "Address: insufficient balance");
684 
685         (bool success, ) = recipient.call{value: amount}("");
686         require(success, "Address: unable to send value, recipient may have reverted");
687     }
688 
689     /**
690      * @dev Performs a Solidity function call using a low level `call`. A
691      * plain `call` is an unsafe replacement for a function call: use this
692      * function instead.
693      *
694      * If `target` reverts with a revert reason, it is bubbled up by this
695      * function (like regular Solidity function calls).
696      *
697      * Returns the raw returned data. To convert to the expected return value,
698      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
699      *
700      * Requirements:
701      *
702      * - `target` must be a contract.
703      * - calling `target` with `data` must not revert.
704      *
705      * _Available since v3.1._
706      */
707     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
708         return functionCall(target, data, "Address: low-level call failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
713      * `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCall(
718         address target,
719         bytes memory data,
720         string memory errorMessage
721     ) internal returns (bytes memory) {
722         return functionCallWithValue(target, data, 0, errorMessage);
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
727      * but also transferring `value` wei to `target`.
728      *
729      * Requirements:
730      *
731      * - the calling contract must have an ETH balance of at least `value`.
732      * - the called Solidity function must be `payable`.
733      *
734      * _Available since v3.1._
735      */
736     function functionCallWithValue(
737         address target,
738         bytes memory data,
739         uint256 value
740     ) internal returns (bytes memory) {
741         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
746      * with `errorMessage` as a fallback revert reason when `target` reverts.
747      *
748      * _Available since v3.1._
749      */
750     function functionCallWithValue(
751         address target,
752         bytes memory data,
753         uint256 value,
754         string memory errorMessage
755     ) internal returns (bytes memory) {
756         require(address(this).balance >= value, "Address: insufficient balance for call");
757         require(isContract(target), "Address: call to non-contract");
758 
759         (bool success, bytes memory returndata) = target.call{value: value}(data);
760         return verifyCallResult(success, returndata, errorMessage);
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
765      * but performing a static call.
766      *
767      * _Available since v3.3._
768      */
769     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
770         return functionStaticCall(target, data, "Address: low-level static call failed");
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(
780         address target,
781         bytes memory data,
782         string memory errorMessage
783     ) internal view returns (bytes memory) {
784         require(isContract(target), "Address: static call to non-contract");
785 
786         (bool success, bytes memory returndata) = target.staticcall(data);
787         return verifyCallResult(success, returndata, errorMessage);
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
792      * but performing a delegate call.
793      *
794      * _Available since v3.4._
795      */
796     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
797         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
802      * but performing a delegate call.
803      *
804      * _Available since v3.4._
805      */
806     function functionDelegateCall(
807         address target,
808         bytes memory data,
809         string memory errorMessage
810     ) internal returns (bytes memory) {
811         require(isContract(target), "Address: delegate call to non-contract");
812 
813         (bool success, bytes memory returndata) = target.delegatecall(data);
814         return verifyCallResult(success, returndata, errorMessage);
815     }
816 
817     /**
818      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
819      * revert reason using the provided one.
820      *
821      * _Available since v4.3._
822      */
823     function verifyCallResult(
824         bool success,
825         bytes memory returndata,
826         string memory errorMessage
827     ) internal pure returns (bytes memory) {
828         if (success) {
829             return returndata;
830         } else {
831             // Look for revert reason and bubble it up if present
832             if (returndata.length > 0) {
833                 // The easiest way to bubble the revert reason is using memory via assembly
834 
835                 assembly {
836                     let returndata_size := mload(returndata)
837                     revert(add(32, returndata), returndata_size)
838                 }
839             } else {
840                 revert(errorMessage);
841             }
842         }
843     }
844 }
845 
846 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
847 
848 
849 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @title ERC721 token receiver interface
855  * @dev Interface for any contract that wants to support safeTransfers
856  * from ERC721 asset contracts.
857  */
858 interface IERC721Receiver {
859     /**
860      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
861      * by `operator` from `from`, this function is called.
862      *
863      * It must return its Solidity selector to confirm the token transfer.
864      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
865      *
866      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
867      */
868     function onERC721Received(
869         address operator,
870         address from,
871         uint256 tokenId,
872         bytes calldata data
873     ) external returns (bytes4);
874 }
875 
876 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
877 
878 
879 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 /**
884  * @dev Interface of the ERC165 standard, as defined in the
885  * https://eips.ethereum.org/EIPS/eip-165[EIP].
886  *
887  * Implementers can declare support of contract interfaces, which can then be
888  * queried by others ({ERC165Checker}).
889  *
890  * For an implementation, see {ERC165}.
891  */
892 interface IERC165 {
893     /**
894      * @dev Returns true if this contract implements the interface defined by
895      * `interfaceId`. See the corresponding
896      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
897      * to learn more about how these ids are created.
898      *
899      * This function call must use less than 30 000 gas.
900      */
901     function supportsInterface(bytes4 interfaceId) external view returns (bool);
902 }
903 
904 // File: @openzeppelin/contracts/interfaces/IERC165.sol
905 
906 
907 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
913 
914 
915 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
916 
917 pragma solidity ^0.8.0;
918 
919 
920 /**
921  * @dev Interface for the NFT Royalty Standard
922  */
923 interface IERC2981 is IERC165 {
924     /**
925      * @dev Called with the sale price to determine how much royalty is owed and to whom.
926      * @param tokenId - the NFT asset queried for royalty information
927      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
928      * @return receiver - address of who should be sent the royalty payment
929      * @return royaltyAmount - the royalty payment amount for `salePrice`
930      */
931     function royaltyInfo(uint256 tokenId, uint256 salePrice)
932         external
933         view
934         returns (address receiver, uint256 royaltyAmount);
935 }
936 
937 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
938 
939 
940 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
941 
942 pragma solidity ^0.8.0;
943 
944 
945 /**
946  * @dev Implementation of the {IERC165} interface.
947  *
948  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
949  * for the additional interface id that will be supported. For example:
950  *
951  * ```solidity
952  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
953  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
954  * }
955  * ```
956  *
957  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
958  */
959 abstract contract ERC165 is IERC165 {
960     /**
961      * @dev See {IERC165-supportsInterface}.
962      */
963     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
964         return interfaceId == type(IERC165).interfaceId;
965     }
966 }
967 
968 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
1113 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1114 
1115 
1116 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 
1121 /**
1122  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1123  * @dev See https://eips.ethereum.org/EIPS/eip-721
1124  */
1125 interface IERC721Enumerable is IERC721 {
1126     /**
1127      * @dev Returns the total amount of tokens stored by the contract.
1128      */
1129     function totalSupply() external view returns (uint256);
1130 
1131     /**
1132      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1133      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1134      */
1135     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1136 
1137     /**
1138      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1139      * Use along with {totalSupply} to enumerate all tokens.
1140      */
1141     function tokenByIndex(uint256 index) external view returns (uint256);
1142 }
1143 
1144 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1145 
1146 
1147 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1148 
1149 pragma solidity ^0.8.0;
1150 
1151 
1152 /**
1153  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1154  * @dev See https://eips.ethereum.org/EIPS/eip-721
1155  */
1156 interface IERC721Metadata is IERC721 {
1157     /**
1158      * @dev Returns the token collection name.
1159      */
1160     function name() external view returns (string memory);
1161 
1162     /**
1163      * @dev Returns the token collection symbol.
1164      */
1165     function symbol() external view returns (string memory);
1166 
1167     /**
1168      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1169      */
1170     function tokenURI(uint256 tokenId) external view returns (string memory);
1171 }
1172 
1173 // File: contracts/ERC721A.sol
1174 
1175 
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 
1180 
1181 
1182 
1183 
1184 
1185 
1186 
1187 /**
1188  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1189  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1190  *
1191  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1192  *
1193  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1194  *
1195  * Does not support burning tokens to address(0).
1196  */
1197 contract ERC721A is
1198   Context,
1199   ERC165,
1200   IERC721,
1201   IERC721Metadata,
1202   IERC721Enumerable
1203 {
1204   using Address for address;
1205   using Strings for uint256;
1206 
1207   struct TokenOwnership {
1208     address addr;
1209     uint64 startTimestamp;
1210   }
1211 
1212   struct AddressData {
1213     uint128 balance;
1214     uint128 numberMinted;
1215   }
1216 
1217   uint256 private currentIndex = 0;
1218 
1219   uint256 internal immutable collectionSize;
1220   uint256 internal immutable maxBatchSize;
1221 
1222   // Token name
1223   string private _name;
1224 
1225   // Token symbol
1226   string private _symbol;
1227 
1228   // Mapping from token ID to ownership details
1229   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1230   mapping(uint256 => TokenOwnership) private _ownerships;
1231 
1232   // Mapping owner address to address data
1233   mapping(address => AddressData) private _addressData;
1234 
1235   // Mapping from token ID to approved address
1236   mapping(uint256 => address) private _tokenApprovals;
1237 
1238   // Mapping from owner to operator approvals
1239   mapping(address => mapping(address => bool)) private _operatorApprovals;
1240 
1241   /**
1242    * @dev
1243    * `maxBatchSize` refers to how much a minter can mint at a time.
1244    * `collectionSize_` refers to how many tokens are in the collection.
1245    */
1246   constructor(
1247     string memory name_,
1248     string memory symbol_,
1249     uint256 maxBatchSize_,
1250     uint256 collectionSize_
1251   ) {
1252     require(
1253       collectionSize_ > 0,
1254       "ERC721A: collection must have a nonzero supply"
1255     );
1256     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1257     _name = name_;
1258     _symbol = symbol_;
1259     maxBatchSize = maxBatchSize_;
1260     collectionSize = collectionSize_;
1261   }
1262 
1263   /**
1264    * @dev See {IERC721Enumerable-totalSupply}.
1265    */
1266   function totalSupply() public view override returns (uint256) {
1267     return currentIndex;
1268   }
1269 
1270   /**
1271    * @dev See {IERC721Enumerable-tokenByIndex}.
1272    */
1273   function tokenByIndex(uint256 index) public view override returns (uint256) {
1274     require(index < totalSupply(), "ERC721A: global index out of bounds");
1275     return index;
1276   }
1277 
1278   /**
1279    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1280    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1281    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1282    */
1283   function tokenOfOwnerByIndex(address owner, uint256 index)
1284     public
1285     view
1286     override
1287     returns (uint256)
1288   {
1289     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1290     uint256 numMintedSoFar = totalSupply();
1291     uint256 tokenIdsIdx = 0;
1292     address currOwnershipAddr = address(0);
1293     for (uint256 i = 0; i < numMintedSoFar; i++) {
1294       TokenOwnership memory ownership = _ownerships[i];
1295       if (ownership.addr != address(0)) {
1296         currOwnershipAddr = ownership.addr;
1297       }
1298       if (currOwnershipAddr == owner) {
1299         if (tokenIdsIdx == index) {
1300           return i;
1301         }
1302         tokenIdsIdx++;
1303       }
1304     }
1305     revert("ERC721A: unable to get token of owner by index");
1306   }
1307 
1308   /**
1309    * @dev See {IERC165-supportsInterface}.
1310    */
1311   function supportsInterface(bytes4 interfaceId)
1312     public
1313     view
1314     virtual
1315     override(ERC165, IERC165)
1316     returns (bool)
1317   {
1318     return
1319       interfaceId == type(IERC721).interfaceId ||
1320       interfaceId == type(IERC721Metadata).interfaceId ||
1321       interfaceId == type(IERC721Enumerable).interfaceId ||
1322       super.supportsInterface(interfaceId);
1323   }
1324 
1325   /**
1326    * @dev See {IERC721-balanceOf}.
1327    */
1328   function balanceOf(address owner) public view override returns (uint256) {
1329     require(owner != address(0), "ERC721A: balance query for the zero address");
1330     return uint256(_addressData[owner].balance);
1331   }
1332 
1333   function _numberMinted(address owner) internal view returns (uint256) {
1334     require(
1335       owner != address(0),
1336       "ERC721A: number minted query for the zero address"
1337     );
1338     return uint256(_addressData[owner].numberMinted);
1339   }
1340 
1341   function ownershipOf(uint256 tokenId)
1342     internal
1343     view
1344     returns (TokenOwnership memory)
1345   {
1346     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1347 
1348     uint256 lowestTokenToCheck;
1349     if (tokenId >= maxBatchSize) {
1350       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1351     }
1352 
1353     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1354       TokenOwnership memory ownership = _ownerships[curr];
1355       if (ownership.addr != address(0)) {
1356         return ownership;
1357       }
1358     }
1359 
1360     revert("ERC721A: unable to determine the owner of token");
1361   }
1362 
1363   /**
1364    * @dev See {IERC721-ownerOf}.
1365    */
1366   function ownerOf(uint256 tokenId) public view override returns (address) {
1367     return ownershipOf(tokenId).addr;
1368   }
1369 
1370   /**
1371    * @dev See {IERC721Metadata-name}.
1372    */
1373   function name() public view virtual override returns (string memory) {
1374     return _name;
1375   }
1376 
1377   /**
1378    * @dev See {IERC721Metadata-symbol}.
1379    */
1380   function symbol() public view virtual override returns (string memory) {
1381     return _symbol;
1382   }
1383 
1384   /**
1385    * @dev See {IERC721Metadata-tokenURI}.
1386    */
1387   function tokenURI(uint256 tokenId)
1388     public
1389     view
1390     virtual
1391     override
1392     returns (string memory)
1393   {
1394     require(
1395       _exists(tokenId),
1396       "ERC721Metadata: URI query for nonexistent token"
1397     );
1398 
1399     string memory baseURI = _baseURI();
1400     return
1401       bytes(baseURI).length > 0
1402         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1403         : "";
1404   }
1405 
1406   /**
1407    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1408    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1409    * by default, can be overriden in child contracts.
1410    */
1411   function _baseURI() internal view virtual returns (string memory) {
1412     return "";
1413   }
1414 
1415   /**
1416    * @dev See {IERC721-approve}.
1417    */
1418   function approve(address to, uint256 tokenId) public override {
1419     address owner = ERC721A.ownerOf(tokenId);
1420     require(to != owner, "ERC721A: approval to current owner");
1421 
1422     require(
1423       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1424       "ERC721A: approve caller is not owner nor approved for all"
1425     );
1426 
1427     _approve(to, tokenId, owner);
1428   }
1429 
1430   /**
1431    * @dev See {IERC721-getApproved}.
1432    */
1433   function getApproved(uint256 tokenId) public view override returns (address) {
1434     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1435 
1436     return _tokenApprovals[tokenId];
1437   }
1438 
1439   /**
1440    * @dev See {IERC721-setApprovalForAll}.
1441    */
1442   function setApprovalForAll(address operator, bool approved) public override {
1443     require(operator != _msgSender(), "ERC721A: approve to caller");
1444 
1445     _operatorApprovals[_msgSender()][operator] = approved;
1446     emit ApprovalForAll(_msgSender(), operator, approved);
1447   }
1448 
1449   /**
1450    * @dev See {IERC721-isApprovedForAll}.
1451    */
1452   function isApprovedForAll(address owner, address operator)
1453     public
1454     view
1455     virtual
1456     override
1457     returns (bool)
1458   {
1459     return _operatorApprovals[owner][operator];
1460   }
1461 
1462   /**
1463    * @dev See {IERC721-transferFrom}.
1464    */
1465   function transferFrom(
1466     address from,
1467     address to,
1468     uint256 tokenId
1469   ) public override {
1470     _transfer(from, to, tokenId);
1471   }
1472 
1473   /**
1474    * @dev See {IERC721-safeTransferFrom}.
1475    */
1476   function safeTransferFrom(
1477     address from,
1478     address to,
1479     uint256 tokenId
1480   ) public override {
1481     safeTransferFrom(from, to, tokenId, "");
1482   }
1483 
1484   /**
1485    * @dev See {IERC721-safeTransferFrom}.
1486    */
1487   function safeTransferFrom(
1488     address from,
1489     address to,
1490     uint256 tokenId,
1491     bytes memory _data
1492   ) public override {
1493     _transfer(from, to, tokenId);
1494     require(
1495       _checkOnERC721Received(from, to, tokenId, _data),
1496       "ERC721A: transfer to non ERC721Receiver implementer"
1497     );
1498   }
1499 
1500   /**
1501    * @dev Returns whether `tokenId` exists.
1502    *
1503    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1504    *
1505    * Tokens start existing when they are minted (`_mint`),
1506    */
1507   function _exists(uint256 tokenId) internal view returns (bool) {
1508     return tokenId < currentIndex;
1509   }
1510 
1511   function _safeMint(address to, uint256 quantity) internal {
1512     _safeMint(to, quantity, "");
1513   }
1514 
1515   /**
1516    * @dev Mints `quantity` tokens and transfers them to `to`.
1517    *
1518    * Requirements:
1519    *
1520    * - there must be `quantity` tokens remaining unminted in the total collection.
1521    * - `to` cannot be the zero address.
1522    * - `quantity` cannot be larger than the max batch size.
1523    *
1524    * Emits a {Transfer} event.
1525    */
1526   function _safeMint(
1527     address to,
1528     uint256 quantity,
1529     bytes memory _data
1530   ) internal {
1531     uint256 startTokenId = currentIndex;
1532     require(to != address(0), "ERC721A: mint to the zero address");
1533     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1534     require(!_exists(startTokenId), "ERC721A: token already minted");
1535     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1536 
1537     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1538 
1539     AddressData memory addressData = _addressData[to];
1540     _addressData[to] = AddressData(
1541       addressData.balance + uint128(quantity),
1542       addressData.numberMinted + uint128(quantity)
1543     );
1544     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1545 
1546     uint256 updatedIndex = startTokenId;
1547 
1548     for (uint256 i = 0; i < quantity; i++) {
1549       emit Transfer(address(0), to, updatedIndex);
1550       require(
1551         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1552         "ERC721A: transfer to non ERC721Receiver implementer"
1553       );
1554       updatedIndex++;
1555     }
1556 
1557     currentIndex = updatedIndex;
1558     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1559   }
1560 
1561   /**
1562    * @dev Transfers `tokenId` from `from` to `to`.
1563    *
1564    * Requirements:
1565    *
1566    * - `to` cannot be the zero address.
1567    * - `tokenId` token must be owned by `from`.
1568    *
1569    * Emits a {Transfer} event.
1570    */
1571   function _transfer(
1572     address from,
1573     address to,
1574     uint256 tokenId
1575   ) private {
1576     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1577 
1578     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1579       getApproved(tokenId) == _msgSender() ||
1580       isApprovedForAll(prevOwnership.addr, _msgSender()));
1581 
1582     require(
1583       isApprovedOrOwner,
1584       "ERC721A: transfer caller is not owner nor approved"
1585     );
1586 
1587     require(
1588       prevOwnership.addr == from,
1589       "ERC721A: transfer from incorrect owner"
1590     );
1591     require(to != address(0), "ERC721A: transfer to the zero address");
1592 
1593     _beforeTokenTransfers(from, to, tokenId, 1);
1594 
1595     // Clear approvals from the previous owner
1596     _approve(address(0), tokenId, prevOwnership.addr);
1597 
1598     _addressData[from].balance -= 1;
1599     _addressData[to].balance += 1;
1600     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1601 
1602     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1603     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1604     uint256 nextTokenId = tokenId + 1;
1605     if (_ownerships[nextTokenId].addr == address(0)) {
1606       if (_exists(nextTokenId)) {
1607         _ownerships[nextTokenId] = TokenOwnership(
1608           prevOwnership.addr,
1609           prevOwnership.startTimestamp
1610         );
1611       }
1612     }
1613 
1614     emit Transfer(from, to, tokenId);
1615     _afterTokenTransfers(from, to, tokenId, 1);
1616   }
1617 
1618   /**
1619    * @dev Approve `to` to operate on `tokenId`
1620    *
1621    * Emits a {Approval} event.
1622    */
1623   function _approve(
1624     address to,
1625     uint256 tokenId,
1626     address owner
1627   ) private {
1628     _tokenApprovals[tokenId] = to;
1629     emit Approval(owner, to, tokenId);
1630   }
1631 
1632   uint256 public nextOwnerToExplicitlySet = 0;
1633 
1634   /**
1635    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1636    */
1637   function _setOwnersExplicit(uint256 quantity) internal {
1638     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1639     require(quantity > 0, "quantity must be nonzero");
1640     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1641     if (endIndex > collectionSize - 1) {
1642       endIndex = collectionSize - 1;
1643     }
1644     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1645     require(_exists(endIndex), "not enough minted yet for this cleanup");
1646     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1647       if (_ownerships[i].addr == address(0)) {
1648         TokenOwnership memory ownership = ownershipOf(i);
1649         _ownerships[i] = TokenOwnership(
1650           ownership.addr,
1651           ownership.startTimestamp
1652         );
1653       }
1654     }
1655     nextOwnerToExplicitlySet = endIndex + 1;
1656   }
1657 
1658   /**
1659    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1660    * The call is not executed if the target address is not a contract.
1661    *
1662    * @param from address representing the previous owner of the given token ID
1663    * @param to target address that will receive the tokens
1664    * @param tokenId uint256 ID of the token to be transferred
1665    * @param _data bytes optional data to send along with the call
1666    * @return bool whether the call correctly returned the expected magic value
1667    */
1668   function _checkOnERC721Received(
1669     address from,
1670     address to,
1671     uint256 tokenId,
1672     bytes memory _data
1673   ) private returns (bool) {
1674     if (to.isContract()) {
1675       try
1676         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1677       returns (bytes4 retval) {
1678         return retval == IERC721Receiver(to).onERC721Received.selector;
1679       } catch (bytes memory reason) {
1680         if (reason.length == 0) {
1681           revert("ERC721A: transfer to non ERC721Receiver implementer");
1682         } else {
1683           assembly {
1684             revert(add(32, reason), mload(reason))
1685           }
1686         }
1687       }
1688     } else {
1689       return true;
1690     }
1691   }
1692 
1693   /**
1694    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1695    *
1696    * startTokenId - the first token id to be transferred
1697    * quantity - the amount to be transferred
1698    *
1699    * Calling conditions:
1700    *
1701    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1702    * transferred to `to`.
1703    * - When `from` is zero, `tokenId` will be minted for `to`.
1704    */
1705   function _beforeTokenTransfers(
1706     address from,
1707     address to,
1708     uint256 startTokenId,
1709     uint256 quantity
1710   ) internal virtual {}
1711 
1712   /**
1713    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1714    * minting.
1715    *
1716    * startTokenId - the first token id to be transferred
1717    * quantity - the amount to be transferred
1718    *
1719    * Calling conditions:
1720    *
1721    * - when `from` and `to` are both non-zero.
1722    * - `from` and `to` are never both zero.
1723    */
1724   function _afterTokenTransfers(
1725     address from,
1726     address to,
1727     uint256 startTokenId,
1728     uint256 quantity
1729   ) internal virtual {}
1730 }
1731 
1732 //SPDX-License-Identifier: MIT
1733 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1734 
1735 pragma solidity ^0.8.0;
1736 
1737 
1738 
1739 
1740 
1741 
1742 
1743 
1744 
1745 contract Parabellum is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1746     using Counters for Counters.Counter;
1747     using Strings for uint256;
1748 
1749     Counters.Counter private tokenCounter;
1750 
1751     string private baseURI = "ipfs://QmfKi5paf8ds9nzs5xuR6iy6PevDYQKkzLWwF1rx4Tzhs9";
1752     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1753     bool private isOpenSeaProxyActive = true;
1754 
1755     uint256 public constant MAX_MINTS_PER_TX = 5;
1756     uint256 public maxSupply = 1111;
1757 
1758     uint256 public constant PUBLIC_SALE_PRICE = 0.005 ether;
1759     uint256 public NUM_FREE_MINTS = 0;
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
1814     ) ERC721A("The Parabellum Sequence", "TPS", 100, maxSupply) {
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
1836 
1837     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1838 
1839     function getBaseURI() external view returns (string memory) {
1840         return baseURI;
1841     }
1842 
1843     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1844 
1845     function setBaseURI(string memory _baseURI) external onlyOwner {
1846         baseURI = _baseURI;
1847     }
1848 
1849     // function to disable gasless listings for security in case
1850     // opensea ever shuts down or is compromised
1851     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1852         external
1853         onlyOwner
1854     {
1855         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1856     }
1857 
1858     function setIsPublicSaleActive(bool _isPublicSaleActive)
1859         external
1860         onlyOwner
1861     {
1862         isPublicSaleActive = _isPublicSaleActive;
1863     }
1864 
1865 
1866     function setnumfree(uint256 _numfreemints)
1867         external
1868         onlyOwner
1869     {
1870         NUM_FREE_MINTS = _numfreemints;
1871     }
1872 
1873 
1874     function withdraw() public onlyOwner {
1875         uint256 balance = address(this).balance;
1876         payable(msg.sender).transfer(balance);
1877     }
1878 
1879     function withdrawTokens(IERC20 token) public onlyOwner {
1880         uint256 balance = token.balanceOf(address(this));
1881         token.transfer(msg.sender, balance);
1882     }
1883 
1884 
1885 
1886     // ============ SUPPORTING FUNCTIONS ============
1887 
1888     function nextTokenId() private returns (uint256) {
1889         tokenCounter.increment();
1890         return tokenCounter.current();
1891     }
1892 
1893     // ============ FUNCTION OVERRIDES ============
1894 
1895     function supportsInterface(bytes4 interfaceId)
1896         public
1897         view
1898         virtual
1899         override(ERC721A, IERC165)
1900         returns (bool)
1901     {
1902         return
1903             interfaceId == type(IERC2981).interfaceId ||
1904             super.supportsInterface(interfaceId);
1905     }
1906 
1907     /**
1908      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1909      */
1910     function isApprovedForAll(address owner, address operator)
1911         public
1912         view
1913         override
1914         returns (bool)
1915     {
1916         // Get a reference to OpenSea's proxy registry contract by instantiating
1917         // the contract using the already existing address.
1918         ProxyRegistry proxyRegistry = ProxyRegistry(
1919             openSeaProxyRegistryAddress
1920         );
1921         if (
1922             isOpenSeaProxyActive &&
1923             address(proxyRegistry.proxies(owner)) == operator
1924         ) {
1925             return true;
1926         }
1927 
1928         return super.isApprovedForAll(owner, operator);
1929     }
1930 
1931     /**
1932      * @dev See {IERC721Metadata-tokenURI}.
1933      */
1934     function tokenURI(uint256 tokenId)
1935         public
1936         view
1937         virtual
1938         override
1939         returns (string memory)
1940     {
1941         require(_exists(tokenId), "Nonexistent token");
1942 
1943         return
1944             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1945     }
1946 
1947     /**
1948      * @dev See {IERC165-royaltyInfo}.
1949      */
1950     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1951         external
1952         view
1953         override
1954         returns (address receiver, uint256 royaltyAmount)
1955     {
1956         require(_exists(tokenId), "Nonexistent token");
1957 
1958         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1959     }
1960 }
1961 
1962 // These contract definitions are used to create a reference to the OpenSea
1963 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1964 contract OwnableDelegateProxy {
1965 
1966 }
1967 
1968 contract ProxyRegistry {
1969     mapping(address => OwnableDelegateProxy) public proxies;
1970 }