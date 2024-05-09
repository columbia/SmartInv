1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
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
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor() {
174         _transferOwnership(_msgSender());
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view virtual returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 
224 // File: @openzeppelin/contracts/math/SafeMath.sol
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Wrappers over Solidity's arithmetic operations with added overflow
230  * checks.
231  *
232  * Arithmetic operations in Solidity wrap on overflow. This can easily result
233  * in bugs, because programmers usually assume that an overflow raises an
234  * error, which is the standard behavior in high level programming languages.
235  * `SafeMath` restores this intuition by reverting the transaction when an
236  * operation overflows.
237  *
238  * Using this library instead of the unchecked operations eliminates an entire
239  * class of bugs, so it's recommended to use it always.
240  */
241 library SafeMath {
242     /**
243      * @dev Returns the addition of two unsigned integers, with an overflow flag.
244      *
245      * _Available since v3.4._
246      */
247     function tryAdd(uint256 a, uint256 b)
248         internal
249         pure
250         returns (bool, uint256)
251     {
252         uint256 c = a + b;
253         if (c < a) return (false, 0);
254         return (true, c);
255     }
256 
257     /**
258      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
259      *
260      * _Available since v3.4._
261      */
262     function trySub(uint256 a, uint256 b)
263         internal
264         pure
265         returns (bool, uint256)
266     {
267         if (b > a) return (false, 0);
268         return (true, a - b);
269     }
270 
271     /**
272      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
273      *
274      * _Available since v3.4._
275      */
276     function tryMul(uint256 a, uint256 b)
277         internal
278         pure
279         returns (bool, uint256)
280     {
281         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
282         // benefit is lost if 'b' is also tested.
283         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
284         if (a == 0) return (true, 0);
285         uint256 c = a * b;
286         if (c / a != b) return (false, 0);
287         return (true, c);
288     }
289 
290     /**
291      * @dev Returns the division of two unsigned integers, with a division by zero flag.
292      *
293      * _Available since v3.4._
294      */
295     function tryDiv(uint256 a, uint256 b)
296         internal
297         pure
298         returns (bool, uint256)
299     {
300         if (b == 0) return (false, 0);
301         return (true, a / b);
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
306      *
307      * _Available since v3.4._
308      */
309     function tryMod(uint256 a, uint256 b)
310         internal
311         pure
312         returns (bool, uint256)
313     {
314         if (b == 0) return (false, 0);
315         return (true, a % b);
316     }
317 
318     /**
319      * @dev Returns the addition of two unsigned integers, reverting on
320      * overflow.
321      *
322      * Counterpart to Solidity's `+` operator.
323      *
324      * Requirements:
325      *
326      * - Addition cannot overflow.
327      */
328     function add(uint256 a, uint256 b) internal pure returns (uint256) {
329         uint256 c = a + b;
330         require(c >= a, "SafeMath: addition overflow");
331         return c;
332     }
333 
334     /**
335      * @dev Returns the subtraction of two unsigned integers, reverting on
336      * overflow (when the result is negative).
337      *
338      * Counterpart to Solidity's `-` operator.
339      *
340      * Requirements:
341      *
342      * - Subtraction cannot overflow.
343      */
344     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
345         require(b <= a, "SafeMath: subtraction overflow");
346         return a - b;
347     }
348 
349     /**
350      * @dev Returns the multiplication of two unsigned integers, reverting on
351      * overflow.
352      *
353      * Counterpart to Solidity's `*` operator.
354      *
355      * Requirements:
356      *
357      * - Multiplication cannot overflow.
358      */
359     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
360         if (a == 0) return 0;
361         uint256 c = a * b;
362         require(c / a == b, "SafeMath: multiplication overflow");
363         return c;
364     }
365 
366     /**
367      * @dev Returns the integer division of two unsigned integers, reverting on
368      * division by zero. The result is rounded towards zero.
369      *
370      * Counterpart to Solidity's `/` operator. Note: this function uses a
371      * `revert` opcode (which leaves remaining gas untouched) while Solidity
372      * uses an invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      *
376      * - The divisor cannot be zero.
377      */
378     function div(uint256 a, uint256 b) internal pure returns (uint256) {
379         require(b > 0, "SafeMath: division by zero");
380         return a / b;
381     }
382 
383     /**
384      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
385      * reverting when dividing by zero.
386      *
387      * Counterpart to Solidity's `%` operator. This function uses a `revert`
388      * opcode (which leaves remaining gas untouched) while Solidity uses an
389      * invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
396         require(b > 0, "SafeMath: modulo by zero");
397         return a % b;
398     }
399 
400     /**
401      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
402      * overflow (when the result is negative).
403      *
404      * CAUTION: This function is deprecated because it requires allocating memory for the error
405      * message unnecessarily. For custom revert reasons use {trySub}.
406      *
407      * Counterpart to Solidity's `-` operator.
408      *
409      * Requirements:
410      *
411      * - Subtraction cannot overflow.
412      */
413     function sub(
414         uint256 a,
415         uint256 b,
416         string memory errorMessage
417     ) internal pure returns (uint256) {
418         require(b <= a, errorMessage);
419         return a - b;
420     }
421 
422     /**
423      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
424      * division by zero. The result is rounded towards zero.
425      *
426      * CAUTION: This function is deprecated because it requires allocating memory for the error
427      * message unnecessarily. For custom revert reasons use {tryDiv}.
428      *
429      * Counterpart to Solidity's `/` operator. Note: this function uses a
430      * `revert` opcode (which leaves remaining gas untouched) while Solidity
431      * uses an invalid opcode to revert (consuming all remaining gas).
432      *
433      * Requirements:
434      *
435      * - The divisor cannot be zero.
436      */
437     function div(
438         uint256 a,
439         uint256 b,
440         string memory errorMessage
441     ) internal pure returns (uint256) {
442         require(b > 0, errorMessage);
443         return a / b;
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * reverting with custom message when dividing by zero.
449      *
450      * CAUTION: This function is deprecated because it requires allocating memory for the error
451      * message unnecessarily. For custom revert reasons use {tryMod}.
452      *
453      * Counterpart to Solidity's `%` operator. This function uses a `revert`
454      * opcode (which leaves remaining gas untouched) while Solidity uses an
455      * invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function mod(
462         uint256 a,
463         uint256 b,
464         string memory errorMessage
465     ) internal pure returns (uint256) {
466         require(b > 0, errorMessage);
467         return a % b;
468     }
469 }
470 
471 
472 
473 
474 // File: @openzeppelin/contracts/utils/Address.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev Collection of functions related to the address type
483  */
484 library Address {
485     /**
486      * @dev Returns true if `account` is a contract.
487      *
488      * [IMPORTANT]
489      * ====
490      * It is unsafe to assume that an address for which this function returns
491      * false is an externally-owned account (EOA) and not a contract.
492      *
493      * Among others, `isContract` will return false for the following
494      * types of addresses:
495      *
496      *  - an externally-owned account
497      *  - a contract in construction
498      *  - an address where a contract will be created
499      *  - an address where a contract lived, but was destroyed
500      * ====
501      */
502     function isContract(address account) internal view returns (bool) {
503         // This method relies on extcodesize, which returns 0 for contracts in
504         // construction, since the code is only stored at the end of the
505         // constructor execution.
506 
507         uint256 size;
508         assembly {
509             size := extcodesize(account)
510         }
511         return size > 0;
512     }
513 
514     /**
515      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
516      * `recipient`, forwarding all available gas and reverting on errors.
517      *
518      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
519      * of certain opcodes, possibly making contracts go over the 2300 gas limit
520      * imposed by `transfer`, making them unable to receive funds via
521      * `transfer`. {sendValue} removes this limitation.
522      *
523      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
524      *
525      * IMPORTANT: because control is transferred to `recipient`, care must be
526      * taken to not create reentrancy vulnerabilities. Consider using
527      * {ReentrancyGuard} or the
528      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
529      */
530     function sendValue(address payable recipient, uint256 amount) internal {
531         require(address(this).balance >= amount, "Address: insufficient balance");
532 
533         (bool success, ) = recipient.call{value: amount}("");
534         require(success, "Address: unable to send value, recipient may have reverted");
535     }
536 
537     /**
538      * @dev Performs a Solidity function call using a low level `call`. A
539      * plain `call` is an unsafe replacement for a function call: use this
540      * function instead.
541      *
542      * If `target` reverts with a revert reason, it is bubbled up by this
543      * function (like regular Solidity function calls).
544      *
545      * Returns the raw returned data. To convert to the expected return value,
546      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
547      *
548      * Requirements:
549      *
550      * - `target` must be a contract.
551      * - calling `target` with `data` must not revert.
552      *
553      * _Available since v3.1._
554      */
555     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
556         return functionCall(target, data, "Address: low-level call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
561      * `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, 0, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but also transferring `value` wei to `target`.
576      *
577      * Requirements:
578      *
579      * - the calling contract must have an ETH balance of at least `value`.
580      * - the called Solidity function must be `payable`.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(
585         address target,
586         bytes memory data,
587         uint256 value
588     ) internal returns (bytes memory) {
589         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
594      * with `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(
599         address target,
600         bytes memory data,
601         uint256 value,
602         string memory errorMessage
603     ) internal returns (bytes memory) {
604         require(address(this).balance >= value, "Address: insufficient balance for call");
605         require(isContract(target), "Address: call to non-contract");
606 
607         (bool success, bytes memory returndata) = target.call{value: value}(data);
608         return verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but performing a static call.
614      *
615      * _Available since v3.3._
616      */
617     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
618         return functionStaticCall(target, data, "Address: low-level static call failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(
628         address target,
629         bytes memory data,
630         string memory errorMessage
631     ) internal view returns (bytes memory) {
632         require(isContract(target), "Address: static call to non-contract");
633 
634         (bool success, bytes memory returndata) = target.staticcall(data);
635         return verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a delegate call.
641      *
642      * _Available since v3.4._
643      */
644     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
645         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal returns (bytes memory) {
659         require(isContract(target), "Address: delegate call to non-contract");
660 
661         (bool success, bytes memory returndata) = target.delegatecall(data);
662         return verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     /**
666      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
667      * revert reason using the provided one.
668      *
669      * _Available since v4.3._
670      */
671     function verifyCallResult(
672         bool success,
673         bytes memory returndata,
674         string memory errorMessage
675     ) internal pure returns (bytes memory) {
676         if (success) {
677             return returndata;
678         } else {
679             // Look for revert reason and bubble it up if present
680             if (returndata.length > 0) {
681                 // The easiest way to bubble the revert reason is using memory via assembly
682 
683                 assembly {
684                     let returndata_size := mload(returndata)
685                     revert(add(32, returndata), returndata_size)
686                 }
687             } else {
688                 revert(errorMessage);
689             }
690         }
691     }
692 }
693 
694 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 /**
702  * @title ERC721 token receiver interface
703  * @dev Interface for any contract that wants to support safeTransfers
704  * from ERC721 asset contracts.
705  */
706 interface IERC721Receiver {
707     /**
708      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
709      * by `operator` from `from`, this function is called.
710      *
711      * It must return its Solidity selector to confirm the token transfer.
712      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
713      *
714      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
715      */
716     function onERC721Received(
717         address operator,
718         address from,
719         uint256 tokenId,
720         bytes calldata data
721     ) external returns (bytes4);
722 }
723 
724 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 /**
732  * @dev Interface of the ERC165 standard, as defined in the
733  * https://eips.ethereum.org/EIPS/eip-165[EIP].
734  *
735  * Implementers can declare support of contract interfaces, which can then be
736  * queried by others ({ERC165Checker}).
737  *
738  * For an implementation, see {ERC165}.
739  */
740 interface IERC165 {
741     /**
742      * @dev Returns true if this contract implements the interface defined by
743      * `interfaceId`. See the corresponding
744      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
745      * to learn more about how these ids are created.
746      *
747      * This function call must use less than 30 000 gas.
748      */
749     function supportsInterface(bytes4 interfaceId) external view returns (bool);
750 }
751 
752 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 
760 /**
761  * @dev Implementation of the {IERC165} interface.
762  *
763  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
764  * for the additional interface id that will be supported. For example:
765  *
766  * ```solidity
767  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
768  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
769  * }
770  * ```
771  *
772  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
773  */
774 abstract contract ERC165 is IERC165 {
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
779         return interfaceId == type(IERC165).interfaceId;
780     }
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 /**
792  * @dev Required interface of an ERC721 compliant contract.
793  */
794 interface IERC721 is IERC165 {
795     /**
796      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
797      */
798     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
799 
800     /**
801      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
802      */
803     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
804 
805     /**
806      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
807      */
808     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
809 
810     /**
811      * @dev Returns the number of tokens in ``owner``'s account.
812      */
813     function balanceOf(address owner) external view returns (uint256 balance);
814 
815     /**
816      * @dev Returns the owner of the `tokenId` token.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      */
822     function ownerOf(uint256 tokenId) external view returns (address owner);
823 
824     /**
825      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
826      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must exist and be owned by `from`.
833      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) external;
843 
844     /**
845      * @dev Transfers `tokenId` token from `from` to `to`.
846      *
847      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must be owned by `from`.
854      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
855      *
856      * Emits a {Transfer} event.
857      */
858     function transferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) external;
863 
864     /**
865      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
866      * The approval is cleared when the token is transferred.
867      *
868      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
869      *
870      * Requirements:
871      *
872      * - The caller must own the token or be an approved operator.
873      * - `tokenId` must exist.
874      *
875      * Emits an {Approval} event.
876      */
877     function approve(address to, uint256 tokenId) external;
878 
879     /**
880      * @dev Returns the account approved for `tokenId` token.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      */
886     function getApproved(uint256 tokenId) external view returns (address operator);
887 
888     /**
889      * @dev Approve or remove `operator` as an operator for the caller.
890      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
891      *
892      * Requirements:
893      *
894      * - The `operator` cannot be the caller.
895      *
896      * Emits an {ApprovalForAll} event.
897      */
898     function setApprovalForAll(address operator, bool _approved) external;
899 
900     /**
901      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
902      *
903      * See {setApprovalForAll}
904      */
905     function isApprovedForAll(address owner, address operator) external view returns (bool);
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes calldata data
925     ) external;
926 }
927 
928 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
929 
930 
931 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 
936 /**
937  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
938  * @dev See https://eips.ethereum.org/EIPS/eip-721
939  */
940 interface IERC721Metadata is IERC721 {
941     /**
942      * @dev Returns the token collection name.
943      */
944     function name() external view returns (string memory);
945 
946     /**
947      * @dev Returns the token collection symbol.
948      */
949     function symbol() external view returns (string memory);
950 
951     /**
952      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
953      */
954     function tokenURI(uint256 tokenId) external view returns (string memory);
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 
966 
967 
968 
969 
970 
971 /**
972  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
973  * the Metadata extension, but not including the Enumerable extension, which is available separately as
974  * {ERC721Enumerable}.
975  */
976 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
977     using Address for address;
978     using Strings for uint256;
979 
980     // Token name
981     string private _name;
982 
983     // Token symbol
984     string private _symbol;
985 
986     // Mapping from token ID to owner address
987     mapping(uint256 => address) private _owners;
988 
989     // Mapping owner address to token count
990     mapping(address => uint256) private _balances;
991 
992     // Mapping from token ID to approved address
993     mapping(uint256 => address) private _tokenApprovals;
994 
995     // Mapping from owner to operator approvals
996     mapping(address => mapping(address => bool)) private _operatorApprovals;
997 
998     /**
999      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1000      */
1001     constructor(string memory name_, string memory symbol_) {
1002         _name = name_;
1003         _symbol = symbol_;
1004     }
1005 
1006     /**
1007      * @dev See {IERC165-supportsInterface}.
1008      */
1009     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1010         return
1011             interfaceId == type(IERC721).interfaceId ||
1012             interfaceId == type(IERC721Metadata).interfaceId ||
1013             super.supportsInterface(interfaceId);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-balanceOf}.
1018      */
1019     function balanceOf(address owner) public view virtual override returns (uint256) {
1020         require(owner != address(0), "ERC721: balance query for the zero address");
1021         return _balances[owner];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-ownerOf}.
1026      */
1027     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1028         address owner = _owners[tokenId];
1029         require(owner != address(0), "ERC721: owner query for nonexistent token");
1030         return owner;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Metadata-name}.
1035      */
1036     function name() public view virtual override returns (string memory) {
1037         return _name;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Metadata-symbol}.
1042      */
1043     function symbol() public view virtual override returns (string memory) {
1044         return _symbol;
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Metadata-tokenURI}.
1049      */
1050     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1051         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1052 
1053         string memory baseURI = _baseURI();
1054         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1055     }
1056 
1057     /**
1058      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1059      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1060      * by default, can be overriden in child contracts.
1061      */
1062     function _baseURI() internal view virtual returns (string memory) {
1063         return "";
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-approve}.
1068      */
1069     function approve(address to, uint256 tokenId) public virtual override {
1070         address owner = ERC721.ownerOf(tokenId);
1071         require(to != owner, "ERC721: approval to current owner");
1072 
1073         require(
1074             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1075             "ERC721: approve caller is not owner nor approved for all"
1076         );
1077 
1078         _approve(to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-getApproved}.
1083      */
1084     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1085         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1086 
1087         return _tokenApprovals[tokenId];
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-setApprovalForAll}.
1092      */
1093     function setApprovalForAll(address operator, bool approved) public virtual override {
1094         _setApprovalForAll(_msgSender(), operator, approved);
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-isApprovedForAll}.
1099      */
1100     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1101         return _operatorApprovals[owner][operator];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-transferFrom}.
1106      */
1107     function transferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) public virtual override {
1112         //solhint-disable-next-line max-line-length
1113         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1114 
1115         _transfer(from, to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-safeTransferFrom}.
1120      */
1121     function safeTransferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) public virtual override {
1126         safeTransferFrom(from, to, tokenId, "");
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-safeTransferFrom}.
1131      */
1132     function safeTransferFrom(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) public virtual override {
1138         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1139         _safeTransfer(from, to, tokenId, _data);
1140     }
1141 
1142     /**
1143      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1144      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1145      *
1146      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1147      *
1148      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1149      * implement alternative mechanisms to perform token transfer, such as signature-based.
1150      *
1151      * Requirements:
1152      *
1153      * - `from` cannot be the zero address.
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must exist and be owned by `from`.
1156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function _safeTransfer(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) internal virtual {
1166         _transfer(from, to, tokenId);
1167         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1168     }
1169 
1170     /**
1171      * @dev Returns whether `tokenId` exists.
1172      *
1173      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1174      *
1175      * Tokens start existing when they are minted (`_mint`),
1176      * and stop existing when they are burned (`_burn`).
1177      */
1178     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1179         return _owners[tokenId] != address(0);
1180     }
1181 
1182     /**
1183      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      */
1189     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1190         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1191         address owner = ERC721.ownerOf(tokenId);
1192         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1193     }
1194 
1195     /**
1196      * @dev Safely mints `tokenId` and transfers it to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must not exist.
1201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _safeMint(address to, uint256 tokenId) internal virtual {
1206         _safeMint(to, tokenId, "");
1207     }
1208 
1209     /**
1210      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1211      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1212      */
1213     function _safeMint(
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) internal virtual {
1218         _mint(to, tokenId);
1219         require(
1220             _checkOnERC721Received(address(0), to, tokenId, _data),
1221             "ERC721: transfer to non ERC721Receiver implementer"
1222         );
1223     }
1224 
1225     /**
1226      * @dev Mints `tokenId` and transfers it to `to`.
1227      *
1228      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must not exist.
1233      * - `to` cannot be the zero address.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _mint(address to, uint256 tokenId) internal virtual {
1238         require(to != address(0), "ERC721: mint to the zero address");
1239         require(!_exists(tokenId), "ERC721: token already minted");
1240 
1241         _beforeTokenTransfer(address(0), to, tokenId);
1242 
1243         _balances[to] += 1;
1244         _owners[tokenId] = to;
1245 
1246         emit Transfer(address(0), to, tokenId);
1247     }
1248 
1249     /**
1250      * @dev Destroys `tokenId`.
1251      * The approval is cleared when the token is burned.
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must exist.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _burn(uint256 tokenId) internal virtual {
1260         address owner = ERC721.ownerOf(tokenId);
1261 
1262         _beforeTokenTransfer(owner, address(0), tokenId);
1263 
1264         // Clear approvals
1265         _approve(address(0), tokenId);
1266 
1267         _balances[owner] -= 1;
1268         delete _owners[tokenId];
1269 
1270         emit Transfer(owner, address(0), tokenId);
1271     }
1272 
1273     /**
1274      * @dev Transfers `tokenId` from `from` to `to`.
1275      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1276      *
1277      * Requirements:
1278      *
1279      * - `to` cannot be the zero address.
1280      * - `tokenId` token must be owned by `from`.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _transfer(
1285         address from,
1286         address to,
1287         uint256 tokenId
1288     ) internal virtual {
1289         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1290         require(to != address(0), "ERC721: transfer to the zero address");
1291 
1292         _beforeTokenTransfer(from, to, tokenId);
1293 
1294         // Clear approvals from the previous owner
1295         _approve(address(0), tokenId);
1296 
1297         _balances[from] -= 1;
1298         _balances[to] += 1;
1299         _owners[tokenId] = to;
1300 
1301         emit Transfer(from, to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Approve `to` to operate on `tokenId`
1306      *
1307      * Emits a {Approval} event.
1308      */
1309     function _approve(address to, uint256 tokenId) internal virtual {
1310         _tokenApprovals[tokenId] = to;
1311         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1312     }
1313 
1314     /**
1315      * @dev Approve `operator` to operate on all of `owner` tokens
1316      *
1317      * Emits a {ApprovalForAll} event.
1318      */
1319     function _setApprovalForAll(
1320         address owner,
1321         address operator,
1322         bool approved
1323     ) internal virtual {
1324         require(owner != operator, "ERC721: approve to caller");
1325         _operatorApprovals[owner][operator] = approved;
1326         emit ApprovalForAll(owner, operator, approved);
1327     }
1328 
1329     /**
1330      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1331      * The call is not executed if the target address is not a contract.
1332      *
1333      * @param from address representing the previous owner of the given token ID
1334      * @param to target address that will receive the tokens
1335      * @param tokenId uint256 ID of the token to be transferred
1336      * @param _data bytes optional data to send along with the call
1337      * @return bool whether the call correctly returned the expected magic value
1338      */
1339     function _checkOnERC721Received(
1340         address from,
1341         address to,
1342         uint256 tokenId,
1343         bytes memory _data
1344     ) private returns (bool) {
1345         if (to.isContract()) {
1346             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1347                 return retval == IERC721Receiver.onERC721Received.selector;
1348             } catch (bytes memory reason) {
1349                 if (reason.length == 0) {
1350                     revert("ERC721: transfer to non ERC721Receiver implementer");
1351                 } else {
1352                     assembly {
1353                         revert(add(32, reason), mload(reason))
1354                     }
1355                 }
1356             }
1357         } else {
1358             return true;
1359         }
1360     }
1361 
1362     /**
1363      * @dev Hook that is called before any token transfer. This includes minting
1364      * and burning.
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` will be minted for `to`.
1371      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1372      * - `from` and `to` are never both zero.
1373      *
1374      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1375      */
1376     function _beforeTokenTransfer(
1377         address from,
1378         address to,
1379         uint256 tokenId
1380     ) internal virtual {}
1381 }
1382 
1383 // File: contracts/TestLowGas.sol
1384 
1385 
1386 
1387 
1388 pragma solidity >=0.7.0 <0.9.0;
1389 
1390 
1391 
1392 
1393 contract PropertyHeistNFT is ERC721, Ownable {
1394   using Strings for uint256;
1395   using SafeMath for uint256;  
1396   using Counters for Counters.Counter;
1397 
1398   Counters.Counter private supply;
1399 
1400   string public uriPrefix = "";
1401   string public uriSuffix = ".json";
1402   string public hiddenMetadataUri;
1403   
1404   uint256 public nftReserve = 100;  
1405   uint256 public cost = 0.08 ether;
1406   uint256 public maxSupply = 8888;
1407   uint256 public maxMintAmountPerTx = 5;
1408 
1409   bool public paused = true;
1410   bool public revealed = false;
1411 
1412   constructor() ERC721("Property Heist Ape Club", "PHAC") {
1413     setHiddenMetadataUri("ipfs://QmdDJFGsNs9hoTYd1KgMxuchFF2XwGFwo22iUfos4umStM/hidden.json");
1414   }
1415 
1416   modifier mintCompliance(uint256 _mintAmount) {
1417     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1418     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1419     _;
1420   }
1421 
1422   function totalSupply() public view returns (uint256) {
1423     return supply.current();
1424   }
1425 
1426 
1427   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1428     require(!paused, "The contract is paused!");
1429     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1430 
1431     _mintLoop(msg.sender, _mintAmount);
1432   }
1433   
1434   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1435     _mintLoop(_receiver, _mintAmount);
1436   }
1437 
1438   function walletOfOwner(address _owner)
1439     public
1440     view
1441     returns (uint256[] memory)
1442   {
1443     uint256 ownerTokenCount = balanceOf(_owner);
1444     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1445     uint256 currentTokenId = 1;
1446     uint256 ownedTokenIndex = 0;
1447 
1448     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1449       address currentTokenOwner = ownerOf(currentTokenId);
1450 
1451       if (currentTokenOwner == _owner) {
1452         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1453 
1454         ownedTokenIndex++;
1455       }
1456 
1457       currentTokenId++;
1458     }
1459 
1460     return ownedTokenIds;
1461   }
1462 
1463   function tokenURI(uint256 _tokenId)
1464     public
1465     view
1466     virtual
1467     override
1468     returns (string memory)
1469   {
1470     require(
1471       _exists(_tokenId),
1472       "ERC721Metadata: URI query for nonexistent token"
1473     );
1474 
1475     if (revealed == false) {
1476       return hiddenMetadataUri;
1477     }
1478 
1479     string memory currentBaseURI = _baseURI();
1480     return bytes(currentBaseURI).length > 0
1481         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1482         : "";
1483   }
1484 
1485   function setRevealed(bool _state) public onlyOwner {
1486     revealed = _state;
1487   }
1488 
1489   function setCost(uint256 _cost) public onlyOwner {
1490     cost = _cost;
1491   }
1492 
1493   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1494     maxMintAmountPerTx = _maxMintAmountPerTx;
1495   }
1496 
1497   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1498     hiddenMetadataUri = _hiddenMetadataUri;
1499   }
1500 
1501   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1502     uriPrefix = _uriPrefix;
1503   }
1504 
1505   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1506     uriSuffix = _uriSuffix;
1507   }
1508 
1509   function setPaused(bool _state) public onlyOwner {
1510     paused = _state;
1511   }
1512 
1513   function withdraw() public onlyOwner {
1514 
1515     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1516     require(os);
1517 
1518   }
1519 
1520   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1521     for (uint256 i = 0; i < _mintAmount; i++) {
1522       supply.increment();
1523       _safeMint(_receiver, supply.current());
1524     }
1525   }
1526 
1527   function _baseURI() internal view virtual override returns (string memory) {
1528     return uriPrefix;
1529   }
1530 }