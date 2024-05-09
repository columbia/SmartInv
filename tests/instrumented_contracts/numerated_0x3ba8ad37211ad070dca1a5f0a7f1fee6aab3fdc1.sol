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
370 // File: @openzeppelin/contracts/security/Pausable.sol
371 
372 
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Contract module which allows children to implement an emergency stop
379  * mechanism that can be triggered by an authorized account.
380  *
381  * This module is used through inheritance. It will make available the
382  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
383  * the functions of your contract. Note that they will not be pausable by
384  * simply including this module, only once the modifiers are put in place.
385  */
386 abstract contract Pausable is Context {
387     /**
388      * @dev Emitted when the pause is triggered by `account`.
389      */
390     event Paused(address account);
391 
392     /**
393      * @dev Emitted when the pause is lifted by `account`.
394      */
395     event Unpaused(address account);
396 
397     bool private _paused;
398 
399     /**
400      * @dev Initializes the contract in unpaused state.
401      */
402     constructor() {
403         _paused = false;
404     }
405 
406     /**
407      * @dev Returns true if the contract is paused, and false otherwise.
408      */
409     function paused() public view virtual returns (bool) {
410         return _paused;
411     }
412 
413     /**
414      * @dev Modifier to make a function callable only when the contract is not paused.
415      *
416      * Requirements:
417      *
418      * - The contract must not be paused.
419      */
420     modifier whenNotPaused() {
421         require(!paused(), "Pausable: paused");
422         _;
423     }
424 
425     /**
426      * @dev Modifier to make a function callable only when the contract is paused.
427      *
428      * Requirements:
429      *
430      * - The contract must be paused.
431      */
432     modifier whenPaused() {
433         require(paused(), "Pausable: not paused");
434         _;
435     }
436 
437     /**
438      * @dev Triggers stopped state.
439      *
440      * Requirements:
441      *
442      * - The contract must not be paused.
443      */
444     function _pause() internal virtual whenNotPaused {
445         _paused = true;
446         emit Paused(_msgSender());
447     }
448 
449     /**
450      * @dev Returns to normal state.
451      *
452      * Requirements:
453      *
454      * - The contract must be paused.
455      */
456     function _unpause() internal virtual whenPaused {
457         _paused = false;
458         emit Unpaused(_msgSender());
459     }
460 }
461 
462 // File: @openzeppelin/contracts/access/Ownable.sol
463 
464 
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Contract module which provides a basic access control mechanism, where
471  * there is an account (an owner) that can be granted exclusive access to
472  * specific functions.
473  *
474  * By default, the owner account will be the one that deploys the contract. This
475  * can later be changed with {transferOwnership}.
476  *
477  * This module is used through inheritance. It will make available the modifier
478  * `onlyOwner`, which can be applied to your functions to restrict their use to
479  * the owner.
480  */
481 abstract contract Ownable is Context {
482     address private _owner;
483 
484     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
485 
486     /**
487      * @dev Initializes the contract setting the deployer as the initial owner.
488      */
489     constructor() {
490         _setOwner(_msgSender());
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view virtual returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(owner() == _msgSender(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Leaves the contract without owner. It will not be possible to call
510      * `onlyOwner` functions anymore. Can only be called by the current owner.
511      *
512      * NOTE: Renouncing ownership will leave the contract without an owner,
513      * thereby removing any functionality that is only available to the owner.
514      */
515     function renounceOwnership() public virtual onlyOwner {
516         _setOwner(address(0));
517     }
518 
519     /**
520      * @dev Transfers ownership of the contract to a new account (`newOwner`).
521      * Can only be called by the current owner.
522      */
523     function transferOwnership(address newOwner) public virtual onlyOwner {
524         require(newOwner != address(0), "Ownable: new owner is the zero address");
525         _setOwner(newOwner);
526     }
527 
528     function _setOwner(address newOwner) private {
529         address oldOwner = _owner;
530         _owner = newOwner;
531         emit OwnershipTransferred(oldOwner, newOwner);
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
984 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
985 
986 
987 
988 pragma solidity ^0.8.0;
989 
990 
991 /**
992  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
993  * @dev See https://eips.ethereum.org/EIPS/eip-721
994  */
995 interface IERC721Enumerable is IERC721 {
996     /**
997      * @dev Returns the total amount of tokens stored by the contract.
998      */
999     function totalSupply() external view returns (uint256);
1000 
1001     /**
1002      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1003      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1004      */
1005     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1006 
1007     /**
1008      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1009      * Use along with {totalSupply} to enumerate all tokens.
1010      */
1011     function tokenByIndex(uint256 index) external view returns (uint256);
1012 }
1013 
1014 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1015 
1016 
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 
1021 /**
1022  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1023  * @dev See https://eips.ethereum.org/EIPS/eip-721
1024  */
1025 interface IERC721Metadata is IERC721 {
1026     /**
1027      * @dev Returns the token collection name.
1028      */
1029     function name() external view returns (string memory);
1030 
1031     /**
1032      * @dev Returns the token collection symbol.
1033      */
1034     function symbol() external view returns (string memory);
1035 
1036     /**
1037      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1038      */
1039     function tokenURI(uint256 tokenId) external view returns (string memory);
1040 }
1041 
1042 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1043 
1044 
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 /**
1056  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1057  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1058  * {ERC721Enumerable}.
1059  */
1060 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1061     using Address for address;
1062     using Strings for uint256;
1063 
1064     // Token name
1065     string private _name;
1066 
1067     // Token symbol
1068     string private _symbol;
1069 
1070     // Mapping from token ID to owner address
1071     mapping(uint256 => address) private _owners;
1072 
1073     // Mapping owner address to token count
1074     mapping(address => uint256) private _balances;
1075 
1076     // Mapping from token ID to approved address
1077     mapping(uint256 => address) private _tokenApprovals;
1078 
1079     // Mapping from owner to operator approvals
1080     mapping(address => mapping(address => bool)) private _operatorApprovals;
1081 
1082     /**
1083      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1084      */
1085     constructor(string memory name_, string memory symbol_) {
1086         _name = name_;
1087         _symbol = symbol_;
1088     }
1089 
1090     /**
1091      * @dev See {IERC165-supportsInterface}.
1092      */
1093     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1094         return
1095             interfaceId == type(IERC721).interfaceId ||
1096             interfaceId == type(IERC721Metadata).interfaceId ||
1097             super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-balanceOf}.
1102      */
1103     function balanceOf(address owner) public view virtual override returns (uint256) {
1104         require(owner != address(0), "ERC721: balance query for the zero address");
1105         return _balances[owner];
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-ownerOf}.
1110      */
1111     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1112         address owner = _owners[tokenId];
1113         require(owner != address(0), "ERC721: owner query for nonexistent token");
1114         return owner;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Metadata-name}.
1119      */
1120     function name() public view virtual override returns (string memory) {
1121         return _name;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Metadata-symbol}.
1126      */
1127     function symbol() public view virtual override returns (string memory) {
1128         return _symbol;
1129     }
1130 
1131     /**
1132      * @dev See {IERC721Metadata-tokenURI}.
1133      */
1134     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1135         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1136 
1137         string memory baseURI = _baseURI();
1138         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1139     }
1140 
1141     /**
1142      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1143      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1144      * by default, can be overriden in child contracts.
1145      */
1146     function _baseURI() internal view virtual returns (string memory) {
1147         return "";
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-approve}.
1152      */
1153     function approve(address to, uint256 tokenId) public virtual override {
1154         address owner = ERC721.ownerOf(tokenId);
1155         require(to != owner, "ERC721: approval to current owner");
1156 
1157         require(
1158             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1159             "ERC721: approve caller is not owner nor approved for all"
1160         );
1161 
1162         _approve(to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-getApproved}.
1167      */
1168     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1169         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1170 
1171         return _tokenApprovals[tokenId];
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-setApprovalForAll}.
1176      */
1177     function setApprovalForAll(address operator, bool approved) public virtual override {
1178         require(operator != _msgSender(), "ERC721: approve to caller");
1179 
1180         _operatorApprovals[_msgSender()][operator] = approved;
1181         emit ApprovalForAll(_msgSender(), operator, approved);
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-isApprovedForAll}.
1186      */
1187     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1188         return _operatorApprovals[owner][operator];
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-transferFrom}.
1193      */
1194     function transferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) public virtual override {
1199         //solhint-disable-next-line max-line-length
1200         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1201 
1202         _transfer(from, to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-safeTransferFrom}.
1207      */
1208     function safeTransferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) public virtual override {
1213         safeTransferFrom(from, to, tokenId, "");
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-safeTransferFrom}.
1218      */
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) public virtual override {
1225         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1226         _safeTransfer(from, to, tokenId, _data);
1227     }
1228 
1229     /**
1230      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1231      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1232      *
1233      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1234      *
1235      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1236      * implement alternative mechanisms to perform token transfer, such as signature-based.
1237      *
1238      * Requirements:
1239      *
1240      * - `from` cannot be the zero address.
1241      * - `to` cannot be the zero address.
1242      * - `tokenId` token must exist and be owned by `from`.
1243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _safeTransfer(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory _data
1252     ) internal virtual {
1253         _transfer(from, to, tokenId);
1254         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1255     }
1256 
1257     /**
1258      * @dev Returns whether `tokenId` exists.
1259      *
1260      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1261      *
1262      * Tokens start existing when they are minted (`_mint`),
1263      * and stop existing when they are burned (`_burn`).
1264      */
1265     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1266         return _owners[tokenId] != address(0);
1267     }
1268 
1269     /**
1270      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1271      *
1272      * Requirements:
1273      *
1274      * - `tokenId` must exist.
1275      */
1276     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1277         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1278         address owner = ERC721.ownerOf(tokenId);
1279         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1280     }
1281 
1282     /**
1283      * @dev Safely mints `tokenId` and transfers it to `to`.
1284      *
1285      * Requirements:
1286      *
1287      * - `tokenId` must not exist.
1288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _safeMint(address to, uint256 tokenId) internal virtual {
1293         _safeMint(to, tokenId, "");
1294     }
1295 
1296     /**
1297      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1298      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1299      */
1300     function _safeMint(
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) internal virtual {
1305         _mint(to, tokenId);
1306         require(
1307             _checkOnERC721Received(address(0), to, tokenId, _data),
1308             "ERC721: transfer to non ERC721Receiver implementer"
1309         );
1310     }
1311 
1312     /**
1313      * @dev Mints `tokenId` and transfers it to `to`.
1314      *
1315      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must not exist.
1320      * - `to` cannot be the zero address.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function _mint(address to, uint256 tokenId) internal virtual {
1325         require(to != address(0), "ERC721: mint to the zero address");
1326         require(!_exists(tokenId), "ERC721: token already minted");
1327 
1328         _beforeTokenTransfer(address(0), to, tokenId);
1329 
1330         _balances[to] += 1;
1331         _owners[tokenId] = to;
1332 
1333         emit Transfer(address(0), to, tokenId);
1334     }
1335 
1336     /**
1337      * @dev Destroys `tokenId`.
1338      * The approval is cleared when the token is burned.
1339      *
1340      * Requirements:
1341      *
1342      * - `tokenId` must exist.
1343      *
1344      * Emits a {Transfer} event.
1345      */
1346     function _burn(uint256 tokenId) internal virtual {
1347         address owner = ERC721.ownerOf(tokenId);
1348 
1349         _beforeTokenTransfer(owner, address(0), tokenId);
1350 
1351         // Clear approvals
1352         _approve(address(0), tokenId);
1353 
1354         _balances[owner] -= 1;
1355         delete _owners[tokenId];
1356 
1357         emit Transfer(owner, address(0), tokenId);
1358     }
1359 
1360     /**
1361      * @dev Transfers `tokenId` from `from` to `to`.
1362      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1363      *
1364      * Requirements:
1365      *
1366      * - `to` cannot be the zero address.
1367      * - `tokenId` token must be owned by `from`.
1368      *
1369      * Emits a {Transfer} event.
1370      */
1371     function _transfer(
1372         address from,
1373         address to,
1374         uint256 tokenId
1375     ) internal virtual {
1376         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1377         require(to != address(0), "ERC721: transfer to the zero address");
1378 
1379         _beforeTokenTransfer(from, to, tokenId);
1380 
1381         // Clear approvals from the previous owner
1382         _approve(address(0), tokenId);
1383 
1384         _balances[from] -= 1;
1385         _balances[to] += 1;
1386         _owners[tokenId] = to;
1387 
1388         emit Transfer(from, to, tokenId);
1389     }
1390 
1391     /**
1392      * @dev Approve `to` to operate on `tokenId`
1393      *
1394      * Emits a {Approval} event.
1395      */
1396     function _approve(address to, uint256 tokenId) internal virtual {
1397         _tokenApprovals[tokenId] = to;
1398         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1399     }
1400 
1401     /**
1402      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1403      * The call is not executed if the target address is not a contract.
1404      *
1405      * @param from address representing the previous owner of the given token ID
1406      * @param to target address that will receive the tokens
1407      * @param tokenId uint256 ID of the token to be transferred
1408      * @param _data bytes optional data to send along with the call
1409      * @return bool whether the call correctly returned the expected magic value
1410      */
1411     function _checkOnERC721Received(
1412         address from,
1413         address to,
1414         uint256 tokenId,
1415         bytes memory _data
1416     ) private returns (bool) {
1417         if (to.isContract()) {
1418             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1419                 return retval == IERC721Receiver.onERC721Received.selector;
1420             } catch (bytes memory reason) {
1421                 if (reason.length == 0) {
1422                     revert("ERC721: transfer to non ERC721Receiver implementer");
1423                 } else {
1424                     assembly {
1425                         revert(add(32, reason), mload(reason))
1426                     }
1427                 }
1428             }
1429         } else {
1430             return true;
1431         }
1432     }
1433 
1434     /**
1435      * @dev Hook that is called before any token transfer. This includes minting
1436      * and burning.
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1441      * transferred to `to`.
1442      * - When `from` is zero, `tokenId` will be minted for `to`.
1443      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1444      * - `from` and `to` are never both zero.
1445      *
1446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1447      */
1448     function _beforeTokenTransfer(
1449         address from,
1450         address to,
1451         uint256 tokenId
1452     ) internal virtual {}
1453 }
1454 
1455 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1456 
1457 
1458 
1459 pragma solidity ^0.8.0;
1460 
1461 
1462 
1463 /**
1464  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1465  * enumerability of all the token ids in the contract as well as all token ids owned by each
1466  * account.
1467  */
1468 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1469     // Mapping from owner to list of owned token IDs
1470     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1471 
1472     // Mapping from token ID to index of the owner tokens list
1473     mapping(uint256 => uint256) private _ownedTokensIndex;
1474 
1475     // Array with all token ids, used for enumeration
1476     uint256[] private _allTokens;
1477 
1478     // Mapping from token id to position in the allTokens array
1479     mapping(uint256 => uint256) private _allTokensIndex;
1480 
1481     /**
1482      * @dev See {IERC165-supportsInterface}.
1483      */
1484     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1485         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1486     }
1487 
1488     /**
1489      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1490      */
1491     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1492         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1493         return _ownedTokens[owner][index];
1494     }
1495 
1496     /**
1497      * @dev See {IERC721Enumerable-totalSupply}.
1498      */
1499     function totalSupply() public view virtual override returns (uint256) {
1500         return _allTokens.length;
1501     }
1502 
1503     /**
1504      * @dev See {IERC721Enumerable-tokenByIndex}.
1505      */
1506     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1507         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1508         return _allTokens[index];
1509     }
1510 
1511     /**
1512      * @dev Hook that is called before any token transfer. This includes minting
1513      * and burning.
1514      *
1515      * Calling conditions:
1516      *
1517      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1518      * transferred to `to`.
1519      * - When `from` is zero, `tokenId` will be minted for `to`.
1520      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1521      * - `from` cannot be the zero address.
1522      * - `to` cannot be the zero address.
1523      *
1524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1525      */
1526     function _beforeTokenTransfer(
1527         address from,
1528         address to,
1529         uint256 tokenId
1530     ) internal virtual override {
1531         super._beforeTokenTransfer(from, to, tokenId);
1532 
1533         if (from == address(0)) {
1534             _addTokenToAllTokensEnumeration(tokenId);
1535         } else if (from != to) {
1536             _removeTokenFromOwnerEnumeration(from, tokenId);
1537         }
1538         if (to == address(0)) {
1539             _removeTokenFromAllTokensEnumeration(tokenId);
1540         } else if (to != from) {
1541             _addTokenToOwnerEnumeration(to, tokenId);
1542         }
1543     }
1544 
1545     /**
1546      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1547      * @param to address representing the new owner of the given token ID
1548      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1549      */
1550     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1551         uint256 length = ERC721.balanceOf(to);
1552         _ownedTokens[to][length] = tokenId;
1553         _ownedTokensIndex[tokenId] = length;
1554     }
1555 
1556     /**
1557      * @dev Private function to add a token to this extension's token tracking data structures.
1558      * @param tokenId uint256 ID of the token to be added to the tokens list
1559      */
1560     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1561         _allTokensIndex[tokenId] = _allTokens.length;
1562         _allTokens.push(tokenId);
1563     }
1564 
1565     /**
1566      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1567      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1568      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1569      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1570      * @param from address representing the previous owner of the given token ID
1571      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1572      */
1573     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1574         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1575         // then delete the last slot (swap and pop).
1576 
1577         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1578         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1579 
1580         // When the token to delete is the last token, the swap operation is unnecessary
1581         if (tokenIndex != lastTokenIndex) {
1582             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1583 
1584             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1585             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1586         }
1587 
1588         // This also deletes the contents at the last position of the array
1589         delete _ownedTokensIndex[tokenId];
1590         delete _ownedTokens[from][lastTokenIndex];
1591     }
1592 
1593     /**
1594      * @dev Private function to remove a token from this extension's token tracking data structures.
1595      * This has O(1) time complexity, but alters the order of the _allTokens array.
1596      * @param tokenId uint256 ID of the token to be removed from the tokens list
1597      */
1598     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1599         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1600         // then delete the last slot (swap and pop).
1601 
1602         uint256 lastTokenIndex = _allTokens.length - 1;
1603         uint256 tokenIndex = _allTokensIndex[tokenId];
1604 
1605         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1606         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1607         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1608         uint256 lastTokenId = _allTokens[lastTokenIndex];
1609 
1610         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1611         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1612 
1613         // This also deletes the contents at the last position of the array
1614         delete _allTokensIndex[tokenId];
1615         _allTokens.pop();
1616     }
1617 }
1618 
1619 // File: contracts/StickManERC721.sol
1620 
1621 
1622 pragma solidity ^0.8.9;
1623 
1624 
1625 
1626 
1627 
1628 
1629 /*
1630  ____  _   _      _    __  __                  _    _____   __ _    _   _  __     __
1631 / ___|| |_(_) ___| | _|  \/  | __ _ _ __      / \  |_ _\ \ / // \  | | | | \ \   / /__ _ __ ___  ___
1632 \___ \| __| |/ __| |/ / |\/| |/ _` | '_ \    / _ \  | | \ V // _ \ | |_| |  \ \ / / _ \ '__/ __|/ _ \
1633  ___) | |_| | (__|   <| |  | | (_| | | | |  / ___ \ | |  | |/ ___ \|  _  |   \ V /  __/ |  \__ \  __/
1634 |____/ \__|_|\___|_|\_\_|  |_|\__,_|_| |_| /_/   \_\___| |_/_/   \_\_| |_|    \_/ \___|_|  |___/\___|
1635 
1636 */
1637 
1638 contract StickManERC721 is ERC721Enumerable, Ownable {
1639 
1640     using SafeMath for uint256;
1641 
1642     string private _baseUri;
1643 
1644     uint256 constant public _MAX_SUPPLY = 5555;
1645 
1646     // reserved supply: 555
1647     uint256 public _currentSupply = 1555;
1648 
1649     uint8 public _saleStatus = 0;
1650 
1651     uint public _revealTokenId = 0;
1652 
1653     uint8 public _priceIncr = 0;
1654 
1655     uint8 public _phase = 1;
1656 
1657     uint8 public  _maxMintCount = 3;
1658 
1659     string private _secretFam;
1660 
1661     string private _secretWL;
1662 
1663     mapping(address => bool) public _giveawayAddrs;
1664 
1665     mapping(uint8 => mapping(address => uint8)) public _mintCounts;
1666 
1667     event syncMintedCount(uint256 count);
1668 
1669     event syncSaleStatus(uint8 status);
1670 
1671 
1672     constructor(string memory baseUri, string memory secretFam, string memory secretWL) ERC721("Aiyah Verse Stickman-X", "SMX") {
1673 
1674         _baseUri = baseUri;
1675         _secretFam = secretFam;
1676         _secretWL = secretWL;
1677     }
1678 
1679     function _baseURI() internal view virtual override returns (string memory) {
1680 
1681         return _baseUri;
1682     }
1683 
1684     function setBaseURI(string memory baseUri) public onlyOwner {
1685 
1686         _baseUri = baseUri;
1687     }
1688 
1689     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1690 
1691         require(_exists(tokenId), "tokenId not found");
1692 
1693         if (_revealTokenId >= tokenId) {
1694 
1695             return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json"));
1696         }
1697 
1698         return string(abi.encodePacked(_baseURI(), "unknown.json"));
1699     }
1700 
1701     function renounceOwnership() public virtual override onlyOwner {
1702 
1703         // disable it too dangerous
1704     }
1705 
1706     function check(uint8 status, address to, uint8 mintNum) private view {
1707 
1708         require(status == _saleStatus, "not yet on sale or sale status mismatch");
1709         require(_mintCounts[_phase][to] + mintNum <= _maxMintCount, "over max mint count");
1710         require(mintNum > 0 && mintNum <= _maxMintCount, "over batch mint count");
1711         require(totalSupply().add(mintNum) <= _currentSupply.sub(555), "sold out");
1712     }
1713 
1714     function goMint(address to, uint8 mintNum) private {
1715 
1716         for (uint8 i = 1; i <= mintNum; i++) {
1717 
1718             _safeMint(to, totalSupply().add(1));
1719         }
1720 
1721         _mintCounts[_phase][to] += mintNum;
1722 
1723         emit syncMintedCount(totalSupply());
1724     }
1725 
1726     function famSaleMint(uint8 mintNum, bytes32 hash) public payable {
1727 
1728         check(1, msg.sender, mintNum);
1729         require(hash == sha256(abi.encodePacked(msg.sender, _secretFam)), "permission denied");
1730         require(msg.value == ((0.06 ether + (uint(_priceIncr) * 0.01 ether)) * uint(mintNum)), "ether value incorrect");
1731         goMint(msg.sender, mintNum);
1732     }
1733 
1734     function preSaleMint(uint8 mintNum, bytes32 hash) public payable {
1735 
1736         check(2, msg.sender, mintNum);
1737         require(hash == sha256(abi.encodePacked(msg.sender, _secretWL)), "permission denied");
1738         require(msg.value == ((0.07 ether + (uint(_priceIncr) * 0.01 ether)) * uint(mintNum)), "ether value incorrect");
1739         goMint(msg.sender, mintNum);
1740     }
1741 
1742     function publicSaleMint(uint8 mintNum) public payable {
1743 
1744         check(4, msg.sender, mintNum);
1745         require(msg.value == ((0.08 ether + (uint(_priceIncr) * 0.01 ether)) * uint(mintNum)), "ether value incorrect");
1746         goMint(msg.sender, mintNum);
1747     }
1748 
1749     function giveawayMint() public {
1750 
1751         require(_saleStatus > 0, "not yet on sale or sale status mismatch");
1752         require(totalSupply().add(1) <= _currentSupply.sub(555), "sold out");
1753         require(_giveawayAddrs[msg.sender] == true, "permission denied");
1754         delete _giveawayAddrs[msg.sender];
1755 
1756         _safeMint(msg.sender, totalSupply().add(1));
1757 
1758         emit syncMintedCount(totalSupply());
1759     }
1760 
1761     function ownerMint(uint8 mintNum) public onlyOwner {
1762 
1763         require(totalSupply().add(mintNum) <= _currentSupply, "sold out");
1764         goMint(msg.sender, mintNum);
1765     }
1766 
1767     function addGiveaway(address[] memory addresses) public onlyOwner {
1768 
1769         for (uint i = 0; i < addresses.length; i++) {
1770 
1771             _giveawayAddrs[addresses[i]] = true;
1772         }
1773     }
1774 
1775     function deleteGiveaway(address[] memory addresses) public onlyOwner {
1776 
1777         for (uint i = 0; i < addresses.length; i++) {
1778 
1779             delete _giveawayAddrs[addresses[i]];
1780         }
1781     }
1782 
1783     function setSecret(string memory secretFam, string memory secretWL) public onlyOwner {
1784 
1785         _secretFam = secretFam;
1786         _secretWL = secretWL;
1787     }
1788 
1789     function setSaleStatus(uint8 saleStatus) public onlyOwner {
1790 
1791         _saleStatus = saleStatus;
1792 
1793         emit syncSaleStatus(_saleStatus);
1794     }
1795 
1796     function setRevealTokenId(uint revealTokenId) public onlyOwner {
1797 
1798         _revealTokenId = revealTokenId;
1799     }
1800 
1801     function setPhaseConfig(uint8 phase, uint8 priceIncr, uint8 maxMintCount) public onlyOwner {
1802 
1803         _phase = phase;
1804         _priceIncr = priceIncr;
1805         _maxMintCount = maxMintCount;
1806     }
1807 
1808     function setCurrentSupply(uint currentSupply) public onlyOwner {
1809 
1810         require(currentSupply <= _MAX_SUPPLY, "over max supply");
1811         _currentSupply = currentSupply;
1812     }
1813 
1814     function withdraw() public virtual onlyOwner {
1815 
1816         Address.sendValue(payable(owner()), address(this).balance);
1817     }
1818 
1819     function getBalance() public onlyOwner view returns (uint256) {
1820 
1821         return address(this).balance;
1822     }
1823 
1824 }