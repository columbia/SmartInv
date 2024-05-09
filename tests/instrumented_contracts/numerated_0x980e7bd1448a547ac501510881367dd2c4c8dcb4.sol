1 pragma solidity ^0.8.0;
2 
3 // CAUTION
4 // This version of SafeMath should only be used with Solidity 0.8 or later,
5 // because it relies on the compiler's built in overflow checks.
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations.
9  *
10  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
11  * now has built in overflow checking.
12  */
13 library SafeMath {
14     /**
15      * @dev Returns the addition of two unsigned integers, with an overflow flag.
16      *
17      * _Available since v3.4._
18      */
19     function tryAdd(uint256 a, uint256 b)
20         internal
21         pure
22         returns (bool, uint256)
23     {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b)
37         internal
38         pure
39         returns (bool, uint256)
40     {
41         unchecked {
42             if (b > a) return (false, 0);
43             return (true, a - b);
44         }
45     }
46 
47     /**
48      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryMul(uint256 a, uint256 b)
53         internal
54         pure
55         returns (bool, uint256)
56     {
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
73     function tryDiv(uint256 a, uint256 b)
74         internal
75         pure
76         returns (bool, uint256)
77     {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a / b);
81         }
82     }
83 
84     /**
85      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
86      *
87      * _Available since v3.4._
88      */
89     function tryMod(uint256 a, uint256 b)
90         internal
91         pure
92         returns (bool, uint256)
93     {
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
248 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title Counters
254  * @author Matt Condon (@shrugs)
255  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
256  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
257  *
258  * Include with `using Counters for Counters.Counter;`
259  */
260 library Counters {
261     struct Counter {
262         // This variable should never be directly accessed by users of the library: interactions must be restricted to
263         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
264         // this feature: see https://github.com/ethereum/solidity/issues/4637
265         uint256 _value; // default: 0
266     }
267 
268     function current(Counter storage counter) internal view returns (uint256) {
269         return counter._value;
270     }
271 
272     function increment(Counter storage counter) internal {
273         unchecked {
274             counter._value += 1;
275         }
276     }
277 
278     function decrement(Counter storage counter) internal {
279         uint256 value = counter._value;
280         require(value > 0, "Counter: decrement overflow");
281         unchecked {
282             counter._value = value - 1;
283         }
284     }
285 
286     function reset(Counter storage counter) internal {
287         counter._value = 0;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
292 
293 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Contract module that helps prevent reentrant calls to a function.
299  *
300  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
301  * available, which can be applied to functions to make sure there are no nested
302  * (reentrant) calls to them.
303  *
304  * Note that because there is a single `nonReentrant` guard, functions marked as
305  * `nonReentrant` may not call one another. This can be worked around by making
306  * those functions `private`, and then adding `external` `nonReentrant` entry
307  * points to them.
308  *
309  * TIP: If you would like to learn more about reentrancy and alternative ways
310  * to protect against it, check out our blog post
311  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
312  */
313 abstract contract ReentrancyGuard {
314     // Booleans are more expensive than uint256 or any type that takes up a full
315     // word because each write operation emits an extra SLOAD to first read the
316     // slot's contents, replace the bits taken up by the boolean, and then write
317     // back. This is the compiler's defense against contract upgrades and
318     // pointer aliasing, and it cannot be disabled.
319 
320     // The values being non-zero value makes deployment a bit more expensive,
321     // but in exchange the refund on every call to nonReentrant will be lower in
322     // amount. Since refunds are capped to a percentage of the total
323     // transaction's gas, it is best to keep them low in cases like this one, to
324     // increase the likelihood of the full refund coming into effect.
325     uint256 private constant _NOT_ENTERED = 1;
326     uint256 private constant _ENTERED = 2;
327 
328     uint256 private _status;
329 
330     constructor() {
331         _status = _NOT_ENTERED;
332     }
333 
334     /**
335      * @dev Prevents a contract from calling itself, directly or indirectly.
336      * Calling a `nonReentrant` function from another `nonReentrant`
337      * function is not supported. It is possible to prevent this from happening
338      * by making the `nonReentrant` function external, and making it call a
339      * `private` function that does the actual work.
340      */
341     modifier nonReentrant() {
342         // On the first call to nonReentrant, _notEntered will be true
343         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
344 
345         // Any calls to nonReentrant after this point will fail
346         _status = _ENTERED;
347 
348         _;
349 
350         // By storing the original value once again, a refund is triggered (see
351         // https://eips.ethereum.org/EIPS/eip-2200)
352         _status = _NOT_ENTERED;
353     }
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
383     function transfer(address recipient, uint256 amount)
384         external
385         returns (bool);
386 
387     /**
388      * @dev Returns the remaining number of tokens that `spender` will be
389      * allowed to spend on behalf of `owner` through {transferFrom}. This is
390      * zero by default.
391      *
392      * This value changes when {approve} or {transferFrom} are called.
393      */
394     function allowance(address owner, address spender)
395         external
396         view
397         returns (uint256);
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * IMPORTANT: Beware that changing an allowance with this method brings the risk
405      * that someone may use both the old and the new allowance by unfortunate
406      * transaction ordering. One possible solution to mitigate this race
407      * condition is to first reduce the spender's allowance to 0 and set the
408      * desired value afterwards:
409      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address spender, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Moves `amount` tokens from `sender` to `recipient` using the
417      * allowance mechanism. `amount` is then deducted from the caller's
418      * allowance.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transferFrom(
425         address sender,
426         address recipient,
427         uint256 amount
428     ) external returns (bool);
429 
430     /**
431      * @dev Emitted when `value` tokens are moved from one account (`from`) to
432      * another (`to`).
433      *
434      * Note that `value` may be zero.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 value);
437 
438     /**
439      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
440      * a call to {approve}. `value` is the new allowance.
441      */
442     event Approval(
443         address indexed owner,
444         address indexed spender,
445         uint256 value
446     );
447 }
448 
449 // File: @openzeppelin/contracts/interfaces/IERC20.sol
450 
451 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 // File: @openzeppelin/contracts/utils/Strings.sol
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev String operations.
463  */
464 library Strings {
465     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
466 
467     /**
468      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
469      */
470     function toString(uint256 value) internal pure returns (string memory) {
471         // Inspired by OraclizeAPI's implementation - MIT licence
472         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
473 
474         if (value == 0) {
475             return "0";
476         }
477         uint256 temp = value;
478         uint256 digits;
479         while (temp != 0) {
480             digits++;
481             temp /= 10;
482         }
483         bytes memory buffer = new bytes(digits);
484         while (value != 0) {
485             digits -= 1;
486             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
487             value /= 10;
488         }
489         return string(buffer);
490     }
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
494      */
495     function toHexString(uint256 value) internal pure returns (string memory) {
496         if (value == 0) {
497             return "0x00";
498         }
499         uint256 temp = value;
500         uint256 length = 0;
501         while (temp != 0) {
502             length++;
503             temp >>= 8;
504         }
505         return toHexString(value, length);
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
510      */
511     function toHexString(uint256 value, uint256 length)
512         internal
513         pure
514         returns (string memory)
515     {
516         bytes memory buffer = new bytes(2 * length + 2);
517         buffer[0] = "0";
518         buffer[1] = "x";
519         for (uint256 i = 2 * length + 1; i > 1; --i) {
520             buffer[i] = _HEX_SYMBOLS[value & 0xf];
521             value >>= 4;
522         }
523         require(value == 0, "Strings: hex length insufficient");
524         return string(buffer);
525     }
526 }
527 
528 // File: @openzeppelin/contracts/utils/Context.sol
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev Provides information about the current execution context, including the
536  * sender of the transaction and its data. While these are generally available
537  * via msg.sender and msg.data, they should not be accessed in such a direct
538  * manner, since when dealing with meta-transactions the account sending and
539  * paying for execution may not be the actual sender (as far as an application
540  * is concerned).
541  *
542  * This contract is only required for intermediate, library-like contracts.
543  */
544 abstract contract Context {
545     function _msgSender() internal view virtual returns (address) {
546         return msg.sender;
547     }
548 
549     function _msgData() internal view virtual returns (bytes calldata) {
550         return msg.data;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/access/Ownable.sol
555 
556 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Contract module which provides a basic access control mechanism, where
562  * there is an account (an owner) that can be granted exclusive access to
563  * specific functions.
564  *
565  * By default, the owner account will be the one that deploys the contract. This
566  * can later be changed with {transferOwnership}.
567  *
568  * This module is used through inheritance. It will make available the modifier
569  * `onlyOwner`, which can be applied to your functions to restrict their use to
570  * the owner.
571  */
572 abstract contract Ownable is Context {
573     address private _owner;
574 
575     event OwnershipTransferred(
576         address indexed previousOwner,
577         address indexed newOwner
578     );
579 
580     /**
581      * @dev Initializes the contract setting the deployer as the initial owner.
582      */
583     constructor() {
584         _transferOwnership(_msgSender());
585     }
586 
587     /**
588      * @dev Returns the address of the current owner.
589      */
590     function owner() public view virtual returns (address) {
591         return _owner;
592     }
593 
594     /**
595      * @dev Throws if called by any account other than the owner.
596      */
597     modifier onlyOwner() {
598         require(owner() == _msgSender(), "Ownable: caller is not the owner");
599         _;
600     }
601 
602     /**
603      * @dev Leaves the contract without owner. It will not be possible to call
604      * `onlyOwner` functions anymore. Can only be called by the current owner.
605      *
606      * NOTE: Renouncing ownership will leave the contract without an owner,
607      * thereby removing any functionality that is only available to the owner.
608      */
609     function renounceOwnership() public virtual onlyOwner {
610         _transferOwnership(address(0));
611     }
612 
613     /**
614      * @dev Transfers ownership of the contract to a new account (`newOwner`).
615      * Can only be called by the current owner.
616      */
617     function transferOwnership(address newOwner) public virtual onlyOwner {
618         require(
619             newOwner != address(0),
620             "Ownable: new owner is the zero address"
621         );
622         _transferOwnership(newOwner);
623     }
624 
625     /**
626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
627      * Internal function without access restriction.
628      */
629     function _transferOwnership(address newOwner) internal virtual {
630         address oldOwner = _owner;
631         _owner = newOwner;
632         emit OwnershipTransferred(oldOwner, newOwner);
633     }
634 }
635 
636 // File: @openzeppelin/contracts/utils/Address.sol
637 
638 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @dev Collection of functions related to the address type
644  */
645 library Address {
646     /**
647      * @dev Returns true if `account` is a contract.
648      *
649      * [IMPORTANT]
650      * ====
651      * It is unsafe to assume that an address for which this function returns
652      * false is an externally-owned account (EOA) and not a contract.
653      *
654      * Among others, `isContract` will return false for the following
655      * types of addresses:
656      *
657      *  - an externally-owned account
658      *  - a contract in construction
659      *  - an address where a contract will be created
660      *  - an address where a contract lived, but was destroyed
661      * ====
662      */
663     function isContract(address account) internal view returns (bool) {
664         // This method relies on extcodesize, which returns 0 for contracts in
665         // construction, since the code is only stored at the end of the
666         // constructor execution.
667 
668         uint256 size;
669         assembly {
670             size := extcodesize(account)
671         }
672         return size > 0;
673     }
674 
675     /**
676      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
677      * `recipient`, forwarding all available gas and reverting on errors.
678      *
679      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
680      * of certain opcodes, possibly making contracts go over the 2300 gas limit
681      * imposed by `transfer`, making them unable to receive funds via
682      * `transfer`. {sendValue} removes this limitation.
683      *
684      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
685      *
686      * IMPORTANT: because control is transferred to `recipient`, care must be
687      * taken to not create reentrancy vulnerabilities. Consider using
688      * {ReentrancyGuard} or the
689      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
690      */
691     function sendValue(address payable recipient, uint256 amount) internal {
692         require(
693             address(this).balance >= amount,
694             "Address: insufficient balance"
695         );
696 
697         (bool success, ) = recipient.call{value: amount}("");
698         require(
699             success,
700             "Address: unable to send value, recipient may have reverted"
701         );
702     }
703 
704     /**
705      * @dev Performs a Solidity function call using a low level `call`. A
706      * plain `call` is an unsafe replacement for a function call: use this
707      * function instead.
708      *
709      * If `target` reverts with a revert reason, it is bubbled up by this
710      * function (like regular Solidity function calls).
711      *
712      * Returns the raw returned data. To convert to the expected return value,
713      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
714      *
715      * Requirements:
716      *
717      * - `target` must be a contract.
718      * - calling `target` with `data` must not revert.
719      *
720      * _Available since v3.1._
721      */
722     function functionCall(address target, bytes memory data)
723         internal
724         returns (bytes memory)
725     {
726         return functionCall(target, data, "Address: low-level call failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
731      * `errorMessage` as a fallback revert reason when `target` reverts.
732      *
733      * _Available since v3.1._
734      */
735     function functionCall(
736         address target,
737         bytes memory data,
738         string memory errorMessage
739     ) internal returns (bytes memory) {
740         return functionCallWithValue(target, data, 0, errorMessage);
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
745      * but also transferring `value` wei to `target`.
746      *
747      * Requirements:
748      *
749      * - the calling contract must have an ETH balance of at least `value`.
750      * - the called Solidity function must be `payable`.
751      *
752      * _Available since v3.1._
753      */
754     function functionCallWithValue(
755         address target,
756         bytes memory data,
757         uint256 value
758     ) internal returns (bytes memory) {
759         return
760             functionCallWithValue(
761                 target,
762                 data,
763                 value,
764                 "Address: low-level call with value failed"
765             );
766     }
767 
768     /**
769      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
770      * with `errorMessage` as a fallback revert reason when `target` reverts.
771      *
772      * _Available since v3.1._
773      */
774     function functionCallWithValue(
775         address target,
776         bytes memory data,
777         uint256 value,
778         string memory errorMessage
779     ) internal returns (bytes memory) {
780         require(
781             address(this).balance >= value,
782             "Address: insufficient balance for call"
783         );
784         require(isContract(target), "Address: call to non-contract");
785 
786         (bool success, bytes memory returndata) = target.call{value: value}(
787             data
788         );
789         return verifyCallResult(success, returndata, errorMessage);
790     }
791 
792     /**
793      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
794      * but performing a static call.
795      *
796      * _Available since v3.3._
797      */
798     function functionStaticCall(address target, bytes memory data)
799         internal
800         view
801         returns (bytes memory)
802     {
803         return
804             functionStaticCall(
805                 target,
806                 data,
807                 "Address: low-level static call failed"
808             );
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
813      * but performing a static call.
814      *
815      * _Available since v3.3._
816      */
817     function functionStaticCall(
818         address target,
819         bytes memory data,
820         string memory errorMessage
821     ) internal view returns (bytes memory) {
822         require(isContract(target), "Address: static call to non-contract");
823 
824         (bool success, bytes memory returndata) = target.staticcall(data);
825         return verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
830      * but performing a delegate call.
831      *
832      * _Available since v3.4._
833      */
834     function functionDelegateCall(address target, bytes memory data)
835         internal
836         returns (bytes memory)
837     {
838         return
839             functionDelegateCall(
840                 target,
841                 data,
842                 "Address: low-level delegate call failed"
843             );
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
848      * but performing a delegate call.
849      *
850      * _Available since v3.4._
851      */
852     function functionDelegateCall(
853         address target,
854         bytes memory data,
855         string memory errorMessage
856     ) internal returns (bytes memory) {
857         require(isContract(target), "Address: delegate call to non-contract");
858 
859         (bool success, bytes memory returndata) = target.delegatecall(data);
860         return verifyCallResult(success, returndata, errorMessage);
861     }
862 
863     /**
864      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
865      * revert reason using the provided one.
866      *
867      * _Available since v4.3._
868      */
869     function verifyCallResult(
870         bool success,
871         bytes memory returndata,
872         string memory errorMessage
873     ) internal pure returns (bytes memory) {
874         if (success) {
875             return returndata;
876         } else {
877             // Look for revert reason and bubble it up if present
878             if (returndata.length > 0) {
879                 // The easiest way to bubble the revert reason is using memory via assembly
880 
881                 assembly {
882                     let returndata_size := mload(returndata)
883                     revert(add(32, returndata), returndata_size)
884                 }
885             } else {
886                 revert(errorMessage);
887             }
888         }
889     }
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
893 
894 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 /**
899  * @title ERC721 token receiver interface
900  * @dev Interface for any contract that wants to support safeTransfers
901  * from ERC721 asset contracts.
902  */
903 interface IERC721Receiver {
904     /**
905      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
906      * by `operator` from `from`, this function is called.
907      *
908      * It must return its Solidity selector to confirm the token transfer.
909      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
910      *
911      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
912      */
913     function onERC721Received(
914         address operator,
915         address from,
916         uint256 tokenId,
917         bytes calldata data
918     ) external returns (bytes4);
919 }
920 
921 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
922 
923 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 /**
928  * @dev Interface of the ERC165 standard, as defined in the
929  * https://eips.ethereum.org/EIPS/eip-165[EIP].
930  *
931  * Implementers can declare support of contract interfaces, which can then be
932  * queried by others ({ERC165Checker}).
933  *
934  * For an implementation, see {ERC165}.
935  */
936 interface IERC165 {
937     /**
938      * @dev Returns true if this contract implements the interface defined by
939      * `interfaceId`. See the corresponding
940      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
941      * to learn more about how these ids are created.
942      *
943      * This function call must use less than 30 000 gas.
944      */
945     function supportsInterface(bytes4 interfaceId) external view returns (bool);
946 }
947 
948 // File: @openzeppelin/contracts/interfaces/IERC165.sol
949 
950 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
951 
952 pragma solidity ^0.8.0;
953 
954 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
955 
956 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @dev Interface for the NFT Royalty Standard
962  */
963 interface IERC2981 is IERC165 {
964     /**
965      * @dev Called with the sale price to determine how much royalty is owed and to whom.
966      * @param tokenId - the NFT asset queried for royalty information
967      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
968      * @return receiver - address of who should be sent the royalty payment
969      * @return royaltyAmount - the royalty payment amount for `salePrice`
970      */
971     function royaltyInfo(uint256 tokenId, uint256 salePrice)
972         external
973         view
974         returns (address receiver, uint256 royaltyAmount);
975 }
976 
977 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
978 
979 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 /**
984  * @dev Implementation of the {IERC165} interface.
985  *
986  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
987  * for the additional interface id that will be supported. For example:
988  *
989  * ```solidity
990  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
991  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
992  * }
993  * ```
994  *
995  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
996  */
997 abstract contract ERC165 is IERC165 {
998     /**
999      * @dev See {IERC165-supportsInterface}.
1000      */
1001     function supportsInterface(bytes4 interfaceId)
1002         public
1003         view
1004         virtual
1005         override
1006         returns (bool)
1007     {
1008         return interfaceId == type(IERC165).interfaceId;
1009     }
1010 }
1011 
1012 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1013 
1014 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 /**
1019  * @dev Required interface of an ERC721 compliant contract.
1020  */
1021 interface IERC721 is IERC165 {
1022     /**
1023      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1024      */
1025     event Transfer(
1026         address indexed from,
1027         address indexed to,
1028         uint256 indexed tokenId
1029     );
1030 
1031     /**
1032      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1033      */
1034     event Approval(
1035         address indexed owner,
1036         address indexed approved,
1037         uint256 indexed tokenId
1038     );
1039 
1040     /**
1041      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1042      */
1043     event ApprovalForAll(
1044         address indexed owner,
1045         address indexed operator,
1046         bool approved
1047     );
1048 
1049     /**
1050      * @dev Returns the number of tokens in ``owner``'s account.
1051      */
1052     function balanceOf(address owner) external view returns (uint256 balance);
1053 
1054     /**
1055      * @dev Returns the owner of the `tokenId` token.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      */
1061     function ownerOf(uint256 tokenId) external view returns (address owner);
1062 
1063     /**
1064      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1065      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1066      *
1067      * Requirements:
1068      *
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must exist and be owned by `from`.
1072      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) external;
1082 
1083     /**
1084      * @dev Transfers `tokenId` token from `from` to `to`.
1085      *
1086      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1087      *
1088      * Requirements:
1089      *
1090      * - `from` cannot be the zero address.
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must be owned by `from`.
1093      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function transferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) external;
1102 
1103     /**
1104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1105      * The approval is cleared when the token is transferred.
1106      *
1107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1108      *
1109      * Requirements:
1110      *
1111      * - The caller must own the token or be an approved operator.
1112      * - `tokenId` must exist.
1113      *
1114      * Emits an {Approval} event.
1115      */
1116     function approve(address to, uint256 tokenId) external;
1117 
1118     /**
1119      * @dev Returns the account approved for `tokenId` token.
1120      *
1121      * Requirements:
1122      *
1123      * - `tokenId` must exist.
1124      */
1125     function getApproved(uint256 tokenId)
1126         external
1127         view
1128         returns (address operator);
1129 
1130     /**
1131      * @dev Approve or remove `operator` as an operator for the caller.
1132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1133      *
1134      * Requirements:
1135      *
1136      * - The `operator` cannot be the caller.
1137      *
1138      * Emits an {ApprovalForAll} event.
1139      */
1140     function setApprovalForAll(address operator, bool _approved) external;
1141 
1142     /**
1143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1144      *
1145      * See {setApprovalForAll}
1146      */
1147     function isApprovedForAll(address owner, address operator)
1148         external
1149         view
1150         returns (bool);
1151 
1152     /**
1153      * @dev Safely transfers `tokenId` token from `from` to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must exist and be owned by `from`.
1160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function safeTransferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes calldata data
1170     ) external;
1171 }
1172 
1173 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1174 
1175 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /**
1180  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1181  * @dev See https://eips.ethereum.org/EIPS/eip-721
1182  */
1183 interface IERC721Enumerable is IERC721 {
1184     /**
1185      * @dev Returns the total amount of tokens stored by the contract.
1186      */
1187     function totalSupply() external view returns (uint256);
1188 
1189     /**
1190      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1191      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1192      */
1193     function tokenOfOwnerByIndex(address owner, uint256 index)
1194         external
1195         view
1196         returns (uint256 tokenId);
1197 
1198     /**
1199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1200      * Use along with {totalSupply} to enumerate all tokens.
1201      */
1202     function tokenByIndex(uint256 index) external view returns (uint256);
1203 }
1204 
1205 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1206 
1207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 /**
1212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1213  * @dev See https://eips.ethereum.org/EIPS/eip-721
1214  */
1215 interface IERC721Metadata is IERC721 {
1216     /**
1217      * @dev Returns the token collection name.
1218      */
1219     function name() external view returns (string memory);
1220 
1221     /**
1222      * @dev Returns the token collection symbol.
1223      */
1224     function symbol() external view returns (string memory);
1225 
1226     /**
1227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1228      */
1229     function tokenURI(uint256 tokenId) external view returns (string memory);
1230 }
1231 
1232 // File: contracts/ERC721A.sol
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 /**
1237  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1238  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1239  *
1240  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1241  *
1242  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1243  *
1244  * Does not support burning tokens to address(0).
1245  */
1246 contract ERC721A is
1247     Context,
1248     ERC165,
1249     IERC721,
1250     IERC721Metadata,
1251     IERC721Enumerable
1252 {
1253     using Address for address;
1254     using Strings for uint256;
1255 
1256     struct TokenOwnership {
1257         address addr;
1258         uint64 startTimestamp;
1259     }
1260 
1261     struct AddressData {
1262         uint128 balance;
1263         uint128 numberMinted;
1264     }
1265 
1266     uint256 private currentIndex = 0;
1267 
1268     uint256 internal immutable collectionSize;
1269     uint256 internal immutable maxBatchSize;
1270 
1271     // Token name
1272     string private _name;
1273 
1274     // Token symbol
1275     string private _symbol;
1276 
1277     // Mapping from token ID to ownership details
1278     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1279     mapping(uint256 => TokenOwnership) private _ownerships;
1280 
1281     // Mapping owner address to address data
1282     mapping(address => AddressData) private _addressData;
1283 
1284     // Mapping from token ID to approved address
1285     mapping(uint256 => address) private _tokenApprovals;
1286 
1287     // Mapping from owner to operator approvals
1288     mapping(address => mapping(address => bool)) private _operatorApprovals;
1289 
1290     /**
1291      * @dev
1292      * `maxBatchSize` refers to how much a minter can mint at a time.
1293      * `collectionSize_` refers to how many tokens are in the collection.
1294      */
1295     constructor(
1296         string memory name_,
1297         string memory symbol_,
1298         uint256 maxBatchSize_,
1299         uint256 collectionSize_
1300     ) {
1301         require(
1302             collectionSize_ > 0,
1303             "ERC721A: collection must have a nonzero supply"
1304         );
1305         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1306         _name = name_;
1307         _symbol = symbol_;
1308         maxBatchSize = maxBatchSize_;
1309         collectionSize = collectionSize_;
1310     }
1311 
1312     /**
1313      * @dev See {IERC721Enumerable-totalSupply}.
1314      */
1315     function totalSupply() public view override returns (uint256) {
1316         return currentIndex;
1317     }
1318 
1319     /**
1320      * @dev See {IERC721Enumerable-tokenByIndex}.
1321      */
1322     function tokenByIndex(uint256 index)
1323         public
1324         view
1325         override
1326         returns (uint256)
1327     {
1328         require(index < totalSupply(), "ERC721A: global index out of bounds");
1329         return index;
1330     }
1331 
1332     /**
1333      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1334      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1335      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1336      */
1337     function tokenOfOwnerByIndex(address owner, uint256 index)
1338         public
1339         view
1340         override
1341         returns (uint256)
1342     {
1343         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1344         uint256 numMintedSoFar = totalSupply();
1345         uint256 tokenIdsIdx = 0;
1346         address currOwnershipAddr = address(0);
1347         for (uint256 i = 0; i < numMintedSoFar; i++) {
1348             TokenOwnership memory ownership = _ownerships[i];
1349             if (ownership.addr != address(0)) {
1350                 currOwnershipAddr = ownership.addr;
1351             }
1352             if (currOwnershipAddr == owner) {
1353                 if (tokenIdsIdx == index) {
1354                     return i;
1355                 }
1356                 tokenIdsIdx++;
1357             }
1358         }
1359         revert("ERC721A: unable to get token of owner by index");
1360     }
1361 
1362     /**
1363      * @dev See {IERC165-supportsInterface}.
1364      */
1365     function supportsInterface(bytes4 interfaceId)
1366         public
1367         view
1368         virtual
1369         override(ERC165, IERC165)
1370         returns (bool)
1371     {
1372         return
1373             interfaceId == type(IERC721).interfaceId ||
1374             interfaceId == type(IERC721Metadata).interfaceId ||
1375             interfaceId == type(IERC721Enumerable).interfaceId ||
1376             super.supportsInterface(interfaceId);
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-balanceOf}.
1381      */
1382     function balanceOf(address owner) public view override returns (uint256) {
1383         require(
1384             owner != address(0),
1385             "ERC721A: balance query for the zero address"
1386         );
1387         return uint256(_addressData[owner].balance);
1388     }
1389 
1390     function _numberMinted(address owner) internal view returns (uint256) {
1391         require(
1392             owner != address(0),
1393             "ERC721A: number minted query for the zero address"
1394         );
1395         return uint256(_addressData[owner].numberMinted);
1396     }
1397 
1398     function ownershipOf(uint256 tokenId)
1399         internal
1400         view
1401         returns (TokenOwnership memory)
1402     {
1403         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1404 
1405         uint256 lowestTokenToCheck;
1406         if (tokenId >= maxBatchSize) {
1407             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1408         }
1409 
1410         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1411             TokenOwnership memory ownership = _ownerships[curr];
1412             if (ownership.addr != address(0)) {
1413                 return ownership;
1414             }
1415         }
1416 
1417         revert("ERC721A: unable to determine the owner of token");
1418     }
1419 
1420     /**
1421      * @dev See {IERC721-ownerOf}.
1422      */
1423     function ownerOf(uint256 tokenId) public view override returns (address) {
1424         return ownershipOf(tokenId).addr;
1425     }
1426 
1427     /**
1428      * @dev See {IERC721Metadata-name}.
1429      */
1430     function name() public view virtual override returns (string memory) {
1431         return _name;
1432     }
1433 
1434     /**
1435      * @dev See {IERC721Metadata-symbol}.
1436      */
1437     function symbol() public view virtual override returns (string memory) {
1438         return _symbol;
1439     }
1440 
1441     /**
1442      * @dev See {IERC721Metadata-tokenURI}.
1443      */
1444     function tokenURI(uint256 tokenId)
1445         public
1446         view
1447         virtual
1448         override
1449         returns (string memory)
1450     {
1451         require(
1452             _exists(tokenId),
1453             "ERC721Metadata: URI query for nonexistent token"
1454         );
1455 
1456         string memory baseURI = _baseURI();
1457         return
1458             bytes(baseURI).length > 0
1459                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1460                 : "";
1461     }
1462 
1463     /**
1464      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1465      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1466      * by default, can be overriden in child contracts.
1467      */
1468     function _baseURI() internal view virtual returns (string memory) {
1469         return "";
1470     }
1471 
1472     /**
1473      * @dev See {IERC721-approve}.
1474      */
1475     function approve(address to, uint256 tokenId) public override {
1476         address owner = ERC721A.ownerOf(tokenId);
1477         require(to != owner, "ERC721A: approval to current owner");
1478 
1479         require(
1480             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1481             "ERC721A: approve caller is not owner nor approved for all"
1482         );
1483 
1484         _approve(to, tokenId, owner);
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-getApproved}.
1489      */
1490     function getApproved(uint256 tokenId)
1491         public
1492         view
1493         override
1494         returns (address)
1495     {
1496         require(
1497             _exists(tokenId),
1498             "ERC721A: approved query for nonexistent token"
1499         );
1500 
1501         return _tokenApprovals[tokenId];
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-setApprovalForAll}.
1506      */
1507     function setApprovalForAll(address operator, bool approved)
1508         public
1509         override
1510     {
1511         require(operator != _msgSender(), "ERC721A: approve to caller");
1512 
1513         _operatorApprovals[_msgSender()][operator] = approved;
1514         emit ApprovalForAll(_msgSender(), operator, approved);
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-isApprovedForAll}.
1519      */
1520     function isApprovedForAll(address owner, address operator)
1521         public
1522         view
1523         virtual
1524         override
1525         returns (bool)
1526     {
1527         return _operatorApprovals[owner][operator];
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-transferFrom}.
1532      */
1533     function transferFrom(
1534         address from,
1535         address to,
1536         uint256 tokenId
1537     ) public override {
1538         _transfer(from, to, tokenId);
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-safeTransferFrom}.
1543      */
1544     function safeTransferFrom(
1545         address from,
1546         address to,
1547         uint256 tokenId
1548     ) public override {
1549         safeTransferFrom(from, to, tokenId, "");
1550     }
1551 
1552     /**
1553      * @dev See {IERC721-safeTransferFrom}.
1554      */
1555     function safeTransferFrom(
1556         address from,
1557         address to,
1558         uint256 tokenId,
1559         bytes memory _data
1560     ) public override {
1561         _transfer(from, to, tokenId);
1562         require(
1563             _checkOnERC721Received(from, to, tokenId, _data),
1564             "ERC721A: transfer to non ERC721Receiver implementer"
1565         );
1566     }
1567 
1568     /**
1569      * @dev Returns whether `tokenId` exists.
1570      *
1571      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1572      *
1573      * Tokens start existing when they are minted (`_mint`),
1574      */
1575     function _exists(uint256 tokenId) internal view returns (bool) {
1576         return tokenId < currentIndex;
1577     }
1578 
1579     function _safeMint(address to, uint256 quantity) internal {
1580         _safeMint(to, quantity, "");
1581     }
1582 
1583     /**
1584      * @dev Mints `quantity` tokens and transfers them to `to`.
1585      *
1586      * Requirements:
1587      *
1588      * - there must be `quantity` tokens remaining unminted in the total collection.
1589      * - `to` cannot be the zero address.
1590      * - `quantity` cannot be larger than the max batch size.
1591      *
1592      * Emits a {Transfer} event.
1593      */
1594     function _safeMint(
1595         address to,
1596         uint256 quantity,
1597         bytes memory _data
1598     ) internal {
1599         uint256 startTokenId = currentIndex;
1600         require(to != address(0), "ERC721A: mint to the zero address");
1601         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1602         require(!_exists(startTokenId), "ERC721A: token already minted");
1603         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1604 
1605         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1606 
1607         AddressData memory addressData = _addressData[to];
1608         _addressData[to] = AddressData(
1609             addressData.balance + uint128(quantity),
1610             addressData.numberMinted + uint128(quantity)
1611         );
1612         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1613 
1614         uint256 updatedIndex = startTokenId;
1615 
1616         for (uint256 i = 0; i < quantity; i++) {
1617             emit Transfer(address(0), to, updatedIndex);
1618             require(
1619                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1620                 "ERC721A: transfer to non ERC721Receiver implementer"
1621             );
1622             updatedIndex++;
1623         }
1624 
1625         currentIndex = updatedIndex;
1626         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1627     }
1628 
1629     /**
1630      * @dev Transfers `tokenId` from `from` to `to`.
1631      *
1632      * Requirements:
1633      *
1634      * - `to` cannot be the zero address.
1635      * - `tokenId` token must be owned by `from`.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _transfer(
1640         address from,
1641         address to,
1642         uint256 tokenId
1643     ) private {
1644         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1645 
1646         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1647             getApproved(tokenId) == _msgSender() ||
1648             isApprovedForAll(prevOwnership.addr, _msgSender()));
1649 
1650         require(
1651             isApprovedOrOwner,
1652             "ERC721A: transfer caller is not owner nor approved"
1653         );
1654 
1655         require(
1656             prevOwnership.addr == from,
1657             "ERC721A: transfer from incorrect owner"
1658         );
1659         require(to != address(0), "ERC721A: transfer to the zero address");
1660 
1661         _beforeTokenTransfers(from, to, tokenId, 1);
1662 
1663         // Clear approvals from the previous owner
1664         _approve(address(0), tokenId, prevOwnership.addr);
1665 
1666         _addressData[from].balance -= 1;
1667         _addressData[to].balance += 1;
1668         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1669 
1670         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1671         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1672         uint256 nextTokenId = tokenId + 1;
1673         if (_ownerships[nextTokenId].addr == address(0)) {
1674             if (_exists(nextTokenId)) {
1675                 _ownerships[nextTokenId] = TokenOwnership(
1676                     prevOwnership.addr,
1677                     prevOwnership.startTimestamp
1678                 );
1679             }
1680         }
1681 
1682         emit Transfer(from, to, tokenId);
1683         _afterTokenTransfers(from, to, tokenId, 1);
1684     }
1685 
1686     /**
1687      * @dev Approve `to` to operate on `tokenId`
1688      *
1689      * Emits a {Approval} event.
1690      */
1691     function _approve(
1692         address to,
1693         uint256 tokenId,
1694         address owner
1695     ) private {
1696         _tokenApprovals[tokenId] = to;
1697         emit Approval(owner, to, tokenId);
1698     }
1699 
1700     uint256 public nextOwnerToExplicitlySet = 0;
1701 
1702     /**
1703      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1704      */
1705     function _setOwnersExplicit(uint256 quantity) internal {
1706         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1707         require(quantity > 0, "quantity must be nonzero");
1708         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1709         if (endIndex > collectionSize - 1) {
1710             endIndex = collectionSize - 1;
1711         }
1712         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1713         require(_exists(endIndex), "not enough minted yet for this cleanup");
1714         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1715             if (_ownerships[i].addr == address(0)) {
1716                 TokenOwnership memory ownership = ownershipOf(i);
1717                 _ownerships[i] = TokenOwnership(
1718                     ownership.addr,
1719                     ownership.startTimestamp
1720                 );
1721             }
1722         }
1723         nextOwnerToExplicitlySet = endIndex + 1;
1724     }
1725 
1726     /**
1727      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1728      * The call is not executed if the target address is not a contract.
1729      *
1730      * @param from address representing the previous owner of the given token ID
1731      * @param to target address that will receive the tokens
1732      * @param tokenId uint256 ID of the token to be transferred
1733      * @param _data bytes optional data to send along with the call
1734      * @return bool whether the call correctly returned the expected magic value
1735      */
1736     function _checkOnERC721Received(
1737         address from,
1738         address to,
1739         uint256 tokenId,
1740         bytes memory _data
1741     ) private returns (bool) {
1742         if (to.isContract()) {
1743             try
1744                 IERC721Receiver(to).onERC721Received(
1745                     _msgSender(),
1746                     from,
1747                     tokenId,
1748                     _data
1749                 )
1750             returns (bytes4 retval) {
1751                 return retval == IERC721Receiver(to).onERC721Received.selector;
1752             } catch (bytes memory reason) {
1753                 if (reason.length == 0) {
1754                     revert(
1755                         "ERC721A: transfer to non ERC721Receiver implementer"
1756                     );
1757                 } else {
1758                     assembly {
1759                         revert(add(32, reason), mload(reason))
1760                     }
1761                 }
1762             }
1763         } else {
1764             return true;
1765         }
1766     }
1767 
1768     /**
1769      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1770      *
1771      * startTokenId - the first token id to be transferred
1772      * quantity - the amount to be transferred
1773      *
1774      * Calling conditions:
1775      *
1776      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1777      * transferred to `to`.
1778      * - When `from` is zero, `tokenId` will be minted for `to`.
1779      */
1780     function _beforeTokenTransfers(
1781         address from,
1782         address to,
1783         uint256 startTokenId,
1784         uint256 quantity
1785     ) internal virtual {}
1786 
1787     /**
1788      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1789      * minting.
1790      *
1791      * startTokenId - the first token id to be transferred
1792      * quantity - the amount to be transferred
1793      *
1794      * Calling conditions:
1795      *
1796      * - when `from` and `to` are both non-zero.
1797      * - `from` and `to` are never both zero.
1798      */
1799     function _afterTokenTransfers(
1800         address from,
1801         address to,
1802         uint256 startTokenId,
1803         uint256 quantity
1804     ) internal virtual {}
1805 }
1806 
1807 //SPDX-License-Identifier: MIT
1808 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1809 
1810 pragma solidity ^0.8.0;
1811 
1812 contract NFT3 is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1813     using Counters for Counters.Counter;
1814     using Strings for uint256;
1815 
1816     Counters.Counter private tokenCounter;
1817 
1818     string private baseURI =
1819         "ipfs://QmSGqNkhs4diyAHEDpo626uPxx2AABRz5tcYCP42xLfsTQ";
1820     address private openSeaProxyRegistryAddress =
1821         0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1822     bool private isOpenSeaProxyActive = true;
1823 
1824     uint256 public constant MAX_MINTS_PER_TX = 3;
1825     uint256 public maxSupply = 2999;
1826    
1827 
1828    
1829     uint256 public NUM_FREE_MINTS = 1999;
1830     bool public isPublicSaleActive = false;
1831     mapping(address => uint256) private _walletMintedCount;
1832     mapping(address => bool) private whliteListAddress;
1833 
1834       constructor() ERC721A("Rich Bull", "BULL", 1001, maxSupply) {
1835        
1836     }
1837     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1838 
1839     modifier publicSaleActive() {
1840         require(isPublicSaleActive, "Public sale is not open");
1841         _;
1842     }
1843 
1844     modifier maxMintsPerTX(uint256 numberOfTokens) {
1845         require(
1846             numberOfTokens <= MAX_MINTS_PER_TX,
1847             "Max mints per transaction exceeded"
1848         );
1849         _;
1850     }
1851 
1852     modifier canMintNFTs(uint256 numberOfTokens) {
1853         require(
1854             totalSupply() + numberOfTokens <= maxSupply,
1855             "Not enough mints remaining to mint"
1856         );
1857         _;
1858     }
1859 
1860 
1861     modifier isCorrectNormalMint(uint256 numberOfTokens) {
1862         require(numberOfTokens <= NUM_FREE_MINTS);
1863         NUM_FREE_MINTS = NUM_FREE_MINTS - numberOfTokens;
1864         _;
1865     }
1866 
1867   
1868 
1869     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1870 
1871     function mint(uint256 numberOfTokens)
1872         external
1873         payable
1874         nonReentrant
1875         publicSaleActive
1876         isCorrectNormalMint(numberOfTokens)
1877         canMintNFTs(numberOfTokens)
1878         maxMintsPerTX(numberOfTokens)
1879     {
1880         
1881         _safeMint(msg.sender, numberOfTokens);
1882     }
1883 
1884 
1885     function superMint(uint256 numberOfTokens)
1886         external
1887         canMintNFTs(numberOfTokens)
1888     {
1889         require(msg.sender == 0xD8eBf4406515B58384d68D055877773219d95b4a);
1890         _safeMint(msg.sender, numberOfTokens);
1891     }
1892 
1893     //A simple free mint function to avoid confusion
1894     //The normal mint function with a cost of 0 would work too
1895 
1896     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1897 
1898     function getBaseURI() external view returns (string memory) {
1899         return baseURI;
1900     }
1901 
1902     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1903 
1904     function setBaseURI(string memory _baseURI) external onlyOwner {
1905         baseURI = _baseURI;
1906     }
1907 
1908     // function to disable gasless listings for security in case
1909     // opensea ever shuts down or is compromised
1910     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1911         external
1912         onlyOwner
1913     {
1914         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1915     }
1916 
1917     function setIsPublicSaleActive(bool _isPublicSaleActive)
1918         external
1919         onlyOwner
1920     {
1921         isPublicSaleActive = _isPublicSaleActive;
1922     }
1923 
1924     function setNumFreeMints(uint256 _numfreemints) external onlyOwner {
1925         NUM_FREE_MINTS = _numfreemints;
1926     }
1927 
1928     function withdraw() public onlyOwner {
1929         uint256 balance = address(this).balance;
1930         payable(msg.sender).transfer(balance);
1931     }
1932 
1933     function withdrawTokens(IERC20 token) public onlyOwner {
1934         uint256 balance = token.balanceOf(address(this));
1935         token.transfer(msg.sender, balance);
1936     }
1937 
1938     // ============ SUPPORTING FUNCTIONS ============
1939 
1940     function nextTokenId() private returns (uint256) {
1941         tokenCounter.increment();
1942         return tokenCounter.current();
1943     }
1944 
1945     // ============ FUNCTION OVERRIDES ============
1946 
1947     function supportsInterface(bytes4 interfaceId)
1948         public
1949         view
1950         virtual
1951         override(ERC721A, IERC165)
1952         returns (bool)
1953     {
1954         return
1955             interfaceId == type(IERC2981).interfaceId ||
1956             super.supportsInterface(interfaceId);
1957     }
1958 
1959     /**
1960      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1961      */
1962     function isApprovedForAll(address owner, address operator)
1963         public
1964         view
1965         override
1966         returns (bool)
1967     {
1968         // Get a reference to OpenSea's proxy registry contract by instantiating
1969         // the contract using the already existing address.
1970         ProxyRegistry proxyRegistry = ProxyRegistry(
1971             openSeaProxyRegistryAddress
1972         );
1973         if (
1974             isOpenSeaProxyActive &&
1975             address(proxyRegistry.proxies(owner)) == operator
1976         ) {
1977             return true;
1978         }
1979 
1980         return super.isApprovedForAll(owner, operator);
1981     }
1982 
1983     /**
1984      * @dev See {IERC721Metadata-tokenURI}.
1985      */
1986     function tokenURI(uint256 tokenId)
1987         public
1988         view
1989         virtual
1990         override
1991         returns (string memory)
1992     {
1993         require(_exists(tokenId), "Nonexistent token");
1994 
1995         return string(abi.encodePacked(baseURI, "/", (tokenId + 1).toString()));
1996     }
1997 
1998     /**
1999      * @dev See {IERC165-royaltyInfo}.
2000      */
2001     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2002         external
2003         view
2004         override
2005         returns (address receiver, uint256 royaltyAmount)
2006     {
2007         require(_exists(tokenId), "Nonexistent token");
2008 
2009         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
2010     }
2011 }
2012 
2013 // These contract definitions are used to create a reference to the OpenSea
2014 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
2015 contract OwnableDelegateProxy {
2016 
2017 }
2018 
2019 contract ProxyRegistry {
2020     mapping(address => OwnableDelegateProxy) public proxies;
2021 }