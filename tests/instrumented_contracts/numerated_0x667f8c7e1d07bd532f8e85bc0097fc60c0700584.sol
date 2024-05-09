1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
67 
68 
69 
70 pragma solidity ^0.8.0;
71 
72 // CAUTION
73 // This version of SafeMath should only be used with Solidity 0.8 or later,
74 // because it relies on the compiler's built in overflow checks.
75 
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations.
78  *
79  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
80  * now has built in overflow checking.
81  */
82 library SafeMath {
83     /**
84      * @dev Returns the addition of two unsigned integers, with an overflow flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             uint256 c = a + b;
91             if (c < a) return (false, 0);
92             return (true, c);
93         }
94     }
95 
96     /**
97      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             if (b > a) return (false, 0);
104             return (true, a - b);
105         }
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116             // benefit is lost if 'b' is also tested.
117             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118             if (a == 0) return (true, 0);
119             uint256 c = a * b;
120             if (c / a != b) return (false, 0);
121             return (true, c);
122         }
123     }
124 
125     /**
126      * @dev Returns the division of two unsigned integers, with a division by zero flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             if (b == 0) return (false, 0);
133             return (true, a / b);
134         }
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
139      *
140      * _Available since v3.4._
141      */
142     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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
295 // File: @openzeppelin/contracts/utils/Counters.sol
296 
297 
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @title Counters
303  * @author Matt Condon (@shrugs)
304  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
305  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
306  *
307  * Include with `using Counters for Counters.Counter;`
308  */
309 library Counters {
310     struct Counter {
311         // This variable should never be directly accessed by users of the library: interactions must be restricted to
312         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
313         // this feature: see https://github.com/ethereum/solidity/issues/4637
314         uint256 _value; // default: 0
315     }
316 
317     function current(Counter storage counter) internal view returns (uint256) {
318         return counter._value;
319     }
320 
321     function increment(Counter storage counter) internal {
322         unchecked {
323             counter._value += 1;
324         }
325     }
326 
327     function decrement(Counter storage counter) internal {
328         uint256 value = counter._value;
329         require(value > 0, "Counter: decrement overflow");
330         unchecked {
331             counter._value = value - 1;
332         }
333     }
334 
335     function reset(Counter storage counter) internal {
336         counter._value = 0;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/utils/Strings.sol
341 
342 
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev String operations.
348  */
349 library Strings {
350     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
351 
352     /**
353      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
354      */
355     function toString(uint256 value) internal pure returns (string memory) {
356         // Inspired by OraclizeAPI's implementation - MIT licence
357         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
358 
359         if (value == 0) {
360             return "0";
361         }
362         uint256 temp = value;
363         uint256 digits;
364         while (temp != 0) {
365             digits++;
366             temp /= 10;
367         }
368         bytes memory buffer = new bytes(digits);
369         while (value != 0) {
370             digits -= 1;
371             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
372             value /= 10;
373         }
374         return string(buffer);
375     }
376 
377     /**
378      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
379      */
380     function toHexString(uint256 value) internal pure returns (string memory) {
381         if (value == 0) {
382             return "0x00";
383         }
384         uint256 temp = value;
385         uint256 length = 0;
386         while (temp != 0) {
387             length++;
388             temp >>= 8;
389         }
390         return toHexString(value, length);
391     }
392 
393     /**
394      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
395      */
396     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
397         bytes memory buffer = new bytes(2 * length + 2);
398         buffer[0] = "0";
399         buffer[1] = "x";
400         for (uint256 i = 2 * length + 1; i > 1; --i) {
401             buffer[i] = _HEX_SYMBOLS[value & 0xf];
402             value >>= 4;
403         }
404         require(value == 0, "Strings: hex length insufficient");
405         return string(buffer);
406     }
407 }
408 
409 // File: @openzeppelin/contracts/utils/Context.sol
410 
411 
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev Provides information about the current execution context, including the
417  * sender of the transaction and its data. While these are generally available
418  * via msg.sender and msg.data, they should not be accessed in such a direct
419  * manner, since when dealing with meta-transactions the account sending and
420  * paying for execution may not be the actual sender (as far as an application
421  * is concerned).
422  *
423  * This contract is only required for intermediate, library-like contracts.
424  */
425 abstract contract Context {
426     function _msgSender() internal view virtual returns (address) {
427         return msg.sender;
428     }
429 
430     function _msgData() internal view virtual returns (bytes calldata) {
431         return msg.data;
432     }
433 }
434 
435 // File: @openzeppelin/contracts/access/Ownable.sol
436 
437 
438 
439 pragma solidity ^0.8.0;
440 
441 
442 /**
443  * @dev Contract module which provides a basic access control mechanism, where
444  * there is an account (an owner) that can be granted exclusive access to
445  * specific functions.
446  *
447  * By default, the owner account will be the one that deploys the contract. This
448  * can later be changed with {transferOwnership}.
449  *
450  * This module is used through inheritance. It will make available the modifier
451  * `onlyOwner`, which can be applied to your functions to restrict their use to
452  * the owner.
453  */
454 abstract contract Ownable is Context {
455     address private _owner;
456 
457     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
458 
459     /**
460      * @dev Initializes the contract setting the deployer as the initial owner.
461      */
462     constructor() {
463         _setOwner(_msgSender());
464     }
465 
466     /**
467      * @dev Returns the address of the current owner.
468      */
469     function owner() public view virtual returns (address) {
470         return _owner;
471     }
472 
473     /**
474      * @dev Throws if called by any account other than the owner.
475      */
476     modifier onlyOwner() {
477         require(owner() == _msgSender(), "Ownable: caller is not the owner");
478         _;
479     }
480 
481     /**
482      * @dev Leaves the contract without owner. It will not be possible to call
483      * `onlyOwner` functions anymore. Can only be called by the current owner.
484      *
485      * NOTE: Renouncing ownership will leave the contract without an owner,
486      * thereby removing any functionality that is only available to the owner.
487      */
488     function renounceOwnership() public virtual onlyOwner {
489         _setOwner(address(0));
490     }
491 
492     /**
493      * @dev Transfers ownership of the contract to a new account (`newOwner`).
494      * Can only be called by the current owner.
495      */
496     function transferOwnership(address newOwner) public virtual onlyOwner {
497         require(newOwner != address(0), "Ownable: new owner is the zero address");
498         _setOwner(newOwner);
499     }
500 
501     function _setOwner(address newOwner) private {
502         address oldOwner = _owner;
503         _owner = newOwner;
504         emit OwnershipTransferred(oldOwner, newOwner);
505     }
506 }
507 
508 // File: @openzeppelin/contracts/utils/Address.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Collection of functions related to the address type
516  */
517 library Address {
518     /**
519      * @dev Returns true if `account` is a contract.
520      *
521      * [IMPORTANT]
522      * ====
523      * It is unsafe to assume that an address for which this function returns
524      * false is an externally-owned account (EOA) and not a contract.
525      *
526      * Among others, `isContract` will return false for the following
527      * types of addresses:
528      *
529      *  - an externally-owned account
530      *  - a contract in construction
531      *  - an address where a contract will be created
532      *  - an address where a contract lived, but was destroyed
533      * ====
534      */
535     function isContract(address account) internal view returns (bool) {
536         // This method relies on extcodesize, which returns 0 for contracts in
537         // construction, since the code is only stored at the end of the
538         // constructor execution.
539 
540         uint256 size;
541         assembly {
542             size := extcodesize(account)
543         }
544         return size > 0;
545     }
546 
547     /**
548      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
549      * `recipient`, forwarding all available gas and reverting on errors.
550      *
551      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
552      * of certain opcodes, possibly making contracts go over the 2300 gas limit
553      * imposed by `transfer`, making them unable to receive funds via
554      * `transfer`. {sendValue} removes this limitation.
555      *
556      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
557      *
558      * IMPORTANT: because control is transferred to `recipient`, care must be
559      * taken to not create reentrancy vulnerabilities. Consider using
560      * {ReentrancyGuard} or the
561      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
562      */
563     function sendValue(address payable recipient, uint256 amount) internal {
564         require(address(this).balance >= amount, "Address: insufficient balance");
565 
566         (bool success, ) = recipient.call{value: amount}("");
567         require(success, "Address: unable to send value, recipient may have reverted");
568     }
569 
570     /**
571      * @dev Performs a Solidity function call using a low level `call`. A
572      * plain `call` is an unsafe replacement for a function call: use this
573      * function instead.
574      *
575      * If `target` reverts with a revert reason, it is bubbled up by this
576      * function (like regular Solidity function calls).
577      *
578      * Returns the raw returned data. To convert to the expected return value,
579      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
580      *
581      * Requirements:
582      *
583      * - `target` must be a contract.
584      * - calling `target` with `data` must not revert.
585      *
586      * _Available since v3.1._
587      */
588     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
589         return functionCall(target, data, "Address: low-level call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
594      * `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         return functionCallWithValue(target, data, 0, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but also transferring `value` wei to `target`.
609      *
610      * Requirements:
611      *
612      * - the calling contract must have an ETH balance of at least `value`.
613      * - the called Solidity function must be `payable`.
614      *
615      * _Available since v3.1._
616      */
617     function functionCallWithValue(
618         address target,
619         bytes memory data,
620         uint256 value
621     ) internal returns (bytes memory) {
622         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
627      * with `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCallWithValue(
632         address target,
633         bytes memory data,
634         uint256 value,
635         string memory errorMessage
636     ) internal returns (bytes memory) {
637         require(address(this).balance >= value, "Address: insufficient balance for call");
638         require(isContract(target), "Address: call to non-contract");
639 
640         (bool success, bytes memory returndata) = target.call{value: value}(data);
641         return verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
646      * but performing a static call.
647      *
648      * _Available since v3.3._
649      */
650     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
651         return functionStaticCall(target, data, "Address: low-level static call failed");
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
656      * but performing a static call.
657      *
658      * _Available since v3.3._
659      */
660     function functionStaticCall(
661         address target,
662         bytes memory data,
663         string memory errorMessage
664     ) internal view returns (bytes memory) {
665         require(isContract(target), "Address: static call to non-contract");
666 
667         (bool success, bytes memory returndata) = target.staticcall(data);
668         return verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but performing a delegate call.
674      *
675      * _Available since v3.4._
676      */
677     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
678         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
683      * but performing a delegate call.
684      *
685      * _Available since v3.4._
686      */
687     function functionDelegateCall(
688         address target,
689         bytes memory data,
690         string memory errorMessage
691     ) internal returns (bytes memory) {
692         require(isContract(target), "Address: delegate call to non-contract");
693 
694         (bool success, bytes memory returndata) = target.delegatecall(data);
695         return verifyCallResult(success, returndata, errorMessage);
696     }
697 
698     /**
699      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
700      * revert reason using the provided one.
701      *
702      * _Available since v4.3._
703      */
704     function verifyCallResult(
705         bool success,
706         bytes memory returndata,
707         string memory errorMessage
708     ) internal pure returns (bytes memory) {
709         if (success) {
710             return returndata;
711         } else {
712             // Look for revert reason and bubble it up if present
713             if (returndata.length > 0) {
714                 // The easiest way to bubble the revert reason is using memory via assembly
715 
716                 assembly {
717                     let returndata_size := mload(returndata)
718                     revert(add(32, returndata), returndata_size)
719                 }
720             } else {
721                 revert(errorMessage);
722             }
723         }
724     }
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
728 
729 
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @title ERC721 token receiver interface
735  * @dev Interface for any contract that wants to support safeTransfers
736  * from ERC721 asset contracts.
737  */
738 interface IERC721Receiver {
739     /**
740      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
741      * by `operator` from `from`, this function is called.
742      *
743      * It must return its Solidity selector to confirm the token transfer.
744      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
745      *
746      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
747      */
748     function onERC721Received(
749         address operator,
750         address from,
751         uint256 tokenId,
752         bytes calldata data
753     ) external returns (bytes4);
754 }
755 
756 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
757 
758 
759 
760 pragma solidity ^0.8.0;
761 
762 /**
763  * @dev Interface of the ERC165 standard, as defined in the
764  * https://eips.ethereum.org/EIPS/eip-165[EIP].
765  *
766  * Implementers can declare support of contract interfaces, which can then be
767  * queried by others ({ERC165Checker}).
768  *
769  * For an implementation, see {ERC165}.
770  */
771 interface IERC165 {
772     /**
773      * @dev Returns true if this contract implements the interface defined by
774      * `interfaceId`. See the corresponding
775      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
776      * to learn more about how these ids are created.
777      *
778      * This function call must use less than 30 000 gas.
779      */
780     function supportsInterface(bytes4 interfaceId) external view returns (bool);
781 }
782 
783 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
784 
785 
786 
787 pragma solidity ^0.8.0;
788 
789 
790 /**
791  * @dev Implementation of the {IERC165} interface.
792  *
793  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
794  * for the additional interface id that will be supported. For example:
795  *
796  * ```solidity
797  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
798  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
799  * }
800  * ```
801  *
802  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
803  */
804 abstract contract ERC165 is IERC165 {
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
809         return interfaceId == type(IERC165).interfaceId;
810     }
811 }
812 
813 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
814 
815 
816 
817 pragma solidity ^0.8.0;
818 
819 
820 /**
821  * @dev Required interface of an ERC721 compliant contract.
822  */
823 interface IERC721 is IERC165 {
824     /**
825      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
826      */
827     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
828 
829     /**
830      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
831      */
832     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
833 
834     /**
835      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
836      */
837     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
838 
839     /**
840      * @dev Returns the number of tokens in ``owner``'s account.
841      */
842     function balanceOf(address owner) external view returns (uint256 balance);
843 
844     /**
845      * @dev Returns the owner of the `tokenId` token.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function ownerOf(uint256 tokenId) external view returns (address owner);
852 
853     /**
854      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
855      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) external;
872 
873     /**
874      * @dev Transfers `tokenId` token from `from` to `to`.
875      *
876      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must be owned by `from`.
883      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
884      *
885      * Emits a {Transfer} event.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) external;
892 
893     /**
894      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
895      * The approval is cleared when the token is transferred.
896      *
897      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
898      *
899      * Requirements:
900      *
901      * - The caller must own the token or be an approved operator.
902      * - `tokenId` must exist.
903      *
904      * Emits an {Approval} event.
905      */
906     function approve(address to, uint256 tokenId) external;
907 
908     /**
909      * @dev Returns the account approved for `tokenId` token.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      */
915     function getApproved(uint256 tokenId) external view returns (address operator);
916 
917     /**
918      * @dev Approve or remove `operator` as an operator for the caller.
919      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
920      *
921      * Requirements:
922      *
923      * - The `operator` cannot be the caller.
924      *
925      * Emits an {ApprovalForAll} event.
926      */
927     function setApprovalForAll(address operator, bool _approved) external;
928 
929     /**
930      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
931      *
932      * See {setApprovalForAll}
933      */
934     function isApprovedForAll(address owner, address operator) external view returns (bool);
935 
936     /**
937      * @dev Safely transfers `tokenId` token from `from` to `to`.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes calldata data
954     ) external;
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
967  * @dev See https://eips.ethereum.org/EIPS/eip-721
968  */
969 interface IERC721Enumerable is IERC721 {
970     /**
971      * @dev Returns the total amount of tokens stored by the contract.
972      */
973     function totalSupply() external view returns (uint256);
974 
975     /**
976      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
977      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
978      */
979     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
980 
981     /**
982      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
983      * Use along with {totalSupply} to enumerate all tokens.
984      */
985     function tokenByIndex(uint256 index) external view returns (uint256);
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
989 
990 
991 
992 pragma solidity ^0.8.0;
993 
994 
995 /**
996  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
997  * @dev See https://eips.ethereum.org/EIPS/eip-721
998  */
999 interface IERC721Metadata is IERC721 {
1000     /**
1001      * @dev Returns the token collection name.
1002      */
1003     function name() external view returns (string memory);
1004 
1005     /**
1006      * @dev Returns the token collection symbol.
1007      */
1008     function symbol() external view returns (string memory);
1009 
1010     /**
1011      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1012      */
1013     function tokenURI(uint256 tokenId) external view returns (string memory);
1014 }
1015 
1016 // File: ERC721A.sol
1017 
1018 
1019 // Creator: Chiru Labs
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 
1025 
1026 
1027 
1028 
1029 
1030 
1031 /**
1032  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1033  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1034  *
1035  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1036  *
1037  * Does not support burning tokens to address(0).
1038  *
1039  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
1040  */
1041 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1042     using Address for address;
1043     using Strings for uint256;
1044 
1045     struct TokenOwnership {
1046         address addr;
1047         uint64 startTimestamp;
1048     }
1049 
1050     struct AddressData {
1051         uint128 balance;
1052         uint128 numberMinted;
1053     }
1054 
1055     uint256 internal currentIndex = 0;
1056 
1057     // Token name
1058     string private _name;
1059 
1060     // Token symbol
1061     string private _symbol;
1062 
1063     // Mapping from token ID to ownership details
1064     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1065     mapping(uint256 => TokenOwnership) internal _ownerships;
1066 
1067     // Mapping owner address to address data
1068     mapping(address => AddressData) private _addressData;
1069 
1070     // Mapping from token ID to approved address
1071     mapping(uint256 => address) private _tokenApprovals;
1072 
1073     // Mapping from owner to operator approvals
1074     mapping(address => mapping(address => bool)) private _operatorApprovals;
1075 
1076     constructor(string memory name_, string memory symbol_) {
1077         _name = name_;
1078         _symbol = symbol_;
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Enumerable-totalSupply}.
1083      */
1084     function totalSupply() public view override returns (uint256) {
1085         return currentIndex;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Enumerable-tokenByIndex}.
1090      */
1091     function tokenByIndex(uint256 index) public view override returns (uint256) {
1092         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1093         return index;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1098      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1099      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1100      */
1101     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1102         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1103         uint256 numMintedSoFar = totalSupply();
1104         uint256 tokenIdsIdx = 0;
1105         address currOwnershipAddr = address(0);
1106         for (uint256 i = 0; i < numMintedSoFar; i++) {
1107             TokenOwnership memory ownership = _ownerships[i];
1108             if (ownership.addr != address(0)) {
1109                 currOwnershipAddr = ownership.addr;
1110             }
1111             if (currOwnershipAddr == owner) {
1112                 if (tokenIdsIdx == index) {
1113                     return i;
1114                 }
1115                 tokenIdsIdx++;
1116             }
1117         }
1118         revert('ERC721A: unable to get token of owner by index');
1119     }
1120 
1121     /**
1122      * @dev See {IERC165-supportsInterface}.
1123      */
1124     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1125         return
1126             interfaceId == type(IERC721).interfaceId ||
1127             interfaceId == type(IERC721Metadata).interfaceId ||
1128             interfaceId == type(IERC721Enumerable).interfaceId ||
1129             super.supportsInterface(interfaceId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-balanceOf}.
1134      */
1135     function balanceOf(address owner) public view override returns (uint256) {
1136         require(owner != address(0), 'ERC721A: balance query for the zero address');
1137         return uint256(_addressData[owner].balance);
1138     }
1139 
1140     function _numberMinted(address owner) internal view returns (uint256) {
1141         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1142         return uint256(_addressData[owner].numberMinted);
1143     }
1144 
1145     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1146         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1147 
1148         for (uint256 curr = tokenId; ; curr--) {
1149             TokenOwnership memory ownership = _ownerships[curr];
1150             if (ownership.addr != address(0)) {
1151                 return ownership;
1152             }
1153         }
1154 
1155         revert('ERC721A: unable to determine the owner of token');
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-ownerOf}.
1160      */
1161     function ownerOf(uint256 tokenId) public view override returns (address) {
1162         return ownershipOf(tokenId).addr;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-name}.
1167      */
1168     function name() public view virtual override returns (string memory) {
1169         return _name;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Metadata-symbol}.
1174      */
1175     function symbol() public view virtual override returns (string memory) {
1176         return _symbol;
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Metadata-tokenURI}.
1181      */
1182     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1183         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1184 
1185         string memory baseURI = _baseURI();
1186         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1187     }
1188 
1189     /**
1190      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1191      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1192      * by default, can be overriden in child contracts.
1193      */
1194     function _baseURI() internal view virtual returns (string memory) {
1195         return '';
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-approve}.
1200      */
1201     function approve(address to, uint256 tokenId) public override {
1202         address owner = ERC721A.ownerOf(tokenId);
1203         require(to != owner, 'ERC721A: approval to current owner');
1204 
1205         require(
1206             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1207             'ERC721A: approve caller is not owner nor approved for all'
1208         );
1209 
1210         _approve(to, tokenId, owner);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-getApproved}.
1215      */
1216     function getApproved(uint256 tokenId) public view override returns (address) {
1217         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1218 
1219         return _tokenApprovals[tokenId];
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-setApprovalForAll}.
1224      */
1225     function setApprovalForAll(address operator, bool approved) public override {
1226         require(operator != _msgSender(), 'ERC721A: approve to caller');
1227 
1228         _operatorApprovals[_msgSender()][operator] = approved;
1229         emit ApprovalForAll(_msgSender(), operator, approved);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-isApprovedForAll}.
1234      */
1235     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1236         return _operatorApprovals[owner][operator];
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-transferFrom}.
1241      */
1242     function transferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) public override {
1247         _transfer(from, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-safeTransferFrom}.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) public override {
1258         safeTransferFrom(from, to, tokenId, '');
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId,
1268         bytes memory _data
1269     ) public override {
1270         _transfer(from, to, tokenId);
1271         require(
1272             _checkOnERC721Received(from, to, tokenId, _data),
1273             'ERC721A: transfer to non ERC721Receiver implementer'
1274         );
1275     }
1276 
1277     /**
1278      * @dev Returns whether `tokenId` exists.
1279      *
1280      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1281      *
1282      * Tokens start existing when they are minted (`_mint`),
1283      */
1284     function _exists(uint256 tokenId) internal view returns (bool) {
1285         return tokenId < currentIndex;
1286     }
1287 
1288     function _safeMint(address to, uint256 quantity) internal {
1289         _safeMint(to, quantity, '');
1290     }
1291 
1292     /**
1293      * @dev Mints `quantity` tokens and transfers them to `to`.
1294      *
1295      * Requirements:
1296      *
1297      * - `to` cannot be the zero address.
1298      * - `quantity` cannot be larger than the max batch size.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _safeMint(
1303         address to,
1304         uint256 quantity,
1305         bytes memory _data
1306     ) internal {
1307         uint256 startTokenId = currentIndex;
1308         require(to != address(0), 'ERC721A: mint to the zero address');
1309         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1310         require(!_exists(startTokenId), 'ERC721A: token already minted');
1311         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1312 
1313         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315         AddressData memory addressData = _addressData[to];
1316         _addressData[to] = AddressData(
1317             addressData.balance + uint128(quantity),
1318             addressData.numberMinted + uint128(quantity)
1319         );
1320         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1321 
1322         uint256 updatedIndex = startTokenId;
1323 
1324         for (uint256 i = 0; i < quantity; i++) {
1325             emit Transfer(address(0), to, updatedIndex);
1326             require(
1327                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1328                 'ERC721A: transfer to non ERC721Receiver implementer'
1329             );
1330             updatedIndex++;
1331         }
1332 
1333         currentIndex = updatedIndex;
1334         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1335     }
1336 
1337     /**
1338      * @dev Transfers `tokenId` from `from` to `to`.
1339      *
1340      * Requirements:
1341      *
1342      * - `to` cannot be the zero address.
1343      * - `tokenId` token must be owned by `from`.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _transfer(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) private {
1352         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1353 
1354         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1355             getApproved(tokenId) == _msgSender() ||
1356             isApprovedForAll(prevOwnership.addr, _msgSender()));
1357 
1358         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1359 
1360         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1361         require(to != address(0), 'ERC721A: transfer to the zero address');
1362 
1363         _beforeTokenTransfers(from, to, tokenId, 1);
1364 
1365         // Clear approvals from the previous owner
1366         _approve(address(0), tokenId, prevOwnership.addr);
1367 
1368         // Underflow of the sender's balance is impossible because we check for
1369         // ownership above and the recipient's balance can't realistically overflow.
1370         unchecked {
1371             _addressData[from].balance -= 1;
1372             _addressData[to].balance += 1;
1373         }
1374 
1375         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1376 
1377         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1378         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1379         uint256 nextTokenId = tokenId + 1;
1380         if (_ownerships[nextTokenId].addr == address(0)) {
1381             if (_exists(nextTokenId)) {
1382                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1383             }
1384         }
1385 
1386         emit Transfer(from, to, tokenId);
1387         _afterTokenTransfers(from, to, tokenId, 1);
1388     }
1389 
1390     /**
1391      * @dev Approve `to` to operate on `tokenId`
1392      *
1393      * Emits a {Approval} event.
1394      */
1395     function _approve(
1396         address to,
1397         uint256 tokenId,
1398         address owner
1399     ) private {
1400         _tokenApprovals[tokenId] = to;
1401         emit Approval(owner, to, tokenId);
1402     }
1403 
1404     /**
1405      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1406      * The call is not executed if the target address is not a contract.
1407      *
1408      * @param from address representing the previous owner of the given token ID
1409      * @param to target address that will receive the tokens
1410      * @param tokenId uint256 ID of the token to be transferred
1411      * @param _data bytes optional data to send along with the call
1412      * @return bool whether the call correctly returned the expected magic value
1413      */
1414     function _checkOnERC721Received(
1415         address from,
1416         address to,
1417         uint256 tokenId,
1418         bytes memory _data
1419     ) private returns (bool) {
1420         if (to.isContract()) {
1421             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1422                 return retval == IERC721Receiver(to).onERC721Received.selector;
1423             } catch (bytes memory reason) {
1424                 if (reason.length == 0) {
1425                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1426                 } else {
1427                     assembly {
1428                         revert(add(32, reason), mload(reason))
1429                     }
1430                 }
1431             }
1432         } else {
1433             return true;
1434         }
1435     }
1436 
1437     /**
1438      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1439      *
1440      * startTokenId - the first token id to be transferred
1441      * quantity - the amount to be transferred
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` will be minted for `to`.
1448      */
1449     function _beforeTokenTransfers(
1450         address from,
1451         address to,
1452         uint256 startTokenId,
1453         uint256 quantity
1454     ) internal virtual {}
1455 
1456     /**
1457      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1458      * minting.
1459      *
1460      * startTokenId - the first token id to be transferred
1461      * quantity - the amount to be transferred
1462      *
1463      * Calling conditions:
1464      *
1465      * - when `from` and `to` are both non-zero.
1466      * - `from` and `to` are never both zero.
1467      */
1468     function _afterTokenTransfers(
1469         address from,
1470         address to,
1471         uint256 startTokenId,
1472         uint256 quantity
1473     ) internal virtual {}
1474 }
1475 // File: NFT.sol
1476 
1477 
1478 pragma solidity ^0.8.7;
1479 
1480 
1481 
1482 
1483 
1484 
1485 contract NFT is ERC721A, Ownable, ReentrancyGuard {
1486   using Counters for Counters.Counter;
1487   using SafeMath for uint256;
1488   uint256 private _mintCost;
1489   uint256 private _maxSupply;
1490   bool private _isPublicMintEnabled;
1491   uint256 private _freeSupply;
1492   uint256 private _freeMintLimit;
1493   
1494   /**
1495   * @dev Initializes the contract setting the `tokenName` and `symbol` of the nft, `cost` of each mint call, and maximum `supply` of the nft.
1496   * Note: `cost` is in wei. 
1497   */
1498   constructor(string memory tokenName, string memory symbol, uint256 cost, uint256 supply) ERC721A(tokenName, symbol) Ownable() {
1499     _mintCost = cost;
1500     _maxSupply = supply;
1501     _isPublicMintEnabled = false;
1502     _freeSupply = 0;
1503     _freeMintLimit = 1;
1504   }
1505 
1506   /**
1507   * @dev Changes contract state to enable public access to `mintTokens` function
1508   * Can only be called by the current owner.
1509   */
1510   function allowPublicMint()
1511   public
1512   onlyOwner{
1513     _isPublicMintEnabled = true;
1514   }
1515 
1516   /**
1517   * @dev Changes contract state to disable public access to `mintTokens` function
1518   * Can only be called by the current owner.
1519   */
1520   function denyPublicMint()
1521   public
1522   onlyOwner{
1523     _isPublicMintEnabled = false;
1524   }
1525 
1526   /**
1527   * @dev Mint `count` tokens if requirements are satisfied.
1528   * 
1529   */
1530   function mintTokens(uint256 count)
1531   public
1532   payable
1533   nonReentrant{
1534     require(_isPublicMintEnabled, "Mint disabled");
1535     require(count > 0 && count <= 100, "You can drop minimum 1, maximum 100 NFTs");
1536     require(count.add(totalSupply()) <= _maxSupply, "Exceeds max supply");
1537     require(owner() == msg.sender || msg.value >= _mintCost.mul(count),
1538            "Ether value sent is below the price");
1539     
1540     _mint(msg.sender, count);
1541   }
1542 
1543   /**
1544   * @dev Mint a token to each Address of `recipients`.
1545   * Can only be called if requirements are satisfied.
1546   */
1547   function mintTokens(address[] calldata recipients)
1548   public
1549   payable
1550   nonReentrant{
1551     require(recipients.length>0,"Missing recipient addresses");
1552     require(owner() == msg.sender || _isPublicMintEnabled, "Mint disabled");
1553     require(recipients.length > 0 && recipients.length <= 100, "You can drop minimum 1, maximum 100 NFTs");
1554     require(recipients.length.add(totalSupply()) <= _maxSupply, "Exceeds max supply");
1555     require(owner() == msg.sender || msg.value >= _mintCost.mul(recipients.length),
1556            "Ether value sent is below the price");
1557     for(uint i=0; i<recipients.length; i++){
1558         _mint(recipients[i], 1);
1559      }
1560   }
1561 
1562   /**
1563   * @dev Mint `count` tokens if requirements are satisfied.
1564   */
1565   function freeMint(uint256 count) 
1566   public 
1567   payable 
1568   nonReentrant{
1569     require(owner() == msg.sender || _isPublicMintEnabled, "Mint disabled");
1570     require(totalSupply() + count <= _freeSupply, "Exceed max free supply");
1571     require(count <= _freeMintLimit, "Cant mint more than mint limit");
1572     require(count > 0, "Must mint at least 1 token");
1573 
1574     _safeMint(msg.sender, count);
1575   }
1576 
1577   /**
1578   * @dev Update the cost to mint a token.
1579   * Can only be called by the current owner.
1580   */
1581   function setCost(uint256 cost) public onlyOwner{
1582     _mintCost = cost;
1583   }
1584 
1585   /**
1586   * @dev Update the max supply.
1587   * Can only be called by the current owner.
1588   */
1589   function setMaxSupply(uint256 max) public onlyOwner{
1590     _maxSupply = max;
1591   }
1592 
1593   /**
1594   * @dev Update the max free supply.
1595   * Can only be called by the current owner.
1596   */
1597   function setFreeSupply(uint256 max) public onlyOwner{
1598     _freeSupply = max;
1599   }
1600   /**
1601   * @dev Update the free mint transaction limit.
1602   * Can only be called by the current owner.
1603   */
1604   function setFreeMintLimit(uint256 max) public onlyOwner{
1605     _freeMintLimit = max;
1606   }
1607 
1608   /**
1609   * @dev Transfers contract balance to contract owner.
1610   * Can only be called by the current owner.
1611   */
1612   function withdraw() public onlyOwner{
1613     payable(owner()).transfer(address(this).balance);
1614   }
1615 
1616   /**
1617   * @dev Used by public mint functions and by owner functions.
1618   * Can only be called internally by other functions.
1619   */
1620   function _mint(address to, uint256 count) internal virtual returns (uint256){
1621     _safeMint(to, count);
1622 
1623     return count;
1624   }
1625 
1626   function getState() public view returns (bool, uint256, uint256, uint256, uint256, uint256){
1627     return (_isPublicMintEnabled, _mintCost, _maxSupply, totalSupply(), _freeSupply, _freeMintLimit);
1628   }
1629   function getCost() public view returns (uint256){
1630     return _mintCost;
1631   }
1632   function getMaxSupply() public view returns (uint256){
1633     return _maxSupply;
1634   }
1635   function getCurrentSupply() public view returns (uint256){
1636     return totalSupply();
1637   }
1638   function getMintStatus() public view returns (bool) {
1639     return _isPublicMintEnabled;
1640   }
1641   function getFreeSupply() public view returns (uint256) {
1642     return _freeSupply;
1643   }
1644   function getFreeMintLimit() public view returns (uint256) {
1645     return _freeMintLimit;
1646   }
1647   function _baseURI() override internal pure returns (string memory) {
1648     return "https://mw9spidhbc.execute-api.us-east-1.amazonaws.com/dev/token/women-of-pixel/";
1649   }
1650   function contractURI() public pure returns (string memory) {
1651     return "https://mw9spidhbc.execute-api.us-east-1.amazonaws.com/dev/contract/women-of-pixel";
1652   }
1653 }