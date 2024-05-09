1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 // CAUTION
7 // This version of SafeMath should only be used with Solidity 0.8 or later,
8 // because it relies on the compiler's built in overflow checks.
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations.
12  *
13  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
14  * now has built in overflow checking.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, with an overflow flag.
19      *
20      * _Available since v3.4._
21      */
22     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             uint256 c = a + b;
25             if (c < a) return (false, 0);
26             return (true, c);
27         }
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             if (b > a) return (false, 0);
38             return (true, a - b);
39         }
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a / b);
68         }
69     }
70 
71     /**
72      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a % b);
80         }
81     }
82 
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      *
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a + b;
95     }
96 
97     /**
98      * @dev Returns the subtraction of two unsigned integers, reverting on
99      * overflow (when the result is negative).
100      *
101      * Counterpart to Solidity's `-` operator.
102      *
103      * Requirements:
104      *
105      * - Subtraction cannot overflow.
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a - b;
109     }
110 
111     /**
112      * @dev Returns the multiplication of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `*` operator.
116      *
117      * Requirements:
118      *
119      * - Multiplication cannot overflow.
120      */
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a * b;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator.
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a / b;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * reverting when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a % b;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * CAUTION: This function is deprecated because it requires allocating memory for the error
160      * message unnecessarily. For custom revert reasons use {trySub}.
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         unchecked {
174             require(b <= a, errorMessage);
175             return a - b;
176         }
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b > 0, errorMessage);
198             return a / b;
199         }
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * reverting with custom message when dividing by zero.
205      *
206      * CAUTION: This function is deprecated because it requires allocating memory for the error
207      * message unnecessarily. For custom revert reasons use {tryMod}.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a % b;
225         }
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Counters.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @title Counters
238  * @author Matt Condon (@shrugs)
239  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
240  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
241  *
242  * Include with `using Counters for Counters.Counter;`
243  */
244 library Counters {
245     struct Counter {
246         // This variable should never be directly accessed by users of the library: interactions must be restricted to
247         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
248         // this feature: see https://github.com/ethereum/solidity/issues/4637
249         uint256 _value; // default: 0
250     }
251 
252     function current(Counter storage counter) internal view returns (uint256) {
253         return counter._value;
254     }
255 
256     function increment(Counter storage counter) internal {
257         unchecked {
258             counter._value += 1;
259         }
260     }
261 
262     function decrement(Counter storage counter) internal {
263         uint256 value = counter._value;
264         require(value > 0, "Counter: decrement overflow");
265         unchecked {
266             counter._value = value - 1;
267         }
268     }
269 
270     function reset(Counter storage counter) internal {
271         counter._value = 0;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Contract module that helps prevent reentrant calls to a function.
284  *
285  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
286  * available, which can be applied to functions to make sure there are no nested
287  * (reentrant) calls to them.
288  *
289  * Note that because there is a single `nonReentrant` guard, functions marked as
290  * `nonReentrant` may not call one another. This can be worked around by making
291  * those functions `private`, and then adding `external` `nonReentrant` entry
292  * points to them.
293  *
294  * TIP: If you would like to learn more about reentrancy and alternative ways
295  * to protect against it, check out our blog post
296  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
297  */
298 abstract contract ReentrancyGuard {
299     // Booleans are more expensive than uint256 or any type that takes up a full
300     // word because each write operation emits an extra SLOAD to first read the
301     // slot's contents, replace the bits taken up by the boolean, and then write
302     // back. This is the compiler's defense against contract upgrades and
303     // pointer aliasing, and it cannot be disabled.
304 
305     // The values being non-zero value makes deployment a bit more expensive,
306     // but in exchange the refund on every call to nonReentrant will be lower in
307     // amount. Since refunds are capped to a percentage of the total
308     // transaction's gas, it is best to keep them low in cases like this one, to
309     // increase the likelihood of the full refund coming into effect.
310     uint256 private constant _NOT_ENTERED = 1;
311     uint256 private constant _ENTERED = 2;
312 
313     uint256 private _status;
314 
315     constructor() {
316         _status = _NOT_ENTERED;
317     }
318 
319     /**
320      * @dev Prevents a contract from calling itself, directly or indirectly.
321      * Calling a `nonReentrant` function from another `nonReentrant`
322      * function is not supported. It is possible to prevent this from happening
323      * by making the `nonReentrant` function external, and making it call a
324      * `private` function that does the actual work.
325      */
326     modifier nonReentrant() {
327         // On the first call to nonReentrant, _notEntered will be true
328         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
329 
330         // Any calls to nonReentrant after this point will fail
331         _status = _ENTERED;
332 
333         _;
334 
335         // By storing the original value once again, a refund is triggered (see
336         // https://eips.ethereum.org/EIPS/eip-2200)
337         _status = _NOT_ENTERED;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
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
797 // File: @openzeppelin/contracts/interfaces/IERC165.sol
798 
799 
800 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
801 
802 pragma solidity ^0.8.0;
803 
804 
805 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
806 
807 
808 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 
813 /**
814  * @dev Interface for the NFT Royalty Standard
815  */
816 interface IERC2981 is IERC165 {
817     /**
818      * @dev Called with the sale price to determine how much royalty is owed and to whom.
819      * @param tokenId - the NFT asset queried for royalty information
820      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
821      * @return receiver - address of who should be sent the royalty payment
822      * @return royaltyAmount - the royalty payment amount for `salePrice`
823      */
824     function royaltyInfo(uint256 tokenId, uint256 salePrice)
825         external
826         view
827         returns (address receiver, uint256 royaltyAmount);
828 }
829 
830 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
831 
832 
833 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
834 
835 pragma solidity ^0.8.0;
836 
837 
838 /**
839  * @dev Implementation of the {IERC165} interface.
840  *
841  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
842  * for the additional interface id that will be supported. For example:
843  *
844  * ```solidity
845  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
846  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
847  * }
848  * ```
849  *
850  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
851  */
852 abstract contract ERC165 is IERC165 {
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
857         return interfaceId == type(IERC165).interfaceId;
858     }
859 }
860 
861 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
862 
863 
864 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 
869 /**
870  * @dev Required interface of an ERC721 compliant contract.
871  */
872 interface IERC721 is IERC165 {
873     /**
874      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
875      */
876     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
877 
878     /**
879      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
880      */
881     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
882 
883     /**
884      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
885      */
886     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
887 
888     /**
889      * @dev Returns the number of tokens in ``owner``'s account.
890      */
891     function balanceOf(address owner) external view returns (uint256 balance);
892 
893     /**
894      * @dev Returns the owner of the `tokenId` token.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must exist.
899      */
900     function ownerOf(uint256 tokenId) external view returns (address owner);
901 
902     /**
903      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
904      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
912      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
913      *
914      * Emits a {Transfer} event.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) external;
921 
922     /**
923      * @dev Transfers `tokenId` token from `from` to `to`.
924      *
925      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
926      *
927      * Requirements:
928      *
929      * - `from` cannot be the zero address.
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
933      *
934      * Emits a {Transfer} event.
935      */
936     function transferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) external;
941 
942     /**
943      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
944      * The approval is cleared when the token is transferred.
945      *
946      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
947      *
948      * Requirements:
949      *
950      * - The caller must own the token or be an approved operator.
951      * - `tokenId` must exist.
952      *
953      * Emits an {Approval} event.
954      */
955     function approve(address to, uint256 tokenId) external;
956 
957     /**
958      * @dev Returns the account approved for `tokenId` token.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      */
964     function getApproved(uint256 tokenId) external view returns (address operator);
965 
966     /**
967      * @dev Approve or remove `operator` as an operator for the caller.
968      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
969      *
970      * Requirements:
971      *
972      * - The `operator` cannot be the caller.
973      *
974      * Emits an {ApprovalForAll} event.
975      */
976     function setApprovalForAll(address operator, bool _approved) external;
977 
978     /**
979      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
980      *
981      * See {setApprovalForAll}
982      */
983     function isApprovedForAll(address owner, address operator) external view returns (bool);
984 
985     /**
986      * @dev Safely transfers `tokenId` token from `from` to `to`.
987      *
988      * Requirements:
989      *
990      * - `from` cannot be the zero address.
991      * - `to` cannot be the zero address.
992      * - `tokenId` token must exist and be owned by `from`.
993      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
994      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
995      *
996      * Emits a {Transfer} event.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes calldata data
1003     ) external;
1004 }
1005 
1006 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1007 
1008 
1009 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1016  * @dev See https://eips.ethereum.org/EIPS/eip-721
1017  */
1018 interface IERC721Enumerable is IERC721 {
1019     /**
1020      * @dev Returns the total amount of tokens stored by the contract.
1021      */
1022     function totalSupply() external view returns (uint256);
1023 
1024     /**
1025      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1026      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1029 
1030     /**
1031      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1032      * Use along with {totalSupply} to enumerate all tokens.
1033      */
1034     function tokenByIndex(uint256 index) external view returns (uint256);
1035 }
1036 
1037 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1038 
1039 
1040 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 
1045 /**
1046  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1047  * @dev See https://eips.ethereum.org/EIPS/eip-721
1048  */
1049 interface IERC721Metadata is IERC721 {
1050     /**
1051      * @dev Returns the token collection name.
1052      */
1053     function name() external view returns (string memory);
1054 
1055     /**
1056      * @dev Returns the token collection symbol.
1057      */
1058     function symbol() external view returns (string memory);
1059 
1060     /**
1061      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1062      */
1063     function tokenURI(uint256 tokenId) external view returns (string memory);
1064 }
1065 
1066 // File: contracts/ERC721A.sol
1067 
1068 
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 /**
1073  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1074  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1075  *
1076  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1077  *
1078  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1079  *
1080  * Does not support burning tokens to address(0).
1081  */
1082 contract ERC721A is
1083   Context,
1084   ERC165,
1085   IERC721,
1086   IERC721Metadata,
1087   IERC721Enumerable
1088 {
1089   using Address for address;
1090   using Strings for uint256;
1091 
1092   struct TokenOwnership {
1093     address addr;
1094     uint64 startTimestamp;
1095   }
1096 
1097   struct AddressData {
1098     uint128 balance;
1099     uint128 numberMinted;
1100   }
1101 
1102   uint256 private currentIndex = 1;
1103 
1104   uint256 internal immutable maxBatchSize;
1105 
1106   // Token name
1107   string private _name;
1108 
1109   // Token symbol
1110   string private _symbol;
1111 
1112   // Mapping from token ID to ownership details
1113   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1114   mapping(uint256 => TokenOwnership) private _ownerships;
1115 
1116   // Mapping owner address to address data
1117   mapping(address => AddressData) private _addressData;
1118 
1119   // Mapping from token ID to approved address
1120   mapping(uint256 => address) private _tokenApprovals;
1121 
1122   // Mapping from owner to operator approvals
1123   mapping(address => mapping(address => bool)) private _operatorApprovals;
1124 
1125   /**
1126    * @dev
1127    * `maxBatchSize` refers to how much a minter can mint at a time.
1128    */
1129   constructor(
1130     string memory name_,
1131     string memory symbol_,
1132     uint256 maxBatchSize_
1133   ) {
1134     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1135     _name = name_;
1136     _symbol = symbol_;
1137     maxBatchSize = maxBatchSize_;
1138   }
1139 
1140   /**
1141    * @dev See {IERC721Enumerable-totalSupply}.
1142    */
1143   function totalSupply() public view override returns (uint256) {
1144     return currentIndex;
1145   }
1146 
1147   /**
1148    * @dev See {IERC721Enumerable-tokenByIndex}.
1149    */
1150   function tokenByIndex(uint256 index) public view override returns (uint256) {
1151     require(index < totalSupply(), "ERC721A: global index out of bounds");
1152     return index;
1153   }
1154 
1155   /**
1156    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1157    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1158    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1159    */
1160   function tokenOfOwnerByIndex(address owner, uint256 index)
1161     public
1162     view
1163     override
1164     returns (uint256)
1165   {
1166     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1167     uint256 numMintedSoFar = totalSupply();
1168     uint256 tokenIdsIdx = 0;
1169     address currOwnershipAddr = address(0);
1170     for (uint256 i = 0; i < numMintedSoFar; i++) {
1171       TokenOwnership memory ownership = _ownerships[i];
1172       if (ownership.addr != address(0)) {
1173         currOwnershipAddr = ownership.addr;
1174       }
1175       if (currOwnershipAddr == owner) {
1176         if (tokenIdsIdx == index) {
1177           return i;
1178         }
1179         tokenIdsIdx++;
1180       }
1181     }
1182     revert("ERC721A: unable to get token of owner by index");
1183   }
1184 
1185   /**
1186    * @dev See {IERC165-supportsInterface}.
1187    */
1188   function supportsInterface(bytes4 interfaceId)
1189     public
1190     view
1191     virtual
1192     override(ERC165, IERC165)
1193     returns (bool)
1194   {
1195     return
1196       interfaceId == type(IERC721).interfaceId ||
1197       interfaceId == type(IERC721Metadata).interfaceId ||
1198       interfaceId == type(IERC721Enumerable).interfaceId ||
1199       super.supportsInterface(interfaceId);
1200   }
1201 
1202   /**
1203    * @dev See {IERC721-balanceOf}.
1204    */
1205   function balanceOf(address owner) public view override returns (uint256) {
1206     require(owner != address(0), "ERC721A: balance query for the zero address");
1207     return uint256(_addressData[owner].balance);
1208   }
1209 
1210   function _numberMinted(address owner) internal view returns (uint256) {
1211     require(
1212       owner != address(0),
1213       "ERC721A: number minted query for the zero address"
1214     );
1215     return uint256(_addressData[owner].numberMinted);
1216   }
1217 
1218   function ownershipOf(uint256 tokenId)
1219     internal
1220     view
1221     returns (TokenOwnership memory)
1222   {
1223     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1224 
1225     uint256 lowestTokenToCheck;
1226     if (tokenId >= maxBatchSize) {
1227       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1228     }
1229 
1230     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1231       TokenOwnership memory ownership = _ownerships[curr];
1232       if (ownership.addr != address(0)) {
1233         return ownership;
1234       }
1235     }
1236 
1237     revert("ERC721A: unable to determine the owner of token");
1238   }
1239 
1240   /**
1241    * @dev See {IERC721-ownerOf}.
1242    */
1243   function ownerOf(uint256 tokenId) public view override returns (address) {
1244     return ownershipOf(tokenId).addr;
1245   }
1246 
1247   /**
1248    * @dev See {IERC721Metadata-name}.
1249    */
1250   function name() public view virtual override returns (string memory) {
1251     return _name;
1252   }
1253 
1254   /**
1255    * @dev See {IERC721Metadata-symbol}.
1256    */
1257   function symbol() public view virtual override returns (string memory) {
1258     return _symbol;
1259   }
1260 
1261   /**
1262    * @dev See {IERC721Metadata-tokenURI}.
1263    */
1264   function tokenURI(uint256 tokenId)
1265     public
1266     view
1267     virtual
1268     override
1269     returns (string memory)
1270   {
1271     require(
1272       _exists(tokenId),
1273       "ERC721Metadata: URI query for nonexistent token"
1274     );
1275 
1276     string memory baseURI = _baseURI();
1277     return
1278       bytes(baseURI).length > 0
1279         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1280         : "";
1281   }
1282 
1283   /**
1284    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1285    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1286    * by default, can be overriden in child contracts.
1287    */
1288   function _baseURI() internal view virtual returns (string memory) {
1289     return "";
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-approve}.
1294    */
1295   function approve(address to, uint256 tokenId) public override {
1296     address owner = ERC721A.ownerOf(tokenId);
1297     require(to != owner, "ERC721A: approval to current owner");
1298 
1299     require(
1300       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1301       "ERC721A: approve caller is not owner nor approved for all"
1302     );
1303 
1304     _approve(to, tokenId, owner);
1305   }
1306 
1307   /**
1308    * @dev See {IERC721-getApproved}.
1309    */
1310   function getApproved(uint256 tokenId) public view override returns (address) {
1311     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1312 
1313     return _tokenApprovals[tokenId];
1314   }
1315 
1316   /**
1317    * @dev See {IERC721-setApprovalForAll}.
1318    */
1319   function setApprovalForAll(address operator, bool approved) public override {
1320     require(operator != _msgSender(), "ERC721A: approve to caller");
1321 
1322     _operatorApprovals[_msgSender()][operator] = approved;
1323     emit ApprovalForAll(_msgSender(), operator, approved);
1324   }
1325 
1326   /**
1327    * @dev See {IERC721-isApprovedForAll}.
1328    */
1329   function isApprovedForAll(address owner, address operator)
1330     public
1331     view
1332     virtual
1333     override
1334     returns (bool)
1335   {
1336     return _operatorApprovals[owner][operator];
1337   }
1338 
1339   /**
1340    * @dev See {IERC721-transferFrom}.
1341    */
1342   function transferFrom(
1343     address from,
1344     address to,
1345     uint256 tokenId
1346   ) public override {
1347     _transfer(from, to, tokenId);
1348   }
1349 
1350   /**
1351    * @dev See {IERC721-safeTransferFrom}.
1352    */
1353   function safeTransferFrom(
1354     address from,
1355     address to,
1356     uint256 tokenId
1357   ) public override {
1358     safeTransferFrom(from, to, tokenId, "");
1359   }
1360 
1361   /**
1362    * @dev See {IERC721-safeTransferFrom}.
1363    */
1364   function safeTransferFrom(
1365     address from,
1366     address to,
1367     uint256 tokenId,
1368     bytes memory _data
1369   ) public override {
1370     _transfer(from, to, tokenId);
1371     require(
1372       _checkOnERC721Received(from, to, tokenId, _data),
1373       "ERC721A: transfer to non ERC721Receiver implementer"
1374     );
1375   }
1376 
1377   /**
1378    * @dev Returns whether `tokenId` exists.
1379    *
1380    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1381    *
1382    * Tokens start existing when they are minted (`_mint`),
1383    */
1384   function _exists(uint256 tokenId) internal view returns (bool) {
1385     return tokenId < currentIndex;
1386   }
1387 
1388   function _safeMint(address to, uint256 quantity) internal {
1389     _safeMint(to, quantity, "");
1390   }
1391 
1392   /**
1393    * @dev Mints `quantity` tokens and transfers them to `to`.
1394    *
1395    * Requirements:
1396    *
1397    * - `to` cannot be the zero address.
1398    * - `quantity` cannot be larger than the max batch size.
1399    *
1400    * Emits a {Transfer} event.
1401    */
1402   function _safeMint(
1403     address to,
1404     uint256 quantity,
1405     bytes memory _data
1406   ) internal {
1407     uint256 startTokenId = currentIndex;
1408     require(to != address(0), "ERC721A: mint to the zero address");
1409     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1410     require(!_exists(startTokenId), "ERC721A: token already minted");
1411     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1412 
1413     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1414 
1415     AddressData memory addressData = _addressData[to];
1416     _addressData[to] = AddressData(
1417       addressData.balance + uint128(quantity),
1418       addressData.numberMinted + uint128(quantity)
1419     );
1420     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1421 
1422     uint256 updatedIndex = startTokenId;
1423 
1424     for (uint256 i = 0; i < quantity; i++) {
1425       emit Transfer(address(0), to, updatedIndex);
1426       require(
1427         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1428         "ERC721A: transfer to non ERC721Receiver implementer"
1429       );
1430       updatedIndex++;
1431     }
1432 
1433     currentIndex = updatedIndex;
1434     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1435   }
1436 
1437   /**
1438    * @dev Transfers `tokenId` from `from` to `to`.
1439    *
1440    * Requirements:
1441    *
1442    * - `to` cannot be the zero address.
1443    * - `tokenId` token must be owned by `from`.
1444    *
1445    * Emits a {Transfer} event.
1446    */
1447   function _transfer(
1448     address from,
1449     address to,
1450     uint256 tokenId
1451   ) private {
1452     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1453 
1454     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1455       getApproved(tokenId) == _msgSender() ||
1456       isApprovedForAll(prevOwnership.addr, _msgSender()));
1457 
1458     require(
1459       isApprovedOrOwner,
1460       "ERC721A: transfer caller is not owner nor approved"
1461     );
1462 
1463     require(
1464       prevOwnership.addr == from,
1465       "ERC721A: transfer from incorrect owner"
1466     );
1467     require(to != address(0), "ERC721A: transfer to the zero address");
1468 
1469     _beforeTokenTransfers(from, to, tokenId, 1);
1470 
1471     // Clear approvals from the previous owner
1472     _approve(address(0), tokenId, prevOwnership.addr);
1473 
1474     _addressData[from].balance -= 1;
1475     _addressData[to].balance += 1;
1476     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1477 
1478     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1479     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1480     uint256 nextTokenId = tokenId + 1;
1481     if (_ownerships[nextTokenId].addr == address(0)) {
1482       if (_exists(nextTokenId)) {
1483         _ownerships[nextTokenId] = TokenOwnership(
1484           prevOwnership.addr,
1485           prevOwnership.startTimestamp
1486         );
1487       }
1488     }
1489 
1490     emit Transfer(from, to, tokenId);
1491     _afterTokenTransfers(from, to, tokenId, 1);
1492   }
1493 
1494   /**
1495    * @dev Approve `to` to operate on `tokenId`
1496    *
1497    * Emits a {Approval} event.
1498    */
1499   function _approve(
1500     address to,
1501     uint256 tokenId,
1502     address owner
1503   ) private {
1504     _tokenApprovals[tokenId] = to;
1505     emit Approval(owner, to, tokenId);
1506   }
1507 
1508   uint256 public nextOwnerToExplicitlySet = 0;
1509 
1510   /**
1511    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1512    */
1513   function _setOwnersExplicit(uint256 quantity) internal {
1514     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1515     require(quantity > 0, "quantity must be nonzero");
1516     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1517     if (endIndex > currentIndex - 1) {
1518       endIndex = currentIndex - 1;
1519     }
1520     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1521     require(_exists(endIndex), "not enough minted yet for this cleanup");
1522     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1523       if (_ownerships[i].addr == address(0)) {
1524         TokenOwnership memory ownership = ownershipOf(i);
1525         _ownerships[i] = TokenOwnership(
1526           ownership.addr,
1527           ownership.startTimestamp
1528         );
1529       }
1530     }
1531     nextOwnerToExplicitlySet = endIndex + 1;
1532   }
1533 
1534   /**
1535    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1536    * The call is not executed if the target address is not a contract.
1537    *
1538    * @param from address representing the previous owner of the given token ID
1539    * @param to target address that will receive the tokens
1540    * @param tokenId uint256 ID of the token to be transferred
1541    * @param _data bytes optional data to send along with the call
1542    * @return bool whether the call correctly returned the expected magic value
1543    */
1544   function _checkOnERC721Received(
1545     address from,
1546     address to,
1547     uint256 tokenId,
1548     bytes memory _data
1549   ) private returns (bool) {
1550     if (to.isContract()) {
1551       try
1552         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1553       returns (bytes4 retval) {
1554         return retval == IERC721Receiver(to).onERC721Received.selector;
1555       } catch (bytes memory reason) {
1556         if (reason.length == 0) {
1557           revert("ERC721A: transfer to non ERC721Receiver implementer");
1558         } else {
1559           assembly {
1560             revert(add(32, reason), mload(reason))
1561           }
1562         }
1563       }
1564     } else {
1565       return true;
1566     }
1567   }
1568 
1569   /**
1570    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1571    *
1572    * startTokenId - the first token id to be transferred
1573    * quantity - the amount to be transferred
1574    *
1575    * Calling conditions:
1576    *
1577    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1578    * transferred to `to`.
1579    * - When `from` is zero, `tokenId` will be minted for `to`.
1580    */
1581   function _beforeTokenTransfers(
1582     address from,
1583     address to,
1584     uint256 startTokenId,
1585     uint256 quantity
1586   ) internal virtual {}
1587 
1588   /**
1589    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1590    * minting.
1591    *
1592    * startTokenId - the first token id to be transferred
1593    * quantity - the amount to be transferred
1594    *
1595    * Calling conditions:
1596    *
1597    * - when `from` and `to` are both non-zero.
1598    * - `from` and `to` are never both zero.
1599    */
1600   function _afterTokenTransfers(
1601     address from,
1602     address to,
1603     uint256 startTokenId,
1604     uint256 quantity
1605   ) internal virtual {}
1606 }
1607 
1608 
1609 pragma solidity ^0.8.0;
1610 
1611 library MerkleProof {
1612     /**
1613      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1614      * defined by `root`. For this, a `proof` must be provided, containing
1615      * sibling hashes on the branch from the leaf to the root of the tree. Each
1616      * pair of leaves and each pair of pre-images are assumed to be sorted.
1617      */
1618     function verify(
1619         bytes32[] memory proof,
1620         bytes32 root,
1621         bytes32 leaf
1622     ) internal pure returns (bool) {
1623         return processProof(proof, leaf) == root;
1624     }
1625 
1626     /**
1627      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1628      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1629      * hash matches the root of the tree. When processing the proof, the pairs
1630      * of leafs & pre-images are assumed to be sorted.
1631      *
1632      * _Available since v4.4._
1633      */
1634     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1635         bytes32 computedHash = leaf;
1636         for (uint256 i = 0; i < proof.length; i++) {
1637             bytes32 proofElement = proof[i];
1638             if (computedHash <= proofElement) {
1639                 // Hash(current computed hash + current element of the proof)
1640                 computedHash = _efficientHash(computedHash, proofElement);
1641             } else {
1642                 // Hash(current element of the proof + current computed hash)
1643                 computedHash = _efficientHash(proofElement, computedHash);
1644             }
1645         }
1646         return computedHash;
1647     }
1648 
1649     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1650         /// @solidity memory-safe-assembly
1651         assembly {
1652             mstore(0x00, a)
1653             mstore(0x20, b)
1654             value := keccak256(0x00, 0x40)
1655         }
1656     }
1657 }
1658 
1659 contract HapeWives is ERC721A, Ownable, ReentrancyGuard {
1660     using Counters for Counters.Counter;
1661     using Strings for uint256;
1662 
1663     Counters.Counter private tokenCounter;
1664 
1665     string private baseURI;
1666     string private notRevealedURI;
1667     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1668     bool private isOpenSeaProxyActive = true;
1669     address private donAddress = 0x7F1486142887cadC7f382aC6BE121D506723a91E;
1670     address private mtvAddress = 0x42150e59Cc600D10d2892Da2EA5966Bd343655Ac;
1671 
1672     address public oldAddress = 0x8bF1AF48Ec3fD8DC3a89eDC43Edf74820Bd890E6;
1673     IERC721Enumerable oldContract = IERC721Enumerable(oldAddress);
1674     mapping (uint256 => bool) public claimedTokens;
1675     mapping (address => uint256) public claimedBalance;
1676 
1677     uint256 public maxSupply = 8000;
1678     uint256 public mintPerWhitelistTransaction = 2;
1679     uint256 public mintPerTransaction = 5;
1680     uint256 public giveawayReserved = 888;
1681     bytes32 public merkleRoot = 0x0cc057239d652ae106e52f1de624fb400052d46380cb2aec24dda5e0df776445;
1682 
1683     uint256 public constant salePrice = 0.15 ether;
1684     uint256 public constant whitelistSalePrice = 0.1 ether;
1685     bool public isPublicSaleActive = false;
1686     bool public active = false;
1687     bool public revealed = false;
1688     // MODIFIERS
1689 
1690     modifier maxMintsPerTX(uint256 numberOfTokens) {
1691         require(numberOfTokens <= getMintPerTransaction(), "Max mints per transaction exceeded");
1692         require(numberOfTokens <= canMintAmount(), "Cant mint this number of tokens");
1693         _;
1694     }
1695 
1696     modifier canMintNFTs(uint256 numberOfTokens) {
1697         require(totalSupply() + numberOfTokens <= maxSupply, "The rest reserved for a giveaway");
1698         require(numberOfTokens > 0, "Mint amount must be more than 0");
1699         _;
1700     }
1701 
1702     modifier isActive() {
1703         require(active, "Minting is not active");
1704         _;
1705     }
1706 
1707     modifier isCorrectPayment(uint256 numberOfTokens) {
1708         if (msg.sender != owner()) {
1709             require((_getPrice() * numberOfTokens) == msg.value, "Incorrect ETH value sent");
1710         }
1711         _;
1712     }
1713 
1714     modifier checkMerkle(bytes32[] calldata _merkleProof) {
1715         if (!isPublicSaleActive) {
1716             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1717             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not in the WifeList");
1718         }
1719         _;
1720     }
1721 
1722     function _getPrice() internal view returns (uint256){
1723         if(isPublicSaleActive) {
1724             return salePrice;
1725         }
1726         else {
1727             return whitelistSalePrice;
1728         }
1729     }
1730     function cost() public view returns(uint256) {
1731       return _getPrice();
1732     }
1733 
1734     function getMintPerTransaction() internal view returns (uint256) {
1735         if(isPublicSaleActive) {
1736             return mintPerTransaction + claimedBalance[msg.sender];
1737         }
1738         else {
1739             return mintPerWhitelistTransaction + claimedBalance[msg.sender];
1740         }
1741     }
1742 
1743     constructor(
1744         string memory _NotRevealedURI,
1745         string memory _initBaseURI
1746     ) ERC721A("HAPEWIVES", "HW", giveawayReserved) {
1747         setBaseURI(_initBaseURI);
1748         setNotRevealedURI(_NotRevealedURI);
1749     }
1750 
1751     // SET VARIABLES ON DEPLOY
1752 
1753     function setBaseURI (string memory _baseURI) public onlyOwner {
1754         baseURI = _baseURI;
1755     }
1756 
1757     function setNotRevealedURI (string memory _notRevealedURI) public onlyOwner {
1758         notRevealedURI = _notRevealedURI;
1759     }
1760 
1761     function setGiveawayReserved (uint256 _giveawayReserved) public onlyOwner {
1762       // WE WILL DECREASE IT IF CLAIM AND SOLD AMOUNT WILL BE MORE THAN 8000
1763       giveawayReserved = _giveawayReserved;
1764     }
1765 
1766     // PUBLIC FUNCTIONS
1767 
1768     function mint(uint256 numberOfTokens, bytes32[] calldata _merkleProof) external payable isActive
1769         nonReentrant
1770         checkMerkle(_merkleProof)
1771         isCorrectPayment(numberOfTokens)
1772         canMintNFTs(numberOfTokens)
1773     {
1774         _safeMint(msg.sender, numberOfTokens);
1775     }
1776 
1777     function claim() external nonReentrant isActive {
1778         uint256 claimAmount = canClaim();
1779         require(claimAmount > 0, "You cant claim nft");
1780 
1781         for (uint256 i = 0 ; i < claimAmount; i++) {
1782           _idByOwner(i);
1783           claimedTokens[_idByOwner(i)] = true;
1784         }
1785         claimedBalance[msg.sender] = claimAmount * 2;
1786         _safeMint(msg.sender, claimAmount * 2);
1787     }
1788     // PUBLIC READ-ONLY FUNCTIONS
1789 
1790     function _idByOwner(uint256 _index) internal view returns (uint256) {
1791       return oldContract.tokenOfOwnerByIndex(msg.sender, _index);
1792     }
1793 
1794     function _canClaim() internal view returns (uint256) {
1795       return oldContract.balanceOf(msg.sender);
1796     }
1797 
1798     function canClaim() public view returns (uint256) {
1799       uint256 calculateCanClaim = 0;
1800       for (uint256 i = 0 ; i < _canClaim(); i++) {
1801         if (claimedTokens[_idByOwner(i)] == false) {
1802           calculateCanClaim += 1;
1803         }
1804       }
1805       return calculateCanClaim;
1806     }
1807     // ONLYOWNER ADMIN FUNCTIONS
1808 
1809     function reveal() public onlyOwner {
1810         revealed = true;
1811     }
1812 
1813     function giveaway() public onlyOwner {
1814         require(giveawayReserved > 0);
1815         _safeMint(owner(), giveawayReserved);
1816         giveawayReserved = 0;
1817     }
1818 
1819     function canMintAmount() public view returns (uint256) {
1820       if (balanceOf(msg.sender) > getMintPerTransaction()) {
1821         return 0;
1822       } else {
1823         return getMintPerTransaction() - balanceOf(msg.sender);
1824       }
1825     }
1826 
1827     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1828         external
1829         onlyOwner
1830     {
1831         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1832     }
1833 
1834     function setIsPublicSaleActive(bool _isPublicSaleActive) external onlyOwner {
1835         isPublicSaleActive = _isPublicSaleActive;
1836     }
1837 
1838     function setActive(bool _active) external onlyOwner {
1839         active = _active;
1840     }
1841 
1842     // For debugging
1843     function setOldAddress(address _oldAddress) external onlyOwner {
1844         oldAddress = _oldAddress;
1845     }
1846 
1847     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1848         merkleRoot = _merkleRoot;
1849     }
1850 
1851   function withdraw() public payable onlyOwner {
1852       //Donation
1853     (bool don, ) = payable(donAddress).call{value: address(this).balance * 10 / 100}("");
1854     require(don);
1855 
1856       //Metaverse
1857     (bool mtv, ) = payable(mtvAddress).call{value: address(this).balance * 37 / 100}("");
1858     require(mtv);
1859 
1860     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1861     require(os);
1862   }
1863 
1864 
1865     // SUPPORTING FUNCTIONS
1866 
1867     function nextTokenId() private returns (uint256) {
1868         tokenCounter.increment();
1869         return tokenCounter.current();
1870     }
1871 
1872     /**
1873      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1874      */
1875     function isApprovedForAll(address owner, address operator)
1876         public
1877         view
1878         override
1879         returns (bool)
1880     {
1881         // Get a reference to OpenSea's proxy registry contract by instantiating
1882         // the contract using the already existing address.
1883         ProxyRegistry proxyRegistry = ProxyRegistry(
1884             openSeaProxyRegistryAddress
1885         );
1886         if (
1887             isOpenSeaProxyActive &&
1888             address(proxyRegistry.proxies(owner)) == operator
1889         ) {
1890             return true;
1891         }
1892 
1893         return super.isApprovedForAll(owner, operator);
1894     }
1895     /**
1896      * @dev See {IERC721Metadata-tokenURI}.
1897      */
1898     function tokenURI(uint256 tokenId)
1899         public
1900         view
1901         virtual
1902         override
1903         returns (string memory)
1904     {
1905         require(_exists(tokenId), "Nonexistent token");
1906         if(revealed == false) {
1907             return string(abi.encodePacked(notRevealedURI, (tokenId).toString(), ".json"));
1908         }
1909         return string(abi.encodePacked(baseURI, (tokenId).toString(), ".json"));
1910     }
1911 
1912 }
1913 
1914 // These contract definitions are used to create a reference to the OpenSea
1915 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1916 contract OwnableDelegateProxy {
1917 
1918 }
1919 
1920 contract ProxyRegistry {
1921     mapping(address => OwnableDelegateProxy) public proxies;
1922 }