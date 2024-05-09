1 // SPDX-License-Identifier: MIT
2 // File: Counters.sol
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
46 // File: SafeMath.sol
47 
48 
49 
50 pragma solidity ^0.8.1;
51 
52 // CAUTION
53 // This version of SafeMath should only be used with Solidity 0.8 or later,
54 // because it relies on the compiler's built in overflow checks.
55 
56 /**
57  * @dev Wrappers over Solidity's arithmetic operations.
58  *
59  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
60  * now has built in overflow checking.
61  */
62 library SafeMath {
63     /**
64      * @dev Returns the addition of two unsigned integers, with an overflow flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryAdd(uint256 a, uint256 b)
69         internal
70         pure
71         returns (bool, uint256)
72     {
73         unchecked {
74             uint256 c = a + b;
75             if (c < a) return (false, 0);
76             return (true, c);
77         }
78     }
79 
80     /**
81      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
82      *
83      * _Available since v3.4._
84      */
85     function trySub(uint256 a, uint256 b)
86         internal
87         pure
88         returns (bool, uint256)
89     {
90         unchecked {
91             if (b > a) return (false, 0);
92             return (true, a - b);
93         }
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function tryMul(uint256 a, uint256 b)
102         internal
103         pure
104         returns (bool, uint256)
105     {
106         unchecked {
107             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108             // benefit is lost if 'b' is also tested.
109             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
110             if (a == 0) return (true, 0);
111             uint256 c = a * b;
112             if (c / a != b) return (false, 0);
113             return (true, c);
114         }
115     }
116 
117     /**
118      * @dev Returns the division of two unsigned integers, with a division by zero flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryDiv(uint256 a, uint256 b)
123         internal
124         pure
125         returns (bool, uint256)
126     {
127         unchecked {
128             if (b == 0) return (false, 0);
129             return (true, a / b);
130         }
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryMod(uint256 a, uint256 b)
139         internal
140         pure
141         returns (bool, uint256)
142     {
143         unchecked {
144             if (b == 0) return (false, 0);
145             return (true, a % b);
146         }
147     }
148 
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      *
157      * - Addition cannot overflow.
158      */
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a + b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a * b;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator.
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a / b;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a % b;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
223      * overflow (when the result is negative).
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {trySub}.
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      *
232      * - Subtraction cannot overflow.
233      */
234     function sub(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         unchecked {
240             require(b <= a, errorMessage);
241             return a - b;
242         }
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a / b;
265         }
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * reverting with custom message when dividing by zero.
271      *
272      * CAUTION: This function is deprecated because it requires allocating memory for the error
273      * message unnecessarily. For custom revert reasons use {tryMod}.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         unchecked {
289             require(b > 0, errorMessage);
290             return a % b;
291         }
292     }
293 }
294 
295 // File: Strings.sol
296 
297 
298 
299 pragma solidity ^0.8.1;
300 
301 /**
302  * @dev String operations.
303  */
304 library Strings {
305     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
306 
307     /**
308      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
309      */
310     function toString(uint256 value) internal pure returns (string memory) {
311         // Inspired by OraclizeAPI's implementation - MIT licence
312         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
313 
314         if (value == 0) {
315             return "0";
316         }
317         uint256 temp = value;
318         uint256 digits;
319         while (temp != 0) {
320             digits++;
321             temp /= 10;
322         }
323         bytes memory buffer = new bytes(digits);
324         while (value != 0) {
325             digits -= 1;
326             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
327             value /= 10;
328         }
329         return string(buffer);
330     }
331 
332     /**
333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
334      */
335     function toHexString(uint256 value) internal pure returns (string memory) {
336         if (value == 0) {
337             return "0x00";
338         }
339         uint256 temp = value;
340         uint256 length = 0;
341         while (temp != 0) {
342             length++;
343             temp >>= 8;
344         }
345         return toHexString(value, length);
346     }
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
350      */
351     function toHexString(uint256 value, uint256 length)
352         internal
353         pure
354         returns (string memory)
355     {
356         bytes memory buffer = new bytes(2 * length + 2);
357         buffer[0] = "0";
358         buffer[1] = "x";
359         for (uint256 i = 2 * length + 1; i > 1; --i) {
360             buffer[i] = _HEX_SYMBOLS[value & 0xf];
361             value >>= 4;
362         }
363         require(value == 0, "Strings: hex length insufficient");
364         return string(buffer);
365     }
366 }
367 
368 // File: Context.sol
369 
370 
371 
372 pragma solidity ^0.8.1;
373 
374 /**
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes calldata) {
390         return msg.data;
391     }
392 }
393 
394 // File: Ownable.sol
395 
396 
397 
398 pragma solidity ^0.8.1;
399 
400 
401 /**
402  * @dev Contract module which provides a basic access control mechanism, where
403  * there is an account (an owner) that can be granted exclusive access to
404  * specific functions.
405  *
406  * By default, the owner account will be the one that deploys the contract. This
407  * can later be changed with {transferOwnership}.
408  *
409  * This module is used through inheritance. It will make available the modifier
410  * `onlyOwner`, which can be applied to your functions to restrict their use to
411  * the owner.
412  */
413 abstract contract Ownable is Context {
414     address private _owner;
415 
416     event OwnershipTransferred(
417         address indexed previousOwner,
418         address indexed newOwner
419     );
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor() {
425         _setOwner(_msgSender());
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view virtual returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(owner() == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         _setOwner(address(0));
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Can only be called by the current owner.
457      */
458     function transferOwnership(address newOwner) public virtual onlyOwner {
459         require(
460             newOwner != address(0),
461             "Ownable: new owner is the zero address"
462         );
463         _setOwner(newOwner);
464     }
465 
466     function _setOwner(address newOwner) private {
467         address oldOwner = _owner;
468         _owner = newOwner;
469         emit OwnershipTransferred(oldOwner, newOwner);
470     }
471 }
472 
473 // File: Address.sol
474 
475 
476 
477 pragma solidity ^0.8.1;
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      */
500     function isContract(address account) internal view returns (bool) {
501         // This method relies on extcodesize, which returns 0 for contracts in
502         // construction, since the code is only stored at the end of the
503         // constructor execution.
504 
505         uint256 size;
506         assembly {
507             size := extcodesize(account)
508         }
509         return size > 0;
510     }
511 
512     /**
513      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
514      * `recipient`, forwarding all available gas and reverting on errors.
515      *
516      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
517      * of certain opcodes, possibly making contracts go over the 2300 gas limit
518      * imposed by `transfer`, making them unable to receive funds via
519      * `transfer`. {sendValue} removes this limitation.
520      *
521      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
522      *
523      * IMPORTANT: because control is transferred to `recipient`, care must be
524      * taken to not create reentrancy vulnerabilities. Consider using
525      * {ReentrancyGuard} or the
526      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
527      */
528     function sendValue(address payable recipient, uint256 amount) internal {
529         require(
530             address(this).balance >= amount,
531             "Address: insufficient balance"
532         );
533 
534         (bool success, ) = recipient.call{value: amount}("");
535         require(
536             success,
537             "Address: unable to send value, recipient may have reverted"
538         );
539     }
540 
541     /**
542      * @dev Performs a Solidity function call using a low level `call`. A
543      * plain `call` is an unsafe replacement for a function call: use this
544      * function instead.
545      *
546      * If `target` reverts with a revert reason, it is bubbled up by this
547      * function (like regular Solidity function calls).
548      *
549      * Returns the raw returned data. To convert to the expected return value,
550      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
551      *
552      * Requirements:
553      *
554      * - `target` must be a contract.
555      * - calling `target` with `data` must not revert.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data)
560         internal
561         returns (bytes memory)
562     {
563         return functionCall(target, data, "Address: low-level call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
568      * `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, 0, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but also transferring `value` wei to `target`.
583      *
584      * Requirements:
585      *
586      * - the calling contract must have an ETH balance of at least `value`.
587      * - the called Solidity function must be `payable`.
588      *
589      * _Available since v3.1._
590      */
591     function functionCallWithValue(
592         address target,
593         bytes memory data,
594         uint256 value
595     ) internal returns (bytes memory) {
596         return
597             functionCallWithValue(
598                 target,
599                 data,
600                 value,
601                 "Address: low-level call with value failed"
602             );
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
607      * with `errorMessage` as a fallback revert reason when `target` reverts.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(
612         address target,
613         bytes memory data,
614         uint256 value,
615         string memory errorMessage
616     ) internal returns (bytes memory) {
617         require(
618             address(this).balance >= value,
619             "Address: insufficient balance for call"
620         );
621         require(isContract(target), "Address: call to non-contract");
622 
623         (bool success, bytes memory returndata) = target.call{value: value}(
624             data
625         );
626         return verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but performing a static call.
632      *
633      * _Available since v3.3._
634      */
635     function functionStaticCall(address target, bytes memory data)
636         internal
637         view
638         returns (bytes memory)
639     {
640         return
641             functionStaticCall(
642                 target,
643                 data,
644                 "Address: low-level static call failed"
645             );
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a static call.
651      *
652      * _Available since v3.3._
653      */
654     function functionStaticCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal view returns (bytes memory) {
659         require(isContract(target), "Address: static call to non-contract");
660 
661         (bool success, bytes memory returndata) = target.staticcall(data);
662         return verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
667      * but performing a delegate call.
668      *
669      * _Available since v3.4._
670      */
671     function functionDelegateCall(address target, bytes memory data)
672         internal
673         returns (bytes memory)
674     {
675         return
676             functionDelegateCall(
677                 target,
678                 data,
679                 "Address: low-level delegate call failed"
680             );
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(
690         address target,
691         bytes memory data,
692         string memory errorMessage
693     ) internal returns (bytes memory) {
694         require(isContract(target), "Address: delegate call to non-contract");
695 
696         (bool success, bytes memory returndata) = target.delegatecall(data);
697         return verifyCallResult(success, returndata, errorMessage);
698     }
699 
700     /**
701      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
702      * revert reason using the provided one.
703      *
704      * _Available since v4.3._
705      */
706     function verifyCallResult(
707         bool success,
708         bytes memory returndata,
709         string memory errorMessage
710     ) internal pure returns (bytes memory) {
711         if (success) {
712             return returndata;
713         } else {
714             // Look for revert reason and bubble it up if present
715             if (returndata.length > 0) {
716                 // The easiest way to bubble the revert reason is using memory via assembly
717 
718                 assembly {
719                     let returndata_size := mload(returndata)
720                     revert(add(32, returndata), returndata_size)
721                 }
722             } else {
723                 revert(errorMessage);
724             }
725         }
726     }
727 }
728 
729 // File: IERC721Receiver.sol
730 
731 
732 
733 pragma solidity ^0.8.1;
734 
735 /**
736  * @title ERC721 token receiver interface
737  * @dev Interface for any contract that wants to support safeTransfers
738  * from ERC721 asset contracts.
739  */
740 interface IERC721Receiver {
741     /**
742      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
743      * by `operator` from `from`, this function is called.
744      *
745      * It must return its Solidity selector to confirm the token transfer.
746      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
747      *
748      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
749      */
750     function onERC721Received(
751         address operator,
752         address from,
753         uint256 tokenId,
754         bytes calldata data
755     ) external returns (bytes4);
756 }
757 
758 // File: IERC165.sol
759 
760 
761 
762 pragma solidity ^0.8.1;
763 
764 /**
765  * @dev Interface of the ERC165 standard, as defined in the
766  * https://eips.ethereum.org/EIPS/eip-165[EIP].
767  *
768  * Implementers can declare support of contract interfaces, which can then be
769  * queried by others ({ERC165Checker}).
770  *
771  * For an implementation, see {ERC165}.
772  */
773 interface IERC165 {
774     /**
775      * @dev Returns true if this contract implements the interface defined by
776      * `interfaceId`. See the corresponding
777      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
778      * to learn more about how these ids are created.
779      *
780      * This function call must use less than 30 000 gas.
781      */
782     function supportsInterface(bytes4 interfaceId) external view returns (bool);
783 }
784 
785 // File: ERC165.sol
786 
787 
788 
789 pragma solidity ^0.8.1;
790 
791 
792 /**
793  * @dev Implementation of the {IERC165} interface.
794  *
795  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
796  * for the additional interface id that will be supported. For example:
797  *
798  * ```solidity
799  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
800  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
801  * }
802  * ```
803  *
804  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
805  */
806 abstract contract ERC165 is IERC165 {
807     /**
808      * @dev See {IERC165-supportsInterface}.
809      */
810     function supportsInterface(bytes4 interfaceId)
811         public
812         view
813         virtual
814         override
815         returns (bool)
816     {
817         return interfaceId == type(IERC165).interfaceId;
818     }
819 }
820 
821 // File: IERC721.sol
822 
823 
824 
825 pragma solidity ^0.8.1;
826 
827 
828 /**
829  * @dev Required interface of an ERC721 compliant contract.
830  */
831 interface IERC721 is IERC165 {
832     /**
833      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
834      */
835     event Transfer(
836         address indexed from,
837         address indexed to,
838         uint256 indexed tokenId
839     );
840 
841     /**
842      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
843      */
844     event Approval(
845         address indexed owner,
846         address indexed approved,
847         uint256 indexed tokenId
848     );
849 
850     /**
851      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
852      */
853     event ApprovalForAll(
854         address indexed owner,
855         address indexed operator,
856         bool approved
857     );
858 
859     /**
860      * @dev Returns the number of tokens in ``owner``'s account.
861      */
862     function balanceOf(address owner) external view returns (uint256 balance);
863 
864     /**
865      * @dev Returns the owner of the `tokenId` token.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      */
871     function ownerOf(uint256 tokenId) external view returns (address owner);
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
875      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
876      *
877      * Requirements:
878      *
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must exist and be owned by `from`.
882      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
884      *
885      * Emits a {Transfer} event.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) external;
892 
893     /**
894      * @dev Transfers `tokenId` token from `from` to `to`.
895      *
896      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
897      *
898      * Requirements:
899      *
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
904      *
905      * Emits a {Transfer} event.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) external;
912 
913     /**
914      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
915      * The approval is cleared when the token is transferred.
916      *
917      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
918      *
919      * Requirements:
920      *
921      * - The caller must own the token or be an approved operator.
922      * - `tokenId` must exist.
923      *
924      * Emits an {Approval} event.
925      */
926     function approve(address to, uint256 tokenId) external;
927 
928     /**
929      * @dev Returns the account approved for `tokenId` token.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      */
935     function getApproved(uint256 tokenId)
936         external
937         view
938         returns (address operator);
939 
940     /**
941      * @dev Approve or remove `operator` as an operator for the caller.
942      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
943      *
944      * Requirements:
945      *
946      * - The `operator` cannot be the caller.
947      *
948      * Emits an {ApprovalForAll} event.
949      */
950     function setApprovalForAll(address operator, bool _approved) external;
951 
952     /**
953      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
954      *
955      * See {setApprovalForAll}
956      */
957     function isApprovedForAll(address owner, address operator)
958         external
959         view
960         returns (bool);
961 
962     /**
963      * @dev Safely transfers `tokenId` token from `from` to `to`.
964      *
965      * Requirements:
966      *
967      * - `from` cannot be the zero address.
968      * - `to` cannot be the zero address.
969      * - `tokenId` token must exist and be owned by `from`.
970      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
971      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
972      *
973      * Emits a {Transfer} event.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes calldata data
980     ) external;
981 }
982 
983 // File: IERC721Metadata.sol
984 
985 
986 
987 pragma solidity ^0.8.1;
988 
989 
990 /**
991  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
992  * @dev See https://eips.ethereum.org/EIPS/eip-721
993  */
994 interface IERC721Metadata is IERC721 {
995     /**
996      * @dev Returns the token collection name.
997      */
998     function name() external view returns (string memory);
999 
1000     /**
1001      * @dev Returns the token collection symbol.
1002      */
1003     function symbol() external view returns (string memory);
1004 
1005     /**
1006      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1007      */
1008     function tokenURI(uint256 tokenId) external view returns (string memory);
1009 }
1010 
1011 // File: ERC721.sol
1012 
1013 
1014 
1015 pragma solidity ^0.8.1;
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 /**
1025  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1026  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1027  * {ERC721Enumerable}.
1028  */
1029 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1030     using Address for address;
1031     using Strings for uint256;
1032 
1033     // Token name
1034     string private _name;
1035 
1036     // Token symbol
1037     string private _symbol;
1038 
1039     // Mapping from token ID to owner address
1040     mapping(uint256 => address) private _owners;
1041 
1042     // Mapping owner address to token count
1043     mapping(address => uint256) private _balances;
1044 
1045     // Mapping from token ID to approved address
1046     mapping(uint256 => address) private _tokenApprovals;
1047 
1048     // Mapping from owner to operator approvals
1049     mapping(address => mapping(address => bool)) private _operatorApprovals;
1050 
1051     /**
1052      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1053      */
1054     constructor(string memory name_, string memory symbol_) {
1055         _name = name_;
1056         _symbol = symbol_;
1057     }
1058 
1059     /**
1060      * @dev See {IERC165-supportsInterface}.
1061      */
1062     function supportsInterface(bytes4 interfaceId)
1063         public
1064         view
1065         virtual
1066         override(ERC165, IERC165)
1067         returns (bool)
1068     {
1069         return
1070             interfaceId == type(IERC721).interfaceId ||
1071             interfaceId == type(IERC721Metadata).interfaceId ||
1072             super.supportsInterface(interfaceId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-balanceOf}.
1077      */
1078     function balanceOf(address owner)
1079         public
1080         view
1081         virtual
1082         override
1083         returns (uint256)
1084     {
1085         require(
1086             owner != address(0),
1087             "ERC721: balance query for the zero address"
1088         );
1089         return _balances[owner];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-ownerOf}.
1094      */
1095     function ownerOf(uint256 tokenId)
1096         public
1097         view
1098         virtual
1099         override
1100         returns (address)
1101     {
1102         address owner = _owners[tokenId];
1103         require(
1104             owner != address(0),
1105             "ERC721: owner query for nonexistent token"
1106         );
1107         return owner;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Metadata-name}.
1112      */
1113     function name() public view virtual override returns (string memory) {
1114         return _name;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Metadata-symbol}.
1119      */
1120     function symbol() public view virtual override returns (string memory) {
1121         return _symbol;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Metadata-tokenURI}.
1126      */
1127     function tokenURI(uint256 tokenId)
1128         public
1129         view
1130         virtual
1131         override
1132         returns (string memory)
1133     {
1134         require(
1135             _exists(tokenId),
1136             "ERC721Metadata: URI query for nonexistent token"
1137         );
1138 
1139         string memory baseURI = _baseURI();
1140         return
1141             bytes(baseURI).length > 0
1142                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1143                 : "";
1144     }
1145 
1146     /**
1147      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1148      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1149      * by default, can be overriden in child contracts.
1150      */
1151     function _baseURI() internal view virtual returns (string memory) {
1152         return "";
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-approve}.
1157      */
1158     function approve(address to, uint256 tokenId) public virtual override {
1159         address owner = ERC721.ownerOf(tokenId);
1160         require(to != owner, "ERC721: approval to current owner");
1161 
1162         require(
1163             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1164             "ERC721: approve caller is not owner nor approved for all"
1165         );
1166 
1167         _approve(to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-getApproved}.
1172      */
1173     function getApproved(uint256 tokenId)
1174         public
1175         view
1176         virtual
1177         override
1178         returns (address)
1179     {
1180         require(
1181             _exists(tokenId),
1182             "ERC721: approved query for nonexistent token"
1183         );
1184 
1185         return _tokenApprovals[tokenId];
1186     }
1187 
1188     /**
1189      * @dev See {IERC721-setApprovalForAll}.
1190      */
1191     function setApprovalForAll(address operator, bool approved)
1192         public
1193         virtual
1194         override
1195     {
1196         require(operator != _msgSender(), "ERC721: approve to caller");
1197 
1198         _operatorApprovals[_msgSender()][operator] = approved;
1199         emit ApprovalForAll(_msgSender(), operator, approved);
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-isApprovedForAll}.
1204      */
1205     function isApprovedForAll(address owner, address operator)
1206         public
1207         view
1208         virtual
1209         override
1210         returns (bool)
1211     {
1212         return _operatorApprovals[owner][operator];
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-transferFrom}.
1217      */
1218     function transferFrom(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) public virtual override {
1223         //solhint-disable-next-line max-line-length
1224         require(
1225             _isApprovedOrOwner(_msgSender(), tokenId),
1226             "ERC721: transfer caller is not owner nor approved"
1227         );
1228 
1229         _transfer(from, to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-safeTransferFrom}.
1234      */
1235     function safeTransferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) public virtual override {
1240         safeTransferFrom(from, to, tokenId, "");
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-safeTransferFrom}.
1245      */
1246     function safeTransferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId,
1250         bytes memory _data
1251     ) public virtual override {
1252         require(
1253             _isApprovedOrOwner(_msgSender(), tokenId),
1254             "ERC721: transfer caller is not owner nor approved"
1255         );
1256         _safeTransfer(from, to, tokenId, _data);
1257     }
1258 
1259     /**
1260      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1261      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1262      *
1263      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1264      *
1265      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1266      * implement alternative mechanisms to perform token transfer, such as signature-based.
1267      *
1268      * Requirements:
1269      *
1270      * - `from` cannot be the zero address.
1271      * - `to` cannot be the zero address.
1272      * - `tokenId` token must exist and be owned by `from`.
1273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _safeTransfer(
1278         address from,
1279         address to,
1280         uint256 tokenId,
1281         bytes memory _data
1282     ) internal virtual {
1283         _transfer(from, to, tokenId);
1284         require(
1285             _checkOnERC721Received(from, to, tokenId, _data),
1286             "ERC721: transfer to non ERC721Receiver implementer"
1287         );
1288     }
1289 
1290     /**
1291      * @dev Returns whether `tokenId` exists.
1292      *
1293      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1294      *
1295      * Tokens start existing when they are minted (`_mint`),
1296      * and stop existing when they are burned (`_burn`).
1297      */
1298     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1299         return _owners[tokenId] != address(0);
1300     }
1301 
1302     /**
1303      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must exist.
1308      */
1309     function _isApprovedOrOwner(address spender, uint256 tokenId)
1310         internal
1311         view
1312         virtual
1313         returns (bool)
1314     {
1315         require(
1316             _exists(tokenId),
1317             "ERC721: operator query for nonexistent token"
1318         );
1319         address owner = ERC721.ownerOf(tokenId);
1320         return (spender == owner ||
1321             getApproved(tokenId) == spender ||
1322             isApprovedForAll(owner, spender));
1323     }
1324 
1325     /**
1326      * @dev Safely mints `tokenId` and transfers it to `to`.
1327      *
1328      * Requirements:
1329      *
1330      * - `tokenId` must not exist.
1331      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function _safeMint(address to, uint256 tokenId) internal virtual {
1336         _safeMint(to, tokenId, "");
1337     }
1338 
1339     /**
1340      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1341      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1342      */
1343     function _safeMint(
1344         address to,
1345         uint256 tokenId,
1346         bytes memory _data
1347     ) internal virtual {
1348         _mint(to, tokenId);
1349         require(
1350             _checkOnERC721Received(address(0), to, tokenId, _data),
1351             "ERC721: transfer to non ERC721Receiver implementer"
1352         );
1353     }
1354 
1355     /**
1356      * @dev Mints `tokenId` and transfers it to `to`.
1357      *
1358      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1359      *
1360      * Requirements:
1361      *
1362      * - `tokenId` must not exist.
1363      * - `to` cannot be the zero address.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function _mint(address to, uint256 tokenId) internal virtual {
1368         require(to != address(0), "ERC721: mint to the zero address");
1369         require(!_exists(tokenId), "ERC721: token already minted");
1370 
1371         _beforeTokenTransfer(address(0), to, tokenId);
1372 
1373         _balances[to] += 1;
1374         _owners[tokenId] = to;
1375 
1376         emit Transfer(address(0), to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev Destroys `tokenId`.
1381      * The approval is cleared when the token is burned.
1382      *
1383      * Requirements:
1384      *
1385      * - `tokenId` must exist.
1386      *
1387      * Emits a {Transfer} event.
1388      */
1389     function _burn(uint256 tokenId) internal virtual {
1390         address owner = ERC721.ownerOf(tokenId);
1391 
1392         _beforeTokenTransfer(owner, address(0), tokenId);
1393 
1394         // Clear approvals
1395         _approve(address(0), tokenId);
1396 
1397         _balances[owner] -= 1;
1398         delete _owners[tokenId];
1399 
1400         emit Transfer(owner, address(0), tokenId);
1401     }
1402 
1403     /**
1404      * @dev Transfers `tokenId` from `from` to `to`.
1405      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1406      *
1407      * Requirements:
1408      *
1409      * - `to` cannot be the zero address.
1410      * - `tokenId` token must be owned by `from`.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _transfer(
1415         address from,
1416         address to,
1417         uint256 tokenId
1418     ) internal virtual {
1419         require(
1420             ERC721.ownerOf(tokenId) == from,
1421             "ERC721: transfer of token that is not own"
1422         );
1423         require(to != address(0), "ERC721: transfer to the zero address");
1424 
1425         _beforeTokenTransfer(from, to, tokenId);
1426 
1427         // Clear approvals from the previous owner
1428         _approve(address(0), tokenId);
1429 
1430         _balances[from] -= 1;
1431         _balances[to] += 1;
1432         _owners[tokenId] = to;
1433 
1434         emit Transfer(from, to, tokenId);
1435     }
1436 
1437     /**
1438      * @dev Approve `to` to operate on `tokenId`
1439      *
1440      * Emits a {Approval} event.
1441      */
1442     function _approve(address to, uint256 tokenId) internal virtual {
1443         _tokenApprovals[tokenId] = to;
1444         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1445     }
1446 
1447     /**
1448      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1449      * The call is not executed if the target address is not a contract.
1450      *
1451      * @param from address representing the previous owner of the given token ID
1452      * @param to target address that will receive the tokens
1453      * @param tokenId uint256 ID of the token to be transferred
1454      * @param _data bytes optional data to send along with the call
1455      * @return bool whether the call correctly returned the expected magic value
1456      */
1457     function _checkOnERC721Received(
1458         address from,
1459         address to,
1460         uint256 tokenId,
1461         bytes memory _data
1462     ) private returns (bool) {
1463         if (to.isContract()) {
1464             try
1465                 IERC721Receiver(to).onERC721Received(
1466                     _msgSender(),
1467                     from,
1468                     tokenId,
1469                     _data
1470                 )
1471             returns (bytes4 retval) {
1472                 return retval == IERC721Receiver.onERC721Received.selector;
1473             } catch (bytes memory reason) {
1474                 if (reason.length == 0) {
1475                     revert(
1476                         "ERC721: transfer to non ERC721Receiver implementer"
1477                     );
1478                 } else {
1479                     assembly {
1480                         revert(add(32, reason), mload(reason))
1481                     }
1482                 }
1483             }
1484         } else {
1485             return true;
1486         }
1487     }
1488 
1489     /**
1490      * @dev Hook that is called before any token transfer. This includes minting
1491      * and burning.
1492      *
1493      * Calling conditions:
1494      *
1495      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1496      * transferred to `to`.
1497      * - When `from` is zero, `tokenId` will be minted for `to`.
1498      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1499      * - `from` and `to` are never both zero.
1500      *
1501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1502      */
1503     function _beforeTokenTransfer(
1504         address from,
1505         address to,
1506         uint256 tokenId
1507     ) internal virtual {}
1508 }
1509 
1510 // File: ApeLaunch.sol
1511 
1512 
1513 pragma solidity ^0.8.7;
1514 
1515 
1516 
1517 
1518 
1519 
1520 contract ApeLaunch is ERC721, Ownable {
1521     using SafeMath for uint256;
1522     using Counters for Counters.Counter;
1523     using Strings for uint256;
1524 
1525     uint256 public MAX_APES = 2000;
1526     uint256 public MAX_APE_PER_MINT = 5;
1527     uint256 public MAX_FREE = 500;
1528     uint256 public APE_PRICE = 0.02 ether;
1529 
1530     string public tokenBaseURI;
1531     string public tokenBaseExtension = ".json";
1532     bool public saleActive = false;
1533     address public OWNER;
1534     address public COLLAB;
1535 
1536     Counters.Counter public tokenSupply;
1537 
1538     constructor(address _collab) ERC721("ApeLaunch", "AL") {
1539         OWNER = msg.sender;
1540         COLLAB = _collab;
1541     }
1542 
1543     function getCurrentSupply() external view returns(uint256) {
1544         return tokenSupply.current();
1545     }
1546 
1547     function setTokenBaseURI(string memory _baseURI) external onlyOwner {
1548         tokenBaseURI = _baseURI;
1549     }
1550 
1551     function tokenURI(uint256 _tokenId)
1552         public
1553         view
1554         override
1555         returns (string memory)
1556     {
1557 
1558         require(_exists(_tokenId), "Err: nonexistent token");
1559 
1560         return
1561             string(
1562                 abi.encodePacked(
1563                     tokenBaseURI,
1564                     _tokenId.toString(),
1565                     tokenBaseExtension
1566                 )
1567             );
1568     }
1569 
1570     function mint(uint256 _quantity) external payable {
1571         require(saleActive, "Err: not active.");
1572         require(_quantity <= MAX_APE_PER_MINT, "Err: invalid quantity");
1573 
1574         _safeMintApes(_quantity);
1575     }
1576 
1577     function _safeMintApes(uint256 _quantity) internal {
1578         require(_quantity > 0, "Err: minimum one");
1579         if (MAX_FREE < tokenSupply.current().add(_quantity)){
1580             require(
1581                 tokenSupply.current().add(_quantity) <= MAX_APES,
1582                 "Err: excceed max supply"
1583             );
1584             require(msg.value >= APE_PRICE.mul(_quantity), "Err: incorrect amount");        
1585         }
1586 
1587         for (uint256 i = 0; i < _quantity; i++) {
1588             uint256 mintIndex = tokenSupply.current();
1589 
1590             if (mintIndex < MAX_APES) {
1591                 tokenSupply.increment();
1592                 _safeMint(msg.sender, mintIndex);
1593             }
1594         }
1595     }
1596 
1597     function setMaxFree(uint256 _maxFree) external onlyOwner {
1598         require(tokenSupply.current() <= _maxFree && _maxFree <= MAX_APES, "Err: invalid max free");
1599         MAX_FREE = _maxFree;
1600     }
1601 
1602     function setMaxApePerMint(uint256 _maxApePerMint) external onlyOwner {
1603         MAX_APE_PER_MINT = _maxApePerMint;
1604     }
1605 
1606     function setApePrice(uint256 _apePrice) external onlyOwner {
1607         APE_PRICE = _apePrice;
1608     }
1609 
1610     function setSaleActive(bool _active) external onlyOwner {
1611         saleActive = _active;
1612     }
1613 
1614     function setCollab(address _collab) external onlyOwner {
1615         COLLAB = _collab;
1616     }
1617 
1618     function setTokenBaseExtension(string memory _tokenBaseExtension)
1619         external
1620         onlyOwner
1621     {
1622         tokenBaseExtension = _tokenBaseExtension;
1623     }
1624 
1625     function withdrawAll() public onlyOwner {
1626         uint256 balance = address(this).balance;
1627         if (COLLAB == OWNER){
1628             _withdraw(OWNER, address(this).balance);
1629         } else {
1630             _withdraw(COLLAB, balance / 2); // 50%
1631             _withdraw(OWNER, address(this).balance); // 50%
1632         }
1633     }
1634 
1635     function _withdraw(address _addr, uint256 _amt) private {
1636         (bool success,) = _addr.call{value: _amt}("");
1637         require(success, "transfer failed");
1638     }
1639 }