1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
48 
49 
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev Contract module that helps prevent reentrant calls to a function.
55  *
56  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
57  * available, which can be applied to functions to make sure there are no nested
58  * (reentrant) calls to them.
59  *
60  * Note that because there is a single `nonReentrant` guard, functions marked as
61  * `nonReentrant` may not call one another. This can be worked around by making
62  * those functions `private`, and then adding `external` `nonReentrant` entry
63  * points to them.
64  *
65  * TIP: If you would like to learn more about reentrancy and alternative ways
66  * to protect against it, check out our blog post
67  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
68  */
69 abstract contract ReentrancyGuard {
70     // Booleans are more expensive than uint256 or any type that takes up a full
71     // word because each write operation emits an extra SLOAD to first read the
72     // slot's contents, replace the bits taken up by the boolean, and then write
73     // back. This is the compiler's defense against contract upgrades and
74     // pointer aliasing, and it cannot be disabled.
75 
76     // The values being non-zero value makes deployment a bit more expensive,
77     // but in exchange the refund on every call to nonReentrant will be lower in
78     // amount. Since refunds are capped to a percentage of the total
79     // transaction's gas, it is best to keep them low in cases like this one, to
80     // increase the likelihood of the full refund coming into effect.
81     uint256 private constant _NOT_ENTERED = 1;
82     uint256 private constant _ENTERED = 2;
83 
84     uint256 private _status;
85 
86     constructor() {
87         _status = _NOT_ENTERED;
88     }
89 
90     /**
91      * @dev Prevents a contract from calling itself, directly or indirectly.
92      * Calling a `nonReentrant` function from another `nonReentrant`
93      * function is not supported. It is possible to prevent this from happening
94      * by making the `nonReentrant` function external, and make it call a
95      * `private` function that does the actual work.
96      */
97     modifier nonReentrant() {
98         // On the first call to nonReentrant, _notEntered will be true
99         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
100 
101         // Any calls to nonReentrant after this point will fail
102         _status = _ENTERED;
103 
104         _;
105 
106         // By storing the original value once again, a refund is triggered (see
107         // https://eips.ethereum.org/EIPS/eip-2200)
108         _status = _NOT_ENTERED;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
113 
114 
115 
116 pragma solidity ^0.8.0;
117 
118 // CAUTION
119 // This version of SafeMath should only be used with Solidity 0.8 or later,
120 // because it relies on the compiler's built in overflow checks.
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations.
124  *
125  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
126  * now has built in overflow checking.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             uint256 c = a + b;
137             if (c < a) return (false, 0);
138             return (true, c);
139         }
140     }
141 
142     /**
143      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             if (b > a) return (false, 0);
150             return (true, a - b);
151         }
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162             // benefit is lost if 'b' is also tested.
163             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164             if (a == 0) return (true, 0);
165             uint256 c = a * b;
166             if (c / a != b) return (false, 0);
167             return (true, c);
168         }
169     }
170 
171     /**
172      * @dev Returns the division of two unsigned integers, with a division by zero flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         unchecked {
178             if (b == 0) return (false, 0);
179             return (true, a / b);
180         }
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
185      *
186      * _Available since v3.4._
187      */
188     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
189         unchecked {
190             if (b == 0) return (false, 0);
191             return (true, a % b);
192         }
193     }
194 
195     /**
196      * @dev Returns the addition of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      *
203      * - Addition cannot overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a + b;
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      *
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a - b;
221     }
222 
223     /**
224      * @dev Returns the multiplication of two unsigned integers, reverting on
225      * overflow.
226      *
227      * Counterpart to Solidity's `*` operator.
228      *
229      * Requirements:
230      *
231      * - Multiplication cannot overflow.
232      */
233     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a * b;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers, reverting on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator.
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         return a / b;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * reverting when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a % b;
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
269      * overflow (when the result is negative).
270      *
271      * CAUTION: This function is deprecated because it requires allocating memory for the error
272      * message unnecessarily. For custom revert reasons use {trySub}.
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      *
278      * - Subtraction cannot overflow.
279      */
280     function sub(
281         uint256 a,
282         uint256 b,
283         string memory errorMessage
284     ) internal pure returns (uint256) {
285         unchecked {
286             require(b <= a, errorMessage);
287             return a - b;
288         }
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b > 0, errorMessage);
310             return a / b;
311         }
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * reverting with custom message when dividing by zero.
317      *
318      * CAUTION: This function is deprecated because it requires allocating memory for the error
319      * message unnecessarily. For custom revert reasons use {tryMod}.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      *
327      * - The divisor cannot be zero.
328      */
329     function mod(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a % b;
337         }
338     }
339 }
340 
341 // File: @openzeppelin/contracts/utils/Strings.sol
342 
343 
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev String operations.
349  */
350 library Strings {
351     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
352 
353     /**
354      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
355      */
356     function toString(uint256 value) internal pure returns (string memory) {
357         // Inspired by OraclizeAPI's implementation - MIT licence
358         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
359 
360         if (value == 0) {
361             return "0";
362         }
363         uint256 temp = value;
364         uint256 digits;
365         while (temp != 0) {
366             digits++;
367             temp /= 10;
368         }
369         bytes memory buffer = new bytes(digits);
370         while (value != 0) {
371             digits -= 1;
372             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
373             value /= 10;
374         }
375         return string(buffer);
376     }
377 
378     /**
379      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
380      */
381     function toHexString(uint256 value) internal pure returns (string memory) {
382         if (value == 0) {
383             return "0x00";
384         }
385         uint256 temp = value;
386         uint256 length = 0;
387         while (temp != 0) {
388             length++;
389             temp >>= 8;
390         }
391         return toHexString(value, length);
392     }
393 
394     /**
395      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
396      */
397     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
398         bytes memory buffer = new bytes(2 * length + 2);
399         buffer[0] = "0";
400         buffer[1] = "x";
401         for (uint256 i = 2 * length + 1; i > 1; --i) {
402             buffer[i] = _HEX_SYMBOLS[value & 0xf];
403             value >>= 4;
404         }
405         require(value == 0, "Strings: hex length insufficient");
406         return string(buffer);
407     }
408 }
409 
410 // File: @openzeppelin/contracts/utils/Context.sol
411 
412 
413 
414 pragma solidity ^0.8.0;
415 
416 /**
417  * @dev Provides information about the current execution context, including the
418  * sender of the transaction and its data. While these are generally available
419  * via msg.sender and msg.data, they should not be accessed in such a direct
420  * manner, since when dealing with meta-transactions the account sending and
421  * paying for execution may not be the actual sender (as far as an application
422  * is concerned).
423  *
424  * This contract is only required for intermediate, library-like contracts.
425  */
426 abstract contract Context {
427     function _msgSender() internal view virtual returns (address) {
428         return msg.sender;
429     }
430 
431     function _msgData() internal view virtual returns (bytes calldata) {
432         return msg.data;
433     }
434 }
435 
436 // File: @openzeppelin/contracts/security/Pausable.sol
437 
438 
439 
440 pragma solidity ^0.8.0;
441 
442 
443 /**
444  * @dev Contract module which allows children to implement an emergency stop
445  * mechanism that can be triggered by an authorized account.
446  *
447  * This module is used through inheritance. It will make available the
448  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
449  * the functions of your contract. Note that they will not be pausable by
450  * simply including this module, only once the modifiers are put in place.
451  */
452 abstract contract Pausable is Context {
453     /**
454      * @dev Emitted when the pause is triggered by `account`.
455      */
456     event Paused(address account);
457 
458     /**
459      * @dev Emitted when the pause is lifted by `account`.
460      */
461     event Unpaused(address account);
462 
463     bool private _paused;
464 
465     /**
466      * @dev Initializes the contract in unpaused state.
467      */
468     constructor() {
469         _paused = false;
470     }
471 
472     /**
473      * @dev Returns true if the contract is paused, and false otherwise.
474      */
475     function paused() public view virtual returns (bool) {
476         return _paused;
477     }
478 
479     /**
480      * @dev Modifier to make a function callable only when the contract is not paused.
481      *
482      * Requirements:
483      *
484      * - The contract must not be paused.
485      */
486     modifier whenNotPaused() {
487         require(!paused(), "Pausable: paused");
488         _;
489     }
490 
491     /**
492      * @dev Modifier to make a function callable only when the contract is paused.
493      *
494      * Requirements:
495      *
496      * - The contract must be paused.
497      */
498     modifier whenPaused() {
499         require(paused(), "Pausable: not paused");
500         _;
501     }
502 
503     /**
504      * @dev Triggers stopped state.
505      *
506      * Requirements:
507      *
508      * - The contract must not be paused.
509      */
510     function _pause() internal virtual whenNotPaused {
511         _paused = true;
512         emit Paused(_msgSender());
513     }
514 
515     /**
516      * @dev Returns to normal state.
517      *
518      * Requirements:
519      *
520      * - The contract must be paused.
521      */
522     function _unpause() internal virtual whenPaused {
523         _paused = false;
524         emit Unpaused(_msgSender());
525     }
526 }
527 
528 // File: @openzeppelin/contracts/access/Ownable.sol
529 
530 
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @dev Contract module which provides a basic access control mechanism, where
537  * there is an account (an owner) that can be granted exclusive access to
538  * specific functions.
539  *
540  * By default, the owner account will be the one that deploys the contract. This
541  * can later be changed with {transferOwnership}.
542  *
543  * This module is used through inheritance. It will make available the modifier
544  * `onlyOwner`, which can be applied to your functions to restrict their use to
545  * the owner.
546  */
547 abstract contract Ownable is Context {
548     address private _owner;
549 
550     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
551 
552     /**
553      * @dev Initializes the contract setting the deployer as the initial owner.
554      */
555     constructor() {
556         _setOwner(_msgSender());
557     }
558 
559     /**
560      * @dev Returns the address of the current owner.
561      */
562     function owner() public view virtual returns (address) {
563         return _owner;
564     }
565 
566     /**
567      * @dev Throws if called by any account other than the owner.
568      */
569     modifier onlyOwner() {
570         require(owner() == _msgSender(), "Ownable: caller is not the owner");
571         _;
572     }
573 
574     /**
575      * @dev Leaves the contract without owner. It will not be possible to call
576      * `onlyOwner` functions anymore. Can only be called by the current owner.
577      *
578      * NOTE: Renouncing ownership will leave the contract without an owner,
579      * thereby removing any functionality that is only available to the owner.
580      */
581     function renounceOwnership() public virtual onlyOwner {
582         _setOwner(address(0));
583     }
584 
585     /**
586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
587      * Can only be called by the current owner.
588      */
589     function transferOwnership(address newOwner) public virtual onlyOwner {
590         require(newOwner != address(0), "Ownable: new owner is the zero address");
591         _setOwner(newOwner);
592     }
593 
594     function _setOwner(address newOwner) private {
595         address oldOwner = _owner;
596         _owner = newOwner;
597         emit OwnershipTransferred(oldOwner, newOwner);
598     }
599 }
600 
601 // File: @openzeppelin/contracts/utils/Address.sol
602 
603 
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Collection of functions related to the address type
609  */
610 library Address {
611     /**
612      * @dev Returns true if `account` is a contract.
613      *
614      * [IMPORTANT]
615      * ====
616      * It is unsafe to assume that an address for which this function returns
617      * false is an externally-owned account (EOA) and not a contract.
618      *
619      * Among others, `isContract` will return false for the following
620      * types of addresses:
621      *
622      *  - an externally-owned account
623      *  - a contract in construction
624      *  - an address where a contract will be created
625      *  - an address where a contract lived, but was destroyed
626      * ====
627      */
628     function isContract(address account) internal view returns (bool) {
629         // This method relies on extcodesize, which returns 0 for contracts in
630         // construction, since the code is only stored at the end of the
631         // constructor execution.
632 
633         uint256 size;
634         assembly {
635             size := extcodesize(account)
636         }
637         return size > 0;
638     }
639 
640     /**
641      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
642      * `recipient`, forwarding all available gas and reverting on errors.
643      *
644      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
645      * of certain opcodes, possibly making contracts go over the 2300 gas limit
646      * imposed by `transfer`, making them unable to receive funds via
647      * `transfer`. {sendValue} removes this limitation.
648      *
649      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
650      *
651      * IMPORTANT: because control is transferred to `recipient`, care must be
652      * taken to not create reentrancy vulnerabilities. Consider using
653      * {ReentrancyGuard} or the
654      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
655      */
656     function sendValue(address payable recipient, uint256 amount) internal {
657         require(address(this).balance >= amount, "Address: insufficient balance");
658 
659         (bool success, ) = recipient.call{value: amount}("");
660         require(success, "Address: unable to send value, recipient may have reverted");
661     }
662 
663     /**
664      * @dev Performs a Solidity function call using a low level `call`. A
665      * plain `call` is an unsafe replacement for a function call: use this
666      * function instead.
667      *
668      * If `target` reverts with a revert reason, it is bubbled up by this
669      * function (like regular Solidity function calls).
670      *
671      * Returns the raw returned data. To convert to the expected return value,
672      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
673      *
674      * Requirements:
675      *
676      * - `target` must be a contract.
677      * - calling `target` with `data` must not revert.
678      *
679      * _Available since v3.1._
680      */
681     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
682         return functionCall(target, data, "Address: low-level call failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
687      * `errorMessage` as a fallback revert reason when `target` reverts.
688      *
689      * _Available since v3.1._
690      */
691     function functionCall(
692         address target,
693         bytes memory data,
694         string memory errorMessage
695     ) internal returns (bytes memory) {
696         return functionCallWithValue(target, data, 0, errorMessage);
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
701      * but also transferring `value` wei to `target`.
702      *
703      * Requirements:
704      *
705      * - the calling contract must have an ETH balance of at least `value`.
706      * - the called Solidity function must be `payable`.
707      *
708      * _Available since v3.1._
709      */
710     function functionCallWithValue(
711         address target,
712         bytes memory data,
713         uint256 value
714     ) internal returns (bytes memory) {
715         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
720      * with `errorMessage` as a fallback revert reason when `target` reverts.
721      *
722      * _Available since v3.1._
723      */
724     function functionCallWithValue(
725         address target,
726         bytes memory data,
727         uint256 value,
728         string memory errorMessage
729     ) internal returns (bytes memory) {
730         require(address(this).balance >= value, "Address: insufficient balance for call");
731         require(isContract(target), "Address: call to non-contract");
732 
733         (bool success, bytes memory returndata) = target.call{value: value}(data);
734         return verifyCallResult(success, returndata, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but performing a static call.
740      *
741      * _Available since v3.3._
742      */
743     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
744         return functionStaticCall(target, data, "Address: low-level static call failed");
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
749      * but performing a static call.
750      *
751      * _Available since v3.3._
752      */
753     function functionStaticCall(
754         address target,
755         bytes memory data,
756         string memory errorMessage
757     ) internal view returns (bytes memory) {
758         require(isContract(target), "Address: static call to non-contract");
759 
760         (bool success, bytes memory returndata) = target.staticcall(data);
761         return verifyCallResult(success, returndata, errorMessage);
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
766      * but performing a delegate call.
767      *
768      * _Available since v3.4._
769      */
770     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
771         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
776      * but performing a delegate call.
777      *
778      * _Available since v3.4._
779      */
780     function functionDelegateCall(
781         address target,
782         bytes memory data,
783         string memory errorMessage
784     ) internal returns (bytes memory) {
785         require(isContract(target), "Address: delegate call to non-contract");
786 
787         (bool success, bytes memory returndata) = target.delegatecall(data);
788         return verifyCallResult(success, returndata, errorMessage);
789     }
790 
791     /**
792      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
793      * revert reason using the provided one.
794      *
795      * _Available since v4.3._
796      */
797     function verifyCallResult(
798         bool success,
799         bytes memory returndata,
800         string memory errorMessage
801     ) internal pure returns (bytes memory) {
802         if (success) {
803             return returndata;
804         } else {
805             // Look for revert reason and bubble it up if present
806             if (returndata.length > 0) {
807                 // The easiest way to bubble the revert reason is using memory via assembly
808 
809                 assembly {
810                     let returndata_size := mload(returndata)
811                     revert(add(32, returndata), returndata_size)
812                 }
813             } else {
814                 revert(errorMessage);
815             }
816         }
817     }
818 }
819 
820 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
821 
822 
823 
824 pragma solidity ^0.8.0;
825 
826 
827 
828 
829 /**
830  * @title PaymentSplitter
831  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
832  * that the Ether will be split in this way, since it is handled transparently by the contract.
833  *
834  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
835  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
836  * an amount proportional to the percentage of total shares they were assigned.
837  *
838  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
839  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
840  * function.
841  */
842 contract PaymentSplitter is Context {
843     event PayeeAdded(address account, uint256 shares);
844     event PaymentReleased(address to, uint256 amount);
845     event PaymentReceived(address from, uint256 amount);
846 
847     uint256 private _totalShares;
848     uint256 private _totalReleased;
849 
850     mapping(address => uint256) private _shares;
851     mapping(address => uint256) private _released;
852     address[] private _payees;
853 
854     /**
855      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
856      * the matching position in the `shares` array.
857      *
858      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
859      * duplicates in `payees`.
860      */
861     constructor(address[] memory payees, uint256[] memory shares_) payable {
862         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
863         require(payees.length > 0, "PaymentSplitter: no payees");
864 
865         for (uint256 i = 0; i < payees.length; i++) {
866             _addPayee(payees[i], shares_[i]);
867         }
868     }
869 
870     /**
871      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
872      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
873      * reliability of the events, and not the actual splitting of Ether.
874      *
875      * To learn more about this see the Solidity documentation for
876      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
877      * functions].
878      */
879     receive() external payable virtual {
880         emit PaymentReceived(_msgSender(), msg.value);
881     }
882 
883     /**
884      * @dev Getter for the total shares held by payees.
885      */
886     function totalShares() public view returns (uint256) {
887         return _totalShares;
888     }
889 
890     /**
891      * @dev Getter for the total amount of Ether already released.
892      */
893     function totalReleased() public view returns (uint256) {
894         return _totalReleased;
895     }
896 
897     /**
898      * @dev Getter for the amount of shares held by an account.
899      */
900     function shares(address account) public view returns (uint256) {
901         return _shares[account];
902     }
903 
904     /**
905      * @dev Getter for the amount of Ether already released to a payee.
906      */
907     function released(address account) public view returns (uint256) {
908         return _released[account];
909     }
910 
911     /**
912      * @dev Getter for the address of the payee number `index`.
913      */
914     function payee(uint256 index) public view returns (address) {
915         return _payees[index];
916     }
917 
918     /**
919      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
920      * total shares and their previous withdrawals.
921      */
922     function release(address payable account) public virtual {
923         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
924 
925         uint256 totalReceived = address(this).balance + _totalReleased;
926         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
927 
928         require(payment != 0, "PaymentSplitter: account is not due payment");
929 
930         _released[account] = _released[account] + payment;
931         _totalReleased = _totalReleased + payment;
932 
933         Address.sendValue(account, payment);
934         emit PaymentReleased(account, payment);
935     }
936 
937     /**
938      * @dev Add a new payee to the contract.
939      * @param account The address of the payee to add.
940      * @param shares_ The number of shares owned by the payee.
941      */
942     function _addPayee(address account, uint256 shares_) private {
943         require(account != address(0), "PaymentSplitter: account is the zero address");
944         require(shares_ > 0, "PaymentSplitter: shares are 0");
945         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
946 
947         _payees.push(account);
948         _shares[account] = shares_;
949         _totalShares = _totalShares + shares_;
950         emit PayeeAdded(account, shares_);
951     }
952 }
953 
954 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
955 
956 
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @title ERC721 token receiver interface
962  * @dev Interface for any contract that wants to support safeTransfers
963  * from ERC721 asset contracts.
964  */
965 interface IERC721Receiver {
966     /**
967      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
968      * by `operator` from `from`, this function is called.
969      *
970      * It must return its Solidity selector to confirm the token transfer.
971      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
972      *
973      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
974      */
975     function onERC721Received(
976         address operator,
977         address from,
978         uint256 tokenId,
979         bytes calldata data
980     ) external returns (bytes4);
981 }
982 
983 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
984 
985 
986 
987 pragma solidity ^0.8.0;
988 
989 /**
990  * @dev Interface of the ERC165 standard, as defined in the
991  * https://eips.ethereum.org/EIPS/eip-165[EIP].
992  *
993  * Implementers can declare support of contract interfaces, which can then be
994  * queried by others ({ERC165Checker}).
995  *
996  * For an implementation, see {ERC165}.
997  */
998 interface IERC165 {
999     /**
1000      * @dev Returns true if this contract implements the interface defined by
1001      * `interfaceId`. See the corresponding
1002      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1003      * to learn more about how these ids are created.
1004      *
1005      * This function call must use less than 30 000 gas.
1006      */
1007     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1008 }
1009 
1010 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1011 
1012 
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 /**
1018  * @dev Implementation of the {IERC165} interface.
1019  *
1020  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1021  * for the additional interface id that will be supported. For example:
1022  *
1023  * ```solidity
1024  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1025  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1026  * }
1027  * ```
1028  *
1029  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1030  */
1031 abstract contract ERC165 is IERC165 {
1032     /**
1033      * @dev See {IERC165-supportsInterface}.
1034      */
1035     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1036         return interfaceId == type(IERC165).interfaceId;
1037     }
1038 }
1039 
1040 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1041 
1042 
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 
1047 /**
1048  * @dev Required interface of an ERC721 compliant contract.
1049  */
1050 interface IERC721 is IERC165 {
1051     /**
1052      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1053      */
1054     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1055 
1056     /**
1057      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1058      */
1059     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1060 
1061     /**
1062      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1063      */
1064     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1065 
1066     /**
1067      * @dev Returns the number of tokens in ``owner``'s account.
1068      */
1069     function balanceOf(address owner) external view returns (uint256 balance);
1070 
1071     /**
1072      * @dev Returns the owner of the `tokenId` token.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      */
1078     function ownerOf(uint256 tokenId) external view returns (address owner);
1079 
1080     /**
1081      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1082      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1083      *
1084      * Requirements:
1085      *
1086      * - `from` cannot be the zero address.
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must exist and be owned by `from`.
1089      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1090      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) external;
1099 
1100     /**
1101      * @dev Transfers `tokenId` token from `from` to `to`.
1102      *
1103      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1104      *
1105      * Requirements:
1106      *
1107      * - `from` cannot be the zero address.
1108      * - `to` cannot be the zero address.
1109      * - `tokenId` token must be owned by `from`.
1110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function transferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) external;
1119 
1120     /**
1121      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1122      * The approval is cleared when the token is transferred.
1123      *
1124      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1125      *
1126      * Requirements:
1127      *
1128      * - The caller must own the token or be an approved operator.
1129      * - `tokenId` must exist.
1130      *
1131      * Emits an {Approval} event.
1132      */
1133     function approve(address to, uint256 tokenId) external;
1134 
1135     /**
1136      * @dev Returns the account approved for `tokenId` token.
1137      *
1138      * Requirements:
1139      *
1140      * - `tokenId` must exist.
1141      */
1142     function getApproved(uint256 tokenId) external view returns (address operator);
1143 
1144     /**
1145      * @dev Approve or remove `operator` as an operator for the caller.
1146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1147      *
1148      * Requirements:
1149      *
1150      * - The `operator` cannot be the caller.
1151      *
1152      * Emits an {ApprovalForAll} event.
1153      */
1154     function setApprovalForAll(address operator, bool _approved) external;
1155 
1156     /**
1157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1158      *
1159      * See {setApprovalForAll}
1160      */
1161     function isApprovedForAll(address owner, address operator) external view returns (bool);
1162 
1163     /**
1164      * @dev Safely transfers `tokenId` token from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `from` cannot be the zero address.
1169      * - `to` cannot be the zero address.
1170      * - `tokenId` token must exist and be owned by `from`.
1171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function safeTransferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId,
1180         bytes calldata data
1181     ) external;
1182 }
1183 
1184 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1185 
1186 
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 
1191 /**
1192  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1193  * @dev See https://eips.ethereum.org/EIPS/eip-721
1194  */
1195 interface IERC721Enumerable is IERC721 {
1196     /**
1197      * @dev Returns the total amount of tokens stored by the contract.
1198      */
1199     function totalSupply() external view returns (uint256);
1200 
1201     /**
1202      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1203      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1204      */
1205     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1206 
1207     /**
1208      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1209      * Use along with {totalSupply} to enumerate all tokens.
1210      */
1211     function tokenByIndex(uint256 index) external view returns (uint256);
1212 }
1213 
1214 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1215 
1216 
1217 
1218 pragma solidity ^0.8.0;
1219 
1220 
1221 /**
1222  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1223  * @dev See https://eips.ethereum.org/EIPS/eip-721
1224  */
1225 interface IERC721Metadata is IERC721 {
1226     /**
1227      * @dev Returns the token collection name.
1228      */
1229     function name() external view returns (string memory);
1230 
1231     /**
1232      * @dev Returns the token collection symbol.
1233      */
1234     function symbol() external view returns (string memory);
1235 
1236     /**
1237      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1238      */
1239     function tokenURI(uint256 tokenId) external view returns (string memory);
1240 }
1241 
1242 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1243 
1244 
1245 
1246 pragma solidity ^0.8.0;
1247 
1248 
1249 
1250 
1251 
1252 
1253 
1254 
1255 /**
1256  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1257  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1258  * {ERC721Enumerable}.
1259  */
1260 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1261     using Address for address;
1262     using Strings for uint256;
1263 
1264     // Token name
1265     string private _name;
1266 
1267     // Token symbol
1268     string private _symbol;
1269 
1270     // Mapping from token ID to owner address
1271     mapping(uint256 => address) private _owners;
1272 
1273     // Mapping owner address to token count
1274     mapping(address => uint256) private _balances;
1275 
1276     // Mapping from token ID to approved address
1277     mapping(uint256 => address) private _tokenApprovals;
1278 
1279     // Mapping from owner to operator approvals
1280     mapping(address => mapping(address => bool)) private _operatorApprovals;
1281 
1282     /**
1283      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1284      */
1285     constructor(string memory name_, string memory symbol_) {
1286         _name = name_;
1287         _symbol = symbol_;
1288     }
1289 
1290     /**
1291      * @dev See {IERC165-supportsInterface}.
1292      */
1293     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1294         return
1295             interfaceId == type(IERC721).interfaceId ||
1296             interfaceId == type(IERC721Metadata).interfaceId ||
1297             super.supportsInterface(interfaceId);
1298     }
1299 
1300     /**
1301      * @dev See {IERC721-balanceOf}.
1302      */
1303     function balanceOf(address owner) public view virtual override returns (uint256) {
1304         require(owner != address(0), "ERC721: balance query for the zero address");
1305         return _balances[owner];
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-ownerOf}.
1310      */
1311     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1312         address owner = _owners[tokenId];
1313         require(owner != address(0), "ERC721: owner query for nonexistent token");
1314         return owner;
1315     }
1316 
1317     /**
1318      * @dev See {IERC721Metadata-name}.
1319      */
1320     function name() public view virtual override returns (string memory) {
1321         return _name;
1322     }
1323 
1324     /**
1325      * @dev See {IERC721Metadata-symbol}.
1326      */
1327     function symbol() public view virtual override returns (string memory) {
1328         return _symbol;
1329     }
1330 
1331     /**
1332      * @dev See {IERC721Metadata-tokenURI}.
1333      */
1334     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1335         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1336 
1337         string memory baseURI = _baseURI();
1338         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1339     }
1340 
1341     /**
1342      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1343      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1344      * by default, can be overriden in child contracts.
1345      */
1346     function _baseURI() internal view virtual returns (string memory) {
1347         return "";
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-approve}.
1352      */
1353     function approve(address to, uint256 tokenId) public virtual override {
1354         address owner = ERC721.ownerOf(tokenId);
1355         require(to != owner, "ERC721: approval to current owner");
1356 
1357         require(
1358             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1359             "ERC721: approve caller is not owner nor approved for all"
1360         );
1361 
1362         _approve(to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-getApproved}.
1367      */
1368     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1369         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1370 
1371         return _tokenApprovals[tokenId];
1372     }
1373 
1374     /**
1375      * @dev See {IERC721-setApprovalForAll}.
1376      */
1377     function setApprovalForAll(address operator, bool approved) public virtual override {
1378         require(operator != _msgSender(), "ERC721: approve to caller");
1379 
1380         _operatorApprovals[_msgSender()][operator] = approved;
1381         emit ApprovalForAll(_msgSender(), operator, approved);
1382     }
1383 
1384     /**
1385      * @dev See {IERC721-isApprovedForAll}.
1386      */
1387     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1388         return _operatorApprovals[owner][operator];
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-transferFrom}.
1393      */
1394     function transferFrom(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) public virtual override {
1399         //solhint-disable-next-line max-line-length
1400         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1401 
1402         _transfer(from, to, tokenId);
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-safeTransferFrom}.
1407      */
1408     function safeTransferFrom(
1409         address from,
1410         address to,
1411         uint256 tokenId
1412     ) public virtual override {
1413         safeTransferFrom(from, to, tokenId, "");
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-safeTransferFrom}.
1418      */
1419     function safeTransferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId,
1423         bytes memory _data
1424     ) public virtual override {
1425         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1426         _safeTransfer(from, to, tokenId, _data);
1427     }
1428 
1429     /**
1430      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1431      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1432      *
1433      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1434      *
1435      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1436      * implement alternative mechanisms to perform token transfer, such as signature-based.
1437      *
1438      * Requirements:
1439      *
1440      * - `from` cannot be the zero address.
1441      * - `to` cannot be the zero address.
1442      * - `tokenId` token must exist and be owned by `from`.
1443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1444      *
1445      * Emits a {Transfer} event.
1446      */
1447     function _safeTransfer(
1448         address from,
1449         address to,
1450         uint256 tokenId,
1451         bytes memory _data
1452     ) internal virtual {
1453         _transfer(from, to, tokenId);
1454         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1455     }
1456 
1457     /**
1458      * @dev Returns whether `tokenId` exists.
1459      *
1460      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1461      *
1462      * Tokens start existing when they are minted (`_mint`),
1463      * and stop existing when they are burned (`_burn`).
1464      */
1465     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1466         return _owners[tokenId] != address(0);
1467     }
1468 
1469     /**
1470      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1471      *
1472      * Requirements:
1473      *
1474      * - `tokenId` must exist.
1475      */
1476     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1477         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1478         address owner = ERC721.ownerOf(tokenId);
1479         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1480     }
1481 
1482     /**
1483      * @dev Safely mints `tokenId` and transfers it to `to`.
1484      *
1485      * Requirements:
1486      *
1487      * - `tokenId` must not exist.
1488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _safeMint(address to, uint256 tokenId) internal virtual {
1493         _safeMint(to, tokenId, "");
1494     }
1495 
1496     /**
1497      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1498      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1499      */
1500     function _safeMint(
1501         address to,
1502         uint256 tokenId,
1503         bytes memory _data
1504     ) internal virtual {
1505         _mint(to, tokenId);
1506         require(
1507             _checkOnERC721Received(address(0), to, tokenId, _data),
1508             "ERC721: transfer to non ERC721Receiver implementer"
1509         );
1510     }
1511 
1512     /**
1513      * @dev Mints `tokenId` and transfers it to `to`.
1514      *
1515      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1516      *
1517      * Requirements:
1518      *
1519      * - `tokenId` must not exist.
1520      * - `to` cannot be the zero address.
1521      *
1522      * Emits a {Transfer} event.
1523      */
1524     function _mint(address to, uint256 tokenId) internal virtual {
1525         require(to != address(0), "ERC721: mint to the zero address");
1526         require(!_exists(tokenId), "ERC721: token already minted");
1527 
1528         _beforeTokenTransfer(address(0), to, tokenId);
1529 
1530         _balances[to] += 1;
1531         _owners[tokenId] = to;
1532 
1533         emit Transfer(address(0), to, tokenId);
1534     }
1535 
1536     /**
1537      * @dev Destroys `tokenId`.
1538      * The approval is cleared when the token is burned.
1539      *
1540      * Requirements:
1541      *
1542      * - `tokenId` must exist.
1543      *
1544      * Emits a {Transfer} event.
1545      */
1546     function _burn(uint256 tokenId) internal virtual {
1547         address owner = ERC721.ownerOf(tokenId);
1548 
1549         _beforeTokenTransfer(owner, address(0), tokenId);
1550 
1551         // Clear approvals
1552         _approve(address(0), tokenId);
1553 
1554         _balances[owner] -= 1;
1555         delete _owners[tokenId];
1556 
1557         emit Transfer(owner, address(0), tokenId);
1558     }
1559 
1560     /**
1561      * @dev Transfers `tokenId` from `from` to `to`.
1562      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1563      *
1564      * Requirements:
1565      *
1566      * - `to` cannot be the zero address.
1567      * - `tokenId` token must be owned by `from`.
1568      *
1569      * Emits a {Transfer} event.
1570      */
1571     function _transfer(
1572         address from,
1573         address to,
1574         uint256 tokenId
1575     ) internal virtual {
1576         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1577         require(to != address(0), "ERC721: transfer to the zero address");
1578 
1579         _beforeTokenTransfer(from, to, tokenId);
1580 
1581         // Clear approvals from the previous owner
1582         _approve(address(0), tokenId);
1583 
1584         _balances[from] -= 1;
1585         _balances[to] += 1;
1586         _owners[tokenId] = to;
1587 
1588         emit Transfer(from, to, tokenId);
1589     }
1590 
1591     /**
1592      * @dev Approve `to` to operate on `tokenId`
1593      *
1594      * Emits a {Approval} event.
1595      */
1596     function _approve(address to, uint256 tokenId) internal virtual {
1597         _tokenApprovals[tokenId] = to;
1598         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1599     }
1600 
1601     /**
1602      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1603      * The call is not executed if the target address is not a contract.
1604      *
1605      * @param from address representing the previous owner of the given token ID
1606      * @param to target address that will receive the tokens
1607      * @param tokenId uint256 ID of the token to be transferred
1608      * @param _data bytes optional data to send along with the call
1609      * @return bool whether the call correctly returned the expected magic value
1610      */
1611     function _checkOnERC721Received(
1612         address from,
1613         address to,
1614         uint256 tokenId,
1615         bytes memory _data
1616     ) private returns (bool) {
1617         if (to.isContract()) {
1618             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1619                 return retval == IERC721Receiver.onERC721Received.selector;
1620             } catch (bytes memory reason) {
1621                 if (reason.length == 0) {
1622                     revert("ERC721: transfer to non ERC721Receiver implementer");
1623                 } else {
1624                     assembly {
1625                         revert(add(32, reason), mload(reason))
1626                     }
1627                 }
1628             }
1629         } else {
1630             return true;
1631         }
1632     }
1633 
1634     /**
1635      * @dev Hook that is called before any token transfer. This includes minting
1636      * and burning.
1637      *
1638      * Calling conditions:
1639      *
1640      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1641      * transferred to `to`.
1642      * - When `from` is zero, `tokenId` will be minted for `to`.
1643      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1644      * - `from` and `to` are never both zero.
1645      *
1646      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1647      */
1648     function _beforeTokenTransfer(
1649         address from,
1650         address to,
1651         uint256 tokenId
1652     ) internal virtual {}
1653 }
1654 
1655 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1656 
1657 
1658 
1659 pragma solidity ^0.8.0;
1660 
1661 
1662 /**
1663  * @dev ERC721 token with storage based token URI management.
1664  */
1665 abstract contract ERC721URIStorage is ERC721 {
1666     using Strings for uint256;
1667 
1668     // Optional mapping for token URIs
1669     mapping(uint256 => string) private _tokenURIs;
1670 
1671     /**
1672      * @dev See {IERC721Metadata-tokenURI}.
1673      */
1674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1675         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1676 
1677         string memory _tokenURI = _tokenURIs[tokenId];
1678         string memory base = _baseURI();
1679 
1680         // If there is no base URI, return the token URI.
1681         if (bytes(base).length == 0) {
1682             return _tokenURI;
1683         }
1684         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1685         if (bytes(_tokenURI).length > 0) {
1686             return string(abi.encodePacked(base, _tokenURI));
1687         }
1688 
1689         return super.tokenURI(tokenId);
1690     }
1691 
1692     /**
1693      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1694      *
1695      * Requirements:
1696      *
1697      * - `tokenId` must exist.
1698      */
1699     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1700         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1701         _tokenURIs[tokenId] = _tokenURI;
1702     }
1703 
1704     /**
1705      * @dev Destroys `tokenId`.
1706      * The approval is cleared when the token is burned.
1707      *
1708      * Requirements:
1709      *
1710      * - `tokenId` must exist.
1711      *
1712      * Emits a {Transfer} event.
1713      */
1714     function _burn(uint256 tokenId) internal virtual override {
1715         super._burn(tokenId);
1716 
1717         if (bytes(_tokenURIs[tokenId]).length != 0) {
1718             delete _tokenURIs[tokenId];
1719         }
1720     }
1721 }
1722 
1723 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1724 
1725 
1726 
1727 pragma solidity ^0.8.0;
1728 
1729 
1730 
1731 /**
1732  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1733  * enumerability of all the token ids in the contract as well as all token ids owned by each
1734  * account.
1735  */
1736 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1737     // Mapping from owner to list of owned token IDs
1738     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1739 
1740     // Mapping from token ID to index of the owner tokens list
1741     mapping(uint256 => uint256) private _ownedTokensIndex;
1742 
1743     // Array with all token ids, used for enumeration
1744     uint256[] private _allTokens;
1745 
1746     // Mapping from token id to position in the allTokens array
1747     mapping(uint256 => uint256) private _allTokensIndex;
1748 
1749     /**
1750      * @dev See {IERC165-supportsInterface}.
1751      */
1752     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1753         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1754     }
1755 
1756     /**
1757      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1758      */
1759     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1760         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1761         return _ownedTokens[owner][index];
1762     }
1763 
1764     /**
1765      * @dev See {IERC721Enumerable-totalSupply}.
1766      */
1767     function totalSupply() public view virtual override returns (uint256) {
1768         return _allTokens.length;
1769     }
1770 
1771     /**
1772      * @dev See {IERC721Enumerable-tokenByIndex}.
1773      */
1774     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1775         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1776         return _allTokens[index];
1777     }
1778 
1779     /**
1780      * @dev Hook that is called before any token transfer. This includes minting
1781      * and burning.
1782      *
1783      * Calling conditions:
1784      *
1785      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1786      * transferred to `to`.
1787      * - When `from` is zero, `tokenId` will be minted for `to`.
1788      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1789      * - `from` cannot be the zero address.
1790      * - `to` cannot be the zero address.
1791      *
1792      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1793      */
1794     function _beforeTokenTransfer(
1795         address from,
1796         address to,
1797         uint256 tokenId
1798     ) internal virtual override {
1799         super._beforeTokenTransfer(from, to, tokenId);
1800 
1801         if (from == address(0)) {
1802             _addTokenToAllTokensEnumeration(tokenId);
1803         } else if (from != to) {
1804             _removeTokenFromOwnerEnumeration(from, tokenId);
1805         }
1806         if (to == address(0)) {
1807             _removeTokenFromAllTokensEnumeration(tokenId);
1808         } else if (to != from) {
1809             _addTokenToOwnerEnumeration(to, tokenId);
1810         }
1811     }
1812 
1813     /**
1814      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1815      * @param to address representing the new owner of the given token ID
1816      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1817      */
1818     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1819         uint256 length = ERC721.balanceOf(to);
1820         _ownedTokens[to][length] = tokenId;
1821         _ownedTokensIndex[tokenId] = length;
1822     }
1823 
1824     /**
1825      * @dev Private function to add a token to this extension's token tracking data structures.
1826      * @param tokenId uint256 ID of the token to be added to the tokens list
1827      */
1828     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1829         _allTokensIndex[tokenId] = _allTokens.length;
1830         _allTokens.push(tokenId);
1831     }
1832 
1833     /**
1834      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1835      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1836      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1837      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1838      * @param from address representing the previous owner of the given token ID
1839      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1840      */
1841     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1842         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1843         // then delete the last slot (swap and pop).
1844 
1845         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1846         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1847 
1848         // When the token to delete is the last token, the swap operation is unnecessary
1849         if (tokenIndex != lastTokenIndex) {
1850             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1851 
1852             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1853             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1854         }
1855 
1856         // This also deletes the contents at the last position of the array
1857         delete _ownedTokensIndex[tokenId];
1858         delete _ownedTokens[from][lastTokenIndex];
1859     }
1860 
1861     /**
1862      * @dev Private function to remove a token from this extension's token tracking data structures.
1863      * This has O(1) time complexity, but alters the order of the _allTokens array.
1864      * @param tokenId uint256 ID of the token to be removed from the tokens list
1865      */
1866     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1867         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1868         // then delete the last slot (swap and pop).
1869 
1870         uint256 lastTokenIndex = _allTokens.length - 1;
1871         uint256 tokenIndex = _allTokensIndex[tokenId];
1872 
1873         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1874         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1875         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1876         uint256 lastTokenId = _allTokens[lastTokenIndex];
1877 
1878         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1879         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1880 
1881         // This also deletes the contents at the last position of the array
1882         delete _allTokensIndex[tokenId];
1883         _allTokens.pop();
1884     }
1885 }
1886 
1887 // File: @chainlink/contracts/src/v0.8/VRFRequestIDBase.sol
1888 
1889 
1890 pragma solidity ^0.8.0;
1891 
1892 contract VRFRequestIDBase {
1893 
1894   /**
1895    * @notice returns the seed which is actually input to the VRF coordinator
1896    *
1897    * @dev To prevent repetition of VRF output due to repetition of the
1898    * @dev user-supplied seed, that seed is combined in a hash with the
1899    * @dev user-specific nonce, and the address of the consuming contract. The
1900    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
1901    * @dev the final seed, but the nonce does protect against repetition in
1902    * @dev requests which are included in a single block.
1903    *
1904    * @param _userSeed VRF seed input provided by user
1905    * @param _requester Address of the requesting contract
1906    * @param _nonce User-specific nonce at the time of the request
1907    */
1908   function makeVRFInputSeed(
1909     bytes32 _keyHash,
1910     uint256 _userSeed,
1911     address _requester,
1912     uint256 _nonce
1913   )
1914     internal
1915     pure
1916     returns (
1917       uint256
1918     )
1919   {
1920     return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
1921   }
1922 
1923   /**
1924    * @notice Returns the id for this request
1925    * @param _keyHash The serviceAgreement ID to be used for this request
1926    * @param _vRFInputSeed The seed to be passed directly to the VRF
1927    * @return The id for this request
1928    *
1929    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
1930    * @dev contract, but the one generated by makeVRFInputSeed
1931    */
1932   function makeRequestId(
1933     bytes32 _keyHash,
1934     uint256 _vRFInputSeed
1935   )
1936     internal
1937     pure
1938     returns (
1939       bytes32
1940     )
1941   {
1942     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
1943   }
1944 }
1945 // File: @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol
1946 
1947 
1948 pragma solidity ^0.8.0;
1949 
1950 interface LinkTokenInterface {
1951 
1952   function allowance(
1953     address owner,
1954     address spender
1955   )
1956     external
1957     view
1958     returns (
1959       uint256 remaining
1960     );
1961 
1962   function approve(
1963     address spender,
1964     uint256 value
1965   )
1966     external
1967     returns (
1968       bool success
1969     );
1970 
1971   function balanceOf(
1972     address owner
1973   )
1974     external
1975     view
1976     returns (
1977       uint256 balance
1978     );
1979 
1980   function decimals()
1981     external
1982     view
1983     returns (
1984       uint8 decimalPlaces
1985     );
1986 
1987   function decreaseApproval(
1988     address spender,
1989     uint256 addedValue
1990   )
1991     external
1992     returns (
1993       bool success
1994     );
1995 
1996   function increaseApproval(
1997     address spender,
1998     uint256 subtractedValue
1999   ) external;
2000 
2001   function name()
2002     external
2003     view
2004     returns (
2005       string memory tokenName
2006     );
2007 
2008   function symbol()
2009     external
2010     view
2011     returns (
2012       string memory tokenSymbol
2013     );
2014 
2015   function totalSupply()
2016     external
2017     view
2018     returns (
2019       uint256 totalTokensIssued
2020     );
2021 
2022   function transfer(
2023     address to,
2024     uint256 value
2025   )
2026     external
2027     returns (
2028       bool success
2029     );
2030 
2031   function transferAndCall(
2032     address to,
2033     uint256 value,
2034     bytes calldata data
2035   )
2036     external
2037     returns (
2038       bool success
2039     );
2040 
2041   function transferFrom(
2042     address from,
2043     address to,
2044     uint256 value
2045   )
2046     external
2047     returns (
2048       bool success
2049     );
2050 
2051 }
2052 
2053 // File: @chainlink/contracts/src/v0.8/VRFConsumerBase.sol
2054 
2055 
2056 pragma solidity ^0.8.0;
2057 
2058 
2059 
2060 /** ****************************************************************************
2061  * @notice Interface for contracts using VRF randomness
2062  * *****************************************************************************
2063  * @dev PURPOSE
2064  *
2065  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
2066  * @dev to Vera the verifier in such a way that Vera can be sure he's not
2067  * @dev making his output up to suit himself. Reggie provides Vera a public key
2068  * @dev to which he knows the secret key. Each time Vera provides a seed to
2069  * @dev Reggie, he gives back a value which is computed completely
2070  * @dev deterministically from the seed and the secret key.
2071  *
2072  * @dev Reggie provides a proof by which Vera can verify that the output was
2073  * @dev correctly computed once Reggie tells it to her, but without that proof,
2074  * @dev the output is indistinguishable to her from a uniform random sample
2075  * @dev from the output space.
2076  *
2077  * @dev The purpose of this contract is to make it easy for unrelated contracts
2078  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
2079  * @dev simple access to a verifiable source of randomness.
2080  * *****************************************************************************
2081  * @dev USAGE
2082  *
2083  * @dev Calling contracts must inherit from VRFConsumerBase, and can
2084  * @dev initialize VRFConsumerBase's attributes in their constructor as
2085  * @dev shown:
2086  *
2087  * @dev   contract VRFConsumer {
2088  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
2089  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
2090  * @dev         <initialization with other arguments goes here>
2091  * @dev       }
2092  * @dev   }
2093  *
2094  * @dev The oracle will have given you an ID for the VRF keypair they have
2095  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
2096  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
2097  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
2098  * @dev want to generate randomness from.
2099  *
2100  * @dev Once the VRFCoordinator has received and validated the oracle's response
2101  * @dev to your request, it will call your contract's fulfillRandomness method.
2102  *
2103  * @dev The randomness argument to fulfillRandomness is the actual random value
2104  * @dev generated from your seed.
2105  *
2106  * @dev The requestId argument is generated from the keyHash and the seed by
2107  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
2108  * @dev requests open, you can use the requestId to track which seed is
2109  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
2110  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
2111  * @dev if your contract could have multiple requests in flight simultaneously.)
2112  *
2113  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
2114  * @dev differ. (Which is critical to making unpredictable randomness! See the
2115  * @dev next section.)
2116  *
2117  * *****************************************************************************
2118  * @dev SECURITY CONSIDERATIONS
2119  *
2120  * @dev A method with the ability to call your fulfillRandomness method directly
2121  * @dev could spoof a VRF response with any random value, so it's critical that
2122  * @dev it cannot be directly called by anything other than this base contract
2123  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
2124  *
2125  * @dev For your users to trust that your contract's random behavior is free
2126  * @dev from malicious interference, it's best if you can write it so that all
2127  * @dev behaviors implied by a VRF response are executed *during* your
2128  * @dev fulfillRandomness method. If your contract must store the response (or
2129  * @dev anything derived from it) and use it later, you must ensure that any
2130  * @dev user-significant behavior which depends on that stored value cannot be
2131  * @dev manipulated by a subsequent VRF request.
2132  *
2133  * @dev Similarly, both miners and the VRF oracle itself have some influence
2134  * @dev over the order in which VRF responses appear on the blockchain, so if
2135  * @dev your contract could have multiple VRF requests in flight simultaneously,
2136  * @dev you must ensure that the order in which the VRF responses arrive cannot
2137  * @dev be used to manipulate your contract's user-significant behavior.
2138  *
2139  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
2140  * @dev block in which the request is made, user-provided seeds have no impact
2141  * @dev on its economic security properties. They are only included for API
2142  * @dev compatability with previous versions of this contract.
2143  *
2144  * @dev Since the block hash of the block which contains the requestRandomness
2145  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
2146  * @dev miner could, in principle, fork the blockchain to evict the block
2147  * @dev containing the request, forcing the request to be included in a
2148  * @dev different block with a different hash, and therefore a different input
2149  * @dev to the VRF. However, such an attack would incur a substantial economic
2150  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
2151  * @dev until it calls responds to a request.
2152  */
2153 abstract contract VRFConsumerBase is VRFRequestIDBase {
2154 
2155   /**
2156    * @notice fulfillRandomness handles the VRF response. Your contract must
2157    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
2158    * @notice principles to keep in mind when implementing your fulfillRandomness
2159    * @notice method.
2160    *
2161    * @dev VRFConsumerBase expects its subcontracts to have a method with this
2162    * @dev signature, and will call it once it has verified the proof
2163    * @dev associated with the randomness. (It is triggered via a call to
2164    * @dev rawFulfillRandomness, below.)
2165    *
2166    * @param requestId The Id initially returned by requestRandomness
2167    * @param randomness the VRF output
2168    */
2169   function fulfillRandomness(
2170     bytes32 requestId,
2171     uint256 randomness
2172   )
2173     internal
2174     virtual;
2175 
2176   /**
2177    * @dev In order to keep backwards compatibility we have kept the user
2178    * seed field around. We remove the use of it because given that the blockhash
2179    * enters later, it overrides whatever randomness the used seed provides.
2180    * Given that it adds no security, and can easily lead to misunderstandings,
2181    * we have removed it from usage and can now provide a simpler API.
2182    */
2183   uint256 constant private USER_SEED_PLACEHOLDER = 0;
2184 
2185   /**
2186    * @notice requestRandomness initiates a request for VRF output given _seed
2187    *
2188    * @dev The fulfillRandomness method receives the output, once it's provided
2189    * @dev by the Oracle, and verified by the vrfCoordinator.
2190    *
2191    * @dev The _keyHash must already be registered with the VRFCoordinator, and
2192    * @dev the _fee must exceed the fee specified during registration of the
2193    * @dev _keyHash.
2194    *
2195    * @dev The _seed parameter is vestigial, and is kept only for API
2196    * @dev compatibility with older versions. It can't *hurt* to mix in some of
2197    * @dev your own randomness, here, but it's not necessary because the VRF
2198    * @dev oracle will mix the hash of the block containing your request into the
2199    * @dev VRF seed it ultimately uses.
2200    *
2201    * @param _keyHash ID of public key against which randomness is generated
2202    * @param _fee The amount of LINK to send with the request
2203    *
2204    * @return requestId unique ID for this request
2205    *
2206    * @dev The returned requestId can be used to distinguish responses to
2207    * @dev concurrent requests. It is passed as the first argument to
2208    * @dev fulfillRandomness.
2209    */
2210   function requestRandomness(
2211     bytes32 _keyHash,
2212     uint256 _fee
2213   )
2214     internal
2215     returns (
2216       bytes32 requestId
2217     )
2218   {
2219     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
2220     // This is the seed passed to VRFCoordinator. The oracle will mix this with
2221     // the hash of the block containing this request to obtain the seed/input
2222     // which is finally passed to the VRF cryptographic machinery.
2223     uint256 vRFSeed  = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
2224     // nonces[_keyHash] must stay in sync with
2225     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
2226     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
2227     // This provides protection against the user repeating their input seed,
2228     // which would result in a predictable/duplicate output, if multiple such
2229     // requests appeared in the same block.
2230     nonces[_keyHash] = nonces[_keyHash] + 1;
2231     return makeRequestId(_keyHash, vRFSeed);
2232   }
2233 
2234   LinkTokenInterface immutable internal LINK;
2235   address immutable private vrfCoordinator;
2236 
2237   // Nonces for each VRF key from which randomness has been requested.
2238   //
2239   // Must stay in sync with VRFCoordinator[_keyHash][this]
2240   mapping(bytes32 /* keyHash */ => uint256 /* nonce */) private nonces;
2241 
2242   /**
2243    * @param _vrfCoordinator address of VRFCoordinator contract
2244    * @param _link address of LINK token contract
2245    *
2246    * @dev https://docs.chain.link/docs/link-token-contracts
2247    */
2248   constructor(
2249     address _vrfCoordinator,
2250     address _link
2251   ) {
2252     vrfCoordinator = _vrfCoordinator;
2253     LINK = LinkTokenInterface(_link);
2254   }
2255 
2256   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
2257   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
2258   // the origin of the call
2259   function rawFulfillRandomness(
2260     bytes32 requestId,
2261     uint256 randomness
2262   )
2263     external
2264   {
2265     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
2266     fulfillRandomness(requestId, randomness);
2267   }
2268 }
2269 
2270 // File: BohemianBulldogs.sol
2271 
2272 
2273 
2274 pragma solidity 0.8.9;
2275 
2276 
2277 // SPC Treasure Keys Contract: 0x4bc87f553fce25bd613a7c31b17d6d224a84c7bf
2278 interface ISpacePunksTreasureKeys {
2279     function burnKeyForAddress(uint256 typeId, address burnTokenAddress) external;
2280     function balanceOf(address account, uint256 id) external view returns (uint256);
2281 }
2282 
2283 
2284 contract BohemianBulldogs is Ownable, ERC721Enumerable, ReentrancyGuard, ERC721URIStorage, PaymentSplitter {
2285    using SafeMath for uint256;
2286    using Counters for Counters.Counter;
2287     
2288     // Sale settings
2289     uint256 public constant MAX_BULLDOGS = 10000;
2290     uint256 public constant PRESALE_BULLDOGS_AMOUNT = 4000;
2291     uint256 public constant RESERVED_BULLDOGS_AMOUNT = 1000; // for SPC keys & BB team
2292     uint256 public MAX_BULLDOGS_PER_TRANSACTION = 20;
2293     
2294     // Starting price (for presale) is 0.05 ETH
2295     // The sale price is 0.09 ETH and will be switched with the switchPrice function
2296     uint256 public TOKEN_PRICE = 50000000000000000;
2297     
2298     // Sale & presale states
2299     bool public saleIsActive = false;
2300     bool public presaleIsActive = false;
2301     
2302     // Public URI to all the arts available
2303     string public _baseTokenURI = "";
2304     
2305     // Referral system related variables
2306     mapping(address => uint256) public _referrals;
2307     mapping(uint256 => address) public _referrers;
2308     uint256 public _referrersCount = 0;
2309     
2310     // Helpers variables to mint random token
2311     uint internal nonce = 0;
2312     uint[MAX_BULLDOGS] internal indices;
2313     
2314     // SPC x BohemianBulldogs launchpad id
2315     uint256 private LAUNCHPAD_PROJECT_ID = 6;
2316     
2317     // Splitting payments
2318     uint256[] private _teamShares = [93, 5, 2];
2319     address[] private _team = [0xbA5e1F929D6045d2eFb07bDAae9b6D4541055598, 0x19B5Ca7135859D3AEBD36228E0C6DE2756f1c658, 0x17895988aB2B64f041813936bF46Fb9133a6B160];
2320 
2321     
2322     constructor(string memory baseTokenURI) 
2323     PaymentSplitter(_team, _teamShares)
2324     ERC721("Bohemian Bulldogs","BB") {
2325         _baseTokenURI = baseTokenURI;
2326     }
2327 
2328     // *******************************************************************************************
2329     // Minting with SPC Treasure Keys
2330     address private _treasureKeys = 0x4bc87F553fcE25bd613a7C31b17d6D224A84c7bF;
2331     
2332     function setTreasureKeys(address value) external onlyOwner {
2333         _treasureKeys = value;
2334     }
2335     
2336     // Required overrides from parent contracts
2337     function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
2338         super._burn(tokenId);
2339     }
2340 
2341     // Required overrides from parent contracts
2342     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
2343         super._beforeTokenTransfer(from, to, tokenId);
2344     }
2345     
2346     // Required overrides from parent contracts
2347     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
2348         return super.supportsInterface(interfaceId);
2349     }
2350 
2351     function mintWithTreasureKey() external nonReentrant {
2352 
2353         // Checking supply numbers
2354         require(totalSupply() + 1 <= MAX_BULLDOGS, "Sale has already ended");
2355         
2356         ISpacePunksTreasureKeys keys = ISpacePunksTreasureKeys(_treasureKeys);
2357         require(keys.balanceOf(msg.sender, LAUNCHPAD_PROJECT_ID) > 0, "SPC Treasure Keys: must own at least one key");
2358 
2359         keys.burnKeyForAddress(LAUNCHPAD_PROJECT_ID, msg.sender);
2360         _mintWithRandomTokenId(msg.sender);
2361     }
2362     // *******************************************************************************************
2363     
2364     // Getting base URI
2365     function _baseURI() internal view virtual override returns (string memory) {
2366         return _baseTokenURI;
2367     }
2368     
2369     // Getting token's URI by id
2370     function tokenURI(uint256 _tokenId) override(ERC721, ERC721URIStorage) public view returns (string memory) {
2371         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
2372     }
2373     
2374     // Setting base URI
2375     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2376         _baseTokenURI = _newBaseURI;
2377     }
2378     
2379     // Setting LAUNCHPAD_PROJECT_ID
2380     function setLaunchpadProjectId(uint _newID) public onlyOwner {
2381         LAUNCHPAD_PROJECT_ID = _newID;
2382     }
2383     
2384     // Setting max tokens per trasaction
2385     function setMaxTokensPerTransaction(uint256 _newMaxTokens) public onlyOwner {
2386         MAX_BULLDOGS_PER_TRANSACTION = _newMaxTokens;
2387     }
2388 
2389     // Getting list of tokens that belong to the given address
2390     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
2391         // Get list of tokens owned by given address
2392         
2393         uint256 tokenCount = balanceOf(_owner);
2394         if (tokenCount == 0) {
2395             // Return an empty array
2396             return new uint256[](0);
2397         } else {
2398             uint256[] memory result = new uint256[](tokenCount);
2399             uint256 index;
2400             for (index = 0; index < tokenCount; index++) {
2401                 result[index] = tokenOfOwnerByIndex(_owner, index);
2402             }
2403             return result;
2404         }
2405     }
2406     
2407     // Price switcher between presale and sale values
2408     // Price has only 2 options: 0.05 and 0.09 ETH
2409     function switchPrice(uint256 option) public onlyOwner {
2410         if (option == 1) {
2411             TOKEN_PRICE = 50000000000000000; // 0.05 ETH
2412         } else if (option == 2) {
2413             TOKEN_PRICE = 90000000000000000; // 0.09 ETH
2414         }
2415     }
2416     
2417     // Pick a random index to mint the token
2418     function randomIndex() internal returns(uint256) {
2419         uint256 totalSize = MAX_BULLDOGS - totalSupply();
2420         uint256 index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
2421         uint256 value = 0;
2422     
2423         if (indices[index] != 0) {
2424             value = indices[index];
2425         } else {
2426             value = index;
2427         }
2428     
2429         if (indices[totalSize - 1] == 0) {
2430             indices[index] = totalSize - 1;
2431         } else {
2432             indices[index] = indices[totalSize - 1];
2433         }
2434     
2435         nonce++;
2436     
2437         return value.add(1);
2438     }
2439     
2440     
2441     // Mint the token (internal)
2442    function _mintWithRandomTokenId(address _to) private {
2443         uint _tokenID = randomIndex();
2444         _safeMint(_to, _tokenID);
2445    }
2446     
2447    // Main minting function
2448    // If you weren't referred by anyone, insert an empty ETH address
2449    function mintBohemianBulldog(uint256 numBulldogs, address referrer) public payable nonReentrant {
2450        
2451         // Checking whether the sale or presale is active
2452         require(saleIsActive || presaleIsActive, "Neither sale nor presale is active at the moment");
2453         
2454         // Checking for reserved bulldogs
2455         require(totalSupply().add(numBulldogs) <= MAX_BULLDOGS - RESERVED_BULLDOGS_AMOUNT, "Purchase would exceed max supply of Bohemian Bulldogs");
2456         
2457         // Checking supply numbers
2458         require(numBulldogs > 0 && numBulldogs <= MAX_BULLDOGS_PER_TRANSACTION, "You can mint minimum 1, maximum 20 Bohemian Bulldogs");
2459         
2460         // Checking price
2461         require(msg.value >= TOKEN_PRICE * numBulldogs, "Ether value sent is unsufficient");
2462 
2463         // Minting Bulldogs
2464         for (uint256 i = 0; i < numBulldogs; i++) {
2465             _mintWithRandomTokenId(msg.sender);
2466         }
2467         
2468         // Adding points to referree 
2469         addReferral(referrer, numBulldogs);
2470     }
2471     
2472     // Starting/stopping the sale
2473     function flipSaleState() public onlyOwner {
2474         saleIsActive = !saleIsActive;
2475     }
2476     
2477     // Starting/stopping the presale
2478     function flipPresaleState() public onlyOwner {
2479         presaleIsActive = !presaleIsActive;
2480     }
2481 
2482     // Referral points calculation
2483     function addReferral(address _referrer, uint256 _tokensCount) private {
2484         
2485         if (_referrals[_referrer] == 0) {
2486             _referrers[_referrersCount] = _referrer;
2487             _referrersCount += 1;
2488             // if referrer has never invited referrals, default bonus value is 0 in _referrals
2489             // then adding referrer to referrers list to find them after and increment _referrersCount index by 1
2490         }
2491        
2492         _referrals[_referrer] += _tokensCount;
2493    }
2494 }