1 // File: contracts/ISaleContract.sol
2 
3 
4 
5 pragma solidity >=0.4.22 <0.9.0;
6 
7 abstract contract ISaleContract {
8     function sale(uint256 tokenId, uint256[] memory _settings, address[] memory _addrs) public virtual;
9 
10     function offload(uint256 tokenId) public virtual;
11 }
12 // File: contracts/IVoiceStreetNft.sol
13 
14 
15 
16 pragma solidity >=0.4.22 <0.9.0;
17 
18 struct TokenMeta {
19     uint256 id;
20     string name;
21     string uri;
22     string hash;
23     uint256 soldTimes;
24     address minter;
25 }
26 
27 abstract contract IVoiceStreetNft {
28     function totalSupply() public virtual view returns(uint256);
29 
30     function tokenMeta(uint256 _tokenId) public virtual view returns (TokenMeta memory);
31     
32     function setTokenAsset(uint256 _tokenId, string memory _uri, string memory _hash, address _minter) public virtual;
33 
34     function increaseSoldTimes(uint256 _tokenId) public virtual;
35 
36     function getSoldTimes(uint256 _tokenId) public virtual view returns(uint256);
37 }
38 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
39 
40 
41 
42 pragma solidity ^0.8.0;
43 
44 // CAUTION
45 // This version of SafeMath should only be used with Solidity 0.8 or later,
46 // because it relies on the compiler's built in overflow checks.
47 
48 /**
49  * @dev Wrappers over Solidity's arithmetic operations.
50  *
51  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
52  * now has built in overflow checking.
53  */
54 library SafeMath {
55     /**
56      * @dev Returns the addition of two unsigned integers, with an overflow flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         unchecked {
62             uint256 c = a + b;
63             if (c < a) return (false, 0);
64             return (true, c);
65         }
66     }
67 
68     /**
69      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
70      *
71      * _Available since v3.4._
72      */
73     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b > a) return (false, 0);
76             return (true, a - b);
77         }
78     }
79 
80     /**
81      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
82      *
83      * _Available since v3.4._
84      */
85     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88             // benefit is lost if 'b' is also tested.
89             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90             if (a == 0) return (true, 0);
91             uint256 c = a * b;
92             if (c / a != b) return (false, 0);
93             return (true, c);
94         }
95     }
96 
97     /**
98      * @dev Returns the division of two unsigned integers, with a division by zero flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             if (b == 0) return (false, 0);
105             return (true, a / b);
106         }
107     }
108 
109     /**
110      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
111      *
112      * _Available since v3.4._
113      */
114     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         unchecked {
116             if (b == 0) return (false, 0);
117             return (true, a % b);
118         }
119     }
120 
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a + b;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a - b;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a * b;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers, reverting on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator.
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a / b;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * reverting when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a % b;
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
195      * overflow (when the result is negative).
196      *
197      * CAUTION: This function is deprecated because it requires allocating memory for the error
198      * message unnecessarily. For custom revert reasons use {trySub}.
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(
207         uint256 a,
208         uint256 b,
209         string memory errorMessage
210     ) internal pure returns (uint256) {
211         unchecked {
212             require(b <= a, errorMessage);
213             return a - b;
214         }
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         unchecked {
235             require(b > 0, errorMessage);
236             return a / b;
237         }
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * reverting with custom message when dividing by zero.
243      *
244      * CAUTION: This function is deprecated because it requires allocating memory for the error
245      * message unnecessarily. For custom revert reasons use {tryMod}.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(
256         uint256 a,
257         uint256 b,
258         string memory errorMessage
259     ) internal pure returns (uint256) {
260         unchecked {
261             require(b > 0, errorMessage);
262             return a % b;
263         }
264     }
265 }
266 
267 // File: @openzeppelin/contracts/utils/Counters.sol
268 
269 
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @title Counters
275  * @author Matt Condon (@shrugs)
276  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
277  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
278  *
279  * Include with `using Counters for Counters.Counter;`
280  */
281 library Counters {
282     struct Counter {
283         // This variable should never be directly accessed by users of the library: interactions must be restricted to
284         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
285         // this feature: see https://github.com/ethereum/solidity/issues/4637
286         uint256 _value; // default: 0
287     }
288 
289     function current(Counter storage counter) internal view returns (uint256) {
290         return counter._value;
291     }
292 
293     function increment(Counter storage counter) internal {
294         unchecked {
295             counter._value += 1;
296         }
297     }
298 
299     function decrement(Counter storage counter) internal {
300         uint256 value = counter._value;
301         require(value > 0, "Counter: decrement overflow");
302         unchecked {
303             counter._value = value - 1;
304         }
305     }
306 
307     function reset(Counter storage counter) internal {
308         counter._value = 0;
309     }
310 }
311 
312 // File: @openzeppelin/contracts/utils/Strings.sol
313 
314 
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev String operations.
320  */
321 library Strings {
322     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
323 
324     /**
325      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
326      */
327     function toString(uint256 value) internal pure returns (string memory) {
328         // Inspired by OraclizeAPI's implementation - MIT licence
329         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
330 
331         if (value == 0) {
332             return "0";
333         }
334         uint256 temp = value;
335         uint256 digits;
336         while (temp != 0) {
337             digits++;
338             temp /= 10;
339         }
340         bytes memory buffer = new bytes(digits);
341         while (value != 0) {
342             digits -= 1;
343             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
344             value /= 10;
345         }
346         return string(buffer);
347     }
348 
349     /**
350      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
351      */
352     function toHexString(uint256 value) internal pure returns (string memory) {
353         if (value == 0) {
354             return "0x00";
355         }
356         uint256 temp = value;
357         uint256 length = 0;
358         while (temp != 0) {
359             length++;
360             temp >>= 8;
361         }
362         return toHexString(value, length);
363     }
364 
365     /**
366      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
367      */
368     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
369         bytes memory buffer = new bytes(2 * length + 2);
370         buffer[0] = "0";
371         buffer[1] = "x";
372         for (uint256 i = 2 * length + 1; i > 1; --i) {
373             buffer[i] = _HEX_SYMBOLS[value & 0xf];
374             value >>= 4;
375         }
376         require(value == 0, "Strings: hex length insufficient");
377         return string(buffer);
378     }
379 }
380 
381 // File: @openzeppelin/contracts/utils/Context.sol
382 
383 
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @dev Provides information about the current execution context, including the
389  * sender of the transaction and its data. While these are generally available
390  * via msg.sender and msg.data, they should not be accessed in such a direct
391  * manner, since when dealing with meta-transactions the account sending and
392  * paying for execution may not be the actual sender (as far as an application
393  * is concerned).
394  *
395  * This contract is only required for intermediate, library-like contracts.
396  */
397 abstract contract Context {
398     function _msgSender() internal view virtual returns (address) {
399         return msg.sender;
400     }
401 
402     function _msgData() internal view virtual returns (bytes calldata) {
403         return msg.data;
404     }
405 }
406 
407 // File: @openzeppelin/contracts/access/Ownable.sol
408 
409 
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @dev Contract module which provides a basic access control mechanism, where
416  * there is an account (an owner) that can be granted exclusive access to
417  * specific functions.
418  *
419  * By default, the owner account will be the one that deploys the contract. This
420  * can later be changed with {transferOwnership}.
421  *
422  * This module is used through inheritance. It will make available the modifier
423  * `onlyOwner`, which can be applied to your functions to restrict their use to
424  * the owner.
425  */
426 abstract contract Ownable is Context {
427     address private _owner;
428 
429     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
430 
431     /**
432      * @dev Initializes the contract setting the deployer as the initial owner.
433      */
434     constructor() {
435         _setOwner(_msgSender());
436     }
437 
438     /**
439      * @dev Returns the address of the current owner.
440      */
441     function owner() public view virtual returns (address) {
442         return _owner;
443     }
444 
445     /**
446      * @dev Throws if called by any account other than the owner.
447      */
448     modifier onlyOwner() {
449         require(owner() == _msgSender(), "Ownable: caller is not the owner");
450         _;
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         _setOwner(address(0));
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public virtual onlyOwner {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         _setOwner(newOwner);
471     }
472 
473     function _setOwner(address newOwner) private {
474         address oldOwner = _owner;
475         _owner = newOwner;
476         emit OwnershipTransferred(oldOwner, newOwner);
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/Address.sol
481 
482 
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Collection of functions related to the address type
488  */
489 library Address {
490     /**
491      * @dev Returns true if `account` is a contract.
492      *
493      * [IMPORTANT]
494      * ====
495      * It is unsafe to assume that an address for which this function returns
496      * false is an externally-owned account (EOA) and not a contract.
497      *
498      * Among others, `isContract` will return false for the following
499      * types of addresses:
500      *
501      *  - an externally-owned account
502      *  - a contract in construction
503      *  - an address where a contract will be created
504      *  - an address where a contract lived, but was destroyed
505      * ====
506      */
507     function isContract(address account) internal view returns (bool) {
508         // This method relies on extcodesize, which returns 0 for contracts in
509         // construction, since the code is only stored at the end of the
510         // constructor execution.
511 
512         uint256 size;
513         assembly {
514             size := extcodesize(account)
515         }
516         return size > 0;
517     }
518 
519     /**
520      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
521      * `recipient`, forwarding all available gas and reverting on errors.
522      *
523      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
524      * of certain opcodes, possibly making contracts go over the 2300 gas limit
525      * imposed by `transfer`, making them unable to receive funds via
526      * `transfer`. {sendValue} removes this limitation.
527      *
528      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
529      *
530      * IMPORTANT: because control is transferred to `recipient`, care must be
531      * taken to not create reentrancy vulnerabilities. Consider using
532      * {ReentrancyGuard} or the
533      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
534      */
535     function sendValue(address payable recipient, uint256 amount) internal {
536         require(address(this).balance >= amount, "Address: insufficient balance");
537 
538         (bool success, ) = recipient.call{value: amount}("");
539         require(success, "Address: unable to send value, recipient may have reverted");
540     }
541 
542     /**
543      * @dev Performs a Solidity function call using a low level `call`. A
544      * plain `call` is an unsafe replacement for a function call: use this
545      * function instead.
546      *
547      * If `target` reverts with a revert reason, it is bubbled up by this
548      * function (like regular Solidity function calls).
549      *
550      * Returns the raw returned data. To convert to the expected return value,
551      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
552      *
553      * Requirements:
554      *
555      * - `target` must be a contract.
556      * - calling `target` with `data` must not revert.
557      *
558      * _Available since v3.1._
559      */
560     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionCall(target, data, "Address: low-level call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
566      * `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, 0, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but also transferring `value` wei to `target`.
581      *
582      * Requirements:
583      *
584      * - the calling contract must have an ETH balance of at least `value`.
585      * - the called Solidity function must be `payable`.
586      *
587      * _Available since v3.1._
588      */
589     function functionCallWithValue(
590         address target,
591         bytes memory data,
592         uint256 value
593     ) internal returns (bytes memory) {
594         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
599      * with `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCallWithValue(
604         address target,
605         bytes memory data,
606         uint256 value,
607         string memory errorMessage
608     ) internal returns (bytes memory) {
609         require(address(this).balance >= value, "Address: insufficient balance for call");
610         require(isContract(target), "Address: call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.call{value: value}(data);
613         return verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but performing a static call.
619      *
620      * _Available since v3.3._
621      */
622     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
623         return functionStaticCall(target, data, "Address: low-level static call failed");
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
628      * but performing a static call.
629      *
630      * _Available since v3.3._
631      */
632     function functionStaticCall(
633         address target,
634         bytes memory data,
635         string memory errorMessage
636     ) internal view returns (bytes memory) {
637         require(isContract(target), "Address: static call to non-contract");
638 
639         (bool success, bytes memory returndata) = target.staticcall(data);
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a delegate call.
646      *
647      * _Available since v3.4._
648      */
649     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
650         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         require(isContract(target), "Address: delegate call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.delegatecall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
672      * revert reason using the provided one.
673      *
674      * _Available since v4.3._
675      */
676     function verifyCallResult(
677         bool success,
678         bytes memory returndata,
679         string memory errorMessage
680     ) internal pure returns (bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687 
688                 assembly {
689                     let returndata_size := mload(returndata)
690                     revert(add(32, returndata), returndata_size)
691                 }
692             } else {
693                 revert(errorMessage);
694             }
695         }
696     }
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
700 
701 
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @title ERC721 token receiver interface
707  * @dev Interface for any contract that wants to support safeTransfers
708  * from ERC721 asset contracts.
709  */
710 interface IERC721Receiver {
711     /**
712      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
713      * by `operator` from `from`, this function is called.
714      *
715      * It must return its Solidity selector to confirm the token transfer.
716      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
717      *
718      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
719      */
720     function onERC721Received(
721         address operator,
722         address from,
723         uint256 tokenId,
724         bytes calldata data
725     ) external returns (bytes4);
726 }
727 
728 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
729 
730 
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Interface of the ERC165 standard, as defined in the
736  * https://eips.ethereum.org/EIPS/eip-165[EIP].
737  *
738  * Implementers can declare support of contract interfaces, which can then be
739  * queried by others ({ERC165Checker}).
740  *
741  * For an implementation, see {ERC165}.
742  */
743 interface IERC165 {
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30 000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 }
754 
755 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
756 
757 
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @dev Implementation of the {IERC165} interface.
764  *
765  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
766  * for the additional interface id that will be supported. For example:
767  *
768  * ```solidity
769  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
771  * }
772  * ```
773  *
774  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
775  */
776 abstract contract ERC165 is IERC165 {
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
781         return interfaceId == type(IERC165).interfaceId;
782     }
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
786 
787 
788 
789 pragma solidity ^0.8.0;
790 
791 
792 /**
793  * @dev Required interface of an ERC721 compliant contract.
794  */
795 interface IERC721 is IERC165 {
796     /**
797      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
798      */
799     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
800 
801     /**
802      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
803      */
804     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
805 
806     /**
807      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
808      */
809     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
810 
811     /**
812      * @dev Returns the number of tokens in ``owner``'s account.
813      */
814     function balanceOf(address owner) external view returns (uint256 balance);
815 
816     /**
817      * @dev Returns the owner of the `tokenId` token.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      */
823     function ownerOf(uint256 tokenId) external view returns (address owner);
824 
825     /**
826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must exist and be owned by `from`.
834      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) external;
844 
845     /**
846      * @dev Transfers `tokenId` token from `from` to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
856      *
857      * Emits a {Transfer} event.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) external;
864 
865     /**
866      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
867      * The approval is cleared when the token is transferred.
868      *
869      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
870      *
871      * Requirements:
872      *
873      * - The caller must own the token or be an approved operator.
874      * - `tokenId` must exist.
875      *
876      * Emits an {Approval} event.
877      */
878     function approve(address to, uint256 tokenId) external;
879 
880     /**
881      * @dev Returns the account approved for `tokenId` token.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      */
887     function getApproved(uint256 tokenId) external view returns (address operator);
888 
889     /**
890      * @dev Approve or remove `operator` as an operator for the caller.
891      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
892      *
893      * Requirements:
894      *
895      * - The `operator` cannot be the caller.
896      *
897      * Emits an {ApprovalForAll} event.
898      */
899     function setApprovalForAll(address operator, bool _approved) external;
900 
901     /**
902      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
903      *
904      * See {setApprovalForAll}
905      */
906     function isApprovedForAll(address owner, address operator) external view returns (bool);
907 
908     /**
909      * @dev Safely transfers `tokenId` token from `from` to `to`.
910      *
911      * Requirements:
912      *
913      * - `from` cannot be the zero address.
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must exist and be owned by `from`.
916      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
917      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes calldata data
926     ) external;
927 }
928 
929 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
930 
931 
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
957 // File: contracts/metarim.sol
958 
959 
960 
961 // 主网部署地址：
962 //     
963 pragma solidity >=0.4.22 <0.9.0;
964 pragma experimental ABIEncoderV2;
965 
966 
967 
968 
969 
970 
971 
972 
973 
974 
975 
976 
977 
978 contract MetaRim is IVoiceStreetNft, Context, ERC165, IERC721, IERC721Metadata, Ownable {
979     using Address for address;
980     using Strings for uint256;
981     using Counters for Counters.Counter;
982     Counters.Counter private _tokenIds;
983 
984     mapping (uint256 => TokenMeta) public tokenOnChainMeta;
985 
986     uint256 public current_supply = 0;
987     uint256 public MAX_SUPPLY = 12000;
988     uint256 public current_sold = 0;
989     string public baseURI;
990 
991     // Token name
992     string private _name;
993 
994     // Token symbol
995     string private _symbol;
996 
997     // Mapping from token ID to owner address
998     mapping(uint256 => address) internal _owners;
999 
1000     // Mapping owner address to token count
1001     mapping(address => uint256) private _balances;
1002 
1003     // Mapping from token ID to approved address
1004     mapping(uint256 => address) private _tokenApprovals;
1005 
1006     // Mapping from owner to operator approvals
1007     mapping(address => mapping(address => bool)) private _operatorApprovals;
1008 
1009     uint public price;
1010 
1011     uint public buy_limit_per_address = 10;
1012 
1013     uint public sell_begin_time = 0;
1014 
1015     constructor()
1016     {
1017         _name = "MetaRim";
1018         _symbol = "MetaRim";
1019         setBaseURI("https://www.metarim.io/token/");
1020     }
1021 
1022     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1023         baseURI = _newBaseURI;
1024     }
1025 
1026     function setSupplies(uint _current_supply, uint _max_supply) public onlyOwner {
1027         require(_current_supply <= MAX_SUPPLY, "CAN_NOT_EXCEED_MAX_SUPPLY");
1028         current_supply = _current_supply;
1029         MAX_SUPPLY = _max_supply;
1030     }
1031 
1032     function setNames(string memory name_, string memory symbol_) public onlyOwner {
1033         _name = name_;
1034         _symbol = symbol_;
1035     }
1036 
1037     function totalSupply() public override view returns(uint256) {
1038         return _tokenIds.current();
1039     }
1040 
1041     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
1042         return
1043             interfaceId == type(IERC721).interfaceId ||
1044             interfaceId == type(IERC721Metadata).interfaceId ||
1045             super.supportsInterface(interfaceId);
1046     }
1047 
1048     function balanceOf(address owner) public view override returns (uint256) {
1049         require(owner != address(0), "ERC721: balance query for the zero address");
1050         return _balances[owner];
1051     }
1052 
1053     function ownerOf(uint256 tokenId) public view override returns (address) {
1054         address tokenOwner = _owners[tokenId];
1055         return tokenOwner == address(0) ? owner() : tokenOwner;
1056     }
1057 
1058     function name() public view override returns (string memory) {
1059         return _name;
1060     }
1061 
1062     function symbol() public view override returns (string memory) {
1063         return _symbol;
1064     }
1065 
1066     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1067         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1068     }
1069 
1070     function approve(address to, uint256 tokenId) public override {
1071         address owner = ownerOf(tokenId);
1072         require(to != owner, "ERC721: approval to current owner");
1073 
1074         require(
1075             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1076             "ERC721: approve caller is not owner nor approved for all"
1077         );
1078 
1079         _approve(to, tokenId);
1080     }
1081 
1082     function getApproved(uint256 tokenId) public view override returns (address) {
1083         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1084 
1085         return _tokenApprovals[tokenId];
1086     }
1087 
1088     function setApprovalForAll(address operator, bool approved) public override {
1089         require(operator != _msgSender(), "ERC721: approve to caller");
1090 
1091         _operatorApprovals[_msgSender()][operator] = approved;
1092         emit ApprovalForAll(_msgSender(), operator, approved);
1093     }
1094 
1095     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1096         return _operatorApprovals[owner][operator];
1097     }
1098 
1099     function transferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId
1103     ) public override {
1104         //solhint-disable-next-line max-line-length
1105         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1106 
1107         _transfer(from, to, tokenId);
1108     }
1109 
1110     function safeTransferFrom(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) public override {
1115         safeTransferFrom(from, to, tokenId, "");
1116     }
1117 
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) public override {
1124         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1125         _safeTransfer(from, to, tokenId, _data);
1126     }
1127 
1128     function _safeTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) internal {
1134         _transfer(from, to, tokenId);
1135         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1136     }
1137 
1138     function _exists(uint256 tokenId) internal view returns (bool) {
1139         return tokenId <= current_supply;
1140     }
1141 
1142     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1143         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1144         address owner = ownerOf(tokenId);
1145         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1146     }
1147 
1148     function _safeMint(address to, uint256 tokenId) internal {
1149         _safeMint(to, tokenId, "");
1150     }
1151 
1152     function _safeMint(
1153         address to,
1154         uint256 tokenId,
1155         bytes memory _data
1156     ) internal {
1157         _mint(to, tokenId, true);
1158         require(
1159             _checkOnERC721Received(address(0), to, tokenId, _data),
1160             "ERC721: transfer to non ERC721Receiver implementer"
1161         );
1162     }
1163 
1164     function _mint(address to, uint256 tokenId, bool emitting) internal {
1165         require(to != address(0), "ERC721: mint to the zero address");
1166         require(_owners[tokenId] == address(0), "ERC721: token already minted");
1167 
1168         _balances[to] += 1;
1169         _owners[tokenId] = to;
1170 
1171         if (emitting) {
1172             emit Transfer(address(0), to, tokenId);
1173         }
1174     }
1175 
1176     function _transfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) internal {
1181         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1182         require(to != address(0), "ERC721: transfer to the zero address");
1183 
1184         // Clear approvals from the previous owner
1185         _approve(address(0), tokenId);
1186 
1187         _balances[from] -= 1;
1188         _balances[to] += 1;
1189         _owners[tokenId] = to;
1190 
1191         emit Transfer(from, to, tokenId);
1192     }
1193 
1194     function _approve(address to, uint256 tokenId) internal {
1195         _tokenApprovals[tokenId] = to;
1196         emit Approval(ownerOf(tokenId), to, tokenId);
1197     }
1198 
1199     function _checkOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         if (to.isContract()) {
1206             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1207                 return retval == IERC721Receiver(to).onERC721Received.selector;
1208             } catch (bytes memory reason) {
1209                 if (reason.length == 0) {
1210                     revert("ERC721: transfer to non ERC721Receiver implementer");
1211                 } else {
1212                     assembly {
1213                         revert(add(32, reason), mload(reason))
1214                     }
1215                 }
1216             }
1217         } else {
1218             return true;
1219         }
1220     }
1221 
1222     function tokenMeta(uint256 _tokenId) public override view returns (TokenMeta memory) {
1223         return tokenOnChainMeta[_tokenId];
1224     }
1225 
1226     function mintAndPricing(uint256 _num, uint256 _price, uint256 _limit, uint256 _time) public onlyOwner {
1227         uint supply = SafeMath.add(current_supply, _num);
1228         require(supply <= MAX_SUPPLY, "CAN_NOT_EXCEED_MAX_SUPPLY");
1229 
1230         current_supply = supply;
1231         price = _price;
1232         buy_limit_per_address = _limit;
1233         sell_begin_time = _time;
1234     }
1235 
1236     function setTokenAsset(uint256 _tokenId, string memory _uri, string memory _hash, address _minter) public override onlyOwner {
1237         require(_exists(_tokenId), "Vsnft_setTokenAsset_notoken");
1238         TokenMeta storage meta = tokenOnChainMeta[_tokenId];
1239         meta.uri = _uri;
1240         meta.hash = _hash;
1241         meta.minter = _minter;
1242         tokenOnChainMeta[_tokenId] = meta;
1243     }
1244 
1245     function setSale(uint256 _tokenId, address _contractAddr, uint256[] memory _settings, address[] memory _addrs) public {
1246         require(_exists(_tokenId), "Vsnft_setTokenAsset_notoken");
1247         address sender = _msgSender();
1248         require(owner() == sender || ownerOf(_tokenId) == sender, "Invalid_Owner");
1249         
1250         ISaleContract _contract = ISaleContract(_contractAddr);
1251         _contract.sale(_tokenId, _settings, _addrs);   
1252         _transfer(sender, _contractAddr, _tokenId);
1253     }
1254 
1255     function increaseSoldTimes(uint256 /* _tokenId */) public override {
1256     }
1257 
1258     function getSoldTimes(uint256 _tokenId) public override view returns(uint256) {
1259         TokenMeta memory meta = tokenOnChainMeta[_tokenId];
1260         return meta.soldTimes;
1261     }
1262 
1263     function buy(uint amount, uint adv_time) public payable {
1264         require(block.timestamp >= SafeMath.sub(sell_begin_time, adv_time), "Purchase_Not_Enabled");
1265         require(SafeMath.add(balanceOf(msg.sender), amount) <= buy_limit_per_address, "Exceed_Purchase_Limit");
1266         uint requiredValue = SafeMath.mul(amount, price);
1267         require(msg.value >= requiredValue, "Not_Enough_Payment");
1268         require(current_supply >= SafeMath.add(current_sold, amount), "Not_Enough_Stock");
1269 
1270         for (uint i = 0; i < amount; ++i) {
1271             _tokenIds.increment();
1272             uint256 newItemId = _tokenIds.current();
1273             _mint(msg.sender, newItemId, true);
1274 
1275             TokenMeta memory meta = TokenMeta(
1276                 newItemId, 
1277                 "", 
1278                 "",
1279                 "",
1280                 1,
1281                 owner());
1282 
1283             tokenOnChainMeta[newItemId] = meta;
1284         }
1285 
1286         current_sold = SafeMath.add(current_sold, amount);
1287     }
1288 
1289     function withdraw() public onlyOwner {
1290         uint balance = address(this).balance;
1291         Address.sendValue(payable(owner()), balance);
1292     }
1293 }