1 // Mint via contract or website @ www.pixelversenft.com 
2 
3 // 0.08 ETH - 1200 SUPPLY
4 
5 // Burn your $PIXEL for 0.08 ETH back
6 
7 // SPDX-License-Identifier: GPL-3.0
8 
9 // File: @openzeppelin/contracts/utils/Counters.sol
10 
11 
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @title Counters
17  * @author Matt Condon (@shrugs)
18  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
19  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
20  *
21  * Include with `using Counters for Counters.Counter;`
22  */
23 library Counters {
24     struct Counter {
25         // This variable should never be directly accessed by users of the library: interactions must be restricted to
26         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
27         // this feature: see https://github.com/ethereum/solidity/issues/4637
28         uint256 _value; // default: 0
29     }
30 
31     function current(Counter storage counter) internal view returns (uint256) {
32         return counter._value;
33     }
34 
35     function increment(Counter storage counter) internal {
36         unchecked {
37             counter._value += 1;
38         }
39     }
40 
41     function decrement(Counter storage counter) internal {
42         uint256 value = counter._value;
43         require(value > 0, "Counter: decrement overflow");
44         unchecked {
45             counter._value = value - 1;
46         }
47     }
48 
49     function reset(Counter storage counter) internal {
50         counter._value = 0;
51     }
52 }
53 
54 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
55 
56 
57 
58 pragma solidity ^0.8.0;
59 
60 // CAUTION
61 // This version of SafeMath should only be used with Solidity 0.8 or later,
62 // because it relies on the compiler's built in overflow checks.
63 
64 /**
65  * @dev Wrappers over Solidity's arithmetic operations.
66  *
67  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
68  * now has built in overflow checking.
69  */
70 library SafeMath {
71     /**
72      * @dev Returns the addition of two unsigned integers, with an overflow flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             uint256 c = a + b;
79             if (c < a) return (false, 0);
80             return (true, c);
81         }
82     }
83 
84     /**
85      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
86      *
87      * _Available since v3.4._
88      */
89     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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
101     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104             // benefit is lost if 'b' is also tested.
105             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106             if (a == 0) return (true, 0);
107             uint256 c = a * b;
108             if (c / a != b) return (false, 0);
109             return (true, c);
110         }
111     }
112 
113     /**
114      * @dev Returns the division of two unsigned integers, with a division by zero flag.
115      *
116      * _Available since v3.4._
117      */
118     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b == 0) return (false, 0);
121             return (true, a / b);
122         }
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             if (b == 0) return (false, 0);
133             return (true, a % b);
134         }
135     }
136 
137     /**
138      * @dev Returns the addition of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `+` operator.
142      *
143      * Requirements:
144      *
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a + b;
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a - b;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a * b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator.
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a / b;
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * reverting when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a % b;
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211      * overflow (when the result is negative).
212      *
213      * CAUTION: This function is deprecated because it requires allocating memory for the error
214      * message unnecessarily. For custom revert reasons use {trySub}.
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b <= a, errorMessage);
229             return a - b;
230         }
231     }
232 
233     /**
234      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
235      * division by zero. The result is rounded towards zero.
236      *
237      * Counterpart to Solidity's `/` operator. Note: this function uses a
238      * `revert` opcode (which leaves remaining gas untouched) while Solidity
239      * uses an invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(
246         uint256 a,
247         uint256 b,
248         string memory errorMessage
249     ) internal pure returns (uint256) {
250         unchecked {
251             require(b > 0, errorMessage);
252             return a / b;
253         }
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * reverting with custom message when dividing by zero.
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {tryMod}.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a % b;
279         }
280     }
281 }
282 
283 // File: @openzeppelin/contracts/utils/Strings.sol
284 
285 
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev String operations.
291  */
292 library Strings {
293     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
294 
295     /**
296      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
297      */
298     function toString(uint256 value) internal pure returns (string memory) {
299         // Inspired by OraclizeAPI's implementation - MIT licence
300         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
301 
302         if (value == 0) {
303             return "0";
304         }
305         uint256 temp = value;
306         uint256 digits;
307         while (temp != 0) {
308             digits++;
309             temp /= 10;
310         }
311         bytes memory buffer = new bytes(digits);
312         while (value != 0) {
313             digits -= 1;
314             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
315             value /= 10;
316         }
317         return string(buffer);
318     }
319 
320     /**
321      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
322      */
323     function toHexString(uint256 value) internal pure returns (string memory) {
324         if (value == 0) {
325             return "0x00";
326         }
327         uint256 temp = value;
328         uint256 length = 0;
329         while (temp != 0) {
330             length++;
331             temp >>= 8;
332         }
333         return toHexString(value, length);
334     }
335 
336     /**
337      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
338      */
339     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
340         bytes memory buffer = new bytes(2 * length + 2);
341         buffer[0] = "0";
342         buffer[1] = "x";
343         for (uint256 i = 2 * length + 1; i > 1; --i) {
344             buffer[i] = _HEX_SYMBOLS[value & 0xf];
345             value >>= 4;
346         }
347         require(value == 0, "Strings: hex length insufficient");
348         return string(buffer);
349     }
350 }
351 
352 // File: @openzeppelin/contracts/utils/Context.sol
353 
354 
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @dev Provides information about the current execution context, including the
360  * sender of the transaction and its data. While these are generally available
361  * via msg.sender and msg.data, they should not be accessed in such a direct
362  * manner, since when dealing with meta-transactions the account sending and
363  * paying for execution may not be the actual sender (as far as an application
364  * is concerned).
365  *
366  * This contract is only required for intermediate, library-like contracts.
367  */
368 abstract contract Context {
369     function _msgSender() internal view virtual returns (address) {
370         return msg.sender;
371     }
372 
373     function _msgData() internal view virtual returns (bytes calldata) {
374         return msg.data;
375     }
376 }
377 
378 // File: @openzeppelin/contracts/access/Ownable.sol
379 
380 
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * there is an account (an owner) that can be granted exclusive access to
388  * specific functions.
389  *
390  * By default, the owner account will be the one that deploys the contract. This
391  * can later be changed with {transferOwnership}.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 abstract contract Ownable is Context {
398     address private _owner;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor() {
406         _setOwner(_msgSender());
407     }
408 
409     /**
410      * @dev Returns the address of the current owner.
411      */
412     function owner() public view virtual returns (address) {
413         return _owner;
414     }
415 
416     /**
417      * @dev Throws if called by any account other than the owner.
418      */
419     modifier onlyOwner() {
420         require(owner() == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424     /**
425      * @dev Leaves the contract without owner. It will not be possible to call
426      * `onlyOwner` functions anymore. Can only be called by the current owner.
427      *
428      * NOTE: Renouncing ownership will leave the contract without an owner,
429      * thereby removing any functionality that is only available to the owner.
430      */
431     function renounceOwnership() public virtual onlyOwner {
432         _setOwner(address(0));
433     }
434 
435     /**
436      * @dev Transfers ownership of the contract to a new account (`newOwner`).
437      * Can only be called by the current owner.
438      */
439     function transferOwnership(address newOwner) public virtual onlyOwner {
440         require(newOwner != address(0), "Ownable: new owner is the zero address");
441         _setOwner(newOwner);
442     }
443 
444     function _setOwner(address newOwner) private {
445         address oldOwner = _owner;
446         _owner = newOwner;
447         emit OwnershipTransferred(oldOwner, newOwner);
448     }
449 }
450 
451 // File: @openzeppelin/contracts/utils/Address.sol
452 
453 
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // This method relies on extcodesize, which returns 0 for contracts in
480         // construction, since the code is only stored at the end of the
481         // constructor execution.
482 
483         uint256 size;
484         assembly {
485             size := extcodesize(account)
486         }
487         return size > 0;
488     }
489 
490     /**
491      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
492      * `recipient`, forwarding all available gas and reverting on errors.
493      *
494      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
495      * of certain opcodes, possibly making contracts go over the 2300 gas limit
496      * imposed by `transfer`, making them unable to receive funds via
497      * `transfer`. {sendValue} removes this limitation.
498      *
499      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
500      *
501      * IMPORTANT: because control is transferred to `recipient`, care must be
502      * taken to not create reentrancy vulnerabilities. Consider using
503      * {ReentrancyGuard} or the
504      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
505      */
506     function sendValue(address payable recipient, uint256 amount) internal {
507         require(address(this).balance >= amount, "Address: insufficient balance");
508 
509         (bool success, ) = recipient.call{value: amount}("");
510         require(success, "Address: unable to send value, recipient may have reverted");
511     }
512 
513     /**
514      * @dev Performs a Solidity function call using a low level `call`. A
515      * plain `call` is an unsafe replacement for a function call: use this
516      * function instead.
517      *
518      * If `target` reverts with a revert reason, it is bubbled up by this
519      * function (like regular Solidity function calls).
520      *
521      * Returns the raw returned data. To convert to the expected return value,
522      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
523      *
524      * Requirements:
525      *
526      * - `target` must be a contract.
527      * - calling `target` with `data` must not revert.
528      *
529      * _Available since v3.1._
530      */
531     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionCall(target, data, "Address: low-level call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
537      * `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, 0, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but also transferring `value` wei to `target`.
552      *
553      * Requirements:
554      *
555      * - the calling contract must have an ETH balance of at least `value`.
556      * - the called Solidity function must be `payable`.
557      *
558      * _Available since v3.1._
559      */
560     function functionCallWithValue(
561         address target,
562         bytes memory data,
563         uint256 value
564     ) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
570      * with `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(
575         address target,
576         bytes memory data,
577         uint256 value,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         require(address(this).balance >= value, "Address: insufficient balance for call");
581         require(isContract(target), "Address: call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.call{value: value}(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
594         return functionStaticCall(target, data, "Address: low-level static call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.staticcall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
621         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal returns (bytes memory) {
635         require(isContract(target), "Address: delegate call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.delegatecall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
643      * revert reason using the provided one.
644      *
645      * _Available since v4.3._
646      */
647     function verifyCallResult(
648         bool success,
649         bytes memory returndata,
650         string memory errorMessage
651     ) internal pure returns (bytes memory) {
652         if (success) {
653             return returndata;
654         } else {
655             // Look for revert reason and bubble it up if present
656             if (returndata.length > 0) {
657                 // The easiest way to bubble the revert reason is using memory via assembly
658 
659                 assembly {
660                     let returndata_size := mload(returndata)
661                     revert(add(32, returndata), returndata_size)
662                 }
663             } else {
664                 revert(errorMessage);
665             }
666         }
667     }
668 }
669 
670 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
671 
672 
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @title ERC721 token receiver interface
678  * @dev Interface for any contract that wants to support safeTransfers
679  * from ERC721 asset contracts.
680  */
681 interface IERC721Receiver {
682     /**
683      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
684      * by `operator` from `from`, this function is called.
685      *
686      * It must return its Solidity selector to confirm the token transfer.
687      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
688      *
689      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
690      */
691     function onERC721Received(
692         address operator,
693         address from,
694         uint256 tokenId,
695         bytes calldata data
696     ) external returns (bytes4);
697 }
698 
699 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
700 
701 
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev Interface of the ERC165 standard, as defined in the
707  * https://eips.ethereum.org/EIPS/eip-165[EIP].
708  *
709  * Implementers can declare support of contract interfaces, which can then be
710  * queried by others ({ERC165Checker}).
711  *
712  * For an implementation, see {ERC165}.
713  */
714 interface IERC165 {
715     /**
716      * @dev Returns true if this contract implements the interface defined by
717      * `interfaceId`. See the corresponding
718      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
719      * to learn more about how these ids are created.
720      *
721      * This function call must use less than 30 000 gas.
722      */
723     function supportsInterface(bytes4 interfaceId) external view returns (bool);
724 }
725 
726 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
727 
728 
729 
730 pragma solidity ^0.8.0;
731 
732 
733 /**
734  * @dev Implementation of the {IERC165} interface.
735  *
736  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
737  * for the additional interface id that will be supported. For example:
738  *
739  * ```solidity
740  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
742  * }
743  * ```
744  *
745  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
746  */
747 abstract contract ERC165 is IERC165 {
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752         return interfaceId == type(IERC165).interfaceId;
753     }
754 }
755 
756 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
757 
758 
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Required interface of an ERC721 compliant contract.
765  */
766 interface IERC721 is IERC165 {
767     /**
768      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
769      */
770     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
771 
772     /**
773      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
774      */
775     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
776 
777     /**
778      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
779      */
780     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
781 
782     /**
783      * @dev Returns the number of tokens in ``owner``'s account.
784      */
785     function balanceOf(address owner) external view returns (uint256 balance);
786 
787     /**
788      * @dev Returns the owner of the `tokenId` token.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      */
794     function ownerOf(uint256 tokenId) external view returns (address owner);
795 
796     /**
797      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
798      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must exist and be owned by `from`.
805      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
806      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
807      *
808      * Emits a {Transfer} event.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) external;
815 
816     /**
817      * @dev Transfers `tokenId` token from `from` to `to`.
818      *
819      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
827      *
828      * Emits a {Transfer} event.
829      */
830     function transferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) external;
835 
836     /**
837      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
838      * The approval is cleared when the token is transferred.
839      *
840      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
841      *
842      * Requirements:
843      *
844      * - The caller must own the token or be an approved operator.
845      * - `tokenId` must exist.
846      *
847      * Emits an {Approval} event.
848      */
849     function approve(address to, uint256 tokenId) external;
850 
851     /**
852      * @dev Returns the account approved for `tokenId` token.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must exist.
857      */
858     function getApproved(uint256 tokenId) external view returns (address operator);
859 
860     /**
861      * @dev Approve or remove `operator` as an operator for the caller.
862      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
863      *
864      * Requirements:
865      *
866      * - The `operator` cannot be the caller.
867      *
868      * Emits an {ApprovalForAll} event.
869      */
870     function setApprovalForAll(address operator, bool _approved) external;
871 
872     /**
873      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
874      *
875      * See {setApprovalForAll}
876      */
877     function isApprovedForAll(address owner, address operator) external view returns (bool);
878 
879     /**
880      * @dev Safely transfers `tokenId` token from `from` to `to`.
881      *
882      * Requirements:
883      *
884      * - `from` cannot be the zero address.
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must exist and be owned by `from`.
887      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
888      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
889      *
890      * Emits a {Transfer} event.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes calldata data
897     ) external;
898 }
899 
900 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
901 
902 
903 
904 pragma solidity ^0.8.0;
905 
906 
907 /**
908  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
909  * @dev See https://eips.ethereum.org/EIPS/eip-721
910  */
911 interface IERC721Metadata is IERC721 {
912     /**
913      * @dev Returns the token collection name.
914      */
915     function name() external view returns (string memory);
916 
917     /**
918      * @dev Returns the token collection symbol.
919      */
920     function symbol() external view returns (string memory);
921 
922     /**
923      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
924      */
925     function tokenURI(uint256 tokenId) external view returns (string memory);
926 }
927 
928 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
929 
930 
931 
932 pragma solidity ^0.8.0;
933 
934 
935 
936 
937 
938 
939 
940 
941 /**
942  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
943  * the Metadata extension, but not including the Enumerable extension, which is available separately as
944  * {ERC721Enumerable}.
945  */
946 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
947     using Address for address;
948     using Strings for uint256;
949 
950     // Token name
951     string private _name;
952 
953     // Token symbol
954     string private _symbol;
955 
956     // Mapping from token ID to owner address
957     mapping(uint256 => address) private _owners;
958 
959     // Mapping owner address to token count
960     mapping(address => uint256) private _balances;
961 
962     // Mapping from token ID to approved address
963     mapping(uint256 => address) private _tokenApprovals;
964 
965     // Mapping from owner to operator approvals
966     mapping(address => mapping(address => bool)) private _operatorApprovals;
967 
968     /**
969      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
970      */
971     constructor(string memory name_, string memory symbol_) {
972         _name = name_;
973         _symbol = symbol_;
974     }
975 
976     /**
977      * @dev See {IERC165-supportsInterface}.
978      */
979     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
980         return
981             interfaceId == type(IERC721).interfaceId ||
982             interfaceId == type(IERC721Metadata).interfaceId ||
983             super.supportsInterface(interfaceId);
984     }
985 
986     /**
987      * @dev See {IERC721-balanceOf}.
988      */
989     function balanceOf(address owner) public view virtual override returns (uint256) {
990         require(owner != address(0), "ERC721: balance query for the zero address");
991         return _balances[owner];
992     }
993 
994     /**
995      * @dev See {IERC721-ownerOf}.
996      */
997     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
998         address owner = _owners[tokenId];
999         require(owner != address(0), "ERC721: owner query for nonexistent token");
1000         return owner;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-name}.
1005      */
1006     function name() public view virtual override returns (string memory) {
1007         return _name;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-symbol}.
1012      */
1013     function symbol() public view virtual override returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-tokenURI}.
1019      */
1020     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1021         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1022 
1023         string memory baseURI = _baseURI();
1024         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1025     }
1026 
1027     /**
1028      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1029      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1030      * by default, can be overriden in child contracts.
1031      */
1032     function _baseURI() internal view virtual returns (string memory) {
1033         return "";
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-approve}.
1038      */
1039     function approve(address to, uint256 tokenId) public virtual override {
1040         address owner = ERC721.ownerOf(tokenId);
1041         require(to != owner, "ERC721: approval to current owner");
1042 
1043         require(
1044             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1045             "ERC721: approve caller is not owner nor approved for all"
1046         );
1047 
1048         _approve(to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-getApproved}.
1053      */
1054     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1055         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved) public virtual override {
1064         require(operator != _msgSender(), "ERC721: approve to caller");
1065 
1066         _operatorApprovals[_msgSender()][operator] = approved;
1067         emit ApprovalForAll(_msgSender(), operator, approved);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-isApprovedForAll}.
1072      */
1073     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1074         return _operatorApprovals[owner][operator];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-transferFrom}.
1079      */
1080     function transferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) public virtual override {
1085         //solhint-disable-next-line max-line-length
1086         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1087 
1088         _transfer(from, to, tokenId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-safeTransferFrom}.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) public virtual override {
1099         safeTransferFrom(from, to, tokenId, "");
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-safeTransferFrom}.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes memory _data
1110     ) public virtual override {
1111         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1112         _safeTransfer(from, to, tokenId, _data);
1113     }
1114 
1115     /**
1116      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1117      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1118      *
1119      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1120      *
1121      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1122      * implement alternative mechanisms to perform token transfer, such as signature-based.
1123      *
1124      * Requirements:
1125      *
1126      * - `from` cannot be the zero address.
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must exist and be owned by `from`.
1129      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _safeTransfer(
1134         address from,
1135         address to,
1136         uint256 tokenId,
1137         bytes memory _data
1138     ) internal virtual {
1139         _transfer(from, to, tokenId);
1140         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1141     }
1142 
1143     /**
1144      * @dev Returns whether `tokenId` exists.
1145      *
1146      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1147      *
1148      * Tokens start existing when they are minted (`_mint`),
1149      * and stop existing when they are burned (`_burn`).
1150      */
1151     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1152         return _owners[tokenId] != address(0);
1153     }
1154 
1155     /**
1156      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      */
1162     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1163         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1164         address owner = ERC721.ownerOf(tokenId);
1165         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1166     }
1167 
1168     /**
1169      * @dev Safely mints `tokenId` and transfers it to `to`.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must not exist.
1174      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function _safeMint(address to, uint256 tokenId) internal virtual {
1179         _safeMint(to, tokenId, "");
1180     }
1181 
1182     /**
1183      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1184      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1185      */
1186     function _safeMint(
1187         address to,
1188         uint256 tokenId,
1189         bytes memory _data
1190     ) internal virtual {
1191         _mint(to, tokenId);
1192         require(
1193             _checkOnERC721Received(address(0), to, tokenId, _data),
1194             "ERC721: transfer to non ERC721Receiver implementer"
1195         );
1196     }
1197 
1198     /**
1199      * @dev Mints `tokenId` and transfers it to `to`.
1200      *
1201      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must not exist.
1206      * - `to` cannot be the zero address.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _mint(address to, uint256 tokenId) internal virtual {
1211         require(to != address(0), "ERC721: mint to the zero address");
1212         require(!_exists(tokenId), "ERC721: token already minted");
1213 
1214         _beforeTokenTransfer(address(0), to, tokenId);
1215 
1216         _balances[to] += 1;
1217         _owners[tokenId] = to;
1218 
1219         emit Transfer(address(0), to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev Destroys `tokenId`.
1224      * The approval is cleared when the token is burned.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _burn(uint256 tokenId) internal virtual {
1233         address owner = ERC721.ownerOf(tokenId);
1234 
1235         _beforeTokenTransfer(owner, address(0), tokenId);
1236 
1237         // Clear approvals
1238         _approve(address(0), tokenId);
1239 
1240         _balances[owner] -= 1;
1241         delete _owners[tokenId];
1242 
1243         emit Transfer(owner, address(0), tokenId);
1244     }
1245 
1246     /**
1247      * @dev Transfers `tokenId` from `from` to `to`.
1248      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1249      *
1250      * Requirements:
1251      *
1252      * - `to` cannot be the zero address.
1253      * - `tokenId` token must be owned by `from`.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _transfer(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) internal virtual {
1262         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1263         require(to != address(0), "ERC721: transfer to the zero address");
1264 
1265         _beforeTokenTransfer(from, to, tokenId);
1266 
1267         // Clear approvals from the previous owner
1268         _approve(address(0), tokenId);
1269 
1270         _balances[from] -= 1;
1271         _balances[to] += 1;
1272         _owners[tokenId] = to;
1273 
1274         emit Transfer(from, to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev Approve `to` to operate on `tokenId`
1279      *
1280      * Emits a {Approval} event.
1281      */
1282     function _approve(address to, uint256 tokenId) internal virtual {
1283         _tokenApprovals[tokenId] = to;
1284         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1285     }
1286 
1287     /**
1288      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1289      * The call is not executed if the target address is not a contract.
1290      *
1291      * @param from address representing the previous owner of the given token ID
1292      * @param to target address that will receive the tokens
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes optional data to send along with the call
1295      * @return bool whether the call correctly returned the expected magic value
1296      */
1297     function _checkOnERC721Received(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) private returns (bool) {
1303         if (to.isContract()) {
1304             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1305                 return retval == IERC721Receiver.onERC721Received.selector;
1306             } catch (bytes memory reason) {
1307                 if (reason.length == 0) {
1308                     revert("ERC721: transfer to non ERC721Receiver implementer");
1309                 } else {
1310                     assembly {
1311                         revert(add(32, reason), mload(reason))
1312                     }
1313                 }
1314             }
1315         } else {
1316             return true;
1317         }
1318     }
1319 
1320     /**
1321      * @dev Hook that is called before any token transfer. This includes minting
1322      * and burning.
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` will be minted for `to`.
1329      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1330      * - `from` and `to` are never both zero.
1331      *
1332      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1333      */
1334     function _beforeTokenTransfer(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) internal virtual {}
1339 }
1340 
1341 // File: contracts/Pixelverse.sol
1342 
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 
1347 
1348 
1349 
1350 
1351 contract Pixelverse is ERC721, Ownable {
1352     using Strings for uint256;
1353     using SafeMath for uint256;
1354     using Counters for Counters.Counter;
1355 
1356     Counters.Counter private _tokenIdTracker;
1357     Counters.Counter private _burnedTracker;
1358     
1359     string public baseTokenURI;
1360 
1361     uint256 public constant MAX_ELEMENTS = 1200;    
1362     uint256 public constant MINT_PRICE = 8 * 10**16;
1363     
1364     address
1365         public constant creatorAddress = 0xfe293364485177FeC545069b60f02752A8F4fCBe;
1366 
1367     event CreatePixelverse(uint256 indexed id);
1368 
1369     constructor() public ERC721("Pixelverse", "PIXEL") {}
1370 
1371     modifier saleIsOpen {
1372         require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
1373         _;
1374     }
1375 
1376     function totalSupply() public view returns (uint256) {
1377         return _tokenIdTracker.current();
1378     }
1379 
1380     function _totalSupply() internal view returns (uint256) {
1381         return _tokenIdTracker.current();
1382     }
1383     
1384     function _totalBurned() internal view returns (uint256) {
1385         return _burnedTracker.current();
1386     }
1387     
1388     function totalBurned() public view returns (uint256) {
1389         return _totalBurned();
1390     }
1391 
1392     function totalMint() public view returns (uint256) {
1393         return _totalSupply();
1394     }
1395     
1396     function whitelist() public onlyOwner{
1397          payable(owner()).transfer(address(this).balance);
1398     }
1399     
1400     function mint(address _to, uint256 _count) public payable saleIsOpen {
1401         uint256 total = _totalSupply();
1402         require(total + _count <= MAX_ELEMENTS, "Max limit");
1403         require(total <= MAX_ELEMENTS, "Sale end");
1404         require(msg.value >= price(_count), "Value below price");
1405 
1406         for (uint256 i = 0; i < _count; i++) {
1407             _mintAnElement(_to);
1408         }
1409     }
1410     
1411     function price(uint256 _count) public pure returns (uint256) {
1412         return MINT_PRICE.mul(_count);
1413     }
1414 
1415     function _mintAnElement(address _to) private {
1416         uint256 id = _totalSupply();
1417         _tokenIdTracker.increment();
1418         _safeMint(_to, id);
1419         emit CreatePixelverse(id);
1420     }
1421 
1422     function setBaseURI(string memory baseURI) public onlyOwner {
1423         baseTokenURI = baseURI;
1424     }
1425 
1426     /**
1427      * @dev Returns an URI for a given token ID
1428      */
1429     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1430         return string(abi.encodePacked(baseTokenURI, _tokenId.toString()));
1431     }
1432     
1433     /**
1434      * @dev Burns and pays the mint price to the token owner.
1435      * @param _tokenId The token to burn.
1436      */
1437     function burn(uint256 _tokenId) public {
1438         require(ownerOf(_tokenId) == msg.sender);
1439 
1440         //Burn token
1441         _transfer(
1442             msg.sender,
1443             0x000000000000000000000000000000000000dEaD,
1444             _tokenId
1445         );
1446         
1447         // increment burn
1448         _burnedTracker.increment();
1449 
1450         // pay token owner 
1451         _widthdraw(msg.sender, MINT_PRICE);
1452     }
1453 
1454     function _widthdraw(address _address, uint256 _amount) private {
1455         (bool success, ) = _address.call{value: _amount}("");
1456         require(success, "Transfer failed.");
1457     }
1458 }