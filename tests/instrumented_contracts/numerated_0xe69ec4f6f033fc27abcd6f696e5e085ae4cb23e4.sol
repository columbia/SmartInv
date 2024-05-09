1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Counters.sol
5 
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
50 
51 
52 
53 pragma solidity ^0.8.0;
54 
55 // CAUTION
56 // This version of SafeMath should only be used with Solidity 0.8 or later,
57 // because it relies on the compiler's built in overflow checks.
58 
59 /**
60  * @dev Wrappers over Solidity's arithmetic operations.
61  *
62  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
63  * now has built in overflow checking.
64  */
65 library SafeMath {
66     /**
67      * @dev Returns the addition of two unsigned integers, with an overflow flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         unchecked {
73             uint256 c = a + b;
74             if (c < a) return (false, 0);
75             return (true, c);
76         }
77     }
78 
79     /**
80      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
81      *
82      * _Available since v3.4._
83      */
84     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         unchecked {
86             if (b > a) return (false, 0);
87             return (true, a - b);
88         }
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
99             // benefit is lost if 'b' is also tested.
100             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
101             if (a == 0) return (true, 0);
102             uint256 c = a * b;
103             if (c / a != b) return (false, 0);
104             return (true, c);
105         }
106     }
107 
108     /**
109      * @dev Returns the division of two unsigned integers, with a division by zero flag.
110      *
111      * _Available since v3.4._
112      */
113     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             if (b == 0) return (false, 0);
116             return (true, a / b);
117         }
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         unchecked {
127             if (b == 0) return (false, 0);
128             return (true, a % b);
129         }
130     }
131 
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a + b;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a - b;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a * b;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator.
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return a / b;
186     }
187 
188     /**
189      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
190      * reverting when dividing by zero.
191      *
192      * Counterpart to Solidity's `%` operator. This function uses a `revert`
193      * opcode (which leaves remaining gas untouched) while Solidity uses an
194      * invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a % b;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
206      * overflow (when the result is negative).
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {trySub}.
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b <= a, errorMessage);
224             return a - b;
225         }
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         unchecked {
246             require(b > 0, errorMessage);
247             return a / b;
248         }
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * reverting with custom message when dividing by zero.
254      *
255      * CAUTION: This function is deprecated because it requires allocating memory for the error
256      * message unnecessarily. For custom revert reasons use {tryMod}.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(
267         uint256 a,
268         uint256 b,
269         string memory errorMessage
270     ) internal pure returns (uint256) {
271         unchecked {
272             require(b > 0, errorMessage);
273             return a % b;
274         }
275     }
276 }
277 
278 // File: @openzeppelin/contracts/utils/Strings.sol
279 
280 
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev String operations.
286  */
287 library Strings {
288     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
289 
290     /**
291      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
292      */
293     function toString(uint256 value) internal pure returns (string memory) {
294         // Inspired by OraclizeAPI's implementation - MIT licence
295         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
296 
297         if (value == 0) {
298             return "0";
299         }
300         uint256 temp = value;
301         uint256 digits;
302         while (temp != 0) {
303             digits++;
304             temp /= 10;
305         }
306         bytes memory buffer = new bytes(digits);
307         while (value != 0) {
308             digits -= 1;
309             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
310             value /= 10;
311         }
312         return string(buffer);
313     }
314 
315     /**
316      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
317      */
318     function toHexString(uint256 value) internal pure returns (string memory) {
319         if (value == 0) {
320             return "0x00";
321         }
322         uint256 temp = value;
323         uint256 length = 0;
324         while (temp != 0) {
325             length++;
326             temp >>= 8;
327         }
328         return toHexString(value, length);
329     }
330 
331     /**
332      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
333      */
334     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
335         bytes memory buffer = new bytes(2 * length + 2);
336         buffer[0] = "0";
337         buffer[1] = "x";
338         for (uint256 i = 2 * length + 1; i > 1; --i) {
339             buffer[i] = _HEX_SYMBOLS[value & 0xf];
340             value >>= 4;
341         }
342         require(value == 0, "Strings: hex length insufficient");
343         return string(buffer);
344     }
345 }
346 
347 // File: @openzeppelin/contracts/utils/Context.sol
348 
349 
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Provides information about the current execution context, including the
355  * sender of the transaction and its data. While these are generally available
356  * via msg.sender and msg.data, they should not be accessed in such a direct
357  * manner, since when dealing with meta-transactions the account sending and
358  * paying for execution may not be the actual sender (as far as an application
359  * is concerned).
360  *
361  * This contract is only required for intermediate, library-like contracts.
362  */
363 abstract contract Context {
364     function _msgSender() internal view virtual returns (address) {
365         return msg.sender;
366     }
367 
368     function _msgData() internal view virtual returns (bytes calldata) {
369         return msg.data;
370     }
371 }
372 
373 // File: @openzeppelin/contracts/access/Ownable.sol
374 
375 
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Contract module which provides a basic access control mechanism, where
382  * there is an account (an owner) that can be granted exclusive access to
383  * specific functions.
384  *
385  * By default, the owner account will be the one that deploys the contract. This
386  * can later be changed with {transferOwnership}.
387  *
388  * This module is used through inheritance. It will make available the modifier
389  * `onlyOwner`, which can be applied to your functions to restrict their use to
390  * the owner.
391  */
392 abstract contract Ownable is Context {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor() {
401         _setOwner(_msgSender());
402     }
403 
404     /**
405      * @dev Returns the address of the current owner.
406      */
407     function owner() public view virtual returns (address) {
408         return _owner;
409     }
410 
411     /**
412      * @dev Throws if called by any account other than the owner.
413      */
414     modifier onlyOwner() {
415         require(owner() == _msgSender(), "Ownable: caller is not the owner");
416         _;
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * NOTE: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public virtual onlyOwner {
427         _setOwner(address(0));
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         _setOwner(newOwner);
437     }
438 
439     function _setOwner(address newOwner) private {
440         address oldOwner = _owner;
441         _owner = newOwner;
442         emit OwnershipTransferred(oldOwner, newOwner);
443     }
444 }
445 
446 // File: @openzeppelin/contracts/utils/Address.sol
447 
448 
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev Collection of functions related to the address type
454  */
455 library Address {
456     /**
457      * @dev Returns true if `account` is a contract.
458      *
459      * [IMPORTANT]
460      * ====
461      * It is unsafe to assume that an address for which this function returns
462      * false is an externally-owned account (EOA) and not a contract.
463      *
464      * Among others, `isContract` will return false for the following
465      * types of addresses:
466      *
467      *  - an externally-owned account
468      *  - a contract in construction
469      *  - an address where a contract will be created
470      *  - an address where a contract lived, but was destroyed
471      * ====
472      */
473     function isContract(address account) internal view returns (bool) {
474         // This method relies on extcodesize, which returns 0 for contracts in
475         // construction, since the code is only stored at the end of the
476         // constructor execution.
477 
478         uint256 size;
479         assembly {
480             size := extcodesize(account)
481         }
482         return size > 0;
483     }
484 
485     /**
486      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
487      * `recipient`, forwarding all available gas and reverting on errors.
488      *
489      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
490      * of certain opcodes, possibly making contracts go over the 2300 gas limit
491      * imposed by `transfer`, making them unable to receive funds via
492      * `transfer`. {sendValue} removes this limitation.
493      *
494      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
495      *
496      * IMPORTANT: because control is transferred to `recipient`, care must be
497      * taken to not create reentrancy vulnerabilities. Consider using
498      * {ReentrancyGuard} or the
499      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
500      */
501     function sendValue(address payable recipient, uint256 amount) internal {
502         require(address(this).balance >= amount, "Address: insufficient balance");
503 
504         (bool success, ) = recipient.call{value: amount}("");
505         require(success, "Address: unable to send value, recipient may have reverted");
506     }
507 
508     /**
509      * @dev Performs a Solidity function call using a low level `call`. A
510      * plain `call` is an unsafe replacement for a function call: use this
511      * function instead.
512      *
513      * If `target` reverts with a revert reason, it is bubbled up by this
514      * function (like regular Solidity function calls).
515      *
516      * Returns the raw returned data. To convert to the expected return value,
517      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
518      *
519      * Requirements:
520      *
521      * - `target` must be a contract.
522      * - calling `target` with `data` must not revert.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
527         return functionCall(target, data, "Address: low-level call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
532      * `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         return functionCallWithValue(target, data, 0, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but also transferring `value` wei to `target`.
547      *
548      * Requirements:
549      *
550      * - the calling contract must have an ETH balance of at least `value`.
551      * - the called Solidity function must be `payable`.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value
559     ) internal returns (bytes memory) {
560         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
565      * with `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(
570         address target,
571         bytes memory data,
572         uint256 value,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         require(address(this).balance >= value, "Address: insufficient balance for call");
576         require(isContract(target), "Address: call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.call{value: value}(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
589         return functionStaticCall(target, data, "Address: low-level static call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal view returns (bytes memory) {
603         require(isContract(target), "Address: static call to non-contract");
604 
605         (bool success, bytes memory returndata) = target.staticcall(data);
606         return verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
616         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(
626         address target,
627         bytes memory data,
628         string memory errorMessage
629     ) internal returns (bytes memory) {
630         require(isContract(target), "Address: delegate call to non-contract");
631 
632         (bool success, bytes memory returndata) = target.delegatecall(data);
633         return verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
638      * revert reason using the provided one.
639      *
640      * _Available since v4.3._
641      */
642     function verifyCallResult(
643         bool success,
644         bytes memory returndata,
645         string memory errorMessage
646     ) internal pure returns (bytes memory) {
647         if (success) {
648             return returndata;
649         } else {
650             // Look for revert reason and bubble it up if present
651             if (returndata.length > 0) {
652                 // The easiest way to bubble the revert reason is using memory via assembly
653 
654                 assembly {
655                     let returndata_size := mload(returndata)
656                     revert(add(32, returndata), returndata_size)
657                 }
658             } else {
659                 revert(errorMessage);
660             }
661         }
662     }
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
666 
667 
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @title ERC721 token receiver interface
673  * @dev Interface for any contract that wants to support safeTransfers
674  * from ERC721 asset contracts.
675  */
676 interface IERC721Receiver {
677     /**
678      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
679      * by `operator` from `from`, this function is called.
680      *
681      * It must return its Solidity selector to confirm the token transfer.
682      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
683      *
684      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
685      */
686     function onERC721Received(
687         address operator,
688         address from,
689         uint256 tokenId,
690         bytes calldata data
691     ) external returns (bytes4);
692 }
693 
694 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
695 
696 
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @dev Interface of the ERC165 standard, as defined in the
702  * https://eips.ethereum.org/EIPS/eip-165[EIP].
703  *
704  * Implementers can declare support of contract interfaces, which can then be
705  * queried by others ({ERC165Checker}).
706  *
707  * For an implementation, see {ERC165}.
708  */
709 interface IERC165 {
710     /**
711      * @dev Returns true if this contract implements the interface defined by
712      * `interfaceId`. See the corresponding
713      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
714      * to learn more about how these ids are created.
715      *
716      * This function call must use less than 30 000 gas.
717      */
718     function supportsInterface(bytes4 interfaceId) external view returns (bool);
719 }
720 
721 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
722 
723 
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @dev Implementation of the {IERC165} interface.
730  *
731  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
732  * for the additional interface id that will be supported. For example:
733  *
734  * ```solidity
735  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
736  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
737  * }
738  * ```
739  *
740  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
741  */
742 abstract contract ERC165 is IERC165 {
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
747         return interfaceId == type(IERC165).interfaceId;
748     }
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
752 
753 
754 
755 pragma solidity ^0.8.0;
756 
757 
758 /**
759  * @dev Required interface of an ERC721 compliant contract.
760  */
761 interface IERC721 is IERC165 {
762     /**
763      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
764      */
765     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
766 
767     /**
768      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
769      */
770     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
771 
772     /**
773      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
774      */
775     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
776 
777     /**
778      * @dev Returns the number of tokens in ``owner``'s account.
779      */
780     function balanceOf(address owner) external view returns (uint256 balance);
781 
782     /**
783      * @dev Returns the owner of the `tokenId` token.
784      *
785      * Requirements:
786      *
787      * - `tokenId` must exist.
788      */
789     function ownerOf(uint256 tokenId) external view returns (address owner);
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
793      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
794      *
795      * Requirements:
796      *
797      * - `from` cannot be the zero address.
798      * - `to` cannot be the zero address.
799      * - `tokenId` token must exist and be owned by `from`.
800      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
801      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function safeTransferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) external;
810 
811     /**
812      * @dev Transfers `tokenId` token from `from` to `to`.
813      *
814      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
822      *
823      * Emits a {Transfer} event.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) external;
830 
831     /**
832      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
833      * The approval is cleared when the token is transferred.
834      *
835      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
836      *
837      * Requirements:
838      *
839      * - The caller must own the token or be an approved operator.
840      * - `tokenId` must exist.
841      *
842      * Emits an {Approval} event.
843      */
844     function approve(address to, uint256 tokenId) external;
845 
846     /**
847      * @dev Returns the account approved for `tokenId` token.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function getApproved(uint256 tokenId) external view returns (address operator);
854 
855     /**
856      * @dev Approve or remove `operator` as an operator for the caller.
857      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
858      *
859      * Requirements:
860      *
861      * - The `operator` cannot be the caller.
862      *
863      * Emits an {ApprovalForAll} event.
864      */
865     function setApprovalForAll(address operator, bool _approved) external;
866 
867     /**
868      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
869      *
870      * See {setApprovalForAll}
871      */
872     function isApprovedForAll(address owner, address operator) external view returns (bool);
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`.
876      *
877      * Requirements:
878      *
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must exist and be owned by `from`.
882      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
884      *
885      * Emits a {Transfer} event.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes calldata data
892     ) external;
893 }
894 
895 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
896 
897 
898 
899 pragma solidity ^0.8.0;
900 
901 
902 /**
903  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
904  * @dev See https://eips.ethereum.org/EIPS/eip-721
905  */
906 interface IERC721Metadata is IERC721 {
907     /**
908      * @dev Returns the token collection name.
909      */
910     function name() external view returns (string memory);
911 
912     /**
913      * @dev Returns the token collection symbol.
914      */
915     function symbol() external view returns (string memory);
916 
917     /**
918      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
919      */
920     function tokenURI(uint256 tokenId) external view returns (string memory);
921 }
922 
923 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
924 
925 
926 
927 pragma solidity ^0.8.0;
928 
929 
930 
931 
932 
933 
934 
935 
936 /**
937  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
938  * the Metadata extension, but not including the Enumerable extension, which is available separately as
939  * {ERC721Enumerable}.
940  */
941 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
942     using Address for address;
943     using Strings for uint256;
944 
945     // Token name
946     string private _name;
947 
948     // Token symbol
949     string private _symbol;
950 
951     // Mapping from token ID to owner address
952     mapping(uint256 => address) private _owners;
953 
954     // Mapping owner address to token count
955     mapping(address => uint256) private _balances;
956 
957     // Mapping from token ID to approved address
958     mapping(uint256 => address) private _tokenApprovals;
959 
960     // Mapping from owner to operator approvals
961     mapping(address => mapping(address => bool)) private _operatorApprovals;
962 
963     /**
964      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
965      */
966     constructor(string memory name_, string memory symbol_) {
967         _name = name_;
968         _symbol = symbol_;
969     }
970 
971     /**
972      * @dev See {IERC165-supportsInterface}.
973      */
974     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
975         return
976             interfaceId == type(IERC721).interfaceId ||
977             interfaceId == type(IERC721Metadata).interfaceId ||
978             super.supportsInterface(interfaceId);
979     }
980 
981     /**
982      * @dev See {IERC721-balanceOf}.
983      */
984     function balanceOf(address owner) public view virtual override returns (uint256) {
985         require(owner != address(0), "ERC721: balance query for the zero address");
986         return _balances[owner];
987     }
988 
989     /**
990      * @dev See {IERC721-ownerOf}.
991      */
992     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
993         address owner = _owners[tokenId];
994         require(owner != address(0), "ERC721: owner query for nonexistent token");
995         return owner;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-name}.
1000      */
1001     function name() public view virtual override returns (string memory) {
1002         return _name;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-symbol}.
1007      */
1008     function symbol() public view virtual override returns (string memory) {
1009         return _symbol;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-tokenURI}.
1014      */
1015     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1016         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1017 
1018         string memory baseURI = _baseURI();
1019         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1020     }
1021 
1022     /**
1023      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1024      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1025      * by default, can be overriden in child contracts.
1026      */
1027     function _baseURI() internal view virtual returns (string memory) {
1028         return "";
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-approve}.
1033      */
1034     function approve(address to, uint256 tokenId) public virtual override {
1035         address owner = ERC721.ownerOf(tokenId);
1036         require(to != owner, "ERC721: approval to current owner");
1037 
1038         require(
1039             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1040             "ERC721: approve caller is not owner nor approved for all"
1041         );
1042 
1043         _approve(to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-getApproved}.
1048      */
1049     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1050         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1051 
1052         return _tokenApprovals[tokenId];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-setApprovalForAll}.
1057      */
1058     function setApprovalForAll(address operator, bool approved) public virtual override {
1059         require(operator != _msgSender(), "ERC721: approve to caller");
1060 
1061         _operatorApprovals[_msgSender()][operator] = approved;
1062         emit ApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         //solhint-disable-next-line max-line-length
1081         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1082 
1083         _transfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         safeTransferFrom(from, to, tokenId, "");
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-safeTransferFrom}.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) public virtual override {
1106         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1107         _safeTransfer(from, to, tokenId, _data);
1108     }
1109 
1110     /**
1111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1113      *
1114      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1115      *
1116      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1117      * implement alternative mechanisms to perform token transfer, such as signature-based.
1118      *
1119      * Requirements:
1120      *
1121      * - `from` cannot be the zero address.
1122      * - `to` cannot be the zero address.
1123      * - `tokenId` token must exist and be owned by `from`.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _safeTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) internal virtual {
1134         _transfer(from, to, tokenId);
1135         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1136     }
1137 
1138     /**
1139      * @dev Returns whether `tokenId` exists.
1140      *
1141      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1142      *
1143      * Tokens start existing when they are minted (`_mint`),
1144      * and stop existing when they are burned (`_burn`).
1145      */
1146     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1147         return _owners[tokenId] != address(0);
1148     }
1149 
1150     /**
1151      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      */
1157     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1158         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1159         address owner = ERC721.ownerOf(tokenId);
1160         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1161     }
1162 
1163     /**
1164      * @dev Safely mints `tokenId` and transfers it to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must not exist.
1169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(address to, uint256 tokenId) internal virtual {
1174         _safeMint(to, tokenId, "");
1175     }
1176 
1177     /**
1178      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1179      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1180      */
1181     function _safeMint(
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) internal virtual {
1186         _mint(to, tokenId);
1187         require(
1188             _checkOnERC721Received(address(0), to, tokenId, _data),
1189             "ERC721: transfer to non ERC721Receiver implementer"
1190         );
1191     }
1192 
1193     /**
1194      * @dev Mints `tokenId` and transfers it to `to`.
1195      *
1196      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must not exist.
1201      * - `to` cannot be the zero address.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _mint(address to, uint256 tokenId) internal virtual {
1206         require(to != address(0), "ERC721: mint to the zero address");
1207         require(!_exists(tokenId), "ERC721: token already minted");
1208 
1209         _beforeTokenTransfer(address(0), to, tokenId);
1210 
1211         _balances[to] += 1;
1212         _owners[tokenId] = to;
1213 
1214         emit Transfer(address(0), to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev Destroys `tokenId`.
1219      * The approval is cleared when the token is burned.
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must exist.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _burn(uint256 tokenId) internal virtual {
1228         address owner = ERC721.ownerOf(tokenId);
1229 
1230         _beforeTokenTransfer(owner, address(0), tokenId);
1231 
1232         // Clear approvals
1233         _approve(address(0), tokenId);
1234 
1235         _balances[owner] -= 1;
1236         delete _owners[tokenId];
1237 
1238         emit Transfer(owner, address(0), tokenId);
1239     }
1240 
1241     /**
1242      * @dev Transfers `tokenId` from `from` to `to`.
1243      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1244      *
1245      * Requirements:
1246      *
1247      * - `to` cannot be the zero address.
1248      * - `tokenId` token must be owned by `from`.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _transfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual {
1257         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1258         require(to != address(0), "ERC721: transfer to the zero address");
1259 
1260         _beforeTokenTransfer(from, to, tokenId);
1261 
1262         // Clear approvals from the previous owner
1263         _approve(address(0), tokenId);
1264 
1265         _balances[from] -= 1;
1266         _balances[to] += 1;
1267         _owners[tokenId] = to;
1268 
1269         emit Transfer(from, to, tokenId);
1270     }
1271 
1272     /**
1273      * @dev Approve `to` to operate on `tokenId`
1274      *
1275      * Emits a {Approval} event.
1276      */
1277     function _approve(address to, uint256 tokenId) internal virtual {
1278         _tokenApprovals[tokenId] = to;
1279         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1284      * The call is not executed if the target address is not a contract.
1285      *
1286      * @param from address representing the previous owner of the given token ID
1287      * @param to target address that will receive the tokens
1288      * @param tokenId uint256 ID of the token to be transferred
1289      * @param _data bytes optional data to send along with the call
1290      * @return bool whether the call correctly returned the expected magic value
1291      */
1292     function _checkOnERC721Received(
1293         address from,
1294         address to,
1295         uint256 tokenId,
1296         bytes memory _data
1297     ) private returns (bool) {
1298         if (to.isContract()) {
1299             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1300                 return retval == IERC721Receiver.onERC721Received.selector;
1301             } catch (bytes memory reason) {
1302                 if (reason.length == 0) {
1303                     revert("ERC721: transfer to non ERC721Receiver implementer");
1304                 } else {
1305                     assembly {
1306                         revert(add(32, reason), mload(reason))
1307                     }
1308                 }
1309             }
1310         } else {
1311             return true;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before any token transfer. This includes minting
1317      * and burning.
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1325      * - `from` and `to` are never both zero.
1326      *
1327      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1328      */
1329     function _beforeTokenTransfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual {}
1334 }
1335 
1336 // File: contracts/HydraBlobs.sol
1337 
1338 
1339 pragma solidity ^0.8.0;
1340 
1341 
1342 
1343 
1344 
1345 
1346 /// @title Base64
1347 /// @author Brecht Devos - <brecht@loopring.org>
1348 /// @notice Provides functions for encoding/decoding base64
1349 library Base64 {
1350     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1351     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
1352                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
1353                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
1354                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
1355 
1356     function encode(bytes memory data) internal pure returns (string memory) {
1357         if (data.length == 0) return '';
1358 
1359         // load the table into memory
1360         string memory table = TABLE_ENCODE;
1361 
1362         // multiply by 4/3 rounded up
1363         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1364 
1365         // add some extra buffer at the end required for the writing
1366         string memory result = new string(encodedLen + 32);
1367 
1368         assembly {
1369             // set the actual output length
1370             mstore(result, encodedLen)
1371 
1372             // prepare the lookup table
1373             let tablePtr := add(table, 1)
1374 
1375             // input ptr
1376             let dataPtr := data
1377             let endPtr := add(dataPtr, mload(data))
1378 
1379             // result ptr, jump over length
1380             let resultPtr := add(result, 32)
1381 
1382             // run over the input, 3 bytes at a time
1383             for {} lt(dataPtr, endPtr) {}
1384             {
1385                 // read 3 bytes
1386                 dataPtr := add(dataPtr, 3)
1387                 let input := mload(dataPtr)
1388 
1389                 // write 4 characters
1390                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1391                 resultPtr := add(resultPtr, 1)
1392                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1393                 resultPtr := add(resultPtr, 1)
1394                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
1395                 resultPtr := add(resultPtr, 1)
1396                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
1397                 resultPtr := add(resultPtr, 1)
1398             }
1399 
1400             // padding with '='
1401             switch mod(mload(data), 3)
1402             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
1403             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
1404         }
1405 
1406         return result;
1407     }
1408 
1409     function decode(string memory _data) internal pure returns (bytes memory) {
1410         bytes memory data = bytes(_data);
1411 
1412         if (data.length == 0) return new bytes(0);
1413         require(data.length % 4 == 0, "invalid base64 decoder input");
1414 
1415         // load the table into memory
1416         bytes memory table = TABLE_DECODE;
1417 
1418         // every 4 characters represent 3 bytes
1419         uint256 decodedLen = (data.length / 4) * 3;
1420 
1421         // add some extra buffer at the end required for the writing
1422         bytes memory result = new bytes(decodedLen + 32);
1423 
1424         assembly {
1425             // padding with '='
1426             let lastBytes := mload(add(data, mload(data)))
1427             if eq(and(lastBytes, 0xFF), 0x3d) {
1428                 decodedLen := sub(decodedLen, 1)
1429                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
1430                     decodedLen := sub(decodedLen, 1)
1431                 }
1432             }
1433 
1434             // set the actual output length
1435             mstore(result, decodedLen)
1436 
1437             // prepare the lookup table
1438             let tablePtr := add(table, 1)
1439 
1440             // input ptr
1441             let dataPtr := data
1442             let endPtr := add(dataPtr, mload(data))
1443 
1444             // result ptr, jump over length
1445             let resultPtr := add(result, 32)
1446 
1447             // run over the input, 4 characters at a time
1448             for {} lt(dataPtr, endPtr) {}
1449             {
1450                // read 4 characters
1451                dataPtr := add(dataPtr, 4)
1452                let input := mload(dataPtr)
1453 
1454                // write 3 bytes
1455                let output := add(
1456                    add(
1457                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
1458                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
1459                    add(
1460                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
1461                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
1462                     )
1463                 )
1464                 mstore(resultPtr, shl(232, output))
1465                 resultPtr := add(resultPtr, 3)
1466             }
1467         }
1468 
1469         return result;
1470     }
1471 }
1472 
1473 contract HydraBlobs is ERC721, Ownable {
1474     using Strings for uint256;
1475     using SafeMath for uint256;
1476     using Counters for Counters.Counter;
1477 
1478     Counters.Counter private _tokenIdTracker;
1479     Counters.Counter private _burnedTracker;
1480 
1481     string[] private _paths;
1482 
1483     uint256 public constant MAX_STEALTH_ELEMENTS = 500;    
1484     uint256 public constant MAX_GENESIS_ELEMENTS = 5555;
1485     uint256 public constant MAX_ELEMENTS         = 20000;    
1486     uint256 public constant MINT_GENESIS_PRICE   = 55000000000000000; // 0.055 ETH
1487     uint256 public constant BASE_BURN_PRICE      = 55000000000000000; // 0.055 ETH, grows over time
1488 
1489 string[] private blobColors = [
1490     "rgba(255, 0, 102, 1)",
1491     "rgba(138, 63, 252, 1)",
1492     "rgba(250, 77, 86, 1)",
1493     "rgba(241, 194, 27, 1)",
1494     "rgba(8, 189, 186, 1)",
1495     "rgba(15, 98, 254, 1)",
1496     "rgba(36, 161, 72, 1)"
1497 ];
1498 
1499 string[] private blobBackgrounds = [
1500     "rgb(167, 240, 186, 1)",
1501     "rgb(158, 240, 240, 1)",
1502     "rgb(186, 230, 255, 1)",
1503     "rgb(208, 226, 255, 1)",
1504     "rgb(232, 218, 255, 1)",
1505     "rgb(255, 214, 232, 1)",
1506     "rgb(242, 244, 248, 1)"
1507 ];
1508 
1509 string[] private transforms = [
1510     "0.3",
1511     "0.4",
1512     "0.5",
1513     "0.6",
1514     "0.7",
1515     "0.8",
1516     "0.9",
1517     "1",
1518     "1.1",
1519     "1.2",
1520     "1.3"
1521 ];
1522 
1523 string[] private durSecs = [
1524     "5",
1525     "6",
1526     "7",
1527     "8",
1528     "9",
1529     "10"
1530 ];
1531     
1532     event CreateHydraBlobs(uint256 indexed id);
1533 
1534     constructor() public ERC721("HydraBlobs", "BLOB") {}
1535 
1536     function totalSupply() public view returns (uint256) {
1537         return  _totalSupply() - _totalBurned();
1538     }
1539 
1540     function _totalSupply() internal view returns (uint256) {
1541         return _tokenIdTracker.current();
1542     }
1543     
1544     function _totalBurned() internal view returns (uint256) {
1545         return _burnedTracker.current();
1546     }
1547     
1548     function totalBurned() public view returns (uint256) {
1549         return _totalBurned();
1550     }
1551 
1552     function totalMint() public view returns (uint256) {
1553         return _totalSupply();
1554     }
1555 
1556     function mintStealth(string memory _path) public payable {
1557         uint256 total = _totalSupply();
1558         require(total + 1 <= MAX_STEALTH_ELEMENTS, "Max stealth limit");
1559         require(total <= MAX_STEALTH_ELEMENTS, "Stealth sale end");
1560 
1561         _paths.push(_path);
1562         _mintAnElement(msg.sender);
1563     }
1564 
1565     function mintGenesis(string memory _path) public payable {
1566         uint256 total = _totalSupply();
1567         require(total + 1 <= MAX_GENESIS_ELEMENTS, "Max genesis limit");
1568         require(total <= MAX_GENESIS_ELEMENTS, "Genesis sale end");
1569         require(msg.value >= MINT_GENESIS_PRICE, "Value below price");
1570 
1571         _paths.push(_path);
1572         _mintAnElement(msg.sender);
1573     }
1574 
1575     function _mintAnElement(address _to) private {
1576         uint256 id = _totalSupply();
1577         _tokenIdTracker.increment();
1578         _safeMint(_to, id);
1579         emit CreateHydraBlobs(id);
1580     }
1581 
1582     /**
1583      * @dev Returns an URI for a given token ID
1584      */
1585     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1586       require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1587 
1588       string memory colorOne = getRandomColor(_tokenId, "BLOB COLOR ONE", blobColors);
1589       string memory colorTwo = getRandomColor(_tokenId, "BLOB COLOR TWO", blobColors);
1590       address tokenOwner = ERC721.ownerOf(_tokenId);
1591       // burned blobs turn red
1592       if (tokenOwner == 0x000000000000000000000000000000000000dEaD) {
1593         colorOne = 'red';
1594         colorTwo = 'red';
1595       }
1596 
1597       string[19] memory parts;
1598       parts[0] = '<svg viewBox="0 0 100 100" style="background-color:';
1599       parts[1] = getRandomColor(_tokenId, "BLOB BACKGROUND", blobBackgrounds);
1600       parts[2] = '" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="sw-gradient" x1="0" x2="1" y1="1" y2="0"><stop id="stop1" stop-color="';
1601       parts[3] = colorOne;
1602       parts[4] = '" offset="0%"></stop><stop id="stop2" stop-color="';
1603       parts[5] = colorTwo;
1604       parts[6] = '" offset="100%"></stop></linearGradient></defs><path fill="url(#sw-gradient)" d="';
1605       parts[7] = _paths[_tokenId];
1606       parts[8] = '" width="100%" height="100%" transform="translate(50 50)" stroke-width="0" style="transition: all 0.3s ease 0s;"><animateTransform attributeName="transform" type="scale" additive="sum"  from="';
1607       parts[9] = getRandom(_tokenId, "TRANSFORMS TO 1", transforms);
1608       parts[10] = ' ';
1609       parts[11] = getRandom(_tokenId, "TRANSFORMS TO 2", transforms);
1610       parts[12] = '" to="';
1611       parts[13] = getRandom(_tokenId, "TRANSFORMS FROM 1", transforms);
1612       parts[14] = ' ';
1613       parts[15] = getRandom(_tokenId, "TRANSFORMS FROM 2", transforms);
1614       parts[16] = '" begin="0s" dur="';
1615       parts[17] = getRandom(_tokenId, "ANIMATION DURATION", durSecs);
1616       parts[18] = 's" repeatCount="indefinite"/></path></svg>';
1617 
1618       string memory isStealth = 'NO';
1619       string memory isGenesis = 'NO';
1620       if (_tokenId <= MAX_STEALTH_ELEMENTS) {
1621           isStealth = 'YES';
1622       }
1623       if (_tokenId <= MAX_GENESIS_ELEMENTS) {
1624           isGenesis = 'YES';
1625       }
1626 
1627       string memory svg = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1628       svg = string(abi.encodePacked(svg, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16], parts[17], parts[18]));
1629       string memory svgUri  = string(abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(abi.encodePacked(svg))));
1630       string memory json    = Base64.encode(abi.encodePacked('{"name":"Blob #', Strings.toString(_tokenId), '", "description": "Animated blobs generated and stored on-chain.",  "image":"', svgUri, '"', ', "attributes":[{"trait_type":"background","value":"',parts[1],'"},{"trait_type":"color one","value":"',parts[3],'"},{"trait_type":"color two","value":"',parts[5],'"},{"trait_type":"animation duration","value":"',parts[17],'"},{"trait_type":"stealth","value":"',isStealth,'"},{"trait_type":"genesis","value":"',isGenesis,'"}]}'));
1631       string memory jsonUri = string(abi.encodePacked("data:application/json;base64,", json));
1632 
1633       return jsonUri;
1634     }
1635 
1636     function getRandom(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
1637         uint256 rand = uint256(keccak256(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
1638         string memory output = sourceArray[rand % sourceArray.length];
1639         return output;
1640     }
1641     
1642     function getRandomColor(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
1643         uint256 rand = uint256(keccak256(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
1644         string memory output = sourceArray[rand % sourceArray.length];
1645         uint256 greatness = rand % 1000;
1646         if (greatness == 69) {
1647             output = "rgb(0, 0, 0)";
1648         }
1649         if (greatness == 420) {
1650             output = "rgb(0, 0, 0)";
1651         }
1652         if (greatness == 33) {
1653             output = "rgb(255, 255, 255)";
1654         }
1655         return output;
1656     }
1657 
1658     function getBurnPrice() public view returns (uint256) {
1659         return BASE_BURN_PRICE * ((_totalBurned() / 50) + 1);
1660     }
1661 
1662     /**
1663      * @dev Burns one and get two. A random genesis token holder will be sent the ETH it takes to burns.
1664      * @param _tokenId The token to burn.
1665      */
1666     function burn(uint256 _tokenId) public payable {
1667         uint256 total = _totalSupply();
1668         require(total + 1 <= MAX_ELEMENTS, "Max burn limit");
1669         require(total <= MAX_ELEMENTS, "Burn end");
1670         require(ownerOf(_tokenId) == msg.sender);
1671         require(msg.value >= getBurnPrice(), "Value below price");
1672 
1673         //Burn token
1674         _transfer(
1675             msg.sender,
1676             0x000000000000000000000000000000000000dEaD,
1677             _tokenId
1678         );
1679         
1680         // increment burn
1681         _burnedTracker.increment();
1682 
1683         // find the bounty winner
1684         uint256 rand = uint256(keccak256(abi.encodePacked(Strings.toString(_tokenId))));
1685         uint256 randWinner = rand % MAX_GENESIS_ELEMENTS;
1686         uint256 bountyWinnerTokenId = randWinner % _totalSupply();
1687         address bountyWinner = ERC721.ownerOf(bountyWinnerTokenId);
1688         if (bountyWinner != 0x000000000000000000000000000000000000dEaD) {
1689             _widthdraw(bountyWinner, msg.value);
1690         }
1691 
1692         // mint two new elements
1693         _paths.push(_paths[_tokenId]);
1694         _mintAnElement(msg.sender);
1695 
1696         _paths.push(_paths[bountyWinnerTokenId]);
1697         _mintAnElement(msg.sender);
1698     }
1699 
1700     function withdrawAll() public payable onlyOwner {
1701         uint256 balance = address(this).balance;
1702         require(balance > 0);
1703         _widthdraw(msg.sender, address(this).balance);
1704     }
1705 
1706     function _widthdraw(address _address, uint256 _amount) private {
1707         (bool success, ) = _address.call{value: _amount}("");
1708         require(success, "Transfer failed.");
1709     }
1710 }