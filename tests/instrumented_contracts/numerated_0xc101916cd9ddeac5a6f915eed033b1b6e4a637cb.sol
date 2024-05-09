1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Counters.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @title Counters
238  * @author Matt Condon (@shrugs)
239  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
240  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
241  *
242  * Include with `using Counters for Counters.Counter;`
243  */
244 library Counters {
245     struct Counter {
246         // This variable should never be directly accessed by users of the library: interactions must be restricted to
247         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
248         // this feature: see https://github.com/ethereum/solidity/issues/4637
249         uint256 _value; // default: 0
250     }
251 
252     function current(Counter storage counter) internal view returns (uint256) {
253         return counter._value;
254     }
255 
256     function increment(Counter storage counter) internal {
257         unchecked {
258             counter._value += 1;
259         }
260     }
261 
262     function decrement(Counter storage counter) internal {
263         uint256 value = counter._value;
264         require(value > 0, "Counter: decrement overflow");
265         unchecked {
266             counter._value = value - 1;
267         }
268     }
269 
270     function reset(Counter storage counter) internal {
271         counter._value = 0;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Strings.sol
276 
277 
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev String operations.
283  */
284 library Strings {
285     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
289      */
290     function toString(uint256 value) internal pure returns (string memory) {
291         // Inspired by OraclizeAPI's implementation - MIT licence
292         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
293 
294         if (value == 0) {
295             return "0";
296         }
297         uint256 temp = value;
298         uint256 digits;
299         while (temp != 0) {
300             digits++;
301             temp /= 10;
302         }
303         bytes memory buffer = new bytes(digits);
304         while (value != 0) {
305             digits -= 1;
306             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
307             value /= 10;
308         }
309         return string(buffer);
310     }
311 
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
314      */
315     function toHexString(uint256 value) internal pure returns (string memory) {
316         if (value == 0) {
317             return "0x00";
318         }
319         uint256 temp = value;
320         uint256 length = 0;
321         while (temp != 0) {
322             length++;
323             temp >>= 8;
324         }
325         return toHexString(value, length);
326     }
327 
328     /**
329      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
330      */
331     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
332         bytes memory buffer = new bytes(2 * length + 2);
333         buffer[0] = "0";
334         buffer[1] = "x";
335         for (uint256 i = 2 * length + 1; i > 1; --i) {
336             buffer[i] = _HEX_SYMBOLS[value & 0xf];
337             value >>= 4;
338         }
339         require(value == 0, "Strings: hex length insufficient");
340         return string(buffer);
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Context.sol
345 
346 
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Provides information about the current execution context, including the
352  * sender of the transaction and its data. While these are generally available
353  * via msg.sender and msg.data, they should not be accessed in such a direct
354  * manner, since when dealing with meta-transactions the account sending and
355  * paying for execution may not be the actual sender (as far as an application
356  * is concerned).
357  *
358  * This contract is only required for intermediate, library-like contracts.
359  */
360 abstract contract Context {
361     function _msgSender() internal view virtual returns (address) {
362         return msg.sender;
363     }
364 
365     function _msgData() internal view virtual returns (bytes calldata) {
366         return msg.data;
367     }
368 }
369 
370 // File: @openzeppelin/contracts/access/Ownable.sol
371 
372 
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Contract module which provides a basic access control mechanism, where
379  * there is an account (an owner) that can be granted exclusive access to
380  * specific functions.
381  *
382  * By default, the owner account will be the one that deploys the contract. This
383  * can later be changed with {transferOwnership}.
384  *
385  * This module is used through inheritance. It will make available the modifier
386  * `onlyOwner`, which can be applied to your functions to restrict their use to
387  * the owner.
388  */
389 abstract contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev Initializes the contract setting the deployer as the initial owner.
396      */
397     constructor() {
398         _setOwner(_msgSender());
399     }
400 
401     /**
402      * @dev Returns the address of the current owner.
403      */
404     function owner() public view virtual returns (address) {
405         return _owner;
406     }
407 
408     /**
409      * @dev Throws if called by any account other than the owner.
410      */
411     modifier onlyOwner() {
412         require(owner() == _msgSender(), "Ownable: caller is not the owner");
413         _;
414     }
415 
416     /**
417      * @dev Leaves the contract without owner. It will not be possible to call
418      * `onlyOwner` functions anymore. Can only be called by the current owner.
419      *
420      * NOTE: Renouncing ownership will leave the contract without an owner,
421      * thereby removing any functionality that is only available to the owner.
422      */
423     function renounceOwnership() public virtual onlyOwner {
424         _setOwner(address(0));
425     }
426 
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      * Can only be called by the current owner.
430      */
431     function transferOwnership(address newOwner) public virtual onlyOwner {
432         require(newOwner != address(0), "Ownable: new owner is the zero address");
433         _setOwner(newOwner);
434     }
435 
436     function _setOwner(address newOwner) private {
437         address oldOwner = _owner;
438         _owner = newOwner;
439         emit OwnershipTransferred(oldOwner, newOwner);
440     }
441 }
442 
443 // File: @openzeppelin/contracts/security/Pausable.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Contract module which allows children to implement an emergency stop
452  * mechanism that can be triggered by an authorized account.
453  *
454  * This module is used through inheritance. It will make available the
455  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
456  * the functions of your contract. Note that they will not be pausable by
457  * simply including this module, only once the modifiers are put in place.
458  */
459 abstract contract Pausable is Context {
460     /**
461      * @dev Emitted when the pause is triggered by `account`.
462      */
463     event Paused(address account);
464 
465     /**
466      * @dev Emitted when the pause is lifted by `account`.
467      */
468     event Unpaused(address account);
469 
470     bool private _paused;
471 
472     /**
473      * @dev Initializes the contract in unpaused state.
474      */
475     constructor() {
476         _paused = false;
477     }
478 
479     /**
480      * @dev Returns true if the contract is paused, and false otherwise.
481      */
482     function paused() public view virtual returns (bool) {
483         return _paused;
484     }
485 
486     /**
487      * @dev Modifier to make a function callable only when the contract is not paused.
488      *
489      * Requirements:
490      *
491      * - The contract must not be paused.
492      */
493     modifier whenNotPaused() {
494         require(!paused(), "Pausable: paused");
495         _;
496     }
497 
498     /**
499      * @dev Modifier to make a function callable only when the contract is paused.
500      *
501      * Requirements:
502      *
503      * - The contract must be paused.
504      */
505     modifier whenPaused() {
506         require(paused(), "Pausable: not paused");
507         _;
508     }
509 
510     /**
511      * @dev Triggers stopped state.
512      *
513      * Requirements:
514      *
515      * - The contract must not be paused.
516      */
517     function _pause() internal virtual whenNotPaused {
518         _paused = true;
519         emit Paused(_msgSender());
520     }
521 
522     /**
523      * @dev Returns to normal state.
524      *
525      * Requirements:
526      *
527      * - The contract must be paused.
528      */
529     function _unpause() internal virtual whenPaused {
530         _paused = false;
531         emit Unpaused(_msgSender());
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Address.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Collection of functions related to the address type
543  */
544 library Address {
545     /**
546      * @dev Returns true if `account` is a contract.
547      *
548      * [IMPORTANT]
549      * ====
550      * It is unsafe to assume that an address for which this function returns
551      * false is an externally-owned account (EOA) and not a contract.
552      *
553      * Among others, `isContract` will return false for the following
554      * types of addresses:
555      *
556      *  - an externally-owned account
557      *  - a contract in construction
558      *  - an address where a contract will be created
559      *  - an address where a contract lived, but was destroyed
560      * ====
561      */
562     function isContract(address account) internal view returns (bool) {
563         // This method relies on extcodesize, which returns 0 for contracts in
564         // construction, since the code is only stored at the end of the
565         // constructor execution.
566 
567         uint256 size;
568         assembly {
569             size := extcodesize(account)
570         }
571         return size > 0;
572     }
573 
574     /**
575      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
576      * `recipient`, forwarding all available gas and reverting on errors.
577      *
578      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
579      * of certain opcodes, possibly making contracts go over the 2300 gas limit
580      * imposed by `transfer`, making them unable to receive funds via
581      * `transfer`. {sendValue} removes this limitation.
582      *
583      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
584      *
585      * IMPORTANT: because control is transferred to `recipient`, care must be
586      * taken to not create reentrancy vulnerabilities. Consider using
587      * {ReentrancyGuard} or the
588      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
589      */
590     function sendValue(address payable recipient, uint256 amount) internal {
591         require(address(this).balance >= amount, "Address: insufficient balance");
592 
593         (bool success, ) = recipient.call{value: amount}("");
594         require(success, "Address: unable to send value, recipient may have reverted");
595     }
596 
597     /**
598      * @dev Performs a Solidity function call using a low level `call`. A
599      * plain `call` is an unsafe replacement for a function call: use this
600      * function instead.
601      *
602      * If `target` reverts with a revert reason, it is bubbled up by this
603      * function (like regular Solidity function calls).
604      *
605      * Returns the raw returned data. To convert to the expected return value,
606      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
607      *
608      * Requirements:
609      *
610      * - `target` must be a contract.
611      * - calling `target` with `data` must not revert.
612      *
613      * _Available since v3.1._
614      */
615     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
616         return functionCall(target, data, "Address: low-level call failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
621      * `errorMessage` as a fallback revert reason when `target` reverts.
622      *
623      * _Available since v3.1._
624      */
625     function functionCall(
626         address target,
627         bytes memory data,
628         string memory errorMessage
629     ) internal returns (bytes memory) {
630         return functionCallWithValue(target, data, 0, errorMessage);
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
635      * but also transferring `value` wei to `target`.
636      *
637      * Requirements:
638      *
639      * - the calling contract must have an ETH balance of at least `value`.
640      * - the called Solidity function must be `payable`.
641      *
642      * _Available since v3.1._
643      */
644     function functionCallWithValue(
645         address target,
646         bytes memory data,
647         uint256 value
648     ) internal returns (bytes memory) {
649         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
654      * with `errorMessage` as a fallback revert reason when `target` reverts.
655      *
656      * _Available since v3.1._
657      */
658     function functionCallWithValue(
659         address target,
660         bytes memory data,
661         uint256 value,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         require(address(this).balance >= value, "Address: insufficient balance for call");
665         require(isContract(target), "Address: call to non-contract");
666 
667         (bool success, bytes memory returndata) = target.call{value: value}(data);
668         return verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but performing a static call.
674      *
675      * _Available since v3.3._
676      */
677     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
678         return functionStaticCall(target, data, "Address: low-level static call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
683      * but performing a static call.
684      *
685      * _Available since v3.3._
686      */
687     function functionStaticCall(
688         address target,
689         bytes memory data,
690         string memory errorMessage
691     ) internal view returns (bytes memory) {
692         require(isContract(target), "Address: static call to non-contract");
693 
694         (bool success, bytes memory returndata) = target.staticcall(data);
695         return verifyCallResult(success, returndata, errorMessage);
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
700      * but performing a delegate call.
701      *
702      * _Available since v3.4._
703      */
704     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
705         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
710      * but performing a delegate call.
711      *
712      * _Available since v3.4._
713      */
714     function functionDelegateCall(
715         address target,
716         bytes memory data,
717         string memory errorMessage
718     ) internal returns (bytes memory) {
719         require(isContract(target), "Address: delegate call to non-contract");
720 
721         (bool success, bytes memory returndata) = target.delegatecall(data);
722         return verifyCallResult(success, returndata, errorMessage);
723     }
724 
725     /**
726      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
727      * revert reason using the provided one.
728      *
729      * _Available since v4.3._
730      */
731     function verifyCallResult(
732         bool success,
733         bytes memory returndata,
734         string memory errorMessage
735     ) internal pure returns (bytes memory) {
736         if (success) {
737             return returndata;
738         } else {
739             // Look for revert reason and bubble it up if present
740             if (returndata.length > 0) {
741                 // The easiest way to bubble the revert reason is using memory via assembly
742 
743                 assembly {
744                     let returndata_size := mload(returndata)
745                     revert(add(32, returndata), returndata_size)
746                 }
747             } else {
748                 revert(errorMessage);
749             }
750         }
751     }
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
755 
756 
757 
758 pragma solidity ^0.8.0;
759 
760 /**
761  * @title ERC721 token receiver interface
762  * @dev Interface for any contract that wants to support safeTransfers
763  * from ERC721 asset contracts.
764  */
765 interface IERC721Receiver {
766     /**
767      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
768      * by `operator` from `from`, this function is called.
769      *
770      * It must return its Solidity selector to confirm the token transfer.
771      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
772      *
773      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
774      */
775     function onERC721Received(
776         address operator,
777         address from,
778         uint256 tokenId,
779         bytes calldata data
780     ) external returns (bytes4);
781 }
782 
783 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
784 
785 
786 
787 pragma solidity ^0.8.0;
788 
789 /**
790  * @dev Interface of the ERC165 standard, as defined in the
791  * https://eips.ethereum.org/EIPS/eip-165[EIP].
792  *
793  * Implementers can declare support of contract interfaces, which can then be
794  * queried by others ({ERC165Checker}).
795  *
796  * For an implementation, see {ERC165}.
797  */
798 interface IERC165 {
799     /**
800      * @dev Returns true if this contract implements the interface defined by
801      * `interfaceId`. See the corresponding
802      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
803      * to learn more about how these ids are created.
804      *
805      * This function call must use less than 30 000 gas.
806      */
807     function supportsInterface(bytes4 interfaceId) external view returns (bool);
808 }
809 
810 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
811 
812 
813 
814 pragma solidity ^0.8.0;
815 
816 
817 /**
818  * @dev Implementation of the {IERC165} interface.
819  *
820  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
821  * for the additional interface id that will be supported. For example:
822  *
823  * ```solidity
824  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
825  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
826  * }
827  * ```
828  *
829  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
830  */
831 abstract contract ERC165 is IERC165 {
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
836         return interfaceId == type(IERC165).interfaceId;
837     }
838 }
839 
840 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
841 
842 
843 
844 pragma solidity ^0.8.0;
845 
846 
847 /**
848  * @dev Required interface of an ERC721 compliant contract.
849  */
850 interface IERC721 is IERC165 {
851     /**
852      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
853      */
854     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
855 
856     /**
857      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
858      */
859     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
860 
861     /**
862      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
863      */
864     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
865 
866     /**
867      * @dev Returns the number of tokens in ``owner``'s account.
868      */
869     function balanceOf(address owner) external view returns (uint256 balance);
870 
871     /**
872      * @dev Returns the owner of the `tokenId` token.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must exist.
877      */
878     function ownerOf(uint256 tokenId) external view returns (address owner);
879 
880     /**
881      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
882      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must exist and be owned by `from`.
889      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
891      *
892      * Emits a {Transfer} event.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) external;
899 
900     /**
901      * @dev Transfers `tokenId` token from `from` to `to`.
902      *
903      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must be owned by `from`.
910      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
911      *
912      * Emits a {Transfer} event.
913      */
914     function transferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) external;
919 
920     /**
921      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
922      * The approval is cleared when the token is transferred.
923      *
924      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
925      *
926      * Requirements:
927      *
928      * - The caller must own the token or be an approved operator.
929      * - `tokenId` must exist.
930      *
931      * Emits an {Approval} event.
932      */
933     function approve(address to, uint256 tokenId) external;
934 
935     /**
936      * @dev Returns the account approved for `tokenId` token.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function getApproved(uint256 tokenId) external view returns (address operator);
943 
944     /**
945      * @dev Approve or remove `operator` as an operator for the caller.
946      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
947      *
948      * Requirements:
949      *
950      * - The `operator` cannot be the caller.
951      *
952      * Emits an {ApprovalForAll} event.
953      */
954     function setApprovalForAll(address operator, bool _approved) external;
955 
956     /**
957      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
958      *
959      * See {setApprovalForAll}
960      */
961     function isApprovedForAll(address owner, address operator) external view returns (bool);
962 
963     /**
964      * @dev Safely transfers `tokenId` token from `from` to `to`.
965      *
966      * Requirements:
967      *
968      * - `from` cannot be the zero address.
969      * - `to` cannot be the zero address.
970      * - `tokenId` token must exist and be owned by `from`.
971      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes calldata data
981     ) external;
982 }
983 
984 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
985 
986 
987 
988 pragma solidity ^0.8.0;
989 
990 
991 /**
992  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
993  * @dev See https://eips.ethereum.org/EIPS/eip-721
994  */
995 interface IERC721Metadata is IERC721 {
996     /**
997      * @dev Returns the token collection name.
998      */
999     function name() external view returns (string memory);
1000 
1001     /**
1002      * @dev Returns the token collection symbol.
1003      */
1004     function symbol() external view returns (string memory);
1005 
1006     /**
1007      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1008      */
1009     function tokenURI(uint256 tokenId) external view returns (string memory);
1010 }
1011 
1012 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1013 
1014 
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 
1025 /**
1026  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1027  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1028  * {ERC721Enumerable}.
1029  */
1030 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1031     using Address for address;
1032     using Strings for uint256;
1033 
1034     // Token name
1035     string private _name;
1036 
1037     // Token symbol
1038     string private _symbol;
1039 
1040     // Mapping from token ID to owner address
1041     mapping(uint256 => address) private _owners;
1042 
1043     // Mapping owner address to token count
1044     mapping(address => uint256) private _balances;
1045 
1046     // Mapping from token ID to approved address
1047     mapping(uint256 => address) private _tokenApprovals;
1048 
1049     // Mapping from owner to operator approvals
1050     mapping(address => mapping(address => bool)) private _operatorApprovals;
1051 
1052     /**
1053      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1054      */
1055     constructor(string memory name_, string memory symbol_) {
1056         _name = name_;
1057         _symbol = symbol_;
1058     }
1059 
1060     /**
1061      * @dev See {IERC165-supportsInterface}.
1062      */
1063     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1064         return
1065             interfaceId == type(IERC721).interfaceId ||
1066             interfaceId == type(IERC721Metadata).interfaceId ||
1067             super.supportsInterface(interfaceId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-balanceOf}.
1072      */
1073     function balanceOf(address owner) public view virtual override returns (uint256) {
1074         require(owner != address(0), "ERC721: balance query for the zero address");
1075         return _balances[owner];
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-ownerOf}.
1080      */
1081     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1082         address owner = _owners[tokenId];
1083         require(owner != address(0), "ERC721: owner query for nonexistent token");
1084         return owner;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Metadata-name}.
1089      */
1090     function name() public view virtual override returns (string memory) {
1091         return _name;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Metadata-symbol}.
1096      */
1097     function symbol() public view virtual override returns (string memory) {
1098         return _symbol;
1099     }
1100 
1101     /**
1102      * @dev See {IERC721Metadata-tokenURI}.
1103      */
1104     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1105         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1106 
1107         string memory baseURI = _baseURI();
1108         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1109     }
1110 
1111     /**
1112      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1113      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1114      * by default, can be overriden in child contracts.
1115      */
1116     function _baseURI() internal view virtual returns (string memory) {
1117         return "";
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-approve}.
1122      */
1123     function approve(address to, uint256 tokenId) public virtual override {
1124         address owner = ERC721.ownerOf(tokenId);
1125         require(to != owner, "ERC721: approval to current owner");
1126 
1127         require(
1128             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1129             "ERC721: approve caller is not owner nor approved for all"
1130         );
1131 
1132         _approve(to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-getApproved}.
1137      */
1138     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1139         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1140 
1141         return _tokenApprovals[tokenId];
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-setApprovalForAll}.
1146      */
1147     function setApprovalForAll(address operator, bool approved) public virtual override {
1148         require(operator != _msgSender(), "ERC721: approve to caller");
1149 
1150         _operatorApprovals[_msgSender()][operator] = approved;
1151         emit ApprovalForAll(_msgSender(), operator, approved);
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-isApprovedForAll}.
1156      */
1157     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1158         return _operatorApprovals[owner][operator];
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-transferFrom}.
1163      */
1164     function transferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) public virtual override {
1169         //solhint-disable-next-line max-line-length
1170         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1171 
1172         _transfer(from, to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-safeTransferFrom}.
1177      */
1178     function safeTransferFrom(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) public virtual override {
1183         safeTransferFrom(from, to, tokenId, "");
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-safeTransferFrom}.
1188      */
1189     function safeTransferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) public virtual override {
1195         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1196         _safeTransfer(from, to, tokenId, _data);
1197     }
1198 
1199     /**
1200      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1201      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1202      *
1203      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1204      *
1205      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1206      * implement alternative mechanisms to perform token transfer, such as signature-based.
1207      *
1208      * Requirements:
1209      *
1210      * - `from` cannot be the zero address.
1211      * - `to` cannot be the zero address.
1212      * - `tokenId` token must exist and be owned by `from`.
1213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _safeTransfer(
1218         address from,
1219         address to,
1220         uint256 tokenId,
1221         bytes memory _data
1222     ) internal virtual {
1223         _transfer(from, to, tokenId);
1224         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1225     }
1226 
1227     /**
1228      * @dev Returns whether `tokenId` exists.
1229      *
1230      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1231      *
1232      * Tokens start existing when they are minted (`_mint`),
1233      * and stop existing when they are burned (`_burn`).
1234      */
1235     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1236         return _owners[tokenId] != address(0);
1237     }
1238 
1239     /**
1240      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1241      *
1242      * Requirements:
1243      *
1244      * - `tokenId` must exist.
1245      */
1246     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1247         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1248         address owner = ERC721.ownerOf(tokenId);
1249         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1250     }
1251 
1252     /**
1253      * @dev Safely mints `tokenId` and transfers it to `to`.
1254      *
1255      * Requirements:
1256      *
1257      * - `tokenId` must not exist.
1258      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1259      *
1260      * Emits a {Transfer} event.
1261      */
1262     function _safeMint(address to, uint256 tokenId) internal virtual {
1263         _safeMint(to, tokenId, "");
1264     }
1265 
1266     /**
1267      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1268      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1269      */
1270     function _safeMint(
1271         address to,
1272         uint256 tokenId,
1273         bytes memory _data
1274     ) internal virtual {
1275         _mint(to, tokenId);
1276         require(
1277             _checkOnERC721Received(address(0), to, tokenId, _data),
1278             "ERC721: transfer to non ERC721Receiver implementer"
1279         );
1280     }
1281 
1282     /**
1283      * @dev Mints `tokenId` and transfers it to `to`.
1284      *
1285      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1286      *
1287      * Requirements:
1288      *
1289      * - `tokenId` must not exist.
1290      * - `to` cannot be the zero address.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function _mint(address to, uint256 tokenId) internal virtual {
1295         require(to != address(0), "ERC721: mint to the zero address");
1296         require(!_exists(tokenId), "ERC721: token already minted");
1297 
1298         _beforeTokenTransfer(address(0), to, tokenId);
1299 
1300         _balances[to] += 1;
1301         _owners[tokenId] = to;
1302 
1303         emit Transfer(address(0), to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev Destroys `tokenId`.
1308      * The approval is cleared when the token is burned.
1309      *
1310      * Requirements:
1311      *
1312      * - `tokenId` must exist.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _burn(uint256 tokenId) internal virtual {
1317         address owner = ERC721.ownerOf(tokenId);
1318 
1319         _beforeTokenTransfer(owner, address(0), tokenId);
1320 
1321         // Clear approvals
1322         _approve(address(0), tokenId);
1323 
1324         _balances[owner] -= 1;
1325         delete _owners[tokenId];
1326 
1327         emit Transfer(owner, address(0), tokenId);
1328     }
1329 
1330     /**
1331      * @dev Transfers `tokenId` from `from` to `to`.
1332      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1333      *
1334      * Requirements:
1335      *
1336      * - `to` cannot be the zero address.
1337      * - `tokenId` token must be owned by `from`.
1338      *
1339      * Emits a {Transfer} event.
1340      */
1341     function _transfer(
1342         address from,
1343         address to,
1344         uint256 tokenId
1345     ) internal virtual {
1346         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1347         require(to != address(0), "ERC721: transfer to the zero address");
1348 
1349         _beforeTokenTransfer(from, to, tokenId);
1350 
1351         // Clear approvals from the previous owner
1352         _approve(address(0), tokenId);
1353 
1354         _balances[from] -= 1;
1355         _balances[to] += 1;
1356         _owners[tokenId] = to;
1357 
1358         emit Transfer(from, to, tokenId);
1359     }
1360 
1361     /**
1362      * @dev Approve `to` to operate on `tokenId`
1363      *
1364      * Emits a {Approval} event.
1365      */
1366     function _approve(address to, uint256 tokenId) internal virtual {
1367         _tokenApprovals[tokenId] = to;
1368         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1369     }
1370 
1371     /**
1372      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1373      * The call is not executed if the target address is not a contract.
1374      *
1375      * @param from address representing the previous owner of the given token ID
1376      * @param to target address that will receive the tokens
1377      * @param tokenId uint256 ID of the token to be transferred
1378      * @param _data bytes optional data to send along with the call
1379      * @return bool whether the call correctly returned the expected magic value
1380      */
1381     function _checkOnERC721Received(
1382         address from,
1383         address to,
1384         uint256 tokenId,
1385         bytes memory _data
1386     ) private returns (bool) {
1387         if (to.isContract()) {
1388             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1389                 return retval == IERC721Receiver.onERC721Received.selector;
1390             } catch (bytes memory reason) {
1391                 if (reason.length == 0) {
1392                     revert("ERC721: transfer to non ERC721Receiver implementer");
1393                 } else {
1394                     assembly {
1395                         revert(add(32, reason), mload(reason))
1396                     }
1397                 }
1398             }
1399         } else {
1400             return true;
1401         }
1402     }
1403 
1404     /**
1405      * @dev Hook that is called before any token transfer. This includes minting
1406      * and burning.
1407      *
1408      * Calling conditions:
1409      *
1410      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1411      * transferred to `to`.
1412      * - When `from` is zero, `tokenId` will be minted for `to`.
1413      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1414      * - `from` and `to` are never both zero.
1415      *
1416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1417      */
1418     function _beforeTokenTransfer(
1419         address from,
1420         address to,
1421         uint256 tokenId
1422     ) internal virtual {}
1423 }
1424 
1425 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1426 
1427 
1428 
1429 pragma solidity ^0.8.0;
1430 
1431 
1432 
1433 /**
1434  * @dev ERC721 token with pausable token transfers, minting and burning.
1435  *
1436  * Useful for scenarios such as preventing trades until the end of an evaluation
1437  * period, or having an emergency switch for freezing all token transfers in the
1438  * event of a large bug.
1439  */
1440 abstract contract ERC721Pausable is ERC721, Pausable {
1441     /**
1442      * @dev See {ERC721-_beforeTokenTransfer}.
1443      *
1444      * Requirements:
1445      *
1446      * - the contract must not be paused.
1447      */
1448     function _beforeTokenTransfer(
1449         address from,
1450         address to,
1451         uint256 tokenId
1452     ) internal virtual override {
1453         super._beforeTokenTransfer(from, to, tokenId);
1454 
1455         require(!paused(), "ERC721Pausable: token transfer while paused");
1456     }
1457 }
1458 
1459 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1460 
1461 
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 
1466 
1467 /**
1468  * @title ERC721 Burnable Token
1469  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1470  */
1471 abstract contract ERC721Burnable is Context, ERC721 {
1472     /**
1473      * @dev Burns `tokenId`. See {ERC721-_burn}.
1474      *
1475      * Requirements:
1476      *
1477      * - The caller must own `tokenId` or be an approved operator.
1478      */
1479     function burn(uint256 tokenId) public virtual {
1480         //solhint-disable-next-line max-line-length
1481         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1482         _burn(tokenId);
1483     }
1484 }
1485 
1486 // File: ZombieMobSecretSociety.sol
1487 
1488 
1489 pragma solidity ^0.8.0;
1490 
1491 
1492 
1493 
1494 
1495 
1496 
1497 /**
1498  *
1499  * Zombie Mob Secret Society
1500  *
1501  */
1502 contract ZombieMobSecretSociety is
1503     Ownable,
1504     ERC721,
1505     ERC721Burnable,
1506     ERC721Pausable
1507 {
1508     using SafeMath for uint256;
1509     using Strings for uint256;
1510     using Counters for Counters.Counter;
1511 
1512     Counters.Counter private _tokenIds;
1513     Counters.Counter private _totalSupply;
1514 
1515     // Base token uri
1516     string private baseTokenURI; // baseTokenURI can point to IPFS folder like ipfs://{cid}/
1517     string private uriSuffix = '.json';
1518     string private hiddenMetadata = 'hidden';
1519 
1520     // Wallet addresses
1521     address private marketingWallet = 0x10cdEe5761B6Ddf4cf9a51d965Dae5823bC95CC6;
1522     address private devWallet = 0x64BE935c04ad0b09155f0af5B9cd9bCfb3D9E59E;
1523 
1524     // Royalties address
1525     address private royaltyAddress;
1526 
1527     // Royalties basis points (percentage using 2 decimals - 10000 = 100, 0 = 0)
1528     uint256 private royaltyBasisPoints = 1000; // 10%
1529 
1530     // Token info
1531     string public constant TOKEN_NAME = "Zombie Mob Secret Society";
1532     string public constant TOKEN_SYMBOL = "ZMSS";
1533     uint256 public constant TOTAL_TOKENS = 10000;
1534 
1535     // Mint costs and max amounts 
1536     uint256 public earlyAccessMintCost = .5 ether;
1537     uint256 public startingDutchAuctionMintCost = .4 ether;
1538     uint256 public endingDutchAuctionMintCost = .1 ether;
1539     uint256 public maxWalletAmount = 10;
1540 
1541     // Early access/Dutch auction sales active
1542     bool public earlyAccessActive;
1543     bool public dutchAuctionActive;
1544     uint256 public dutchAuctionStartTime;
1545     uint256 public elapsedDutchAuctionTime;
1546 
1547     // Dutch auction durations
1548     uint256 public constant DUTCH_AUCTION_DURATION = 12 hours;
1549     uint256 public constant DUTCH_AUCTION_PRICE_CHANGE = 3 hours;
1550 
1551     // Is revealed boolean
1552     bool private isRevealed = false;
1553 
1554     //-- Events --//
1555     event RoyaltyBasisPoints(uint256 indexed _royaltyBasisPoints);
1556 
1557     //-- Modifiers --//
1558 
1559     // Early access active modifier
1560     modifier whenEarlyAccessActive() {
1561         require(earlyAccessActive, "Early access is not active");
1562         _;
1563     }
1564 
1565     // Early access not active modifier
1566     modifier whenEarlyAccessNotActive() {
1567         require(!earlyAccessActive, "Early access is already active");
1568         _;
1569     }
1570 
1571     // Dutch auction active modifier
1572     modifier whenDutchAuctionActive() {
1573         require(dutchAuctionActive, "Dutch auction is not active");
1574         _;
1575     }
1576 
1577     // Dutch auction not active modifier
1578     modifier whenDutchAuctionNotActive() {
1579         require(!dutchAuctionActive,"Dutch auction is already active");
1580         _;
1581     }
1582 
1583     // Owner or sale active modifier
1584     modifier whenOwnerOrSaleActive() {
1585         require(
1586             owner() == _msgSender() || earlyAccessActive || dutchAuctionActive,
1587             "Sale is not active"
1588         );
1589         _;
1590     }
1591 
1592     // -- Constructor --//
1593 
1594     constructor(string memory _baseTokenURI) ERC721(TOKEN_NAME, TOKEN_SYMBOL) {
1595         baseTokenURI = _baseTokenURI;
1596 
1597         royaltyAddress = _msgSender();
1598     }
1599 
1600     // -- External Functions -- //
1601 
1602     // Start early access 
1603     function startEarlyAccess() external onlyOwner whenEarlyAccessNotActive whenDutchAuctionNotActive {
1604         earlyAccessActive = true;
1605     }
1606 
1607     // End early access
1608     function endEarlyAccess() external onlyOwner whenEarlyAccessActive {
1609         earlyAccessActive = false;
1610     }
1611 
1612     // Start dutch auction
1613     function startDutchAuction() external onlyOwner whenEarlyAccessNotActive whenDutchAuctionNotActive {
1614         uint256 startTime = block.timestamp;
1615         if (elapsedDutchAuctionTime != 0) {
1616             startTime = startTime.sub(elapsedDutchAuctionTime);
1617         }
1618 
1619         dutchAuctionStartTime = startTime;
1620         dutchAuctionActive = true;
1621         elapsedDutchAuctionTime = 0;
1622     }
1623 
1624     // Set this value to the block.timestamp you'd like to reset to
1625     // Created as a way to fast foward in time for timing unit tests
1626     // Can also be used if needing to pause and restart dutch auction from original start time (returned in startDutchAuction() above)
1627     function setDutchAuctionStartTime(uint256 _dutchAuctionStartTime)
1628         external
1629         onlyOwner
1630     {
1631         dutchAuctionStartTime = _dutchAuctionStartTime;
1632     }
1633 
1634     // Pause dutch auction
1635     function pauseDutchAuction() external onlyOwner whenDutchAuctionActive {
1636         dutchAuctionActive = false;
1637         elapsedDutchAuctionTime = getElapsedDutchAuctionTime();
1638     }
1639 
1640     // End dutch auction
1641     function endDutchAuction() external onlyOwner whenDutchAuctionActive {
1642         dutchAuctionActive = false;
1643         elapsedDutchAuctionTime = 0;
1644     }
1645 
1646     // Support royalty info - See {EIP-2981}: https://eips.ethereum.org/EIPS/eip-2981
1647     function royaltyInfo(uint256, uint256 _salePrice)
1648         external
1649         view
1650         returns (address receiver, uint256 royaltyAmount)
1651     {
1652         return (
1653             royaltyAddress,
1654             (_salePrice.mul(royaltyBasisPoints)).div(10000)
1655         );
1656     }
1657 
1658     //-- Public Functions --//
1659 
1660     // Get elapsed dutch auction time
1661     function getElapsedDutchAuctionTime() public view returns (uint256) {
1662         return
1663             dutchAuctionStartTime > 0
1664                 ? block.timestamp.sub(dutchAuctionStartTime)
1665                 : 0;
1666     }
1667 
1668     // Mint token - requires amount
1669     function mint(uint256 _amount) public payable whenOwnerOrSaleActive {
1670         // Must mint at least one
1671         require(_amount > 0, "Must mint at least one");
1672         
1673         // Check there enough mints left to mint
1674         require(
1675             getMintsLeft() >= _amount,
1676             "Minting would exceed max supply"
1677         );
1678 
1679         // Set cost to mint
1680         uint256 costToMint = getMintCost() * _amount;
1681 
1682         // Is owner
1683         bool isOwner = owner() == _msgSender();
1684 
1685         // If not owner
1686         if (!isOwner) {
1687             // Get current address total balance
1688             uint256 currentWalletAmount = super.balanceOf(_msgSender());
1689 
1690             // Check current token amount and mint amount is not more than max wallet amount
1691             require(
1692                 currentWalletAmount.add(_amount) <= maxWalletAmount,
1693                 "Requested amount exceeds maximum mint amount per wallet"
1694             );
1695         }
1696 
1697         // Check cost to mint, and if enough ETH is passed to mint
1698         require(costToMint <= msg.value, "ETH amount sent is not correct");
1699 
1700         for (uint256 i = 0; i < _amount; i++) {
1701             // Increment token id
1702             _tokenIds.increment();
1703 
1704             // Safe mint
1705             _safeMint(_msgSender(), _tokenIds.current());
1706 
1707             // Increment total supply
1708             _totalSupply.increment();
1709         }
1710 
1711         // Send half mint cost to marketing and dev wallets
1712         uint256 halfCostToMint = costToMint.div(2);
1713         Address.sendValue(payable(marketingWallet), halfCostToMint);
1714         Address.sendValue(payable(devWallet), halfCostToMint);
1715 
1716         // Return unused value
1717         if (msg.value > costToMint) {
1718             Address.sendValue(payable(_msgSender()), msg.value.sub(costToMint));
1719         }
1720     }
1721 
1722     function totalSupply() public view returns (uint256) {
1723         return _totalSupply.current();
1724     }
1725 
1726     // Get mints left
1727     function getMintsLeft() public view returns (uint256) {
1728         return TOTAL_TOKENS.sub(totalSupply());
1729     }
1730 
1731     // Get mint cost
1732     function getMintCost()
1733         public
1734         view
1735         whenOwnerOrSaleActive
1736         returns (uint256)
1737     {
1738         // Is owner
1739         bool isOwner = owner() == _msgSender();
1740 
1741         // If owner, cost is 0
1742         if (isOwner) {
1743             return 0;
1744         }
1745 
1746         // If early access, pass early access mint cost
1747         if (earlyAccessActive) {
1748             return earlyAccessMintCost;
1749         }
1750 
1751         uint256 elapsed = getElapsedDutchAuctionTime();
1752 
1753         // Setup starting and ending prices
1754         uint256 startingPrice = startingDutchAuctionMintCost;
1755         uint256 endingPrice = endingDutchAuctionMintCost;
1756 
1757         uint256 currentPrice = 0;
1758 
1759         // Time logic based on constants
1760         uint256 auctionStart = 0;
1761         uint256 auctionEnd = auctionStart.add(DUTCH_AUCTION_DURATION);
1762 
1763         // Dutch auction not active
1764         require(elapsed >= auctionStart, "Dutch auction not active");
1765 
1766         // Dutch Auction - price descreses dynamically for duration
1767         if ((elapsed >= auctionStart) && (elapsed < auctionEnd)) {
1768             uint256 elapsedSinceAuctionStart = elapsed.sub(auctionStart); // Elapsed time since auction start
1769             uint256 totalPriceDiff = startingPrice.sub(endingPrice); // Total price diff between starting and ending price
1770             uint256 numPriceChanges = DUTCH_AUCTION_DURATION.div(DUTCH_AUCTION_PRICE_CHANGE).sub(1); // Amount of price changes in the auction
1771             uint256 priceChangeAmount = totalPriceDiff.div(numPriceChanges); // Amount of price change per instance of price change
1772             uint256 elapsedRounded = elapsedSinceAuctionStart.div(
1773                 DUTCH_AUCTION_PRICE_CHANGE
1774             ); // Elapsed time since auction start rounded to auction price change variable
1775             uint256 totalPriceChangeAmount = priceChangeAmount.mul(
1776                 elapsedRounded
1777             ); // Total amount of price change based on time
1778 
1779             currentPrice = startingPrice.sub(totalPriceChangeAmount); // Starting price minus total price change
1780 
1781         // Post auction - ending price
1782         } else if (elapsed >= auctionEnd) {
1783             currentPrice = endingPrice;
1784         }
1785 
1786         // Double check current price is not lower than ending price
1787         return currentPrice < endingPrice ? endingPrice : currentPrice;
1788     }
1789 
1790     // Set early access mint cost
1791     function setEarlyAccessMintCost(uint256 _cost) public onlyOwner {
1792         earlyAccessMintCost = _cost;
1793     }
1794 
1795     // Set starting dutch auction mint cost
1796     function setStartingDutchAuctionMintCost(uint256 _cost) public onlyOwner {
1797         startingDutchAuctionMintCost = _cost;
1798     }
1799 
1800     // Set ending dutch auction mint cost
1801     function setEndingDutchAuctionMintCost(uint256 _cost) public onlyOwner {
1802         endingDutchAuctionMintCost = _cost;
1803     }
1804 
1805     // Set max wallet amount
1806     function setMaxWalletAmount(uint256 _amount) public onlyOwner {
1807         maxWalletAmount = _amount;
1808     }
1809 
1810     // Set royalty wallet address
1811     function setRoyaltyAddress(address _address) public onlyOwner {
1812         royaltyAddress = _address;
1813     }
1814 
1815     // Set royalty basis points
1816     function setRoyaltyBasisPoints(uint256 _basisPoints) public onlyOwner {
1817         royaltyBasisPoints = _basisPoints;
1818         emit RoyaltyBasisPoints(_basisPoints);
1819     }
1820 
1821     // Set base URI
1822     function setBaseURI(string memory _uri) public onlyOwner {
1823         baseTokenURI = _uri;
1824     }
1825 
1826     // Set revealed
1827     function setRevealed(bool _isRevealed) public onlyOwner {
1828         isRevealed = _isRevealed;
1829     }
1830 
1831     // Token URI (baseTokenURI + tokenId)
1832     function tokenURI(uint256 _tokenId)
1833         public
1834         view
1835         virtual
1836         override
1837         returns (string memory)
1838     {
1839         require(_exists(_tokenId), "Nonexistent token");
1840 
1841         if(isRevealed == false) {
1842             return string(abi.encodePacked(_baseURI(), hiddenMetadata, uriSuffix));
1843         }
1844 
1845         return string(abi.encodePacked(_baseURI(), _tokenId.toString(), uriSuffix));
1846     }
1847 
1848     // Contract metadata URI - Support for OpenSea: https://docs.opensea.io/docs/contract-level-metadata
1849     function contractURI() public view returns (string memory) {
1850         return string(abi.encodePacked(_baseURI(), "contract", uriSuffix));
1851     }
1852 
1853     // Override supportsInterface - See {IERC165-supportsInterface}
1854     function supportsInterface(bytes4 _interfaceId)
1855         public
1856         view
1857         virtual
1858         override(ERC721)
1859         returns (bool)
1860     {
1861         return super.supportsInterface(_interfaceId);
1862     }
1863 
1864     // Pauses all token transfers - See {ERC721Pausable}
1865     function pause() public virtual onlyOwner {
1866         _pause();
1867     }
1868 
1869     // Unpauses all token transfers - See {ERC721Pausable}
1870     function unpause() public virtual onlyOwner {
1871         _unpause();
1872     }
1873 
1874     //-- Internal Functions --//
1875 
1876     // Get base URI
1877     function _baseURI() internal view override returns (string memory) {
1878         return baseTokenURI;
1879     }
1880 
1881     // Before all token transfer
1882     function _beforeTokenTransfer(
1883         address _from,
1884         address _to,
1885         uint256 _tokenId
1886     ) internal virtual override(ERC721, ERC721Pausable) {
1887         super._beforeTokenTransfer(_from, _to, _tokenId);
1888     }
1889 }