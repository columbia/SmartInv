1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
49 
50 
51 
52 pragma solidity ^0.8.0;
53 
54 // CAUTION
55 // This version of SafeMath should only be used with Solidity 0.8 or later,
56 // because it relies on the compiler's built in overflow checks.
57 
58 /**
59  * @dev Wrappers over Solidity's arithmetic operations.
60  *
61  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
62  * now has built in overflow checking.
63  */
64 library SafeMath {
65     /**
66      * @dev Returns the addition of two unsigned integers, with an overflow flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             uint256 c = a + b;
73             if (c < a) return (false, 0);
74             return (true, c);
75         }
76     }
77 
78     /**
79      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
80      *
81      * _Available since v3.4._
82      */
83     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
84         unchecked {
85             if (b > a) return (false, 0);
86             return (true, a - b);
87         }
88     }
89 
90     /**
91      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
96         unchecked {
97             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98             // benefit is lost if 'b' is also tested.
99             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100             if (a == 0) return (true, 0);
101             uint256 c = a * b;
102             if (c / a != b) return (false, 0);
103             return (true, c);
104         }
105     }
106 
107     /**
108      * @dev Returns the division of two unsigned integers, with a division by zero flag.
109      *
110      * _Available since v3.4._
111      */
112     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         unchecked {
114             if (b == 0) return (false, 0);
115             return (true, a / b);
116         }
117     }
118 
119     /**
120      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
121      *
122      * _Available since v3.4._
123      */
124     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         unchecked {
126             if (b == 0) return (false, 0);
127             return (true, a % b);
128         }
129     }
130 
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a + b;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a - b;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a * b;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers, reverting on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator.
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a / b;
185     }
186 
187     /**
188      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
189      * reverting when dividing by zero.
190      *
191      * Counterpart to Solidity's `%` operator. This function uses a `revert`
192      * opcode (which leaves remaining gas untouched) while Solidity uses an
193      * invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a % b;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
205      * overflow (when the result is negative).
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {trySub}.
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      *
214      * - Subtraction cannot overflow.
215      */
216     function sub(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b <= a, errorMessage);
223             return a - b;
224         }
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(
240         uint256 a,
241         uint256 b,
242         string memory errorMessage
243     ) internal pure returns (uint256) {
244         unchecked {
245             require(b > 0, errorMessage);
246             return a / b;
247         }
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * reverting with custom message when dividing by zero.
253      *
254      * CAUTION: This function is deprecated because it requires allocating memory for the error
255      * message unnecessarily. For custom revert reasons use {tryMod}.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(
266         uint256 a,
267         uint256 b,
268         string memory errorMessage
269     ) internal pure returns (uint256) {
270         unchecked {
271             require(b > 0, errorMessage);
272             return a % b;
273         }
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/Strings.sol
278 
279 
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev String operations.
285  */
286 library Strings {
287     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
288 
289     /**
290      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
291      */
292     function toString(uint256 value) internal pure returns (string memory) {
293         // Inspired by OraclizeAPI's implementation - MIT licence
294         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
295 
296         if (value == 0) {
297             return "0";
298         }
299         uint256 temp = value;
300         uint256 digits;
301         while (temp != 0) {
302             digits++;
303             temp /= 10;
304         }
305         bytes memory buffer = new bytes(digits);
306         while (value != 0) {
307             digits -= 1;
308             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
309             value /= 10;
310         }
311         return string(buffer);
312     }
313 
314     /**
315      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
316      */
317     function toHexString(uint256 value) internal pure returns (string memory) {
318         if (value == 0) {
319             return "0x00";
320         }
321         uint256 temp = value;
322         uint256 length = 0;
323         while (temp != 0) {
324             length++;
325             temp >>= 8;
326         }
327         return toHexString(value, length);
328     }
329 
330     /**
331      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
332      */
333     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
334         bytes memory buffer = new bytes(2 * length + 2);
335         buffer[0] = "0";
336         buffer[1] = "x";
337         for (uint256 i = 2 * length + 1; i > 1; --i) {
338             buffer[i] = _HEX_SYMBOLS[value & 0xf];
339             value >>= 4;
340         }
341         require(value == 0, "Strings: hex length insufficient");
342         return string(buffer);
343     }
344 }
345 
346 // File: @openzeppelin/contracts/utils/Context.sol
347 
348 
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev Provides information about the current execution context, including the
354  * sender of the transaction and its data. While these are generally available
355  * via msg.sender and msg.data, they should not be accessed in such a direct
356  * manner, since when dealing with meta-transactions the account sending and
357  * paying for execution may not be the actual sender (as far as an application
358  * is concerned).
359  *
360  * This contract is only required for intermediate, library-like contracts.
361  */
362 abstract contract Context {
363     function _msgSender() internal view virtual returns (address) {
364         return msg.sender;
365     }
366 
367     function _msgData() internal view virtual returns (bytes calldata) {
368         return msg.data;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/access/Ownable.sol
373 
374 
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Contract module which provides a basic access control mechanism, where
381  * there is an account (an owner) that can be granted exclusive access to
382  * specific functions.
383  *
384  * By default, the owner account will be the one that deploys the contract. This
385  * can later be changed with {transferOwnership}.
386  *
387  * This module is used through inheritance. It will make available the modifier
388  * `onlyOwner`, which can be applied to your functions to restrict their use to
389  * the owner.
390  */
391 abstract contract Ownable is Context {
392     address private _owner;
393 
394     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
395 
396     /**
397      * @dev Initializes the contract setting the deployer as the initial owner.
398      */
399     constructor() {
400         _setOwner(_msgSender());
401     }
402 
403     /**
404      * @dev Returns the address of the current owner.
405      */
406     function owner() public view virtual returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(owner() == _msgSender(), "Ownable: caller is not the owner");
415         _;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * NOTE: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public virtual onlyOwner {
426         _setOwner(address(0));
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Can only be called by the current owner.
432      */
433     function transferOwnership(address newOwner) public virtual onlyOwner {
434         require(newOwner != address(0), "Ownable: new owner is the zero address");
435         _setOwner(newOwner);
436     }
437 
438     function _setOwner(address newOwner) private {
439         address oldOwner = _owner;
440         _owner = newOwner;
441         emit OwnershipTransferred(oldOwner, newOwner);
442     }
443 }
444 
445 // File: @openzeppelin/contracts/utils/Address.sol
446 
447 
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Collection of functions related to the address type
453  */
454 library Address {
455     /**
456      * @dev Returns true if `account` is a contract.
457      *
458      * [IMPORTANT]
459      * ====
460      * It is unsafe to assume that an address for which this function returns
461      * false is an externally-owned account (EOA) and not a contract.
462      *
463      * Among others, `isContract` will return false for the following
464      * types of addresses:
465      *
466      *  - an externally-owned account
467      *  - a contract in construction
468      *  - an address where a contract will be created
469      *  - an address where a contract lived, but was destroyed
470      * ====
471      */
472     function isContract(address account) internal view returns (bool) {
473         // This method relies on extcodesize, which returns 0 for contracts in
474         // construction, since the code is only stored at the end of the
475         // constructor execution.
476 
477         uint256 size;
478         assembly {
479             size := extcodesize(account)
480         }
481         return size > 0;
482     }
483 
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         (bool success, ) = recipient.call{value: amount}("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506 
507     /**
508      * @dev Performs a Solidity function call using a low level `call`. A
509      * plain `call` is an unsafe replacement for a function call: use this
510      * function instead.
511      *
512      * If `target` reverts with a revert reason, it is bubbled up by this
513      * function (like regular Solidity function calls).
514      *
515      * Returns the raw returned data. To convert to the expected return value,
516      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
517      *
518      * Requirements:
519      *
520      * - `target` must be a contract.
521      * - calling `target` with `data` must not revert.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionCall(target, data, "Address: low-level call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
531      * `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, 0, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but also transferring `value` wei to `target`.
546      *
547      * Requirements:
548      *
549      * - the calling contract must have an ETH balance of at least `value`.
550      * - the called Solidity function must be `payable`.
551      *
552      * _Available since v3.1._
553      */
554     function functionCallWithValue(
555         address target,
556         bytes memory data,
557         uint256 value
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(address(this).balance >= value, "Address: insufficient balance for call");
575         require(isContract(target), "Address: call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.call{value: value}(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal view returns (bytes memory) {
602         require(isContract(target), "Address: static call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.staticcall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
615         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(isContract(target), "Address: delegate call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.delegatecall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
637      * revert reason using the provided one.
638      *
639      * _Available since v4.3._
640      */
641     function verifyCallResult(
642         bool success,
643         bytes memory returndata,
644         string memory errorMessage
645     ) internal pure returns (bytes memory) {
646         if (success) {
647             return returndata;
648         } else {
649             // Look for revert reason and bubble it up if present
650             if (returndata.length > 0) {
651                 // The easiest way to bubble the revert reason is using memory via assembly
652 
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
661     }
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
665 
666 
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @title ERC721 token receiver interface
672  * @dev Interface for any contract that wants to support safeTransfers
673  * from ERC721 asset contracts.
674  */
675 interface IERC721Receiver {
676     /**
677      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
678      * by `operator` from `from`, this function is called.
679      *
680      * It must return its Solidity selector to confirm the token transfer.
681      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
682      *
683      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
684      */
685     function onERC721Received(
686         address operator,
687         address from,
688         uint256 tokenId,
689         bytes calldata data
690     ) external returns (bytes4);
691 }
692 
693 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
694 
695 
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Interface of the ERC165 standard, as defined in the
701  * https://eips.ethereum.org/EIPS/eip-165[EIP].
702  *
703  * Implementers can declare support of contract interfaces, which can then be
704  * queried by others ({ERC165Checker}).
705  *
706  * For an implementation, see {ERC165}.
707  */
708 interface IERC165 {
709     /**
710      * @dev Returns true if this contract implements the interface defined by
711      * `interfaceId`. See the corresponding
712      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
713      * to learn more about how these ids are created.
714      *
715      * This function call must use less than 30 000 gas.
716      */
717     function supportsInterface(bytes4 interfaceId) external view returns (bool);
718 }
719 
720 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
721 
722 
723 
724 pragma solidity ^0.8.0;
725 
726 
727 /**
728  * @dev Implementation of the {IERC165} interface.
729  *
730  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
731  * for the additional interface id that will be supported. For example:
732  *
733  * ```solidity
734  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
735  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
736  * }
737  * ```
738  *
739  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
740  */
741 abstract contract ERC165 is IERC165 {
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
746         return interfaceId == type(IERC165).interfaceId;
747     }
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
751 
752 
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @dev Required interface of an ERC721 compliant contract.
759  */
760 interface IERC721 is IERC165 {
761     /**
762      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
763      */
764     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
765 
766     /**
767      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
768      */
769     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
770 
771     /**
772      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
773      */
774     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
775 
776     /**
777      * @dev Returns the number of tokens in ``owner``'s account.
778      */
779     function balanceOf(address owner) external view returns (uint256 balance);
780 
781     /**
782      * @dev Returns the owner of the `tokenId` token.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must exist.
787      */
788     function ownerOf(uint256 tokenId) external view returns (address owner);
789 
790     /**
791      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
792      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must exist and be owned by `from`.
799      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) external;
809 
810     /**
811      * @dev Transfers `tokenId` token from `from` to `to`.
812      *
813      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must be owned by `from`.
820      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
821      *
822      * Emits a {Transfer} event.
823      */
824     function transferFrom(
825         address from,
826         address to,
827         uint256 tokenId
828     ) external;
829 
830     /**
831      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
832      * The approval is cleared when the token is transferred.
833      *
834      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
835      *
836      * Requirements:
837      *
838      * - The caller must own the token or be an approved operator.
839      * - `tokenId` must exist.
840      *
841      * Emits an {Approval} event.
842      */
843     function approve(address to, uint256 tokenId) external;
844 
845     /**
846      * @dev Returns the account approved for `tokenId` token.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must exist.
851      */
852     function getApproved(uint256 tokenId) external view returns (address operator);
853 
854     /**
855      * @dev Approve or remove `operator` as an operator for the caller.
856      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
857      *
858      * Requirements:
859      *
860      * - The `operator` cannot be the caller.
861      *
862      * Emits an {ApprovalForAll} event.
863      */
864     function setApprovalForAll(address operator, bool _approved) external;
865 
866     /**
867      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
868      *
869      * See {setApprovalForAll}
870      */
871     function isApprovedForAll(address owner, address operator) external view returns (bool);
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes calldata data
891     ) external;
892 }
893 
894 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
895 
896 
897 
898 pragma solidity ^0.8.0;
899 
900 
901 /**
902  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
903  * @dev See https://eips.ethereum.org/EIPS/eip-721
904  */
905 interface IERC721Metadata is IERC721 {
906     /**
907      * @dev Returns the token collection name.
908      */
909     function name() external view returns (string memory);
910 
911     /**
912      * @dev Returns the token collection symbol.
913      */
914     function symbol() external view returns (string memory);
915 
916     /**
917      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
918      */
919     function tokenURI(uint256 tokenId) external view returns (string memory);
920 }
921 
922 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
923 
924 
925 
926 pragma solidity ^0.8.0;
927 
928 
929 
930 
931 
932 
933 
934 
935 /**
936  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
937  * the Metadata extension, but not including the Enumerable extension, which is available separately as
938  * {ERC721Enumerable}.
939  */
940 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
941     using Address for address;
942     using Strings for uint256;
943 
944     // Token name
945     string private _name;
946 
947     // Token symbol
948     string private _symbol;
949 
950     // Mapping from token ID to owner address
951     mapping(uint256 => address) private _owners;
952 
953     // Mapping owner address to token count
954     mapping(address => uint256) private _balances;
955 
956     // Mapping from token ID to approved address
957     mapping(uint256 => address) private _tokenApprovals;
958 
959     // Mapping from owner to operator approvals
960     mapping(address => mapping(address => bool)) private _operatorApprovals;
961 
962     /**
963      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
964      */
965     constructor(string memory name_, string memory symbol_) {
966         _name = name_;
967         _symbol = symbol_;
968     }
969 
970     /**
971      * @dev See {IERC165-supportsInterface}.
972      */
973     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
974         return
975             interfaceId == type(IERC721).interfaceId ||
976             interfaceId == type(IERC721Metadata).interfaceId ||
977             super.supportsInterface(interfaceId);
978     }
979 
980     /**
981      * @dev See {IERC721-balanceOf}.
982      */
983     function balanceOf(address owner) public view virtual override returns (uint256) {
984         require(owner != address(0), "ERC721: balance query for the zero address");
985         return _balances[owner];
986     }
987 
988     /**
989      * @dev See {IERC721-ownerOf}.
990      */
991     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
992         address owner = _owners[tokenId];
993         require(owner != address(0), "ERC721: owner query for nonexistent token");
994         return owner;
995     }
996 
997     /**
998      * @dev See {IERC721Metadata-name}.
999      */
1000     function name() public view virtual override returns (string memory) {
1001         return _name;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-symbol}.
1006      */
1007     function symbol() public view virtual override returns (string memory) {
1008         return _symbol;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-tokenURI}.
1013      */
1014     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1015         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1016 
1017         string memory baseURI = _baseURI();
1018         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1019     }
1020 
1021     /**
1022      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1023      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1024      * by default, can be overriden in child contracts.
1025      */
1026     function _baseURI() internal view virtual returns (string memory) {
1027         return "";
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-approve}.
1032      */
1033     function approve(address to, uint256 tokenId) public virtual override {
1034         address owner = ERC721.ownerOf(tokenId);
1035         require(to != owner, "ERC721: approval to current owner");
1036 
1037         require(
1038             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1039             "ERC721: approve caller is not owner nor approved for all"
1040         );
1041 
1042         _approve(to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-getApproved}.
1047      */
1048     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1049         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1050 
1051         return _tokenApprovals[tokenId];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-setApprovalForAll}.
1056      */
1057     function setApprovalForAll(address operator, bool approved) public virtual override {
1058         require(operator != _msgSender(), "ERC721: approve to caller");
1059 
1060         _operatorApprovals[_msgSender()][operator] = approved;
1061         emit ApprovalForAll(_msgSender(), operator, approved);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-isApprovedForAll}.
1066      */
1067     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1068         return _operatorApprovals[owner][operator];
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-transferFrom}.
1073      */
1074     function transferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public virtual override {
1079         //solhint-disable-next-line max-line-length
1080         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1081 
1082         _transfer(from, to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-safeTransferFrom}.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) public virtual override {
1093         safeTransferFrom(from, to, tokenId, "");
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-safeTransferFrom}.
1098      */
1099     function safeTransferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) public virtual override {
1105         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1106         _safeTransfer(from, to, tokenId, _data);
1107     }
1108 
1109     /**
1110      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1111      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1112      *
1113      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1114      *
1115      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1116      * implement alternative mechanisms to perform token transfer, such as signature-based.
1117      *
1118      * Requirements:
1119      *
1120      * - `from` cannot be the zero address.
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must exist and be owned by `from`.
1123      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _safeTransfer(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) internal virtual {
1133         _transfer(from, to, tokenId);
1134         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1135     }
1136 
1137     /**
1138      * @dev Returns whether `tokenId` exists.
1139      *
1140      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1141      *
1142      * Tokens start existing when they are minted (`_mint`),
1143      * and stop existing when they are burned (`_burn`).
1144      */
1145     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1146         return _owners[tokenId] != address(0);
1147     }
1148 
1149     /**
1150      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1151      *
1152      * Requirements:
1153      *
1154      * - `tokenId` must exist.
1155      */
1156     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1157         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1158         address owner = ERC721.ownerOf(tokenId);
1159         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1160     }
1161 
1162     /**
1163      * @dev Safely mints `tokenId` and transfers it to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must not exist.
1168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _safeMint(address to, uint256 tokenId) internal virtual {
1173         _safeMint(to, tokenId, "");
1174     }
1175 
1176     /**
1177      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1178      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1179      */
1180     function _safeMint(
1181         address to,
1182         uint256 tokenId,
1183         bytes memory _data
1184     ) internal virtual {
1185         _mint(to, tokenId);
1186         require(
1187             _checkOnERC721Received(address(0), to, tokenId, _data),
1188             "ERC721: transfer to non ERC721Receiver implementer"
1189         );
1190     }
1191 
1192     /**
1193      * @dev Mints `tokenId` and transfers it to `to`.
1194      *
1195      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must not exist.
1200      * - `to` cannot be the zero address.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _mint(address to, uint256 tokenId) internal virtual {
1205         require(to != address(0), "ERC721: mint to the zero address");
1206         require(!_exists(tokenId), "ERC721: token already minted");
1207 
1208         _beforeTokenTransfer(address(0), to, tokenId);
1209 
1210         _balances[to] += 1;
1211         _owners[tokenId] = to;
1212 
1213         emit Transfer(address(0), to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev Destroys `tokenId`.
1218      * The approval is cleared when the token is burned.
1219      *
1220      * Requirements:
1221      *
1222      * - `tokenId` must exist.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _burn(uint256 tokenId) internal virtual {
1227         address owner = ERC721.ownerOf(tokenId);
1228 
1229         _beforeTokenTransfer(owner, address(0), tokenId);
1230 
1231         // Clear approvals
1232         _approve(address(0), tokenId);
1233 
1234         _balances[owner] -= 1;
1235         delete _owners[tokenId];
1236 
1237         emit Transfer(owner, address(0), tokenId);
1238     }
1239 
1240     /**
1241      * @dev Transfers `tokenId` from `from` to `to`.
1242      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1243      *
1244      * Requirements:
1245      *
1246      * - `to` cannot be the zero address.
1247      * - `tokenId` token must be owned by `from`.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _transfer(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) internal virtual {
1256         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1257         require(to != address(0), "ERC721: transfer to the zero address");
1258 
1259         _beforeTokenTransfer(from, to, tokenId);
1260 
1261         // Clear approvals from the previous owner
1262         _approve(address(0), tokenId);
1263 
1264         _balances[from] -= 1;
1265         _balances[to] += 1;
1266         _owners[tokenId] = to;
1267 
1268         emit Transfer(from, to, tokenId);
1269     }
1270 
1271     /**
1272      * @dev Approve `to` to operate on `tokenId`
1273      *
1274      * Emits a {Approval} event.
1275      */
1276     function _approve(address to, uint256 tokenId) internal virtual {
1277         _tokenApprovals[tokenId] = to;
1278         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1283      * The call is not executed if the target address is not a contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) private returns (bool) {
1297         if (to.isContract()) {
1298             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1299                 return retval == IERC721Receiver.onERC721Received.selector;
1300             } catch (bytes memory reason) {
1301                 if (reason.length == 0) {
1302                     revert("ERC721: transfer to non ERC721Receiver implementer");
1303                 } else {
1304                     assembly {
1305                         revert(add(32, reason), mload(reason))
1306                     }
1307                 }
1308             }
1309         } else {
1310             return true;
1311         }
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before any token transfer. This includes minting
1316      * and burning.
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` will be minted for `to`.
1323      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1324      * - `from` and `to` are never both zero.
1325      *
1326      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1327      */
1328     function _beforeTokenTransfer(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) internal virtual {}
1333 }
1334 
1335 // File: contracts/Burnables.sol
1336 
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 
1341 
1342 
1343 
1344 
1345 contract Burnables is ERC721, Ownable {
1346     using Strings for uint256;
1347     using SafeMath for uint256;
1348     using Counters for Counters.Counter;
1349 
1350     Counters.Counter private _tokenIdTracker;
1351     Counters.Counter private _burnedTracker;
1352     
1353     string public baseTokenURI;
1354 
1355     uint256 public constant MAX_ELEMENTS = 999;    
1356     uint256 public constant MINT_PRICE = 8 * 10**16;
1357     
1358     address
1359         public constant creatorAddress = 0xc988f2D5BDB203955c5fBB70E2191D62478b2ee7;
1360 
1361     event CreateBurnable(uint256 indexed id);
1362 
1363     constructor() public ERC721("Burnables", "BURN") {}
1364 
1365     modifier saleIsOpen {
1366         require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
1367         _;
1368     }
1369 
1370     function totalSupply() public view returns (uint256) {
1371         return _tokenIdTracker.current();
1372     }
1373 
1374     function _totalSupply() internal view returns (uint256) {
1375         return _tokenIdTracker.current();
1376     }
1377     
1378     function _totalBurned() internal view returns (uint256) {
1379         return _burnedTracker.current();
1380     }
1381     
1382     function totalBurned() public view returns (uint256) {
1383         return _totalBurned();
1384     }
1385 
1386     function totalMint() public view returns (uint256) {
1387         return _totalSupply();
1388     }
1389     
1390     function mint(address _to, uint256 _count) public payable saleIsOpen {
1391         uint256 total = _totalSupply();
1392         require(total + _count <= MAX_ELEMENTS, "Max limit");
1393         require(total <= MAX_ELEMENTS, "Sale end");
1394         require(msg.value >= price(_count), "Value below price");
1395 
1396         for (uint256 i = 0; i < _count; i++) {
1397             _mintAnElement(_to);
1398         }
1399     }
1400     
1401     function price(uint256 _count) public pure returns (uint256) {
1402         return MINT_PRICE.mul(_count);
1403     }
1404 
1405     function _mintAnElement(address _to) private {
1406         uint256 id = _totalSupply();
1407         _tokenIdTracker.increment();
1408         _safeMint(_to, id);
1409         emit CreateBurnable(id);
1410     }
1411 
1412     function setBaseURI(string memory baseURI) public onlyOwner {
1413         baseTokenURI = baseURI;
1414     }
1415 
1416     /**
1417      * @dev Returns an URI for a given token ID
1418      */
1419     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1420         return string(abi.encodePacked(baseTokenURI, _tokenId.toString()));
1421     }
1422     
1423     /**
1424      * @dev Burns and pays the mint price to the token owner.
1425      * @param _tokenId The token to burn.
1426      */
1427     function burn(uint256 _tokenId) public {
1428         require(ownerOf(_tokenId) == msg.sender);
1429 
1430         //Burn token
1431         _transfer(
1432             msg.sender,
1433             0x000000000000000000000000000000000000dEaD,
1434             _tokenId
1435         );
1436         
1437         // increment burn
1438         _burnedTracker.increment();
1439 
1440         // pay token owner 
1441         _widthdraw(msg.sender, MINT_PRICE);
1442     }
1443 
1444     function _widthdraw(address _address, uint256 _amount) private {
1445         (bool success, ) = _address.call{value: _amount}("");
1446         require(success, "Transfer failed.");
1447     }
1448 }