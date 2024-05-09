1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 // CAUTION
76 // This version of SafeMath should only be used with Solidity 0.8 or later,
77 // because it relies on the compiler's built in overflow checks.
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations.
81  *
82  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
83  * now has built in overflow checking.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, with an overflow flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             uint256 c = a + b;
94             if (c < a) return (false, 0);
95             return (true, c);
96         }
97     }
98 
99     /**
100      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
101      *
102      * _Available since v3.4._
103      */
104     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b > a) return (false, 0);
107             return (true, a - b);
108         }
109     }
110 
111     /**
112      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119             // benefit is lost if 'b' is also tested.
120             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
121             if (a == 0) return (true, 0);
122             uint256 c = a * b;
123             if (c / a != b) return (false, 0);
124             return (true, c);
125         }
126     }
127 
128     /**
129      * @dev Returns the division of two unsigned integers, with a division by zero flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             if (b == 0) return (false, 0);
136             return (true, a / b);
137         }
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b == 0) return (false, 0);
148             return (true, a % b);
149         }
150     }
151 
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      *
160      * - Addition cannot overflow.
161      */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a + b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a - b;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a * b;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers, reverting on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator.
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a / b;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a % b;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
226      * overflow (when the result is negative).
227      *
228      * CAUTION: This function is deprecated because it requires allocating memory for the error
229      * message unnecessarily. For custom revert reasons use {trySub}.
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(
238         uint256 a,
239         uint256 b,
240         string memory errorMessage
241     ) internal pure returns (uint256) {
242         unchecked {
243             require(b <= a, errorMessage);
244             return a - b;
245         }
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(
261         uint256 a,
262         uint256 b,
263         string memory errorMessage
264     ) internal pure returns (uint256) {
265         unchecked {
266             require(b > 0, errorMessage);
267             return a / b;
268         }
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * reverting with custom message when dividing by zero.
274      *
275      * CAUTION: This function is deprecated because it requires allocating memory for the error
276      * message unnecessarily. For custom revert reasons use {tryMod}.
277      *
278      * Counterpart to Solidity's `%` operator. This function uses a `revert`
279      * opcode (which leaves remaining gas untouched) while Solidity uses an
280      * invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function mod(
287         uint256 a,
288         uint256 b,
289         string memory errorMessage
290     ) internal pure returns (uint256) {
291         unchecked {
292             require(b > 0, errorMessage);
293             return a % b;
294         }
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Counters.sol
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title Counters
307  * @author Matt Condon (@shrugs)
308  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
309  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
310  *
311  * Include with `using Counters for Counters.Counter;`
312  */
313 library Counters {
314     struct Counter {
315         // This variable should never be directly accessed by users of the library: interactions must be restricted to
316         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
317         // this feature: see https://github.com/ethereum/solidity/issues/4637
318         uint256 _value; // default: 0
319     }
320 
321     function current(Counter storage counter) internal view returns (uint256) {
322         return counter._value;
323     }
324 
325     function increment(Counter storage counter) internal {
326         unchecked {
327             counter._value += 1;
328         }
329     }
330 
331     function decrement(Counter storage counter) internal {
332         uint256 value = counter._value;
333         require(value > 0, "Counter: decrement overflow");
334         unchecked {
335             counter._value = value - 1;
336         }
337     }
338 
339     function reset(Counter storage counter) internal {
340         counter._value = 0;
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Strings.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev String operations.
353  */
354 library Strings {
355     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
356 
357     /**
358      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
359      */
360     function toString(uint256 value) internal pure returns (string memory) {
361         // Inspired by OraclizeAPI's implementation - MIT licence
362         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
363 
364         if (value == 0) {
365             return "0";
366         }
367         uint256 temp = value;
368         uint256 digits;
369         while (temp != 0) {
370             digits++;
371             temp /= 10;
372         }
373         bytes memory buffer = new bytes(digits);
374         while (value != 0) {
375             digits -= 1;
376             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
377             value /= 10;
378         }
379         return string(buffer);
380     }
381 
382     /**
383      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
384      */
385     function toHexString(uint256 value) internal pure returns (string memory) {
386         if (value == 0) {
387             return "0x00";
388         }
389         uint256 temp = value;
390         uint256 length = 0;
391         while (temp != 0) {
392             length++;
393             temp >>= 8;
394         }
395         return toHexString(value, length);
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _HEX_SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 }
413 
414 // File: @openzeppelin/contracts/utils/Context.sol
415 
416 
417 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 /**
422  * @dev Provides information about the current execution context, including the
423  * sender of the transaction and its data. While these are generally available
424  * via msg.sender and msg.data, they should not be accessed in such a direct
425  * manner, since when dealing with meta-transactions the account sending and
426  * paying for execution may not be the actual sender (as far as an application
427  * is concerned).
428  *
429  * This contract is only required for intermediate, library-like contracts.
430  */
431 abstract contract Context {
432     function _msgSender() internal view virtual returns (address) {
433         return msg.sender;
434     }
435 
436     function _msgData() internal view virtual returns (bytes calldata) {
437         return msg.data;
438     }
439 }
440 
441 // File: @openzeppelin/contracts/access/Ownable.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 
449 /**
450  * @dev Contract module which provides a basic access control mechanism, where
451  * there is an account (an owner) that can be granted exclusive access to
452  * specific functions.
453  *
454  * By default, the owner account will be the one that deploys the contract. This
455  * can later be changed with {transferOwnership}.
456  *
457  * This module is used through inheritance. It will make available the modifier
458  * `onlyOwner`, which can be applied to your functions to restrict their use to
459  * the owner.
460  */
461 abstract contract Ownable is Context {
462     address private _owner;
463 
464     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
465 
466     /**
467      * @dev Initializes the contract setting the deployer as the initial owner.
468      */
469     constructor() {
470         _transferOwnership(_msgSender());
471     }
472 
473     /**
474      * @dev Returns the address of the current owner.
475      */
476     function owner() public view virtual returns (address) {
477         return _owner;
478     }
479 
480     /**
481      * @dev Throws if called by any account other than the owner.
482      */
483     modifier onlyOwner() {
484         require(owner() == _msgSender(), "Ownable: caller is not the owner");
485         _;
486     }
487 
488     /**
489      * @dev Leaves the contract without owner. It will not be possible to call
490      * `onlyOwner` functions anymore. Can only be called by the current owner.
491      *
492      * NOTE: Renouncing ownership will leave the contract without an owner,
493      * thereby removing any functionality that is only available to the owner.
494      */
495     function renounceOwnership() public virtual onlyOwner {
496         _transferOwnership(address(0));
497     }
498 
499     /**
500      * @dev Transfers ownership of the contract to a new account (`newOwner`).
501      * Can only be called by the current owner.
502      */
503     function transferOwnership(address newOwner) public virtual onlyOwner {
504         require(newOwner != address(0), "Ownable: new owner is the zero address");
505         _transferOwnership(newOwner);
506     }
507 
508     /**
509      * @dev Transfers ownership of the contract to a new account (`newOwner`).
510      * Internal function without access restriction.
511      */
512     function _transferOwnership(address newOwner) internal virtual {
513         address oldOwner = _owner;
514         _owner = newOwner;
515         emit OwnershipTransferred(oldOwner, newOwner);
516     }
517 }
518 
519 // File: @openzeppelin/contracts/utils/Address.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Collection of functions related to the address type
528  */
529 library Address {
530     /**
531      * @dev Returns true if `account` is a contract.
532      *
533      * [IMPORTANT]
534      * ====
535      * It is unsafe to assume that an address for which this function returns
536      * false is an externally-owned account (EOA) and not a contract.
537      *
538      * Among others, `isContract` will return false for the following
539      * types of addresses:
540      *
541      *  - an externally-owned account
542      *  - a contract in construction
543      *  - an address where a contract will be created
544      *  - an address where a contract lived, but was destroyed
545      * ====
546      */
547     function isContract(address account) internal view returns (bool) {
548         // This method relies on extcodesize, which returns 0 for contracts in
549         // construction, since the code is only stored at the end of the
550         // constructor execution.
551 
552         uint256 size;
553         assembly {
554             size := extcodesize(account)
555         }
556         return size > 0;
557     }
558 
559     /**
560      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
561      * `recipient`, forwarding all available gas and reverting on errors.
562      *
563      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
564      * of certain opcodes, possibly making contracts go over the 2300 gas limit
565      * imposed by `transfer`, making them unable to receive funds via
566      * `transfer`. {sendValue} removes this limitation.
567      *
568      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
569      *
570      * IMPORTANT: because control is transferred to `recipient`, care must be
571      * taken to not create reentrancy vulnerabilities. Consider using
572      * {ReentrancyGuard} or the
573      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
574      */
575     function sendValue(address payable recipient, uint256 amount) internal {
576         require(address(this).balance >= amount, "Address: insufficient balance");
577 
578         (bool success, ) = recipient.call{value: amount}("");
579         require(success, "Address: unable to send value, recipient may have reverted");
580     }
581 
582     /**
583      * @dev Performs a Solidity function call using a low level `call`. A
584      * plain `call` is an unsafe replacement for a function call: use this
585      * function instead.
586      *
587      * If `target` reverts with a revert reason, it is bubbled up by this
588      * function (like regular Solidity function calls).
589      *
590      * Returns the raw returned data. To convert to the expected return value,
591      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
592      *
593      * Requirements:
594      *
595      * - `target` must be a contract.
596      * - calling `target` with `data` must not revert.
597      *
598      * _Available since v3.1._
599      */
600     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
601         return functionCall(target, data, "Address: low-level call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
606      * `errorMessage` as a fallback revert reason when `target` reverts.
607      *
608      * _Available since v3.1._
609      */
610     function functionCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal returns (bytes memory) {
615         return functionCallWithValue(target, data, 0, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but also transferring `value` wei to `target`.
621      *
622      * Requirements:
623      *
624      * - the calling contract must have an ETH balance of at least `value`.
625      * - the called Solidity function must be `payable`.
626      *
627      * _Available since v3.1._
628      */
629     function functionCallWithValue(
630         address target,
631         bytes memory data,
632         uint256 value
633     ) internal returns (bytes memory) {
634         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
639      * with `errorMessage` as a fallback revert reason when `target` reverts.
640      *
641      * _Available since v3.1._
642      */
643     function functionCallWithValue(
644         address target,
645         bytes memory data,
646         uint256 value,
647         string memory errorMessage
648     ) internal returns (bytes memory) {
649         require(address(this).balance >= value, "Address: insufficient balance for call");
650         require(isContract(target), "Address: call to non-contract");
651 
652         (bool success, bytes memory returndata) = target.call{value: value}(data);
653         return verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a static call.
659      *
660      * _Available since v3.3._
661      */
662     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
663         return functionStaticCall(target, data, "Address: low-level static call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a static call.
669      *
670      * _Available since v3.3._
671      */
672     function functionStaticCall(
673         address target,
674         bytes memory data,
675         string memory errorMessage
676     ) internal view returns (bytes memory) {
677         require(isContract(target), "Address: static call to non-contract");
678 
679         (bool success, bytes memory returndata) = target.staticcall(data);
680         return verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
690         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
695      * but performing a delegate call.
696      *
697      * _Available since v3.4._
698      */
699     function functionDelegateCall(
700         address target,
701         bytes memory data,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         require(isContract(target), "Address: delegate call to non-contract");
705 
706         (bool success, bytes memory returndata) = target.delegatecall(data);
707         return verifyCallResult(success, returndata, errorMessage);
708     }
709 
710     /**
711      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
712      * revert reason using the provided one.
713      *
714      * _Available since v4.3._
715      */
716     function verifyCallResult(
717         bool success,
718         bytes memory returndata,
719         string memory errorMessage
720     ) internal pure returns (bytes memory) {
721         if (success) {
722             return returndata;
723         } else {
724             // Look for revert reason and bubble it up if present
725             if (returndata.length > 0) {
726                 // The easiest way to bubble the revert reason is using memory via assembly
727 
728                 assembly {
729                     let returndata_size := mload(returndata)
730                     revert(add(32, returndata), returndata_size)
731                 }
732             } else {
733                 revert(errorMessage);
734             }
735         }
736     }
737 }
738 
739 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
740 
741 
742 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 /**
747  * @title ERC721 token receiver interface
748  * @dev Interface for any contract that wants to support safeTransfers
749  * from ERC721 asset contracts.
750  */
751 interface IERC721Receiver {
752     /**
753      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
754      * by `operator` from `from`, this function is called.
755      *
756      * It must return its Solidity selector to confirm the token transfer.
757      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
758      *
759      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
760      */
761     function onERC721Received(
762         address operator,
763         address from,
764         uint256 tokenId,
765         bytes calldata data
766     ) external returns (bytes4);
767 }
768 
769 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 /**
777  * @dev Interface of the ERC165 standard, as defined in the
778  * https://eips.ethereum.org/EIPS/eip-165[EIP].
779  *
780  * Implementers can declare support of contract interfaces, which can then be
781  * queried by others ({ERC165Checker}).
782  *
783  * For an implementation, see {ERC165}.
784  */
785 interface IERC165 {
786     /**
787      * @dev Returns true if this contract implements the interface defined by
788      * `interfaceId`. See the corresponding
789      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
790      * to learn more about how these ids are created.
791      *
792      * This function call must use less than 30 000 gas.
793      */
794     function supportsInterface(bytes4 interfaceId) external view returns (bool);
795 }
796 
797 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
798 
799 
800 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
801 
802 pragma solidity ^0.8.0;
803 
804 
805 /**
806  * @dev Implementation of the {IERC165} interface.
807  *
808  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
809  * for the additional interface id that will be supported. For example:
810  *
811  * ```solidity
812  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
813  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
814  * }
815  * ```
816  *
817  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
818  */
819 abstract contract ERC165 is IERC165 {
820     /**
821      * @dev See {IERC165-supportsInterface}.
822      */
823     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
824         return interfaceId == type(IERC165).interfaceId;
825     }
826 }
827 
828 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
829 
830 
831 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 
836 /**
837  * @dev Required interface of an ERC721 compliant contract.
838  */
839 interface IERC721 is IERC165 {
840     /**
841      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
842      */
843     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
844 
845     /**
846      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
847      */
848     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
849 
850     /**
851      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
852      */
853     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
854 
855     /**
856      * @dev Returns the number of tokens in ``owner``'s account.
857      */
858     function balanceOf(address owner) external view returns (uint256 balance);
859 
860     /**
861      * @dev Returns the owner of the `tokenId` token.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      */
867     function ownerOf(uint256 tokenId) external view returns (address owner);
868 
869     /**
870      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
871      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must exist and be owned by `from`.
878      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId
887     ) external;
888 
889     /**
890      * @dev Transfers `tokenId` token from `from` to `to`.
891      *
892      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
900      *
901      * Emits a {Transfer} event.
902      */
903     function transferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) external;
908 
909     /**
910      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
911      * The approval is cleared when the token is transferred.
912      *
913      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
914      *
915      * Requirements:
916      *
917      * - The caller must own the token or be an approved operator.
918      * - `tokenId` must exist.
919      *
920      * Emits an {Approval} event.
921      */
922     function approve(address to, uint256 tokenId) external;
923 
924     /**
925      * @dev Returns the account approved for `tokenId` token.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      */
931     function getApproved(uint256 tokenId) external view returns (address operator);
932 
933     /**
934      * @dev Approve or remove `operator` as an operator for the caller.
935      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
936      *
937      * Requirements:
938      *
939      * - The `operator` cannot be the caller.
940      *
941      * Emits an {ApprovalForAll} event.
942      */
943     function setApprovalForAll(address operator, bool _approved) external;
944 
945     /**
946      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
947      *
948      * See {setApprovalForAll}
949      */
950     function isApprovedForAll(address owner, address operator) external view returns (bool);
951 
952     /**
953      * @dev Safely transfers `tokenId` token from `from` to `to`.
954      *
955      * Requirements:
956      *
957      * - `from` cannot be the zero address.
958      * - `to` cannot be the zero address.
959      * - `tokenId` token must exist and be owned by `from`.
960      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes calldata data
970     ) external;
971 }
972 
973 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
974 
975 
976 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
977 
978 pragma solidity ^0.8.0;
979 
980 
981 /**
982  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
983  * @dev See https://eips.ethereum.org/EIPS/eip-721
984  */
985 interface IERC721Metadata is IERC721 {
986     /**
987      * @dev Returns the token collection name.
988      */
989     function name() external view returns (string memory);
990 
991     /**
992      * @dev Returns the token collection symbol.
993      */
994     function symbol() external view returns (string memory);
995 
996     /**
997      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
998      */
999     function tokenURI(uint256 tokenId) external view returns (string memory);
1000 }
1001 
1002 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1003 
1004 
1005 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 
1010 
1011 
1012 
1013 
1014 
1015 
1016 /**
1017  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1018  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1019  * {ERC721Enumerable}.
1020  */
1021 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1022     using Address for address;
1023     using Strings for uint256;
1024 
1025     // Token name
1026     string private _name;
1027 
1028     // Token symbol
1029     string private _symbol;
1030 
1031     // Mapping from token ID to owner address
1032     mapping(uint256 => address) private _owners;
1033 
1034     // Mapping owner address to token count
1035     mapping(address => uint256) private _balances;
1036 
1037     // Mapping from token ID to approved address
1038     mapping(uint256 => address) private _tokenApprovals;
1039 
1040     // Mapping from owner to operator approvals
1041     mapping(address => mapping(address => bool)) private _operatorApprovals;
1042 
1043     /**
1044      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1045      */
1046     constructor(string memory name_, string memory symbol_) {
1047         _name = name_;
1048         _symbol = symbol_;
1049     }
1050 
1051     /**
1052      * @dev See {IERC165-supportsInterface}.
1053      */
1054     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1055         return
1056             interfaceId == type(IERC721).interfaceId ||
1057             interfaceId == type(IERC721Metadata).interfaceId ||
1058             super.supportsInterface(interfaceId);
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-balanceOf}.
1063      */
1064     function balanceOf(address owner) public view virtual override returns (uint256) {
1065         require(owner != address(0), "ERC721: balance query for the zero address");
1066         return _balances[owner];
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-ownerOf}.
1071      */
1072     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1073         address owner = _owners[tokenId];
1074         require(owner != address(0), "ERC721: owner query for nonexistent token");
1075         return owner;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-name}.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-symbol}.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-tokenURI}.
1094      */
1095     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1096         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1097 
1098         string memory baseURI = _baseURI();
1099         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1100     }
1101 
1102     /**
1103      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1104      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1105      * by default, can be overriden in child contracts.
1106      */
1107     function _baseURI() internal view virtual returns (string memory) {
1108         return "";
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-approve}.
1113      */
1114     function approve(address to, uint256 tokenId) public virtual override {
1115         address owner = ERC721.ownerOf(tokenId);
1116         require(to != owner, "ERC721: approval to current owner");
1117 
1118         require(
1119             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1120             "ERC721: approve caller is not owner nor approved for all"
1121         );
1122 
1123         _approve(to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-getApproved}.
1128      */
1129     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1130         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1131 
1132         return _tokenApprovals[tokenId];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-setApprovalForAll}.
1137      */
1138     function setApprovalForAll(address operator, bool approved) public virtual override {
1139         _setApprovalForAll(_msgSender(), operator, approved);
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-isApprovedForAll}.
1144      */
1145     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1146         return _operatorApprovals[owner][operator];
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-transferFrom}.
1151      */
1152     function transferFrom(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) public virtual override {
1157         //solhint-disable-next-line max-line-length
1158         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1159 
1160         _transfer(from, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-safeTransferFrom}.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) public virtual override {
1171         safeTransferFrom(from, to, tokenId, "");
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-safeTransferFrom}.
1176      */
1177     function safeTransferFrom(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) public virtual override {
1183         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1184         _safeTransfer(from, to, tokenId, _data);
1185     }
1186 
1187     /**
1188      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1189      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1190      *
1191      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1192      *
1193      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1194      * implement alternative mechanisms to perform token transfer, such as signature-based.
1195      *
1196      * Requirements:
1197      *
1198      * - `from` cannot be the zero address.
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must exist and be owned by `from`.
1201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _safeTransfer(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) internal virtual {
1211         _transfer(from, to, tokenId);
1212         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1213     }
1214 
1215     /**
1216      * @dev Returns whether `tokenId` exists.
1217      *
1218      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1219      *
1220      * Tokens start existing when they are minted (`_mint`),
1221      * and stop existing when they are burned (`_burn`).
1222      */
1223     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1224         return _owners[tokenId] != address(0);
1225     }
1226 
1227     /**
1228      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      */
1234     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1235         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1236         address owner = ERC721.ownerOf(tokenId);
1237         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1238     }
1239 
1240     /**
1241      * @dev Safely mints `tokenId` and transfers it to `to`.
1242      *
1243      * Requirements:
1244      *
1245      * - `tokenId` must not exist.
1246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _safeMint(address to, uint256 tokenId) internal virtual {
1251         _safeMint(to, tokenId, "");
1252     }
1253 
1254     /**
1255      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1256      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1257      */
1258     function _safeMint(
1259         address to,
1260         uint256 tokenId,
1261         bytes memory _data
1262     ) internal virtual {
1263         _mint(to, tokenId);
1264         require(
1265             _checkOnERC721Received(address(0), to, tokenId, _data),
1266             "ERC721: transfer to non ERC721Receiver implementer"
1267         );
1268     }
1269 
1270     /**
1271      * @dev Mints `tokenId` and transfers it to `to`.
1272      *
1273      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must not exist.
1278      * - `to` cannot be the zero address.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _mint(address to, uint256 tokenId) internal virtual {
1283         require(to != address(0), "ERC721: mint to the zero address");
1284         require(!_exists(tokenId), "ERC721: token already minted");
1285 
1286         _beforeTokenTransfer(address(0), to, tokenId);
1287 
1288         _balances[to] += 1;
1289         _owners[tokenId] = to;
1290 
1291         emit Transfer(address(0), to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Destroys `tokenId`.
1296      * The approval is cleared when the token is burned.
1297      *
1298      * Requirements:
1299      *
1300      * - `tokenId` must exist.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _burn(uint256 tokenId) internal virtual {
1305         address owner = ERC721.ownerOf(tokenId);
1306 
1307         _beforeTokenTransfer(owner, address(0), tokenId);
1308 
1309         // Clear approvals
1310         _approve(address(0), tokenId);
1311 
1312         _balances[owner] -= 1;
1313         delete _owners[tokenId];
1314 
1315         emit Transfer(owner, address(0), tokenId);
1316     }
1317 
1318     /**
1319      * @dev Transfers `tokenId` from `from` to `to`.
1320      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1321      *
1322      * Requirements:
1323      *
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must be owned by `from`.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _transfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual {
1334         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1335         require(to != address(0), "ERC721: transfer to the zero address");
1336 
1337         _beforeTokenTransfer(from, to, tokenId);
1338 
1339         // Clear approvals from the previous owner
1340         _approve(address(0), tokenId);
1341 
1342         _balances[from] -= 1;
1343         _balances[to] += 1;
1344         _owners[tokenId] = to;
1345 
1346         emit Transfer(from, to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev Approve `to` to operate on `tokenId`
1351      *
1352      * Emits a {Approval} event.
1353      */
1354     function _approve(address to, uint256 tokenId) internal virtual {
1355         _tokenApprovals[tokenId] = to;
1356         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1357     }
1358 
1359     /**
1360      * @dev Approve `operator` to operate on all of `owner` tokens
1361      *
1362      * Emits a {ApprovalForAll} event.
1363      */
1364     function _setApprovalForAll(
1365         address owner,
1366         address operator,
1367         bool approved
1368     ) internal virtual {
1369         require(owner != operator, "ERC721: approve to caller");
1370         _operatorApprovals[owner][operator] = approved;
1371         emit ApprovalForAll(owner, operator, approved);
1372     }
1373 
1374     /**
1375      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1376      * The call is not executed if the target address is not a contract.
1377      *
1378      * @param from address representing the previous owner of the given token ID
1379      * @param to target address that will receive the tokens
1380      * @param tokenId uint256 ID of the token to be transferred
1381      * @param _data bytes optional data to send along with the call
1382      * @return bool whether the call correctly returned the expected magic value
1383      */
1384     function _checkOnERC721Received(
1385         address from,
1386         address to,
1387         uint256 tokenId,
1388         bytes memory _data
1389     ) private returns (bool) {
1390         if (to.isContract()) {
1391             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1392                 return retval == IERC721Receiver.onERC721Received.selector;
1393             } catch (bytes memory reason) {
1394                 if (reason.length == 0) {
1395                     revert("ERC721: transfer to non ERC721Receiver implementer");
1396                 } else {
1397                     assembly {
1398                         revert(add(32, reason), mload(reason))
1399                     }
1400                 }
1401             }
1402         } else {
1403             return true;
1404         }
1405     }
1406 
1407     /**
1408      * @dev Hook that is called before any token transfer. This includes minting
1409      * and burning.
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` will be minted for `to`.
1416      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1417      * - `from` and `to` are never both zero.
1418      *
1419      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1420      */
1421     function _beforeTokenTransfer(
1422         address from,
1423         address to,
1424         uint256 tokenId
1425     ) internal virtual {}
1426 }
1427 
1428 // File: contracts/3_Ballot.sol
1429 
1430 
1431 
1432 pragma solidity ^0.8.0;
1433 
1434 
1435 
1436 
1437 
1438 
1439 
1440 contract OwnableDelegateProxy {}
1441 
1442 /**
1443  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1444  */
1445 contract ProxyRegistry {
1446   mapping(address => OwnableDelegateProxy) public proxies;
1447 }
1448 
1449 contract BabybadCollection is ERC721, Ownable, ReentrancyGuard {
1450   using Strings for uint256;
1451   using SafeMath for uint256;
1452   using Counters for Counters.Counter;
1453 
1454   Counters.Counter private _nextTokenId;
1455   address proxyRegistryAddress;
1456 
1457   string public baseURI;
1458   string public baseExtension = ".json";
1459 
1460   bool public paused = false;
1461   bool public whitelistPaused = false;
1462 
1463   uint256 public MAX_SUPPLY = 10000;
1464 
1465   uint256 public MAX_PER_MINT = 20;  
1466 
1467   uint256 public WHITELIST_MAX_PER_MINT = 1;  
1468 
1469   uint256 public PRICE = 0.04 ether; // ../
1470 
1471   uint256 public WHITELIST_PRICE = 0.03 ether; // 30000000000000000
1472 
1473   uint256 public WHITELIST_LIMIT = 500;
1474 
1475   mapping(address => bool) private _whitelist;
1476 
1477   constructor(
1478     string memory _name,
1479     string memory _symbol,
1480     string memory _initBaseURI,
1481     address _proxyRegistryAddress
1482   ) ERC721(_name, _symbol) {
1483     proxyRegistryAddress = _proxyRegistryAddress;
1484     // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
1485     _nextTokenId.increment();
1486     setBaseURI(_initBaseURI);
1487   }
1488 
1489   function _baseURI() internal view virtual override returns (string memory) {
1490     return baseURI;
1491   }
1492 
1493   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1494     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1495 
1496     string memory currentBaseURI = _baseURI();
1497     return bytes(currentBaseURI).length > 0
1498         ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), baseExtension))
1499         : "";
1500   }
1501 
1502   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1503     baseURI = _newBaseURI;
1504   }
1505 
1506   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1507     baseExtension = _newBaseExtension;
1508   }
1509 
1510   function mint(address _to, uint256 _mintAmount) public payable nonReentrant {
1511     if (whitelistPaused) {
1512       require(!paused, "Sale is not active");
1513     }
1514     require(_mintAmount > 0, "Mininum buy 1");
1515 
1516     uint256 supply = totalSupply();
1517     require(supply + _mintAmount <= MAX_SUPPLY, "Could not exceed the max supply");
1518 
1519     require(_mintAmount <= MAX_PER_MINT, "Exceeds max quantity in one transaction");
1520     if (msg.sender != owner()) {
1521       if (!whitelistPaused) 
1522       {
1523         require(_mintAmount <= WHITELIST_MAX_PER_MINT, "Out of limit");
1524         require(supply + _mintAmount <= WHITELIST_LIMIT, "Out of limit");
1525         require(msg.value >= WHITELIST_PRICE * _mintAmount, "Ether value sent is not correct");
1526         require(_whitelist[_to], "Address not in the whitelist");
1527 
1528         _whitelist[_to] = false;
1529       } 
1530       else 
1531       {
1532         require(msg.value >= PRICE * _mintAmount, "Ether value sent is not correct");
1533       }
1534     }
1535 
1536     for (uint256 i = 1; i <= _mintAmount; i++) {
1537       _safeMint(_to, _nextTokenId.current());
1538       _nextTokenId.increment();
1539     }
1540   }
1541 
1542   function airdropMint(address[] calldata _addresses, uint[] calldata _mintAmounts) public payable nonReentrant onlyOwner {
1543     require(_addresses.length == _mintAmounts.length,  "Size not same");
1544     uint256 supply = totalSupply();
1545 
1546     for (uint256 i = 0; i < _addresses.length; i++) {
1547 
1548       require(_mintAmounts[i] > 0, "Mininum buy 1");
1549       require(supply + _mintAmounts[i] <= WHITELIST_LIMIT, "Out of limit");
1550       require(supply + _mintAmounts[i] <= MAX_SUPPLY, "Could not exceed the max supply");
1551 
1552       for (uint256 j = 0; j < _mintAmounts[i]; j++) {
1553         _safeMint(_addresses[i], _nextTokenId.current());
1554         _nextTokenId.increment();
1555       }
1556     }
1557   }
1558 
1559   function isOnWhitelist(address _addr) external view returns (bool) {
1560     return _whitelist[_addr];
1561   }  
1562 
1563   function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
1564     for (uint256 i = 0; i < _tokenIds.length; i++) {
1565       transferFrom(_from, _to, _tokenIds[i]);
1566     }
1567   }
1568 
1569   function batchSafeTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory data_) public {
1570     for (uint256 i = 0; i < _tokenIds.length; i++) {
1571       safeTransferFrom(_from, _to, _tokenIds[i], data_);
1572     }
1573   }
1574 
1575   function addToWhitelist(address[] calldata _addresses) external onlyOwner {
1576     for (uint256 i = 0; i < _addresses.length; i++) {
1577       require(_addresses[i] != address(0), "Cannot add the null address");
1578       _whitelist[_addresses[i]] = true;
1579     }
1580   }
1581 
1582   function removeFromWhitelist(address[] calldata _addresses) external onlyOwner {
1583     for (uint256 i = 0; i < _addresses.length; i++) {
1584       require(_addresses[i] != address(0), "Cannot add the null address");
1585       _whitelist[_addresses[i]] = false;
1586     }
1587   }
1588 
1589   function setCost(uint256 _newCost) public onlyOwner {
1590     require(_newCost > 0, "Minimum 0");
1591     PRICE = _newCost;
1592   }
1593 
1594   function setWhitelistCost(uint256 _newCost) public onlyOwner {
1595     require(_newCost > 0, "Minimum 0");
1596     WHITELIST_PRICE = _newCost;
1597   }
1598 
1599   function setMaxPerMintAmount(uint256 _newAmount) public onlyOwner {
1600     MAX_PER_MINT = _newAmount;
1601   }
1602 
1603   function setWhitelistMaxPerMintAmount(uint256 _newAmount) public onlyOwner {
1604     WHITELIST_MAX_PER_MINT = _newAmount;
1605   }
1606 
1607   function setMaxSupply(uint256 _newAmount) public onlyOwner {
1608     MAX_SUPPLY = _newAmount;
1609   }
1610 
1611   function setWhitelistLimit(uint256 _newAmount) public onlyOwner {
1612     WHITELIST_LIMIT = _newAmount;
1613   }
1614 
1615   function pause(bool _state) public onlyOwner {
1616     paused = _state;
1617   }
1618 
1619   function presalePause(bool _state) public onlyOwner {
1620     whitelistPaused = _state;
1621   }
1622 
1623   function totalSupply() public view returns (uint256) {
1624     return _nextTokenId.current() - 1;
1625   }
1626     
1627   function isApprovedForAll(address owner, address operator) override public view returns (bool) {
1628     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1629     if (address(proxyRegistry.proxies(owner)) == operator) {
1630       return true;
1631     }
1632 
1633     return super.isApprovedForAll(owner, operator);
1634   }
1635 
1636   function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1637     proxyRegistryAddress = _proxyRegistryAddress;
1638   }
1639  
1640   function withdraw() public payable onlyOwner {
1641     require(payable(msg.sender).send(address(this).balance));
1642   }
1643 }