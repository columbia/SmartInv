1 pragma solidity ^0.8.0;
2 
3 /// @title IERC2981Royalties
4 /// @dev Interface for the ERC2981 - Token Royalty standard
5 interface IERC2981Royalties {
6     /// @notice Called with the sale price to determine how much royalty
7     //          is owed and to whom.
8     /// @param _tokenId - the NFT asset queried for royalty information
9     /// @param _value - the sale price of the NFT asset specified by _tokenId
10     /// @return _receiver - address of who should be sent the royalty payment
11     /// @return _royaltyAmount - the royalty payment amount for value sale price
12     function royaltyInfo(uint256 _tokenId, uint256 _value)
13         external
14         view
15         returns (address _receiver, uint256 _royaltyAmount);
16 }
17 
18 
19 pragma solidity ^0.8.0;
20 
21 // CAUTION
22 // This version of SafeMath should only be used with Solidity 0.8 or later,
23 // because it relies on the compiler's built in overflow checks.
24 
25 /**
26  * @dev Wrappers over Solidity's arithmetic operations.
27  *
28  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
29  * now has built in overflow checking.
30  */
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             uint256 c = a + b;
40             if (c < a) return (false, 0);
41             return (true, c);
42         }
43     }
44 
45     /**
46      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             if (b > a) return (false, 0);
53             return (true, a - b);
54         }
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65             // benefit is lost if 'b' is also tested.
66             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67             if (a == 0) return (true, 0);
68             uint256 c = a * b;
69             if (c / a != b) return (false, 0);
70             return (true, c);
71         }
72     }
73 
74     /**
75      * @dev Returns the division of two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a / b);
83         }
84     }
85 
86     /**
87      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             if (b == 0) return (false, 0);
94             return (true, a % b);
95         }
96     }
97 
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a + b;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a - b;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      *
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a * b;
138     }
139 
140     /**
141      * @dev Returns the integer division of two unsigned integers, reverting on
142      * division by zero. The result is rounded towards zero.
143      *
144      * Counterpart to Solidity's `/` operator.
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a / b;
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * reverting when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return a % b;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * CAUTION: This function is deprecated because it requires allocating memory for the error
175      * message unnecessarily. For custom revert reasons use {trySub}.
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(
184         uint256 a,
185         uint256 b,
186         string memory errorMessage
187     ) internal pure returns (uint256) {
188         unchecked {
189             require(b <= a, errorMessage);
190             return a - b;
191         }
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(
207         uint256 a,
208         uint256 b,
209         string memory errorMessage
210     ) internal pure returns (uint256) {
211         unchecked {
212             require(b > 0, errorMessage);
213             return a / b;
214         }
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * reverting with custom message when dividing by zero.
220      *
221      * CAUTION: This function is deprecated because it requires allocating memory for the error
222      * message unnecessarily. For custom revert reasons use {tryMod}.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(
233         uint256 a,
234         uint256 b,
235         string memory errorMessage
236     ) internal pure returns (uint256) {
237         unchecked {
238             require(b > 0, errorMessage);
239             return a % b;
240         }
241     }
242 }
243 
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Standard math utilities missing in the Solidity language.
249  */
250 library Math {
251     /**
252      * @dev Returns the largest of two numbers.
253      */
254     function max(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a >= b ? a : b;
256     }
257 
258     /**
259      * @dev Returns the smallest of two numbers.
260      */
261     function min(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a < b ? a : b;
263     }
264 
265     /**
266      * @dev Returns the average of two numbers. The result is rounded towards
267      * zero.
268      */
269     function average(uint256 a, uint256 b) internal pure returns (uint256) {
270         // (a + b) / 2 can overflow.
271         return (a & b) + (a ^ b) / 2;
272     }
273 
274     /**
275      * @dev Returns the ceiling of the division of two numbers.
276      *
277      * This differs from standard division with `/` in that it rounds up instead
278      * of rounding down.
279      */
280     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
281         // (a + b - 1) / b can overflow on addition, so we distribute.
282         return a / b + (a % b == 0 ? 0 : 1);
283     }
284 }
285 
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @title Counters
291  * @author Matt Condon (@shrugs)
292  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
293  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
294  *
295  * Include with `using Counters for Counters.Counter;`
296  */
297 library Counters {
298     struct Counter {
299         // This variable should never be directly accessed by users of the library: interactions must be restricted to
300         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
301         // this feature: see https://github.com/ethereum/solidity/issues/4637
302         uint256 _value; // default: 0
303     }
304 
305     function current(Counter storage counter) internal view returns (uint256) {
306         return counter._value;
307     }
308 
309     function increment(Counter storage counter) internal {
310         unchecked {
311             counter._value += 1;
312         }
313     }
314 
315     function decrement(Counter storage counter) internal {
316         uint256 value = counter._value;
317         require(value > 0, "Counter: decrement overflow");
318         unchecked {
319             counter._value = value - 1;
320         }
321     }
322 
323     function reset(Counter storage counter) internal {
324         counter._value = 0;
325     }
326 }
327 
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev String operations.
333  */
334 library Strings {
335     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
336 
337     /**
338      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
339      */
340     function toString(uint256 value) internal pure returns (string memory) {
341         // Inspired by OraclizeAPI's implementation - MIT licence
342         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
343 
344         if (value == 0) {
345             return "0";
346         }
347         uint256 temp = value;
348         uint256 digits;
349         while (temp != 0) {
350             digits++;
351             temp /= 10;
352         }
353         bytes memory buffer = new bytes(digits);
354         while (value != 0) {
355             digits -= 1;
356             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
357             value /= 10;
358         }
359         return string(buffer);
360     }
361 
362     /**
363      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
364      */
365     function toHexString(uint256 value) internal pure returns (string memory) {
366         if (value == 0) {
367             return "0x00";
368         }
369         uint256 temp = value;
370         uint256 length = 0;
371         while (temp != 0) {
372             length++;
373             temp >>= 8;
374         }
375         return toHexString(value, length);
376     }
377 
378     /**
379      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
380      */
381     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
382         bytes memory buffer = new bytes(2 * length + 2);
383         buffer[0] = "0";
384         buffer[1] = "x";
385         for (uint256 i = 2 * length + 1; i > 1; --i) {
386             buffer[i] = _HEX_SYMBOLS[value & 0xf];
387             value >>= 4;
388         }
389         require(value == 0, "Strings: hex length insufficient");
390         return string(buffer);
391     }
392 }
393 
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address) {
409         return msg.sender;
410     }
411 
412     function _msgData() internal view virtual returns (bytes calldata) {
413         return msg.data;
414     }
415 }
416 
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Contract module which provides a basic access control mechanism, where
423  * there is an account (an owner) that can be granted exclusive access to
424  * specific functions.
425  *
426  * By default, the owner account will be the one that deploys the contract. This
427  * can later be changed with {transferOwnership}.
428  *
429  * This module is used through inheritance. It will make available the modifier
430  * `onlyOwner`, which can be applied to your functions to restrict their use to
431  * the owner.
432  */
433 abstract contract Ownable is Context {
434     address private _owner;
435 
436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438     /**
439      * @dev Initializes the contract setting the deployer as the initial owner.
440      */
441     constructor() {
442         _setOwner(_msgSender());
443     }
444 
445     /**
446      * @dev Returns the address of the current owner.
447      */
448     function owner() public view virtual returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if called by any account other than the owner.
454      */
455     modifier onlyOwner() {
456         require(owner() == _msgSender(), "Ownable: caller is not the owner");
457         _;
458     }
459 
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public virtual onlyOwner {
468         _setOwner(address(0));
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         _setOwner(newOwner);
478     }
479 
480     function _setOwner(address newOwner) private {
481         address oldOwner = _owner;
482         _owner = newOwner;
483         emit OwnershipTransferred(oldOwner, newOwner);
484     }
485 }
486 
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Collection of functions related to the address type
492  */
493 library Address {
494     /**
495      * @dev Returns true if `account` is a contract.
496      *
497      * [IMPORTANT]
498      * ====
499      * It is unsafe to assume that an address for which this function returns
500      * false is an externally-owned account (EOA) and not a contract.
501      *
502      * Among others, `isContract` will return false for the following
503      * types of addresses:
504      *
505      *  - an externally-owned account
506      *  - a contract in construction
507      *  - an address where a contract will be created
508      *  - an address where a contract lived, but was destroyed
509      * ====
510      */
511     function isContract(address account) internal view returns (bool) {
512         // This method relies on extcodesize, which returns 0 for contracts in
513         // construction, since the code is only stored at the end of the
514         // constructor execution.
515 
516         uint256 size;
517         assembly {
518             size := extcodesize(account)
519         }
520         return size > 0;
521     }
522 
523     /**
524      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
525      * `recipient`, forwarding all available gas and reverting on errors.
526      *
527      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
528      * of certain opcodes, possibly making contracts go over the 2300 gas limit
529      * imposed by `transfer`, making them unable to receive funds via
530      * `transfer`. {sendValue} removes this limitation.
531      *
532      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
533      *
534      * IMPORTANT: because control is transferred to `recipient`, care must be
535      * taken to not create reentrancy vulnerabilities. Consider using
536      * {ReentrancyGuard} or the
537      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
538      */
539     function sendValue(address payable recipient, uint256 amount) internal {
540         require(address(this).balance >= amount, "Address: insufficient balance");
541 
542         (bool success, ) = recipient.call{value: amount}("");
543         require(success, "Address: unable to send value, recipient may have reverted");
544     }
545 
546     /**
547      * @dev Performs a Solidity function call using a low level `call`. A
548      * plain `call` is an unsafe replacement for a function call: use this
549      * function instead.
550      *
551      * If `target` reverts with a revert reason, it is bubbled up by this
552      * function (like regular Solidity function calls).
553      *
554      * Returns the raw returned data. To convert to the expected return value,
555      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
556      *
557      * Requirements:
558      *
559      * - `target` must be a contract.
560      * - calling `target` with `data` must not revert.
561      *
562      * _Available since v3.1._
563      */
564     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
565         return functionCall(target, data, "Address: low-level call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
570      * `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         return functionCallWithValue(target, data, 0, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but also transferring `value` wei to `target`.
585      *
586      * Requirements:
587      *
588      * - the calling contract must have an ETH balance of at least `value`.
589      * - the called Solidity function must be `payable`.
590      *
591      * _Available since v3.1._
592      */
593     function functionCallWithValue(
594         address target,
595         bytes memory data,
596         uint256 value
597     ) internal returns (bytes memory) {
598         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
603      * with `errorMessage` as a fallback revert reason when `target` reverts.
604      *
605      * _Available since v3.1._
606      */
607     function functionCallWithValue(
608         address target,
609         bytes memory data,
610         uint256 value,
611         string memory errorMessage
612     ) internal returns (bytes memory) {
613         require(address(this).balance >= value, "Address: insufficient balance for call");
614         require(isContract(target), "Address: call to non-contract");
615 
616         (bool success, bytes memory returndata) = target.call{value: value}(data);
617         return verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
622      * but performing a static call.
623      *
624      * _Available since v3.3._
625      */
626     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
627         return functionStaticCall(target, data, "Address: low-level static call failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
632      * but performing a static call.
633      *
634      * _Available since v3.3._
635      */
636     function functionStaticCall(
637         address target,
638         bytes memory data,
639         string memory errorMessage
640     ) internal view returns (bytes memory) {
641         require(isContract(target), "Address: static call to non-contract");
642 
643         (bool success, bytes memory returndata) = target.staticcall(data);
644         return verifyCallResult(success, returndata, errorMessage);
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
649      * but performing a delegate call.
650      *
651      * _Available since v3.4._
652      */
653     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
654         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
659      * but performing a delegate call.
660      *
661      * _Available since v3.4._
662      */
663     function functionDelegateCall(
664         address target,
665         bytes memory data,
666         string memory errorMessage
667     ) internal returns (bytes memory) {
668         require(isContract(target), "Address: delegate call to non-contract");
669 
670         (bool success, bytes memory returndata) = target.delegatecall(data);
671         return verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
676      * revert reason using the provided one.
677      *
678      * _Available since v4.3._
679      */
680     function verifyCallResult(
681         bool success,
682         bytes memory returndata,
683         string memory errorMessage
684     ) internal pure returns (bytes memory) {
685         if (success) {
686             return returndata;
687         } else {
688             // Look for revert reason and bubble it up if present
689             if (returndata.length > 0) {
690                 // The easiest way to bubble the revert reason is using memory via assembly
691 
692                 assembly {
693                     let returndata_size := mload(returndata)
694                     revert(add(32, returndata), returndata_size)
695                 }
696             } else {
697                 revert(errorMessage);
698             }
699         }
700     }
701 }
702 
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @title ERC721 token receiver interface
708  * @dev Interface for any contract that wants to support safeTransfers
709  * from ERC721 asset contracts.
710  */
711 interface IERC721Receiver {
712     /**
713      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
714      * by `operator` from `from`, this function is called.
715      *
716      * It must return its Solidity selector to confirm the token transfer.
717      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
718      *
719      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
720      */
721     function onERC721Received(
722         address operator,
723         address from,
724         uint256 tokenId,
725         bytes calldata data
726     ) external returns (bytes4);
727 }
728 
729 
730 pragma solidity ^0.8.0;
731 
732 /**
733  * @dev Interface of the ERC165 standard, as defined in the
734  * https://eips.ethereum.org/EIPS/eip-165[EIP].
735  *
736  * Implementers can declare support of contract interfaces, which can then be
737  * queried by others ({ERC165Checker}).
738  *
739  * For an implementation, see {ERC165}.
740  */
741 interface IERC165 {
742     /**
743      * @dev Returns true if this contract implements the interface defined by
744      * `interfaceId`. See the corresponding
745      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
746      * to learn more about how these ids are created.
747      *
748      * This function call must use less than 30 000 gas.
749      */
750     function supportsInterface(bytes4 interfaceId) external view returns (bool);
751 }
752 
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @dev Implementation of the {IERC165} interface.
759  *
760  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
761  * for the additional interface id that will be supported. For example:
762  *
763  * ```solidity
764  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
766  * }
767  * ```
768  *
769  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
770  */
771 abstract contract ERC165 is IERC165 {
772     /**
773      * @dev See {IERC165-supportsInterface}.
774      */
775     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
776         return interfaceId == type(IERC165).interfaceId;
777     }
778 }
779 
780 
781 pragma solidity ^0.8.0;
782 
783 
784 
785 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
786 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
787     struct RoyaltyInfo {
788         address recipient;
789         uint24 amount;
790     }
791 
792     /// @inheritdoc	ERC165
793     function supportsInterface(bytes4 interfaceId)
794         public
795         view
796         virtual
797         override
798         returns (bool)
799     {
800         return
801             interfaceId == type(IERC2981Royalties).interfaceId ||
802             super.supportsInterface(interfaceId);
803     }
804 }
805 
806 
807 pragma solidity ^0.8.0;
808 
809 
810 
811 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
812 /// @dev This implementation has the same royalties for each and every tokens
813 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
814     RoyaltyInfo private _royalties;
815 
816     /// @dev Sets token royalties
817     /// @param recipient recipient of the royalties
818     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
819     function _setRoyalties(address recipient, uint256 value) internal {
820         require(value <= 10000, 'ERC2981Royalties: Too high');
821         _royalties = RoyaltyInfo(recipient, uint24(value));
822     }
823 
824     /// @inheritdoc	IERC2981Royalties
825     function royaltyInfo(uint256, uint256 value)
826         external
827         view
828         override
829         returns (address receiver, uint256 royaltyAmount)
830     {
831         RoyaltyInfo memory royalties = _royalties;
832         receiver = royalties.recipient;
833         royaltyAmount = (value * royalties.amount) / 10000;
834     }
835 }
836 
837 
838 pragma solidity ^0.8.0;
839 
840 
841 /**
842  * @dev Required interface of an ERC721 compliant contract.
843  */
844 interface IERC721 is IERC165 {
845     /**
846      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
847      */
848     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
849 
850     /**
851      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
852      */
853     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
854 
855     /**
856      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
857      */
858     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
859 
860     /**
861      * @dev Returns the number of tokens in ``owner``'s account.
862      */
863     function balanceOf(address owner) external view returns (uint256 balance);
864 
865     /**
866      * @dev Returns the owner of the `tokenId` token.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function ownerOf(uint256 tokenId) external view returns (address owner);
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
876      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must exist and be owned by `from`.
883      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) external;
893 
894     /**
895      * @dev Transfers `tokenId` token from `from` to `to`.
896      *
897      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
898      *
899      * Requirements:
900      *
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
905      *
906      * Emits a {Transfer} event.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) external;
913 
914     /**
915      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
916      * The approval is cleared when the token is transferred.
917      *
918      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
919      *
920      * Requirements:
921      *
922      * - The caller must own the token or be an approved operator.
923      * - `tokenId` must exist.
924      *
925      * Emits an {Approval} event.
926      */
927     function approve(address to, uint256 tokenId) external;
928 
929     /**
930      * @dev Returns the account approved for `tokenId` token.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must exist.
935      */
936     function getApproved(uint256 tokenId) external view returns (address operator);
937 
938     /**
939      * @dev Approve or remove `operator` as an operator for the caller.
940      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
941      *
942      * Requirements:
943      *
944      * - The `operator` cannot be the caller.
945      *
946      * Emits an {ApprovalForAll} event.
947      */
948     function setApprovalForAll(address operator, bool _approved) external;
949 
950     /**
951      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
952      *
953      * See {setApprovalForAll}
954      */
955     function isApprovedForAll(address owner, address operator) external view returns (bool);
956 
957     /**
958      * @dev Safely transfers `tokenId` token from `from` to `to`.
959      *
960      * Requirements:
961      *
962      * - `from` cannot be the zero address.
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must exist and be owned by `from`.
965      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
967      *
968      * Emits a {Transfer} event.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes calldata data
975     ) external;
976 }
977 
978 
979 pragma solidity ^0.8.0;
980 
981 
982 /**
983  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
984  * @dev See https://eips.ethereum.org/EIPS/eip-721
985  */
986 interface IERC721Enumerable is IERC721 {
987     /**
988      * @dev Returns the total amount of tokens stored by the contract.
989      */
990     function totalSupply() external view returns (uint256);
991 
992     /**
993      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
994      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
995      */
996     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
997 
998     /**
999      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1000      * Use along with {totalSupply} to enumerate all tokens.
1001      */
1002     function tokenByIndex(uint256 index) external view returns (uint256);
1003 }
1004 
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 
1009 /**
1010  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1011  * @dev See https://eips.ethereum.org/EIPS/eip-721
1012  */
1013 interface IERC721Metadata is IERC721 {
1014     /**
1015      * @dev Returns the token collection name.
1016      */
1017     function name() external view returns (string memory);
1018 
1019     /**
1020      * @dev Returns the token collection symbol.
1021      */
1022     function symbol() external view returns (string memory);
1023 
1024     /**
1025      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1026      */
1027     function tokenURI(uint256 tokenId) external view returns (string memory);
1028 }
1029 
1030 
1031 pragma solidity ^0.8.0;
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
1434 
1435 pragma solidity ^0.8.0;
1436 
1437 
1438 /**
1439  * @dev ERC721 token with storage based token URI management.
1440  */
1441 abstract contract ERC721URIStorage is ERC721 {
1442     using Strings for uint256;
1443 
1444     // Optional mapping for token URIs
1445     mapping(uint256 => string) private _tokenURIs;
1446 
1447     /**
1448      * @dev See {IERC721Metadata-tokenURI}.
1449      */
1450     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1451         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1452 
1453         string memory _tokenURI = _tokenURIs[tokenId];
1454         string memory base = _baseURI();
1455 
1456         // If there is no base URI, return the token URI.
1457         if (bytes(base).length == 0) {
1458             return _tokenURI;
1459         }
1460         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1461         if (bytes(_tokenURI).length > 0) {
1462             return string(abi.encodePacked(base, _tokenURI));
1463         }
1464 
1465         return super.tokenURI(tokenId);
1466     }
1467 
1468     /**
1469      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1470      *
1471      * Requirements:
1472      *
1473      * - `tokenId` must exist.
1474      */
1475     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1476         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1477         _tokenURIs[tokenId] = _tokenURI;
1478     }
1479 
1480     /**
1481      * @dev Destroys `tokenId`.
1482      * The approval is cleared when the token is burned.
1483      *
1484      * Requirements:
1485      *
1486      * - `tokenId` must exist.
1487      *
1488      * Emits a {Transfer} event.
1489      */
1490     function _burn(uint256 tokenId) internal virtual override {
1491         super._burn(tokenId);
1492 
1493         if (bytes(_tokenURIs[tokenId]).length != 0) {
1494             delete _tokenURIs[tokenId];
1495         }
1496     }
1497 }
1498 
1499 
1500 pragma solidity ^0.8.0;
1501 
1502 
1503 
1504 /**
1505  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1506  * enumerability of all the token ids in the contract as well as all token ids owned by each
1507  * account.
1508  */
1509 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1510     // Mapping from owner to list of owned token IDs
1511     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1512 
1513     // Mapping from token ID to index of the owner tokens list
1514     mapping(uint256 => uint256) private _ownedTokensIndex;
1515 
1516     // Array with all token ids, used for enumeration
1517     uint256[] private _allTokens;
1518 
1519     // Mapping from token id to position in the allTokens array
1520     mapping(uint256 => uint256) private _allTokensIndex;
1521 
1522     /**
1523      * @dev See {IERC165-supportsInterface}.
1524      */
1525     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1526         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1527     }
1528 
1529     /**
1530      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1531      */
1532     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1533         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1534         return _ownedTokens[owner][index];
1535     }
1536 
1537     /**
1538      * @dev See {IERC721Enumerable-totalSupply}.
1539      */
1540     function totalSupply() public view virtual override returns (uint256) {
1541         return _allTokens.length;
1542     }
1543 
1544     /**
1545      * @dev See {IERC721Enumerable-tokenByIndex}.
1546      */
1547     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1548         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1549         return _allTokens[index];
1550     }
1551 
1552     /**
1553      * @dev Hook that is called before any token transfer. This includes minting
1554      * and burning.
1555      *
1556      * Calling conditions:
1557      *
1558      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1559      * transferred to `to`.
1560      * - When `from` is zero, `tokenId` will be minted for `to`.
1561      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1562      * - `from` cannot be the zero address.
1563      * - `to` cannot be the zero address.
1564      *
1565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1566      */
1567     function _beforeTokenTransfer(
1568         address from,
1569         address to,
1570         uint256 tokenId
1571     ) internal virtual override {
1572         super._beforeTokenTransfer(from, to, tokenId);
1573 
1574         if (from == address(0)) {
1575             _addTokenToAllTokensEnumeration(tokenId);
1576         } else if (from != to) {
1577             _removeTokenFromOwnerEnumeration(from, tokenId);
1578         }
1579         if (to == address(0)) {
1580             _removeTokenFromAllTokensEnumeration(tokenId);
1581         } else if (to != from) {
1582             _addTokenToOwnerEnumeration(to, tokenId);
1583         }
1584     }
1585 
1586     /**
1587      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1588      * @param to address representing the new owner of the given token ID
1589      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1590      */
1591     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1592         uint256 length = ERC721.balanceOf(to);
1593         _ownedTokens[to][length] = tokenId;
1594         _ownedTokensIndex[tokenId] = length;
1595     }
1596 
1597     /**
1598      * @dev Private function to add a token to this extension's token tracking data structures.
1599      * @param tokenId uint256 ID of the token to be added to the tokens list
1600      */
1601     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1602         _allTokensIndex[tokenId] = _allTokens.length;
1603         _allTokens.push(tokenId);
1604     }
1605 
1606     /**
1607      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1608      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1609      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1610      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1611      * @param from address representing the previous owner of the given token ID
1612      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1613      */
1614     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1615         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1616         // then delete the last slot (swap and pop).
1617 
1618         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1619         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1620 
1621         // When the token to delete is the last token, the swap operation is unnecessary
1622         if (tokenIndex != lastTokenIndex) {
1623             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1624 
1625             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1626             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1627         }
1628 
1629         // This also deletes the contents at the last position of the array
1630         delete _ownedTokensIndex[tokenId];
1631         delete _ownedTokens[from][lastTokenIndex];
1632     }
1633 
1634     /**
1635      * @dev Private function to remove a token from this extension's token tracking data structures.
1636      * This has O(1) time complexity, but alters the order of the _allTokens array.
1637      * @param tokenId uint256 ID of the token to be removed from the tokens list
1638      */
1639     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1640         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1641         // then delete the last slot (swap and pop).
1642 
1643         uint256 lastTokenIndex = _allTokens.length - 1;
1644         uint256 tokenIndex = _allTokensIndex[tokenId];
1645 
1646         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1647         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1648         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1649         uint256 lastTokenId = _allTokens[lastTokenIndex];
1650 
1651         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1652         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1653 
1654         // This also deletes the contents at the last position of the array
1655         delete _allTokensIndex[tokenId];
1656         _allTokens.pop();
1657     }
1658 }
1659 
1660 
1661 pragma solidity ^0.8.0;
1662 
1663 /**
1664  * @dev Interface of the ERC20 standard as defined in the EIP.
1665  */
1666 interface IERC20 {
1667     /**
1668      * @dev Returns the amount of tokens in existence.
1669      */
1670     function totalSupply() external view returns (uint256);
1671 
1672     /**
1673      * @dev Returns the amount of tokens owned by `account`.
1674      */
1675     function balanceOf(address account) external view returns (uint256);
1676 
1677     /**
1678      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1679      *
1680      * Returns a boolean value indicating whether the operation succeeded.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function transfer(address recipient, uint256 amount) external returns (bool);
1685 
1686     /**
1687      * @dev Returns the remaining number of tokens that `spender` will be
1688      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1689      * zero by default.
1690      *
1691      * This value changes when {approve} or {transferFrom} are called.
1692      */
1693     function allowance(address owner, address spender) external view returns (uint256);
1694 
1695     /**
1696      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1697      *
1698      * Returns a boolean value indicating whether the operation succeeded.
1699      *
1700      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1701      * that someone may use both the old and the new allowance by unfortunate
1702      * transaction ordering. One possible solution to mitigate this race
1703      * condition is to first reduce the spender's allowance to 0 and set the
1704      * desired value afterwards:
1705      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1706      *
1707      * Emits an {Approval} event.
1708      */
1709     function approve(address spender, uint256 amount) external returns (bool);
1710 
1711     /**
1712      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1713      * allowance mechanism. `amount` is then deducted from the caller's
1714      * allowance.
1715      *
1716      * Returns a boolean value indicating whether the operation succeeded.
1717      *
1718      * Emits a {Transfer} event.
1719      */
1720     function transferFrom(
1721         address sender,
1722         address recipient,
1723         uint256 amount
1724     ) external returns (bool);
1725 
1726     /**
1727      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1728      * another (`to`).
1729      *
1730      * Note that `value` may be zero.
1731      */
1732     event Transfer(address indexed from, address indexed to, uint256 value);
1733 
1734     /**
1735      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1736      * a call to {approve}. `value` is the new allowance.
1737      */
1738     event Approval(address indexed owner, address indexed spender, uint256 value);
1739 }
1740 
1741 
1742 pragma solidity ^0.8.0;
1743 
1744 
1745 
1746 /**
1747  * @title SafeERC20
1748  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1749  * contract returns false). Tokens that return no value (and instead revert or
1750  * throw on failure) are also supported, non-reverting calls are assumed to be
1751  * successful.
1752  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1753  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1754  */
1755 library SafeERC20 {
1756     using Address for address;
1757 
1758     function safeTransfer(
1759         IERC20 token,
1760         address to,
1761         uint256 value
1762     ) internal {
1763         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1764     }
1765 
1766     function safeTransferFrom(
1767         IERC20 token,
1768         address from,
1769         address to,
1770         uint256 value
1771     ) internal {
1772         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1773     }
1774 
1775     /**
1776      * @dev Deprecated. This function has issues similar to the ones found in
1777      * {IERC20-approve}, and its usage is discouraged.
1778      *
1779      * Whenever possible, use {safeIncreaseAllowance} and
1780      * {safeDecreaseAllowance} instead.
1781      */
1782     function safeApprove(
1783         IERC20 token,
1784         address spender,
1785         uint256 value
1786     ) internal {
1787         // safeApprove should only be called when setting an initial allowance,
1788         // or when resetting it to zero. To increase and decrease it, use
1789         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1790         require(
1791             (value == 0) || (token.allowance(address(this), spender) == 0),
1792             "SafeERC20: approve from non-zero to non-zero allowance"
1793         );
1794         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1795     }
1796 
1797     function safeIncreaseAllowance(
1798         IERC20 token,
1799         address spender,
1800         uint256 value
1801     ) internal {
1802         uint256 newAllowance = token.allowance(address(this), spender) + value;
1803         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1804     }
1805 
1806     function safeDecreaseAllowance(
1807         IERC20 token,
1808         address spender,
1809         uint256 value
1810     ) internal {
1811         unchecked {
1812             uint256 oldAllowance = token.allowance(address(this), spender);
1813             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1814             uint256 newAllowance = oldAllowance - value;
1815             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1816         }
1817     }
1818 
1819     /**
1820      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1821      * on the return value: the return value is optional (but if data is returned, it must not be false).
1822      * @param token The token targeted by the call.
1823      * @param data The call data (encoded using abi.encode or one of its variants).
1824      */
1825     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1826         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1827         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1828         // the target address contains contract code and also asserts for success in the low-level call.
1829 
1830         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1831         if (returndata.length > 0) {
1832             // Return data is optional
1833             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1834         }
1835     }
1836 }
1837 
1838 
1839 // OpenZeppelin Contracts v4.3.2 (finance/PaymentSplitter.sol)
1840 
1841 pragma solidity ^0.8.0;
1842 
1843 
1844 
1845 
1846 /**
1847  * @title PaymentSplitter
1848  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1849  * that the Ether will be split in this way, since it is handled transparently by the contract.
1850  *
1851  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1852  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1853  * an amount proportional to the percentage of total shares they were assigned.
1854  *
1855  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1856  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1857  * function.
1858  *
1859  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1860  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1861  * to run tests before sending real value to this contract.
1862  */
1863 contract PaymentSplitter is Context {
1864     event PayeeAdded(address account, uint256 shares);
1865     event PaymentReleased(address to, uint256 amount);
1866     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1867     event PaymentReceived(address from, uint256 amount);
1868     event Warning(string message);
1869 
1870     uint256 private _totalShares = 50000;
1871     uint256 private _totalReleased;
1872 
1873     mapping(address => uint256) private _shares;
1874     mapping(address => uint256) private _released;
1875     address[] private _payees;
1876 
1877     mapping(IERC20 => uint256) private _erc20TotalReleased;
1878     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1879 
1880     /**
1881      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1882      * the matching position in the `shares` array.
1883      *
1884      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1885      * duplicates in `payees`.
1886      */
1887     constructor(address[] memory payees, uint256[] memory shares_) payable {
1888         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1889         require(payees.length > 0, "PaymentSplitter: no payees");
1890 
1891         for (uint256 i = 0; i < payees.length; i++) {
1892             _addPayee(payees[i], shares_[i]);
1893         }
1894     }
1895 
1896     /**
1897      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1898      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1899      * reliability of the events, and not the actual splitting of Ether.
1900      *
1901      * To learn more about this see the Solidity documentation for
1902      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1903      * functions].
1904      */
1905     receive() external payable virtual {
1906         emit PaymentReceived(_msgSender(), msg.value);
1907     }
1908     
1909     function addToReleased(uint256 amount) internal {
1910         _totalReleased += amount;
1911     }
1912 
1913     /**
1914      * @dev Getter for the total shares held by payees.
1915      */
1916     function totalShares() public view returns (uint256) {
1917         return _totalShares;
1918     }
1919 
1920     /**
1921      * @dev Getter for the total amount of Ether already released.
1922      */
1923     function totalReleased() public view returns (uint256) {
1924         return _totalReleased;
1925     }
1926 
1927     /**
1928      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1929      * contract.
1930      */
1931     function totalReleased(IERC20 token) public view returns (uint256) {
1932         return _erc20TotalReleased[token];
1933     }
1934 
1935     /**
1936      * @dev Getter for the amount of shares held by an account.
1937      */
1938     function shares(address account) public view returns (uint256) {
1939         return _shares[account];
1940     }
1941 
1942     /**
1943      * @dev Getter for the amount of Ether already released to a payee.
1944      */
1945     function released(address account) public view returns (uint256) {
1946         return _released[account];
1947     }
1948 
1949     /**
1950      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1951      * IERC20 contract.
1952      */
1953     function released(IERC20 token, address account) public view returns (uint256) {
1954         return _erc20Released[token][account];
1955     }
1956 
1957     /**
1958      * @dev Getter for the address of the payee number `index`.
1959      */
1960     function payee(uint256 index) public view returns (address) {
1961         return _payees[index];
1962     }
1963 
1964     /**
1965      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1966      * total shares and their previous withdrawals.
1967      */
1968     function release(address payable account) public virtual {
1969         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1970 
1971         uint256 totalReceived = address(this).balance + totalReleased();
1972         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1973 
1974         if (payment != 0) {
1975             _released[account] += payment;
1976             _totalReleased += payment;
1977 
1978             Address.sendValue(account, payment);
1979             emit PaymentReleased(account, payment);
1980         } else {
1981             emit Warning("PaymentSplitter: account is not due payment");
1982         }
1983     }
1984 
1985     /**
1986      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1987      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1988      * contract.
1989      */
1990     function release(IERC20 token, address account) public virtual {
1991         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1992 
1993         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1994         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1995 
1996         if (payment != 0) {
1997             _erc20Released[token][account] += payment;
1998             _erc20TotalReleased[token] += payment;
1999 
2000             SafeERC20.safeTransfer(token, account, payment);
2001             emit ERC20PaymentReleased(token, account, payment);
2002         } else {
2003             emit Warning("PaymentSplitter: account is not due payment");
2004         }
2005     }
2006 
2007     /**
2008      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2009      * already released amounts.
2010      */
2011     function _pendingPayment(
2012         address account,
2013         uint256 totalReceived,
2014         uint256 alreadyReleased
2015     ) private view returns (uint256) {
2016         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2017     }
2018 
2019     /**
2020      * @dev Add a new payee to the contract.
2021      * @param account The address of the payee to add.
2022      * @param shares_ The number of shares owned by the payee.
2023      */
2024     function _addPayee(address account, uint256 shares_) private {
2025         require(account != address(0), "PaymentSplitter: account is the zero address");
2026         require(shares_ > 0, "PaymentSplitter: shares are 0");
2027         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2028 
2029         _payees.push(account);
2030         _shares[account] = shares_;
2031         _totalShares = _totalShares + shares_;
2032         emit PayeeAdded(account, shares_);
2033     }
2034 }
2035 
2036 pragma solidity ^0.8.7;
2037 
2038 
2039 contract MegaMilionsGangstarApes is ERC721, ERC721Enumerable, ERC721URIStorage, ERC2981ContractWideRoyalties, Ownable, PaymentSplitter {
2040     using Counters for Counters.Counter;
2041     using Strings for uint;
2042 	using Math for uint;
2043 	using SafeMath for uint;
2044     
2045     enum PriceType{ PROMO, FULL }   //{ 0, 1 }
2046     struct Promo {
2047         uint startTime;
2048         uint duration;
2049     }
2050     
2051     // Mappings
2052     mapping(address => bool) public whitelisted;
2053     mapping(address => uint) public promos;
2054     mapping(address => bool) public admins;
2055     
2056     // Default values
2057     uint internal constant MILLIETHER = 1e15; //0.001 ETHER = 1,000,000,000,000,000 WEI
2058     uint internal promoPrice = 0.1 ether;
2059     uint internal fullPrice = 0.3 ether;
2060     uint internal maxSupply = 10000;
2061     uint internal maxMint = 10;
2062     uint internal maxDiscountedMintPerUser = 2;
2063     
2064     // Vars
2065     string private baseURI;
2066     bool private paused = false;
2067     Promo private promo;
2068     
2069     // Wallet shares - 50% of revenues shared to team
2070 	address private DP = 0xcd70Dc892F240D50b7D46CE120dc75c3243E72ab;
2071 	address private RG = 0x39c34674EEC3AE5F1E9a6Ee899CB85f11a55D990;
2072 	address private JH = 0xD484E2745d27FA62E6ab0396fd46e0A3E3A00eFc;
2073 	address private LH = 0xB2CEe0977Bbb0446B358E0Cb3de69e10EdC5eDA3;
2074 	address private EA = 0x3a4FF805cD9C063f06a0263EEa99F531FAa13B91;
2075 	address private AG = 0x79f6E63B4D593F3794019A4FEFB52196C602E037;
2076 	address private JP = 0xd7EE8aF7a902bb208878E50863220e2872b73992;
2077 	address private MR = 0xaFBC38a36Cb173d75735f3f781e9133939e99888;
2078 	address private AF = 0x7a2DD031a02Fd595C7BCb0A278A4518daB31AF8d;
2079 	address private MA = 0xEe3642cb451F6f4ec5C6dd6699fFE69F2D07921E;
2080 	
2081     uint[] private _shares = [
2082         675,
2083         675,
2084         11250,
2085         6750,
2086         9865,
2087         6750,
2088         7865,
2089         270,
2090         675,
2091         5225
2092     ];
2093     address[] private _team = [
2094         DP,
2095         RG,
2096         JH,
2097         LH,
2098         EA,
2099         AG,
2100         JP,
2101         MR,
2102         AF,
2103         MA
2104     ];
2105     
2106     // Game
2107     struct RoadmapStep { 
2108         uint64 supply;
2109         uint64 winnersCount;
2110         uint64 prizeValue;
2111         uint64 winnersToDraw;
2112     }
2113     uint private drawIndex = 0;
2114     RoadmapStep[9] private roadmap;
2115     mapping(uint => bool) internal isPrizeGiven;
2116     
2117     // Modifiers
2118     modifier onlyAdmin() {
2119         require(address(this) == _msgSender() || owner() == _msgSender() || admins[msg.sender], "Not admin");
2120         _;
2121     }
2122     
2123     // Emitters
2124     event BaseURIChanged(string tokenBaseURI);
2125     event TicketPriceChanged(PriceType priceType, uint price);
2126     event MaxMintAmountChanged(uint amount);
2127     event MaxDiscountedMintPerUser(uint mintPerUser);
2128     event Paused(bool paused);
2129     event PromoChanged(uint startTime, uint duration);
2130     event Airdropped(address to, uint tokenId);
2131     event Winner(uint token, address winner, uint value);
2132     event Log(string error);
2133 
2134     constructor()
2135         ERC721("Mega Millions Gangstar Apes", "MMGA")
2136         PaymentSplitter(_team, _shares)
2137     {
2138         //set default admins
2139         admins[DP] = true;
2140         admins[RG] = true;
2141         
2142         initRoadmap();
2143         
2144         //if ERC2981 supported
2145         _setRoyalties(address(this), 1000);  //10%
2146     }
2147     
2148     // ***************************
2149     //  Overrides
2150     // ***************************
2151     function _beforeTokenTransfer(address from, address to, uint tokenId)
2152         internal
2153         override(ERC721, ERC721Enumerable) {
2154         super._beforeTokenTransfer(from, to, tokenId);
2155     }
2156 
2157     function supportsInterface(bytes4 interfaceId)
2158         public
2159         view
2160         override(ERC721, ERC721Enumerable, ERC2981Base)
2161         returns (bool) {
2162         return super.supportsInterface(interfaceId);
2163     }
2164     
2165     function _burn(uint _tokenId) 
2166         internal
2167         override(ERC721, ERC721URIStorage) {
2168         super._burn(_tokenId);
2169     }
2170     
2171     function burn(uint _tokenId) external onlyAdmin {
2172         _burn(_tokenId);
2173         maxSupply = maxSupply - 1;
2174     }
2175 
2176     // ***************************
2177     //  Admins management by owner
2178     // ***************************
2179     function enableAdmin(address addr) external onlyOwner {
2180         admins[addr] = true;
2181     }
2182 
2183     function disableAdmin(address addr) external onlyOwner {
2184         require(addr != owner(), "Can't disable owner");
2185         admins[addr] = false;
2186     }
2187     
2188     // ***************************
2189     //  Release & withdraw
2190     // ***************************
2191     function releaseAll() public onlyAdmin {
2192         for (uint i = 0; i < _team.length; i++) {
2193             address member = _team[i];
2194             try this.release(payable(member)) {}
2195             catch Error(string memory revertReason) {
2196                 emit Log(revertReason);
2197             } catch (bytes memory returnData) {
2198                 emit Log(string(returnData));
2199             }
2200         }
2201     }
2202     
2203     function withdraw() external onlyAdmin {
2204         releaseAll();
2205         pay(payable(owner()), address(this).balance);
2206     }
2207     
2208     // ***************************
2209     //  Contract management
2210     // ***************************
2211     function pause(bool newState) external onlyAdmin {
2212         paused = newState;
2213         emit Paused(newState);
2214     }
2215  
2216     function addWhitelistedUsers(address[] calldata users) external onlyAdmin {
2217         for (uint i = 0; i < users.length; i++) {
2218             require(users[i] != address(0), "Can't add a zero address");
2219             if (whitelisted[users[i]] == false) {
2220                 whitelisted[users[i]] = true;
2221             }
2222         }
2223     }
2224  
2225     function removeWhitelistedUsers(address[] calldata users) external onlyAdmin {
2226         for (uint i = 0; i < users.length; i++) {
2227             require(users[i] != address(0), "Can't remove a zero address");
2228             if (whitelisted[users[i]] == true) {
2229                 whitelisted[users[i]] = false;
2230             }
2231         }
2232     }
2233     // Duration in seconds
2234     function startPromo(uint duration) external onlyAdmin {
2235         uint startTime = block.timestamp;
2236         promo = Promo(startTime, duration);
2237         emit PromoChanged(startTime, duration);
2238     }
2239 
2240     // ***************************
2241     //  URI management (Reveal)
2242     // ***************************
2243     function _baseURI() internal view virtual override returns (string memory) {
2244         return baseURI;
2245     }
2246     
2247     function setBaseURI(string memory newBaseURI) external onlyAdmin {
2248         baseURI = newBaseURI;
2249         emit BaseURIChanged(newBaseURI);
2250     }
2251 
2252     function setTokenURI(uint _tokenId, string memory _tokenURI) external onlyAdmin {
2253         require(_exists(_tokenId), "URI set of nonexistent token");
2254         _setTokenURI(_tokenId, _tokenURI);
2255     }
2256     
2257     function tokenURI(uint _tokenId)
2258         public
2259         view
2260         override(ERC721, ERC721URIStorage)
2261         returns (string memory) {
2262         return super.tokenURI(_tokenId);
2263     }
2264 
2265     // ***************************
2266     //  Promo & price management
2267     // ***************************
2268     function setPrice(PriceType priceType, uint price) external onlyAdmin {
2269         require(price > 0, "Zero price");
2270         if (priceType == PriceType.PROMO) {
2271             promoPrice = price;
2272         } else if (priceType == PriceType.FULL) {
2273             fullPrice = price;
2274         }
2275         emit TicketPriceChanged(priceType, price);
2276     }
2277     
2278     function setMaxMintAmount(uint amount) external onlyAdmin {
2279         maxMint = amount;
2280         emit MaxMintAmountChanged(amount);
2281     }
2282     
2283     function setMaxDiscountedMintPerUser(uint mintPerUser) external onlyAdmin {
2284         maxDiscountedMintPerUser = mintPerUser;
2285         emit MaxDiscountedMintPerUser(mintPerUser);
2286     }
2287     
2288     function isPromo() public view returns (bool) {
2289         return (promo.startTime > 0 &&
2290                 block.timestamp >= promo.startTime &&
2291                 block.timestamp <= (promo.startTime + promo.duration));
2292     }
2293     
2294     // Dynamically gets the token price according to promo, whitelist and msg.sender
2295     function getPrice() public view returns (uint) {
2296         uint price = fullPrice;
2297         if (admins[msg.sender] == true) {
2298 			price = 0;
2299 		} else if ((isPromo() || whitelisted[msg.sender] == true) &&
2300             promos[msg.sender] < maxDiscountedMintPerUser)
2301         {
2302             price = promoPrice;
2303         }
2304         return price;
2305     }
2306     
2307     // ***************************
2308     //  Mint, Gift & Airdrop
2309     // ***************************
2310     function mint(address to, uint amount) external payable {
2311         uint supply = totalSupply();
2312         bool discounted = (getPrice() == promoPrice);
2313         require(!paused, "Contract is paused");
2314         require(amount > 0, "Amount is zero");
2315         require(amount <= maxMint, "Amount exceeds max mint");
2316         require(supply + amount <= maxSupply, "Max supply reached");
2317         if (admins[msg.sender] != true) {
2318             if (discounted) {
2319                 require(promos[to] + amount <= maxDiscountedMintPerUser, "Max discounted NFT exceeded for this user");
2320             }
2321             require(getPrice().mul(amount) == msg.value, "Ether value sent is not correct");
2322         }
2323         for (uint i = 1; i <= amount; i++) {
2324             _safeMint(to, supply + i);
2325             if(discounted) {
2326                 promos[to] = promos[to] + 1;
2327             }
2328         }
2329     }
2330     
2331     function gift(address to, uint amount) external onlyAdmin {
2332         uint supply = totalSupply();
2333         require(!paused, "Contract is paused");
2334         require(amount > 0, "Amount is zero");
2335         require(amount <= maxMint, "Amount exceeds max mint");
2336         require(supply + amount <= maxSupply, "Max supply reached");
2337         for (uint i = 1; i <= amount; i++) {
2338             _safeMint(to, supply + i);
2339         }
2340     }
2341     
2342     function airdrop(address to, uint tokenId) external onlyAdmin {
2343         require(!paused, "Contract is paused");
2344         require(to != address(0), "Can't airdrop to a zero address");
2345         safeTransferFrom(msg.sender, to, tokenId);
2346         emit Airdropped(to, tokenId);
2347     }
2348     
2349     
2350     // ***************************
2351     //  Game management
2352     // ***************************
2353     
2354     // Main function to draw the roadmap prizes and pay the winners
2355     function draw() external payable onlyAdmin {
2356         require(!paused, "Contract is paused");
2357         releaseAll();
2358         uint[] memory prizes = consumeRoadmapPrizes(totalSupply());
2359         uint nonce = block.difficulty;
2360         for (uint i = 0; i < prizes.length; i++) {
2361             uint tokenId = randToken(i, nonce);
2362             require(tokenId != 0, "Incorrect tokenId");
2363             address winner = ownerOf(tokenId);
2364             require(winner != address(0), "Can't pay a zero address");
2365             pay(payable(winner), (prizes[i] * MILLIETHER));
2366             nonce=nonce^uint(keccak256(abi.encodePacked(winner)));
2367             emit Winner(tokenId, winner, prizes[i]);
2368         }
2369     }
2370     
2371     // Alternative draw method to choose one random winner with a given prize
2372     function drawOne(uint milliEther) external payable onlyAdmin {
2373         require(!paused, "Contract is paused");
2374         releaseAll();
2375         uint seed = uint(keccak256(abi.encodePacked(block.coinbase)));
2376         uint nonce = uint(keccak256(abi.encodePacked(msg.sender)));
2377         uint tokenId = randToken(seed, nonce);
2378         require(tokenId != 0, "Incorrect tokenId");
2379         address winner = ownerOf(tokenId);
2380         require(winner != address(0), "Can't pay a zero address");
2381         pay(payable(winner), (milliEther * MILLIETHER));
2382         emit Winner(tokenId, winner, milliEther);
2383     }
2384     
2385     // ***************************
2386     //  Internals
2387     // ***************************
2388     
2389     // Initialize the roadmap
2390     function initRoadmap() internal onlyAdmin {
2391         roadmap[0] = RoadmapStep(1000,2,22000,1);
2392         roadmap[1] = RoadmapStep(2000,3,22000,1);
2393         roadmap[2] = RoadmapStep(3000,1,44000,1);
2394         roadmap[3] = RoadmapStep(4000,1,44000,1);
2395         roadmap[4] = RoadmapStep(5000,50,1100,2);
2396         roadmap[5] = RoadmapStep(7000,50,1100,2);
2397         roadmap[6] = RoadmapStep(7000,10,11000,1);
2398         roadmap[7] = RoadmapStep(10000,1,220000,1);
2399         roadmap[8] = RoadmapStep(10000,50,2200,1);
2400     }
2401     
2402     // Consume some prizes according to the roadmap
2403     // Rule : winnersCount per week and only one prizeValue same amount at a time.
2404     function consumeRoadmapPrizes(uint supply) internal onlyAdmin returns (uint[] memory) {    
2405         uint index = 0;
2406         uint[] memory temp = new uint[](16);
2407         for (uint i = 0; i < 9; i++) {
2408             isPrizeGiven[roadmap[i].prizeValue] = false;
2409         }
2410         for (uint i = 0; i < roadmap.length; i++) {
2411             if (roadmap[i].supply > supply) {
2412                 break;
2413             }
2414             if ((roadmap[i].supply <= supply) &&
2415                 (roadmap[i].winnersCount > 0) &&
2416                 !isPrizeGiven[roadmap[i].prizeValue]) {
2417                 for (uint j = 0; j < Math.min(roadmap[i].winnersToDraw, roadmap[i].winnersCount); j++) {
2418                     roadmap[i].winnersCount--;
2419                     temp[index] = roadmap[i].prizeValue;
2420                     index++;
2421                 }
2422                 isPrizeGiven[roadmap[i].prizeValue] = true;
2423             }
2424         }
2425         uint[] memory prizes = new uint[](index);
2426         for (uint i = 0; i < index; i++) {
2427             prizes[i] = temp[i];
2428         }
2429         return prizes;
2430     }
2431 
2432     // Randomly picks a tokenId
2433     function randToken(uint seed, uint nonce) internal view onlyAdmin returns(uint) {
2434         uint supply = totalSupply();
2435         if (supply > 0) {
2436             uint tokenId = randModulus(supply, seed, nonce);
2437             if (tokenId > 0) {
2438                 return tokenId;
2439             }
2440         }
2441         return 0;
2442     }
2443     
2444     // Pays eth amount to an address
2445     function pay(address payable to, uint amount) internal onlyAdmin {
2446         require(to != address(0), "Can't pay a zero address");
2447         require(address(this).balance >= amount, "No sufficient fund in contract to pay the address");
2448         (bool sent, bytes memory data) = to.call{value: amount}("");
2449         if (sent) {
2450             addToReleased(amount);
2451         }
2452         require(sent, string(abi.encodePacked("Failed to send Ether:", data)));
2453     } 
2454     
2455     // Gets a random number
2456     function randModulus(uint max, uint seed, uint nonce) internal view returns(uint) {
2457         uint blockNumber = block.number-1;
2458         if (block.number>(seed % 256)) {
2459             blockNumber=block.number-(seed % 256);
2460         }
2461         uint rand = uint(keccak256(abi.encodePacked(
2462             seed^block.timestamp,
2463             block.timestamp, 
2464             msg.data,
2465             nonce, 
2466             msg.sender,
2467             blockhash(blockNumber)
2468             )
2469         )) % max;
2470         return rand+1;
2471     }
2472 }