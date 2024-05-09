1 // File: contracts/ILoot.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface ILoot {
7   function balanceOf(address owner) external view returns (uint256 balance);
8 }
9 
10 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
11 
12 
13 
14 pragma solidity ^0.8.0;
15 
16 // CAUTION
17 // This version of SafeMath should only be used with Solidity 0.8 or later,
18 // because it relies on the compiler's built in overflow checks.
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations.
22  *
23  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
24  * now has built in overflow checking.
25  */
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             uint256 c = a + b;
35             if (c < a) return (false, 0);
36             return (true, c);
37         }
38     }
39 
40     /**
41      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             if (b > a) return (false, 0);
48             return (true, a - b);
49         }
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         unchecked {
59             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60             // benefit is lost if 'b' is also tested.
61             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62             if (a == 0) return (true, 0);
63             uint256 c = a * b;
64             if (c / a != b) return (false, 0);
65             return (true, c);
66         }
67     }
68 
69     /**
70      * @dev Returns the division of two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a / b);
78         }
79     }
80 
81     /**
82      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
83      *
84      * _Available since v3.4._
85      */
86     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         unchecked {
88             if (b == 0) return (false, 0);
89             return (true, a % b);
90         }
91     }
92 
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a + b;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return a - b;
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `*` operator.
126      *
127      * Requirements:
128      *
129      * - Multiplication cannot overflow.
130      */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a * b;
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers, reverting on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator.
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a / b;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * reverting when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a % b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * CAUTION: This function is deprecated because it requires allocating memory for the error
170      * message unnecessarily. For custom revert reasons use {trySub}.
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(
179         uint256 a,
180         uint256 b,
181         string memory errorMessage
182     ) internal pure returns (uint256) {
183         unchecked {
184             require(b <= a, errorMessage);
185             return a - b;
186         }
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(
202         uint256 a,
203         uint256 b,
204         string memory errorMessage
205     ) internal pure returns (uint256) {
206         unchecked {
207             require(b > 0, errorMessage);
208             return a / b;
209         }
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * reverting with custom message when dividing by zero.
215      *
216      * CAUTION: This function is deprecated because it requires allocating memory for the error
217      * message unnecessarily. For custom revert reasons use {tryMod}.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(
228         uint256 a,
229         uint256 b,
230         string memory errorMessage
231     ) internal pure returns (uint256) {
232         unchecked {
233             require(b > 0, errorMessage);
234             return a % b;
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Counters.sol
240 
241 
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
284 // File: @openzeppelin/contracts/utils/Strings.sol
285 
286 
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev String operations.
292  */
293 library Strings {
294     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
298      */
299     function toString(uint256 value) internal pure returns (string memory) {
300         // Inspired by OraclizeAPI's implementation - MIT licence
301         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
302 
303         if (value == 0) {
304             return "0";
305         }
306         uint256 temp = value;
307         uint256 digits;
308         while (temp != 0) {
309             digits++;
310             temp /= 10;
311         }
312         bytes memory buffer = new bytes(digits);
313         while (value != 0) {
314             digits -= 1;
315             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
316             value /= 10;
317         }
318         return string(buffer);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
323      */
324     function toHexString(uint256 value) internal pure returns (string memory) {
325         if (value == 0) {
326             return "0x00";
327         }
328         uint256 temp = value;
329         uint256 length = 0;
330         while (temp != 0) {
331             length++;
332             temp >>= 8;
333         }
334         return toHexString(value, length);
335     }
336 
337     /**
338      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
339      */
340     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
341         bytes memory buffer = new bytes(2 * length + 2);
342         buffer[0] = "0";
343         buffer[1] = "x";
344         for (uint256 i = 2 * length + 1; i > 1; --i) {
345             buffer[i] = _HEX_SYMBOLS[value & 0xf];
346             value >>= 4;
347         }
348         require(value == 0, "Strings: hex length insufficient");
349         return string(buffer);
350     }
351 }
352 
353 // File: @openzeppelin/contracts/utils/Context.sol
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Provides information about the current execution context, including the
361  * sender of the transaction and its data. While these are generally available
362  * via msg.sender and msg.data, they should not be accessed in such a direct
363  * manner, since when dealing with meta-transactions the account sending and
364  * paying for execution may not be the actual sender (as far as an application
365  * is concerned).
366  *
367  * This contract is only required for intermediate, library-like contracts.
368  */
369 abstract contract Context {
370     function _msgSender() internal view virtual returns (address) {
371         return msg.sender;
372     }
373 
374     function _msgData() internal view virtual returns (bytes calldata) {
375         return msg.data;
376     }
377 }
378 
379 // File: @openzeppelin/contracts/security/Pausable.sol
380 
381 
382 
383 pragma solidity ^0.8.0;
384 
385 
386 /**
387  * @dev Contract module which allows children to implement an emergency stop
388  * mechanism that can be triggered by an authorized account.
389  *
390  * This module is used through inheritance. It will make available the
391  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
392  * the functions of your contract. Note that they will not be pausable by
393  * simply including this module, only once the modifiers are put in place.
394  */
395 abstract contract Pausable is Context {
396     /**
397      * @dev Emitted when the pause is triggered by `account`.
398      */
399     event Paused(address account);
400 
401     /**
402      * @dev Emitted when the pause is lifted by `account`.
403      */
404     event Unpaused(address account);
405 
406     bool private _paused;
407 
408     /**
409      * @dev Initializes the contract in unpaused state.
410      */
411     constructor() {
412         _paused = false;
413     }
414 
415     /**
416      * @dev Returns true if the contract is paused, and false otherwise.
417      */
418     function paused() public view virtual returns (bool) {
419         return _paused;
420     }
421 
422     /**
423      * @dev Modifier to make a function callable only when the contract is not paused.
424      *
425      * Requirements:
426      *
427      * - The contract must not be paused.
428      */
429     modifier whenNotPaused() {
430         require(!paused(), "Pausable: paused");
431         _;
432     }
433 
434     /**
435      * @dev Modifier to make a function callable only when the contract is paused.
436      *
437      * Requirements:
438      *
439      * - The contract must be paused.
440      */
441     modifier whenPaused() {
442         require(paused(), "Pausable: not paused");
443         _;
444     }
445 
446     /**
447      * @dev Triggers stopped state.
448      *
449      * Requirements:
450      *
451      * - The contract must not be paused.
452      */
453     function _pause() internal virtual whenNotPaused {
454         _paused = true;
455         emit Paused(_msgSender());
456     }
457 
458     /**
459      * @dev Returns to normal state.
460      *
461      * Requirements:
462      *
463      * - The contract must be paused.
464      */
465     function _unpause() internal virtual whenPaused {
466         _paused = false;
467         emit Unpaused(_msgSender());
468     }
469 }
470 
471 // File: @openzeppelin/contracts/access/Ownable.sol
472 
473 
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Contract module which provides a basic access control mechanism, where
480  * there is an account (an owner) that can be granted exclusive access to
481  * specific functions.
482  *
483  * By default, the owner account will be the one that deploys the contract. This
484  * can later be changed with {transferOwnership}.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 abstract contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor() {
499         _setOwner(_msgSender());
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view virtual returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         require(owner() == _msgSender(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         _setOwner(address(0));
526     }
527 
528     /**
529      * @dev Transfers ownership of the contract to a new account (`newOwner`).
530      * Can only be called by the current owner.
531      */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         _setOwner(newOwner);
535     }
536 
537     function _setOwner(address newOwner) private {
538         address oldOwner = _owner;
539         _owner = newOwner;
540         emit OwnershipTransferred(oldOwner, newOwner);
541     }
542 }
543 
544 // File: @openzeppelin/contracts/utils/Address.sol
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev Collection of functions related to the address type
552  */
553 library Address {
554     /**
555      * @dev Returns true if `account` is a contract.
556      *
557      * [IMPORTANT]
558      * ====
559      * It is unsafe to assume that an address for which this function returns
560      * false is an externally-owned account (EOA) and not a contract.
561      *
562      * Among others, `isContract` will return false for the following
563      * types of addresses:
564      *
565      *  - an externally-owned account
566      *  - a contract in construction
567      *  - an address where a contract will be created
568      *  - an address where a contract lived, but was destroyed
569      * ====
570      */
571     function isContract(address account) internal view returns (bool) {
572         // This method relies on extcodesize, which returns 0 for contracts in
573         // construction, since the code is only stored at the end of the
574         // constructor execution.
575 
576         uint256 size;
577         assembly {
578             size := extcodesize(account)
579         }
580         return size > 0;
581     }
582 
583     /**
584      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
585      * `recipient`, forwarding all available gas and reverting on errors.
586      *
587      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
588      * of certain opcodes, possibly making contracts go over the 2300 gas limit
589      * imposed by `transfer`, making them unable to receive funds via
590      * `transfer`. {sendValue} removes this limitation.
591      *
592      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
593      *
594      * IMPORTANT: because control is transferred to `recipient`, care must be
595      * taken to not create reentrancy vulnerabilities. Consider using
596      * {ReentrancyGuard} or the
597      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
598      */
599     function sendValue(address payable recipient, uint256 amount) internal {
600         require(address(this).balance >= amount, "Address: insufficient balance");
601 
602         (bool success, ) = recipient.call{value: amount}("");
603         require(success, "Address: unable to send value, recipient may have reverted");
604     }
605 
606     /**
607      * @dev Performs a Solidity function call using a low level `call`. A
608      * plain `call` is an unsafe replacement for a function call: use this
609      * function instead.
610      *
611      * If `target` reverts with a revert reason, it is bubbled up by this
612      * function (like regular Solidity function calls).
613      *
614      * Returns the raw returned data. To convert to the expected return value,
615      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
616      *
617      * Requirements:
618      *
619      * - `target` must be a contract.
620      * - calling `target` with `data` must not revert.
621      *
622      * _Available since v3.1._
623      */
624     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
625         return functionCall(target, data, "Address: low-level call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
630      * `errorMessage` as a fallback revert reason when `target` reverts.
631      *
632      * _Available since v3.1._
633      */
634     function functionCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal returns (bytes memory) {
639         return functionCallWithValue(target, data, 0, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but also transferring `value` wei to `target`.
645      *
646      * Requirements:
647      *
648      * - the calling contract must have an ETH balance of at least `value`.
649      * - the called Solidity function must be `payable`.
650      *
651      * _Available since v3.1._
652      */
653     function functionCallWithValue(
654         address target,
655         bytes memory data,
656         uint256 value
657     ) internal returns (bytes memory) {
658         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
663      * with `errorMessage` as a fallback revert reason when `target` reverts.
664      *
665      * _Available since v3.1._
666      */
667     function functionCallWithValue(
668         address target,
669         bytes memory data,
670         uint256 value,
671         string memory errorMessage
672     ) internal returns (bytes memory) {
673         require(address(this).balance >= value, "Address: insufficient balance for call");
674         require(isContract(target), "Address: call to non-contract");
675 
676         (bool success, bytes memory returndata) = target.call{value: value}(data);
677         return verifyCallResult(success, returndata, errorMessage);
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
682      * but performing a static call.
683      *
684      * _Available since v3.3._
685      */
686     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
687         return functionStaticCall(target, data, "Address: low-level static call failed");
688     }
689 
690     /**
691      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
692      * but performing a static call.
693      *
694      * _Available since v3.3._
695      */
696     function functionStaticCall(
697         address target,
698         bytes memory data,
699         string memory errorMessage
700     ) internal view returns (bytes memory) {
701         require(isContract(target), "Address: static call to non-contract");
702 
703         (bool success, bytes memory returndata) = target.staticcall(data);
704         return verifyCallResult(success, returndata, errorMessage);
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
709      * but performing a delegate call.
710      *
711      * _Available since v3.4._
712      */
713     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
714         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
719      * but performing a delegate call.
720      *
721      * _Available since v3.4._
722      */
723     function functionDelegateCall(
724         address target,
725         bytes memory data,
726         string memory errorMessage
727     ) internal returns (bytes memory) {
728         require(isContract(target), "Address: delegate call to non-contract");
729 
730         (bool success, bytes memory returndata) = target.delegatecall(data);
731         return verifyCallResult(success, returndata, errorMessage);
732     }
733 
734     /**
735      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
736      * revert reason using the provided one.
737      *
738      * _Available since v4.3._
739      */
740     function verifyCallResult(
741         bool success,
742         bytes memory returndata,
743         string memory errorMessage
744     ) internal pure returns (bytes memory) {
745         if (success) {
746             return returndata;
747         } else {
748             // Look for revert reason and bubble it up if present
749             if (returndata.length > 0) {
750                 // The easiest way to bubble the revert reason is using memory via assembly
751 
752                 assembly {
753                     let returndata_size := mload(returndata)
754                     revert(add(32, returndata), returndata_size)
755                 }
756             } else {
757                 revert(errorMessage);
758             }
759         }
760     }
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
764 
765 
766 
767 pragma solidity ^0.8.0;
768 
769 /**
770  * @title ERC721 token receiver interface
771  * @dev Interface for any contract that wants to support safeTransfers
772  * from ERC721 asset contracts.
773  */
774 interface IERC721Receiver {
775     /**
776      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
777      * by `operator` from `from`, this function is called.
778      *
779      * It must return its Solidity selector to confirm the token transfer.
780      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
781      *
782      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
783      */
784     function onERC721Received(
785         address operator,
786         address from,
787         uint256 tokenId,
788         bytes calldata data
789     ) external returns (bytes4);
790 }
791 
792 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
793 
794 
795 
796 pragma solidity ^0.8.0;
797 
798 /**
799  * @dev Interface of the ERC165 standard, as defined in the
800  * https://eips.ethereum.org/EIPS/eip-165[EIP].
801  *
802  * Implementers can declare support of contract interfaces, which can then be
803  * queried by others ({ERC165Checker}).
804  *
805  * For an implementation, see {ERC165}.
806  */
807 interface IERC165 {
808     /**
809      * @dev Returns true if this contract implements the interface defined by
810      * `interfaceId`. See the corresponding
811      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
812      * to learn more about how these ids are created.
813      *
814      * This function call must use less than 30 000 gas.
815      */
816     function supportsInterface(bytes4 interfaceId) external view returns (bool);
817 }
818 
819 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
820 
821 
822 
823 pragma solidity ^0.8.0;
824 
825 
826 /**
827  * @dev Implementation of the {IERC165} interface.
828  *
829  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
830  * for the additional interface id that will be supported. For example:
831  *
832  * ```solidity
833  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
834  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
835  * }
836  * ```
837  *
838  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
839  */
840 abstract contract ERC165 is IERC165 {
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
845         return interfaceId == type(IERC165).interfaceId;
846     }
847 }
848 
849 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
850 
851 
852 
853 pragma solidity ^0.8.0;
854 
855 
856 /**
857  * @dev Required interface of an ERC721 compliant contract.
858  */
859 interface IERC721 is IERC165 {
860     /**
861      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
862      */
863     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
864 
865     /**
866      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
867      */
868     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
869 
870     /**
871      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
872      */
873     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
874 
875     /**
876      * @dev Returns the number of tokens in ``owner``'s account.
877      */
878     function balanceOf(address owner) external view returns (uint256 balance);
879 
880     /**
881      * @dev Returns the owner of the `tokenId` token.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      */
887     function ownerOf(uint256 tokenId) external view returns (address owner);
888 
889     /**
890      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
891      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must exist and be owned by `from`.
898      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) external;
908 
909     /**
910      * @dev Transfers `tokenId` token from `from` to `to`.
911      *
912      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must be owned by `from`.
919      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
920      *
921      * Emits a {Transfer} event.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) external;
928 
929     /**
930      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
931      * The approval is cleared when the token is transferred.
932      *
933      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
934      *
935      * Requirements:
936      *
937      * - The caller must own the token or be an approved operator.
938      * - `tokenId` must exist.
939      *
940      * Emits an {Approval} event.
941      */
942     function approve(address to, uint256 tokenId) external;
943 
944     /**
945      * @dev Returns the account approved for `tokenId` token.
946      *
947      * Requirements:
948      *
949      * - `tokenId` must exist.
950      */
951     function getApproved(uint256 tokenId) external view returns (address operator);
952 
953     /**
954      * @dev Approve or remove `operator` as an operator for the caller.
955      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
956      *
957      * Requirements:
958      *
959      * - The `operator` cannot be the caller.
960      *
961      * Emits an {ApprovalForAll} event.
962      */
963     function setApprovalForAll(address operator, bool _approved) external;
964 
965     /**
966      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
967      *
968      * See {setApprovalForAll}
969      */
970     function isApprovedForAll(address owner, address operator) external view returns (bool);
971 
972     /**
973      * @dev Safely transfers `tokenId` token from `from` to `to`.
974      *
975      * Requirements:
976      *
977      * - `from` cannot be the zero address.
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must exist and be owned by `from`.
980      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
981      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
982      *
983      * Emits a {Transfer} event.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId,
989         bytes calldata data
990     ) external;
991 }
992 
993 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
994 
995 
996 
997 pragma solidity ^0.8.0;
998 
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 interface IERC721Metadata is IERC721 {
1005     /**
1006      * @dev Returns the token collection name.
1007      */
1008     function name() external view returns (string memory);
1009 
1010     /**
1011      * @dev Returns the token collection symbol.
1012      */
1013     function symbol() external view returns (string memory);
1014 
1015     /**
1016      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1017      */
1018     function tokenURI(uint256 tokenId) external view returns (string memory);
1019 }
1020 
1021 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1022 
1023 
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 
1028 
1029 
1030 
1031 
1032 
1033 
1034 /**
1035  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1036  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1037  * {ERC721Enumerable}.
1038  */
1039 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1040     using Address for address;
1041     using Strings for uint256;
1042 
1043     // Token name
1044     string private _name;
1045 
1046     // Token symbol
1047     string private _symbol;
1048 
1049     // Mapping from token ID to owner address
1050     mapping(uint256 => address) private _owners;
1051 
1052     // Mapping owner address to token count
1053     mapping(address => uint256) private _balances;
1054 
1055     // Mapping from token ID to approved address
1056     mapping(uint256 => address) private _tokenApprovals;
1057 
1058     // Mapping from owner to operator approvals
1059     mapping(address => mapping(address => bool)) private _operatorApprovals;
1060 
1061     /**
1062      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1063      */
1064     constructor(string memory name_, string memory symbol_) {
1065         _name = name_;
1066         _symbol = symbol_;
1067     }
1068 
1069     /**
1070      * @dev See {IERC165-supportsInterface}.
1071      */
1072     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1073         return
1074             interfaceId == type(IERC721).interfaceId ||
1075             interfaceId == type(IERC721Metadata).interfaceId ||
1076             super.supportsInterface(interfaceId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-balanceOf}.
1081      */
1082     function balanceOf(address owner) public view virtual override returns (uint256) {
1083         require(owner != address(0), "ERC721: balance query for the zero address");
1084         return _balances[owner];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-ownerOf}.
1089      */
1090     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1091         address owner = _owners[tokenId];
1092         require(owner != address(0), "ERC721: owner query for nonexistent token");
1093         return owner;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-name}.
1098      */
1099     function name() public view virtual override returns (string memory) {
1100         return _name;
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Metadata-symbol}.
1105      */
1106     function symbol() public view virtual override returns (string memory) {
1107         return _symbol;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Metadata-tokenURI}.
1112      */
1113     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1114         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1115 
1116         string memory baseURI = _baseURI();
1117         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1118     }
1119 
1120     /**
1121      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1122      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1123      * by default, can be overriden in child contracts.
1124      */
1125     function _baseURI() internal view virtual returns (string memory) {
1126         return "";
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-approve}.
1131      */
1132     function approve(address to, uint256 tokenId) public virtual override {
1133         address owner = ERC721.ownerOf(tokenId);
1134         require(to != owner, "ERC721: approval to current owner");
1135 
1136         require(
1137             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1138             "ERC721: approve caller is not owner nor approved for all"
1139         );
1140 
1141         _approve(to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-getApproved}.
1146      */
1147     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1148         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1149 
1150         return _tokenApprovals[tokenId];
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-setApprovalForAll}.
1155      */
1156     function setApprovalForAll(address operator, bool approved) public virtual override {
1157         require(operator != _msgSender(), "ERC721: approve to caller");
1158 
1159         _operatorApprovals[_msgSender()][operator] = approved;
1160         emit ApprovalForAll(_msgSender(), operator, approved);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-isApprovedForAll}.
1165      */
1166     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1167         return _operatorApprovals[owner][operator];
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-transferFrom}.
1172      */
1173     function transferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) public virtual override {
1178         //solhint-disable-next-line max-line-length
1179         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1180 
1181         _transfer(from, to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-safeTransferFrom}.
1186      */
1187     function safeTransferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public virtual override {
1192         safeTransferFrom(from, to, tokenId, "");
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-safeTransferFrom}.
1197      */
1198     function safeTransferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId,
1202         bytes memory _data
1203     ) public virtual override {
1204         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1205         _safeTransfer(from, to, tokenId, _data);
1206     }
1207 
1208     /**
1209      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1210      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1211      *
1212      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1213      *
1214      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1215      * implement alternative mechanisms to perform token transfer, such as signature-based.
1216      *
1217      * Requirements:
1218      *
1219      * - `from` cannot be the zero address.
1220      * - `to` cannot be the zero address.
1221      * - `tokenId` token must exist and be owned by `from`.
1222      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _safeTransfer(
1227         address from,
1228         address to,
1229         uint256 tokenId,
1230         bytes memory _data
1231     ) internal virtual {
1232         _transfer(from, to, tokenId);
1233         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1234     }
1235 
1236     /**
1237      * @dev Returns whether `tokenId` exists.
1238      *
1239      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1240      *
1241      * Tokens start existing when they are minted (`_mint`),
1242      * and stop existing when they are burned (`_burn`).
1243      */
1244     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1245         return _owners[tokenId] != address(0);
1246     }
1247 
1248     /**
1249      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      */
1255     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1256         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1257         address owner = ERC721.ownerOf(tokenId);
1258         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1259     }
1260 
1261     /**
1262      * @dev Safely mints `tokenId` and transfers it to `to`.
1263      *
1264      * Requirements:
1265      *
1266      * - `tokenId` must not exist.
1267      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _safeMint(address to, uint256 tokenId) internal virtual {
1272         _safeMint(to, tokenId, "");
1273     }
1274 
1275     /**
1276      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1277      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1278      */
1279     function _safeMint(
1280         address to,
1281         uint256 tokenId,
1282         bytes memory _data
1283     ) internal virtual {
1284         _mint(to, tokenId);
1285         require(
1286             _checkOnERC721Received(address(0), to, tokenId, _data),
1287             "ERC721: transfer to non ERC721Receiver implementer"
1288         );
1289     }
1290 
1291     /**
1292      * @dev Mints `tokenId` and transfers it to `to`.
1293      *
1294      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1295      *
1296      * Requirements:
1297      *
1298      * - `tokenId` must not exist.
1299      * - `to` cannot be the zero address.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _mint(address to, uint256 tokenId) internal virtual {
1304         require(to != address(0), "ERC721: mint to the zero address");
1305         require(!_exists(tokenId), "ERC721: token already minted");
1306 
1307         _beforeTokenTransfer(address(0), to, tokenId);
1308 
1309         _balances[to] += 1;
1310         _owners[tokenId] = to;
1311 
1312         emit Transfer(address(0), to, tokenId);
1313     }
1314 
1315     /**
1316      * @dev Destroys `tokenId`.
1317      * The approval is cleared when the token is burned.
1318      *
1319      * Requirements:
1320      *
1321      * - `tokenId` must exist.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _burn(uint256 tokenId) internal virtual {
1326         address owner = ERC721.ownerOf(tokenId);
1327 
1328         _beforeTokenTransfer(owner, address(0), tokenId);
1329 
1330         // Clear approvals
1331         _approve(address(0), tokenId);
1332 
1333         _balances[owner] -= 1;
1334         delete _owners[tokenId];
1335 
1336         emit Transfer(owner, address(0), tokenId);
1337     }
1338 
1339     /**
1340      * @dev Transfers `tokenId` from `from` to `to`.
1341      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1342      *
1343      * Requirements:
1344      *
1345      * - `to` cannot be the zero address.
1346      * - `tokenId` token must be owned by `from`.
1347      *
1348      * Emits a {Transfer} event.
1349      */
1350     function _transfer(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) internal virtual {
1355         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1356         require(to != address(0), "ERC721: transfer to the zero address");
1357 
1358         _beforeTokenTransfer(from, to, tokenId);
1359 
1360         // Clear approvals from the previous owner
1361         _approve(address(0), tokenId);
1362 
1363         _balances[from] -= 1;
1364         _balances[to] += 1;
1365         _owners[tokenId] = to;
1366 
1367         emit Transfer(from, to, tokenId);
1368     }
1369 
1370     /**
1371      * @dev Approve `to` to operate on `tokenId`
1372      *
1373      * Emits a {Approval} event.
1374      */
1375     function _approve(address to, uint256 tokenId) internal virtual {
1376         _tokenApprovals[tokenId] = to;
1377         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1378     }
1379 
1380     /**
1381      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1382      * The call is not executed if the target address is not a contract.
1383      *
1384      * @param from address representing the previous owner of the given token ID
1385      * @param to target address that will receive the tokens
1386      * @param tokenId uint256 ID of the token to be transferred
1387      * @param _data bytes optional data to send along with the call
1388      * @return bool whether the call correctly returned the expected magic value
1389      */
1390     function _checkOnERC721Received(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory _data
1395     ) private returns (bool) {
1396         if (to.isContract()) {
1397             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1398                 return retval == IERC721Receiver.onERC721Received.selector;
1399             } catch (bytes memory reason) {
1400                 if (reason.length == 0) {
1401                     revert("ERC721: transfer to non ERC721Receiver implementer");
1402                 } else {
1403                     assembly {
1404                         revert(add(32, reason), mload(reason))
1405                     }
1406                 }
1407             }
1408         } else {
1409             return true;
1410         }
1411     }
1412 
1413     /**
1414      * @dev Hook that is called before any token transfer. This includes minting
1415      * and burning.
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` will be minted for `to`.
1422      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1423      * - `from` and `to` are never both zero.
1424      *
1425      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1426      */
1427     function _beforeTokenTransfer(
1428         address from,
1429         address to,
1430         uint256 tokenId
1431     ) internal virtual {}
1432 }
1433 
1434 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1435 
1436 
1437 
1438 pragma solidity ^0.8.0;
1439 
1440 
1441 /**
1442  * @dev ERC721 token with storage based token URI management.
1443  */
1444 abstract contract ERC721URIStorage is ERC721 {
1445     using Strings for uint256;
1446 
1447     // Optional mapping for token URIs
1448     mapping(uint256 => string) private _tokenURIs;
1449 
1450     /**
1451      * @dev See {IERC721Metadata-tokenURI}.
1452      */
1453     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1454         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1455 
1456         string memory _tokenURI = _tokenURIs[tokenId];
1457         string memory base = _baseURI();
1458 
1459         // If there is no base URI, return the token URI.
1460         if (bytes(base).length == 0) {
1461             return _tokenURI;
1462         }
1463         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1464         if (bytes(_tokenURI).length > 0) {
1465             return string(abi.encodePacked(base, _tokenURI));
1466         }
1467 
1468         return super.tokenURI(tokenId);
1469     }
1470 
1471     /**
1472      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1473      *
1474      * Requirements:
1475      *
1476      * - `tokenId` must exist.
1477      */
1478     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1479         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1480         _tokenURIs[tokenId] = _tokenURI;
1481     }
1482 
1483     /**
1484      * @dev Destroys `tokenId`.
1485      * The approval is cleared when the token is burned.
1486      *
1487      * Requirements:
1488      *
1489      * - `tokenId` must exist.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _burn(uint256 tokenId) internal virtual override {
1494         super._burn(tokenId);
1495 
1496         if (bytes(_tokenURIs[tokenId]).length != 0) {
1497             delete _tokenURIs[tokenId];
1498         }
1499     }
1500 }
1501 
1502 // File: contracts/CryptoManga.sol
1503 
1504 
1505 pragma solidity ^0.8.0;
1506 
1507 
1508 
1509 
1510 
1511 
1512 
1513 
1514 
1515 contract CryptoManga is ERC721URIStorage, Ownable, Pausable {
1516   using SafeMath for uint256;
1517 
1518   using Counters for Counters.Counter;
1519   Counters.Counter private _tokenIdTracker; // init: 0
1520 
1521   uint256 public constant MAX_TOKENS = 5555;
1522   uint256 public constant MAX_MINT = 20;
1523 
1524   // give aways
1525   uint256 public constant RESERVED_TOKENS = 239;
1526   uint256 private _reserved;
1527 
1528   uint256 public constant LISTING_PRICE = 0.08 ether;
1529   uint256 public constant LOOT_DISCOUNTED_PRICE = 0.07 ether;
1530   uint256 public constant WHITELIST_TIER_ONE_DISCOUNTED_PRICE = 0.065 ether;
1531   uint256 public constant WHITELIST_TIER_TWO_DISCOUNTED_PRICE = 0.07 ether;
1532 
1533   string public baseTokenURI;
1534 
1535   bool public frozen;
1536 
1537   mapping(address => uint256) lootDiscountsRedeemed;
1538   mapping(address => bool) whitelistedDiscount;
1539 
1540   address public multiSigOwner;
1541   address public whitelistSignerTierOne;
1542   address public whitelistSignerTierTwo;
1543 
1544   ILoot cyberLootContract;
1545   ILoot sevensContract;
1546   ILoot metaverseTicket;
1547 
1548   event CryptoMangaSpawn(uint256 indexed id);
1549 
1550   constructor(
1551     string memory baseURI,
1552     address _cyberLoot,
1553     address _metaverseTicket,
1554     address _sevens,
1555     address _multiSigOwner,
1556     address _whitelistSignerTierOne,
1557     address _whitelistSignerTierTwo
1558   ) ERC721("CryptoManga", "CMA") {
1559     setBaseURI(baseURI);
1560     _reserved = RESERVED_TOKENS;
1561     cyberLootContract = ILoot(_cyberLoot);
1562     sevensContract = ILoot(_sevens);
1563     metaverseTicket = ILoot(_metaverseTicket);
1564     multiSigOwner = _multiSigOwner;
1565     whitelistSignerTierOne = _whitelistSignerTierOne;
1566     whitelistSignerTierTwo = _whitelistSignerTierTwo;
1567     pause(true);
1568   }
1569 
1570   function _baseURI() internal view virtual override returns (string memory) {
1571     return baseTokenURI;
1572   }
1573 
1574   function setBaseURI(string memory baseURI) public onlyOwner {
1575     require(!frozen, "Contract is frozen");
1576     baseTokenURI = baseURI;
1577   }
1578 
1579   function freeze() public onlyOwner {
1580     frozen = true;
1581   }
1582 
1583   function _totalSupply() internal view returns (uint256) {
1584     return _tokenIdTracker.current();
1585   }
1586 
1587   modifier saleIsOpen() {
1588     require(_totalSupply() <= MAX_TOKENS, "Sale ended");
1589     if (_msgSender() != owner()) {
1590       require(!paused(), "Pausable: paused");
1591     }
1592     _;
1593   }
1594 
1595   function mint(address _to, uint256 _count) external payable saleIsOpen {
1596     require(_count > 0, "Mint count should be greater than zero");
1597     require(_count <= MAX_MINT, "Exceeds max items");
1598     uint256 numTokens = _totalSupply();
1599     require(numTokens <= MAX_TOKENS, "Sale ended");
1600     require(numTokens + _count <= MAX_TOKENS, "Max limit");
1601 
1602     require(msg.value >= price(_to, _count), "Insufficient funds");
1603 
1604     if (isEligibleForDiscount(_to)) {
1605       uint256 numEligibleDiscounts = calculateNumDiscounts(_to);
1606       if (numEligibleDiscounts >= _count) {
1607         lootDiscountsRedeemed[_to] += _count;
1608       } else {
1609         lootDiscountsRedeemed[_to] += numEligibleDiscounts;
1610       }
1611     }
1612 
1613     for (uint256 i = 0; i < _count; i++) {
1614       _mintOneItem(_to);
1615     }
1616   }
1617 
1618   function mintWithTierOneDiscount(
1619     address _to,
1620     uint256 _count,
1621     bytes calldata _signature
1622   ) external payable saleIsOpen {
1623     mintWithDiscount(
1624       _to,
1625       _count,
1626       _signature,
1627       whitelistSignerTierOne,
1628       WHITELIST_TIER_ONE_DISCOUNTED_PRICE
1629     );
1630   }
1631 
1632   function mintWithTierTwoDiscount(
1633     address _to,
1634     uint256 _count,
1635     bytes calldata _signature
1636   ) external payable saleIsOpen {
1637     mintWithDiscount(
1638       _to,
1639       _count,
1640       _signature,
1641       whitelistSignerTierTwo,
1642       WHITELIST_TIER_TWO_DISCOUNTED_PRICE
1643     );
1644   }
1645 
1646   function mintWithDiscount(
1647     address _to,
1648     uint256 _count,
1649     bytes calldata _signature,
1650     address whitelistSigner,
1651     uint256 _price
1652   ) private {
1653     require(_count > 0, "Mint count should be greater than zero");
1654     require(_count <= MAX_MINT, "Exceeds max items");
1655     bytes32 message = prefixed(keccak256(abi.encodePacked(_to, uint256(1))));
1656 
1657     require(
1658       recoverSigner(message, _signature) == whitelistSigner,
1659       "Wrong signature"
1660     );
1661 
1662     require(whitelistedDiscount[_to] == false, "Discount already claimed");
1663     uint256 numTokens = _totalSupply();
1664     require(numTokens <= MAX_TOKENS, "Sale ended");
1665     require(numTokens + _count <= MAX_TOKENS, "Max limit");
1666     uint256 discountedPrice = _price.mul(_count);
1667     require(msg.value >= discountedPrice, "Insufficient funds");
1668 
1669     for (uint256 i = 0; i < _count; i++) {
1670       _mintOneItem(_to);
1671     }
1672 
1673     whitelistedDiscount[_to] = true;
1674   }
1675 
1676   function giveAway(address _to, uint256 _count) external onlyOwner {
1677     uint256 numTokens = _totalSupply();
1678     require(numTokens <= MAX_TOKENS, "Sale ended");
1679     require(numTokens + _count <= MAX_TOKENS, "Max limit");
1680     require(_reserved > 0, "No more reserved tokens available");
1681 
1682     for (uint256 i = 0; i < _count; i++) {
1683       _mintOneItem(_to);
1684     }
1685 
1686     _reserved = _reserved.sub(_count);
1687   }
1688 
1689   function _mintOneItem(address _to) private {
1690     _tokenIdTracker.increment();
1691     uint256 tokenId = _totalSupply();
1692 
1693     _safeMint(_to, tokenId);
1694     _setTokenURI(
1695       tokenId,
1696       string(abi.encodePacked(Strings.toString(tokenId), ".json"))
1697     );
1698     emit CryptoMangaSpawn(tokenId);
1699   }
1700 
1701   function setMultiSigOwner(address _multiSignOwner) public onlyOwner {
1702     multiSigOwner = _multiSignOwner;
1703   }
1704 
1705   function setWhitelistSignerTierOne(address _whitelistSigner)
1706     public
1707     onlyOwner
1708   {
1709     whitelistSignerTierOne = _whitelistSigner;
1710   }
1711 
1712   function setWhitelistSignerTierTwo(address _whitelistSigner)
1713     public
1714     onlyOwner
1715   {
1716     whitelistSignerTierTwo = _whitelistSigner;
1717   }
1718 
1719   function pause(bool val) public onlyOwner {
1720     if (val == true) {
1721       _pause();
1722       return;
1723     }
1724     _unpause();
1725   }
1726 
1727   function isEligibleForDiscount(address _to) public view returns (bool) {
1728     uint256 numLootTokens = cyberLootContract
1729       .balanceOf(_to)
1730       .add(sevensContract.balanceOf(_to))
1731       .add(metaverseTicket.balanceOf(_to));
1732     uint256 numDiscountsRedeemed = lootDiscountsRedeemed[_to];
1733 
1734     return numDiscountsRedeemed <= numLootTokens;
1735   }
1736 
1737   function calculateNumDiscounts(address _to) public view returns (uint256) {
1738     require(isEligibleForDiscount(_to), "Not eligible for discounts");
1739 
1740     uint256 numLootTokens = cyberLootContract
1741       .balanceOf(_to)
1742       .add(sevensContract.balanceOf(_to))
1743       .add(metaverseTicket.balanceOf(_to));
1744     uint256 numDiscountsRedeemed = lootDiscountsRedeemed[_to];
1745 
1746     return numLootTokens.sub(numDiscountsRedeemed);
1747   }
1748 
1749   function price(address _to, uint256 _count) public view returns (uint256) {
1750     if (!isEligibleForDiscount(_to)) {
1751       return LISTING_PRICE.mul(_count);
1752     } else {
1753       uint256 numEligibleDiscounts = calculateNumDiscounts(_to);
1754       if (numEligibleDiscounts >= _count) {
1755         return LOOT_DISCOUNTED_PRICE.mul(_count);
1756       } else {
1757         uint256 discounted = LOOT_DISCOUNTED_PRICE.mul(numEligibleDiscounts);
1758         uint256 standard = LISTING_PRICE.mul(_count.sub(numEligibleDiscounts));
1759         return discounted.add(standard);
1760       }
1761     }
1762   }
1763 
1764   function prefixed(bytes32 hash) internal pure returns (bytes32) {
1765     return
1766       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1767   }
1768 
1769   function recoverSigner(bytes32 message, bytes memory sig)
1770     internal
1771     pure
1772     returns (address)
1773   {
1774     uint8 v;
1775     bytes32 r;
1776     bytes32 s;
1777 
1778     (v, r, s) = splitSignature(sig);
1779 
1780     return ecrecover(message, v, r, s);
1781   }
1782 
1783   function splitSignature(bytes memory sig)
1784     internal
1785     pure
1786     returns (
1787       uint8,
1788       bytes32,
1789       bytes32
1790     )
1791   {
1792     require(sig.length == 65);
1793 
1794     bytes32 r;
1795     bytes32 s;
1796     uint8 v;
1797 
1798     assembly {
1799       // first 32 bytes, after the length prefix
1800       r := mload(add(sig, 32))
1801       // second 32 bytes
1802       s := mload(add(sig, 64))
1803       // final byte (first byte of the next 32 bytes)
1804       v := byte(0, mload(add(sig, 96)))
1805     }
1806 
1807     return (v, r, s);
1808   }
1809 
1810   function withdrawAll() public payable onlyOwner {
1811     uint256 balance = address(this).balance;
1812     require(balance > 0);
1813     _withdraw(multiSigOwner, balance);
1814   }
1815 
1816   function _withdraw(address _address, uint256 _amount) private {
1817     (bool success, ) = _address.call{ value: _amount }("");
1818     require(success, "Transfer failed.");
1819   }
1820 }