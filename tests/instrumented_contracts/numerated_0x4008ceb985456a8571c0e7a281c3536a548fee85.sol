1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Counters.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @title Counters
240  * @author Matt Condon (@shrugs)
241  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
242  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
243  *
244  * Include with `using Counters for Counters.Counter;`
245  */
246 library Counters {
247     struct Counter {
248         // This variable should never be directly accessed by users of the library: interactions must be restricted to
249         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
250         // this feature: see https://github.com/ethereum/solidity/issues/4637
251         uint256 _value; // default: 0
252     }
253 
254     function current(Counter storage counter) internal view returns (uint256) {
255         return counter._value;
256     }
257 
258     function increment(Counter storage counter) internal {
259         unchecked {
260             counter._value += 1;
261         }
262     }
263 
264     function decrement(Counter storage counter) internal {
265         uint256 value = counter._value;
266         require(value > 0, "Counter: decrement overflow");
267         unchecked {
268             counter._value = value - 1;
269         }
270     }
271 
272     function reset(Counter storage counter) internal {
273         counter._value = 0;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Contract module that helps prevent reentrant calls to a function.
286  *
287  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
288  * available, which can be applied to functions to make sure there are no nested
289  * (reentrant) calls to them.
290  *
291  * Note that because there is a single `nonReentrant` guard, functions marked as
292  * `nonReentrant` may not call one another. This can be worked around by making
293  * those functions `private`, and then adding `external` `nonReentrant` entry
294  * points to them.
295  *
296  * TIP: If you would like to learn more about reentrancy and alternative ways
297  * to protect against it, check out our blog post
298  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
299  */
300 abstract contract ReentrancyGuard {
301     // Booleans are more expensive than uint256 or any type that takes up a full
302     // word because each write operation emits an extra SLOAD to first read the
303     // slot's contents, replace the bits taken up by the boolean, and then write
304     // back. This is the compiler's defense against contract upgrades and
305     // pointer aliasing, and it cannot be disabled.
306 
307     // The values being non-zero value makes deployment a bit more expensive,
308     // but in exchange the refund on every call to nonReentrant will be lower in
309     // amount. Since refunds are capped to a percentage of the total
310     // transaction's gas, it is best to keep them low in cases like this one, to
311     // increase the likelihood of the full refund coming into effect.
312     uint256 private constant _NOT_ENTERED = 1;
313     uint256 private constant _ENTERED = 2;
314 
315     uint256 private _status;
316 
317     constructor() {
318         _status = _NOT_ENTERED;
319     }
320 
321     /**
322      * @dev Prevents a contract from calling itself, directly or indirectly.
323      * Calling a `nonReentrant` function from another `nonReentrant`
324      * function is not supported. It is possible to prevent this from happening
325      * by making the `nonReentrant` function external, and making it call a
326      * `private` function that does the actual work.
327      */
328     modifier nonReentrant() {
329         // On the first call to nonReentrant, _notEntered will be true
330         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
331 
332         // Any calls to nonReentrant after this point will fail
333         _status = _ENTERED;
334 
335         _;
336 
337         // By storing the original value once again, a refund is triggered (see
338         // https://eips.ethereum.org/EIPS/eip-2200)
339         _status = _NOT_ENTERED;
340     }
341 }
342 
343 // File: @openzeppelin/contracts/utils/Strings.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev String operations.
352  */
353 library Strings {
354     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
358      */
359     function toString(uint256 value) internal pure returns (string memory) {
360         // Inspired by OraclizeAPI's implementation - MIT licence
361         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
362 
363         if (value == 0) {
364             return "0";
365         }
366         uint256 temp = value;
367         uint256 digits;
368         while (temp != 0) {
369             digits++;
370             temp /= 10;
371         }
372         bytes memory buffer = new bytes(digits);
373         while (value != 0) {
374             digits -= 1;
375             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
376             value /= 10;
377         }
378         return string(buffer);
379     }
380 
381     /**
382      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
383      */
384     function toHexString(uint256 value) internal pure returns (string memory) {
385         if (value == 0) {
386             return "0x00";
387         }
388         uint256 temp = value;
389         uint256 length = 0;
390         while (temp != 0) {
391             length++;
392             temp >>= 8;
393         }
394         return toHexString(value, length);
395     }
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
399      */
400     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
401         bytes memory buffer = new bytes(2 * length + 2);
402         buffer[0] = "0";
403         buffer[1] = "x";
404         for (uint256 i = 2 * length + 1; i > 1; --i) {
405             buffer[i] = _HEX_SYMBOLS[value & 0xf];
406             value >>= 4;
407         }
408         require(value == 0, "Strings: hex length insufficient");
409         return string(buffer);
410     }
411 }
412 
413 // File: @openzeppelin/contracts/utils/Context.sol
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 /**
421  * @dev Provides information about the current execution context, including the
422  * sender of the transaction and its data. While these are generally available
423  * via msg.sender and msg.data, they should not be accessed in such a direct
424  * manner, since when dealing with meta-transactions the account sending and
425  * paying for execution may not be the actual sender (as far as an application
426  * is concerned).
427  *
428  * This contract is only required for intermediate, library-like contracts.
429  */
430 abstract contract Context {
431     function _msgSender() internal view virtual returns (address) {
432         return msg.sender;
433     }
434 
435     function _msgData() internal view virtual returns (bytes calldata) {
436         return msg.data;
437     }
438 }
439 
440 // File: @openzeppelin/contracts/access/Ownable.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 
448 /**
449  * @dev Contract module which provides a basic access control mechanism, where
450  * there is an account (an owner) that can be granted exclusive access to
451  * specific functions.
452  *
453  * By default, the owner account will be the one that deploys the contract. This
454  * can later be changed with {transferOwnership}.
455  *
456  * This module is used through inheritance. It will make available the modifier
457  * `onlyOwner`, which can be applied to your functions to restrict their use to
458  * the owner.
459  */
460 abstract contract Ownable is Context {
461     address private _owner;
462 
463     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
464 
465     /**
466      * @dev Initializes the contract setting the deployer as the initial owner.
467      */
468     constructor() {
469         _transferOwnership(_msgSender());
470     }
471 
472     /**
473      * @dev Returns the address of the current owner.
474      */
475     function owner() public view virtual returns (address) {
476         return _owner;
477     }
478 
479     /**
480      * @dev Throws if called by any account other than the owner.
481      */
482     modifier onlyOwner() {
483         require(owner() == _msgSender(), "Ownable: caller is not the owner");
484         _;
485     }
486 
487     /**
488      * @dev Leaves the contract without owner. It will not be possible to call
489      * `onlyOwner` functions anymore. Can only be called by the current owner.
490      *
491      * NOTE: Renouncing ownership will leave the contract without an owner,
492      * thereby removing any functionality that is only available to the owner.
493      */
494     function renounceOwnership() public virtual onlyOwner {
495         _transferOwnership(address(0));
496     }
497 
498     /**
499      * @dev Transfers ownership of the contract to a new account (`newOwner`).
500      * Can only be called by the current owner.
501      */
502     function transferOwnership(address newOwner) public virtual onlyOwner {
503         require(newOwner != address(0), "Ownable: new owner is the zero address");
504         _transferOwnership(newOwner);
505     }
506 
507     /**
508      * @dev Transfers ownership of the contract to a new account (`newOwner`).
509      * Internal function without access restriction.
510      */
511     function _transferOwnership(address newOwner) internal virtual {
512         address oldOwner = _owner;
513         _owner = newOwner;
514         emit OwnershipTransferred(oldOwner, newOwner);
515     }
516 }
517 
518 // File: @openzeppelin/contracts/utils/Address.sol
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Collection of functions related to the address type
527  */
528 library Address {
529     /**
530      * @dev Returns true if `account` is a contract.
531      *
532      * [IMPORTANT]
533      * ====
534      * It is unsafe to assume that an address for which this function returns
535      * false is an externally-owned account (EOA) and not a contract.
536      *
537      * Among others, `isContract` will return false for the following
538      * types of addresses:
539      *
540      *  - an externally-owned account
541      *  - a contract in construction
542      *  - an address where a contract will be created
543      *  - an address where a contract lived, but was destroyed
544      * ====
545      */
546     function isContract(address account) internal view returns (bool) {
547         // This method relies on extcodesize, which returns 0 for contracts in
548         // construction, since the code is only stored at the end of the
549         // constructor execution.
550 
551         uint256 size;
552         assembly {
553             size := extcodesize(account)
554         }
555         return size > 0;
556     }
557 
558     /**
559      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
560      * `recipient`, forwarding all available gas and reverting on errors.
561      *
562      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
563      * of certain opcodes, possibly making contracts go over the 2300 gas limit
564      * imposed by `transfer`, making them unable to receive funds via
565      * `transfer`. {sendValue} removes this limitation.
566      *
567      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
568      *
569      * IMPORTANT: because control is transferred to `recipient`, care must be
570      * taken to not create reentrancy vulnerabilities. Consider using
571      * {ReentrancyGuard} or the
572      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
573      */
574     function sendValue(address payable recipient, uint256 amount) internal {
575         require(address(this).balance >= amount, "Address: insufficient balance");
576 
577         (bool success, ) = recipient.call{value: amount}("");
578         require(success, "Address: unable to send value, recipient may have reverted");
579     }
580 
581     /**
582      * @dev Performs a Solidity function call using a low level `call`. A
583      * plain `call` is an unsafe replacement for a function call: use this
584      * function instead.
585      *
586      * If `target` reverts with a revert reason, it is bubbled up by this
587      * function (like regular Solidity function calls).
588      *
589      * Returns the raw returned data. To convert to the expected return value,
590      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
591      *
592      * Requirements:
593      *
594      * - `target` must be a contract.
595      * - calling `target` with `data` must not revert.
596      *
597      * _Available since v3.1._
598      */
599     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
600         return functionCall(target, data, "Address: low-level call failed");
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
605      * `errorMessage` as a fallback revert reason when `target` reverts.
606      *
607      * _Available since v3.1._
608      */
609     function functionCall(
610         address target,
611         bytes memory data,
612         string memory errorMessage
613     ) internal returns (bytes memory) {
614         return functionCallWithValue(target, data, 0, errorMessage);
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
619      * but also transferring `value` wei to `target`.
620      *
621      * Requirements:
622      *
623      * - the calling contract must have an ETH balance of at least `value`.
624      * - the called Solidity function must be `payable`.
625      *
626      * _Available since v3.1._
627      */
628     function functionCallWithValue(
629         address target,
630         bytes memory data,
631         uint256 value
632     ) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
638      * with `errorMessage` as a fallback revert reason when `target` reverts.
639      *
640      * _Available since v3.1._
641      */
642     function functionCallWithValue(
643         address target,
644         bytes memory data,
645         uint256 value,
646         string memory errorMessage
647     ) internal returns (bytes memory) {
648         require(address(this).balance >= value, "Address: insufficient balance for call");
649         require(isContract(target), "Address: call to non-contract");
650 
651         (bool success, bytes memory returndata) = target.call{value: value}(data);
652         return verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but performing a static call.
658      *
659      * _Available since v3.3._
660      */
661     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
662         return functionStaticCall(target, data, "Address: low-level static call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
667      * but performing a static call.
668      *
669      * _Available since v3.3._
670      */
671     function functionStaticCall(
672         address target,
673         bytes memory data,
674         string memory errorMessage
675     ) internal view returns (bytes memory) {
676         require(isContract(target), "Address: static call to non-contract");
677 
678         (bool success, bytes memory returndata) = target.staticcall(data);
679         return verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
684      * but performing a delegate call.
685      *
686      * _Available since v3.4._
687      */
688     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
689         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
694      * but performing a delegate call.
695      *
696      * _Available since v3.4._
697      */
698     function functionDelegateCall(
699         address target,
700         bytes memory data,
701         string memory errorMessage
702     ) internal returns (bytes memory) {
703         require(isContract(target), "Address: delegate call to non-contract");
704 
705         (bool success, bytes memory returndata) = target.delegatecall(data);
706         return verifyCallResult(success, returndata, errorMessage);
707     }
708 
709     /**
710      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
711      * revert reason using the provided one.
712      *
713      * _Available since v4.3._
714      */
715     function verifyCallResult(
716         bool success,
717         bytes memory returndata,
718         string memory errorMessage
719     ) internal pure returns (bytes memory) {
720         if (success) {
721             return returndata;
722         } else {
723             // Look for revert reason and bubble it up if present
724             if (returndata.length > 0) {
725                 // The easiest way to bubble the revert reason is using memory via assembly
726 
727                 assembly {
728                     let returndata_size := mload(returndata)
729                     revert(add(32, returndata), returndata_size)
730                 }
731             } else {
732                 revert(errorMessage);
733             }
734         }
735     }
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @title ERC721 token receiver interface
747  * @dev Interface for any contract that wants to support safeTransfers
748  * from ERC721 asset contracts.
749  */
750 interface IERC721Receiver {
751     /**
752      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
753      * by `operator` from `from`, this function is called.
754      *
755      * It must return its Solidity selector to confirm the token transfer.
756      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
757      *
758      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
759      */
760     function onERC721Received(
761         address operator,
762         address from,
763         uint256 tokenId,
764         bytes calldata data
765     ) external returns (bytes4);
766 }
767 
768 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
769 
770 
771 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 /**
776  * @dev Interface of the ERC165 standard, as defined in the
777  * https://eips.ethereum.org/EIPS/eip-165[EIP].
778  *
779  * Implementers can declare support of contract interfaces, which can then be
780  * queried by others ({ERC165Checker}).
781  *
782  * For an implementation, see {ERC165}.
783  */
784 interface IERC165 {
785     /**
786      * @dev Returns true if this contract implements the interface defined by
787      * `interfaceId`. See the corresponding
788      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
789      * to learn more about how these ids are created.
790      *
791      * This function call must use less than 30 000 gas.
792      */
793     function supportsInterface(bytes4 interfaceId) external view returns (bool);
794 }
795 
796 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
797 
798 
799 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 
804 /**
805  * @dev Implementation of the {IERC165} interface.
806  *
807  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
808  * for the additional interface id that will be supported. For example:
809  *
810  * ```solidity
811  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
812  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
813  * }
814  * ```
815  *
816  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
817  */
818 abstract contract ERC165 is IERC165 {
819     /**
820      * @dev See {IERC165-supportsInterface}.
821      */
822     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
823         return interfaceId == type(IERC165).interfaceId;
824     }
825 }
826 
827 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
828 
829 
830 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
831 
832 pragma solidity ^0.8.0;
833 
834 
835 /**
836  * @dev Required interface of an ERC721 compliant contract.
837  */
838 interface IERC721 is IERC165 {
839     /**
840      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
841      */
842     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
843 
844     /**
845      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
846      */
847     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
848 
849     /**
850      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
851      */
852     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
853 
854     /**
855      * @dev Returns the number of tokens in ``owner``'s account.
856      */
857     function balanceOf(address owner) external view returns (uint256 balance);
858 
859     /**
860      * @dev Returns the owner of the `tokenId` token.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must exist.
865      */
866     function ownerOf(uint256 tokenId) external view returns (address owner);
867 
868     /**
869      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
870      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
879      *
880      * Emits a {Transfer} event.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) external;
887 
888     /**
889      * @dev Transfers `tokenId` token from `from` to `to`.
890      *
891      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must be owned by `from`.
898      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
899      *
900      * Emits a {Transfer} event.
901      */
902     function transferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) external;
907 
908     /**
909      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
910      * The approval is cleared when the token is transferred.
911      *
912      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
913      *
914      * Requirements:
915      *
916      * - The caller must own the token or be an approved operator.
917      * - `tokenId` must exist.
918      *
919      * Emits an {Approval} event.
920      */
921     function approve(address to, uint256 tokenId) external;
922 
923     /**
924      * @dev Returns the account approved for `tokenId` token.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must exist.
929      */
930     function getApproved(uint256 tokenId) external view returns (address operator);
931 
932     /**
933      * @dev Approve or remove `operator` as an operator for the caller.
934      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
935      *
936      * Requirements:
937      *
938      * - The `operator` cannot be the caller.
939      *
940      * Emits an {ApprovalForAll} event.
941      */
942     function setApprovalForAll(address operator, bool _approved) external;
943 
944     /**
945      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
946      *
947      * See {setApprovalForAll}
948      */
949     function isApprovedForAll(address owner, address operator) external view returns (bool);
950 
951     /**
952      * @dev Safely transfers `tokenId` token from `from` to `to`.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must exist and be owned by `from`.
959      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes calldata data
969     ) external;
970 }
971 
972 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
973 
974 
975 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
976 
977 pragma solidity ^0.8.0;
978 
979 
980 /**
981  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
982  * @dev See https://eips.ethereum.org/EIPS/eip-721
983  */
984 interface IERC721Enumerable is IERC721 {
985     /**
986      * @dev Returns the total amount of tokens stored by the contract.
987      */
988     function totalSupply() external view returns (uint256);
989 
990     /**
991      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
992      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
993      */
994     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
995 
996     /**
997      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
998      * Use along with {totalSupply} to enumerate all tokens.
999      */
1000     function tokenByIndex(uint256 index) external view returns (uint256);
1001 }
1002 
1003 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1004 
1005 
1006 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 
1011 /**
1012  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1013  * @dev See https://eips.ethereum.org/EIPS/eip-721
1014  */
1015 interface IERC721Metadata is IERC721 {
1016     /**
1017      * @dev Returns the token collection name.
1018      */
1019     function name() external view returns (string memory);
1020 
1021     /**
1022      * @dev Returns the token collection symbol.
1023      */
1024     function symbol() external view returns (string memory);
1025 
1026     /**
1027      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1028      */
1029     function tokenURI(uint256 tokenId) external view returns (string memory);
1030 }
1031 
1032 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1033 
1034 
1035 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 
1040 
1041 
1042 
1043 
1044 
1045 
1046 /**
1047  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1048  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1049  * {ERC721Enumerable}.
1050  */
1051 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1052     using Address for address;
1053     using Strings for uint256;
1054 
1055     // Token name
1056     string private _name;
1057 
1058     // Token symbol
1059     string private _symbol;
1060 
1061     // Mapping from token ID to owner address
1062     mapping(uint256 => address) private _owners;
1063 
1064     // Mapping owner address to token count
1065     mapping(address => uint256) private _balances;
1066 
1067     // Mapping from token ID to approved address
1068     mapping(uint256 => address) private _tokenApprovals;
1069 
1070     // Mapping from owner to operator approvals
1071     mapping(address => mapping(address => bool)) private _operatorApprovals;
1072 
1073     /**
1074      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1075      */
1076     constructor(string memory name_, string memory symbol_) {
1077         _name = name_;
1078         _symbol = symbol_;
1079     }
1080 
1081     /**
1082      * @dev See {IERC165-supportsInterface}.
1083      */
1084     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1085         return
1086             interfaceId == type(IERC721).interfaceId ||
1087             interfaceId == type(IERC721Metadata).interfaceId ||
1088             super.supportsInterface(interfaceId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-balanceOf}.
1093      */
1094     function balanceOf(address owner) public view virtual override returns (uint256) {
1095         require(owner != address(0), "ERC721: balance query for the zero address");
1096         return _balances[owner];
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-ownerOf}.
1101      */
1102     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1103         address owner = _owners[tokenId];
1104         require(owner != address(0), "ERC721: owner query for nonexistent token");
1105         return owner;
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Metadata-name}.
1110      */
1111     function name() public view virtual override returns (string memory) {
1112         return _name;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Metadata-symbol}.
1117      */
1118     function symbol() public view virtual override returns (string memory) {
1119         return _symbol;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Metadata-tokenURI}.
1124      */
1125     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1126         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1127 
1128         string memory baseURI = _baseURI();
1129         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1130     }
1131 
1132     /**
1133      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1134      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1135      * by default, can be overriden in child contracts.
1136      */
1137     function _baseURI() internal view virtual returns (string memory) {
1138         return "";
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-approve}.
1143      */
1144     function approve(address to, uint256 tokenId) public virtual override {
1145         address owner = ERC721.ownerOf(tokenId);
1146         require(to != owner, "ERC721: approval to current owner");
1147 
1148         require(
1149             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1150             "ERC721: approve caller is not owner nor approved for all"
1151         );
1152 
1153         _approve(to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-getApproved}.
1158      */
1159     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1160         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1161 
1162         return _tokenApprovals[tokenId];
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-setApprovalForAll}.
1167      */
1168     function setApprovalForAll(address operator, bool approved) public virtual override {
1169         _setApprovalForAll(_msgSender(), operator, approved);
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-isApprovedForAll}.
1174      */
1175     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1176         return _operatorApprovals[owner][operator];
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-transferFrom}.
1181      */
1182     function transferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) public virtual override {
1187         //solhint-disable-next-line max-line-length
1188         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1189 
1190         _transfer(from, to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-safeTransferFrom}.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) public virtual override {
1201         safeTransferFrom(from, to, tokenId, "");
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-safeTransferFrom}.
1206      */
1207     function safeTransferFrom(
1208         address from,
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) public virtual override {
1213         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1214         _safeTransfer(from, to, tokenId, _data);
1215     }
1216 
1217     /**
1218      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1219      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1220      *
1221      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1222      *
1223      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1224      * implement alternative mechanisms to perform token transfer, such as signature-based.
1225      *
1226      * Requirements:
1227      *
1228      * - `from` cannot be the zero address.
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must exist and be owned by `from`.
1231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _safeTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId,
1239         bytes memory _data
1240     ) internal virtual {
1241         _transfer(from, to, tokenId);
1242         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1243     }
1244 
1245     /**
1246      * @dev Returns whether `tokenId` exists.
1247      *
1248      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1249      *
1250      * Tokens start existing when they are minted (`_mint`),
1251      * and stop existing when they are burned (`_burn`).
1252      */
1253     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1254         return _owners[tokenId] != address(0);
1255     }
1256 
1257     /**
1258      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1259      *
1260      * Requirements:
1261      *
1262      * - `tokenId` must exist.
1263      */
1264     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1265         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1266         address owner = ERC721.ownerOf(tokenId);
1267         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1268     }
1269 
1270     /**
1271      * @dev Safely mints `tokenId` and transfers it to `to`.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must not exist.
1276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _safeMint(address to, uint256 tokenId) internal virtual {
1281         _safeMint(to, tokenId, "");
1282     }
1283 
1284     /**
1285      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1286      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1287      */
1288     function _safeMint(
1289         address to,
1290         uint256 tokenId,
1291         bytes memory _data
1292     ) internal virtual {
1293         _mint(to, tokenId);
1294         require(
1295             _checkOnERC721Received(address(0), to, tokenId, _data),
1296             "ERC721: transfer to non ERC721Receiver implementer"
1297         );
1298     }
1299 
1300     /**
1301      * @dev Mints `tokenId` and transfers it to `to`.
1302      *
1303      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must not exist.
1308      * - `to` cannot be the zero address.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _mint(address to, uint256 tokenId) internal virtual {
1313         require(to != address(0), "ERC721: mint to the zero address");
1314         require(!_exists(tokenId), "ERC721: token already minted");
1315 
1316         _beforeTokenTransfer(address(0), to, tokenId);
1317 
1318         _balances[to] += 1;
1319         _owners[tokenId] = to;
1320 
1321         emit Transfer(address(0), to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Destroys `tokenId`.
1326      * The approval is cleared when the token is burned.
1327      *
1328      * Requirements:
1329      *
1330      * - `tokenId` must exist.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _burn(uint256 tokenId) internal virtual {
1335         address owner = ERC721.ownerOf(tokenId);
1336 
1337         _beforeTokenTransfer(owner, address(0), tokenId);
1338 
1339         // Clear approvals
1340         _approve(address(0), tokenId);
1341 
1342         _balances[owner] -= 1;
1343         delete _owners[tokenId];
1344 
1345         emit Transfer(owner, address(0), tokenId);
1346     }
1347 
1348     /**
1349      * @dev Transfers `tokenId` from `from` to `to`.
1350      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1351      *
1352      * Requirements:
1353      *
1354      * - `to` cannot be the zero address.
1355      * - `tokenId` token must be owned by `from`.
1356      *
1357      * Emits a {Transfer} event.
1358      */
1359     function _transfer(
1360         address from,
1361         address to,
1362         uint256 tokenId
1363     ) internal virtual {
1364         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1365         require(to != address(0), "ERC721: transfer to the zero address");
1366 
1367         _beforeTokenTransfer(from, to, tokenId);
1368 
1369         // Clear approvals from the previous owner
1370         _approve(address(0), tokenId);
1371 
1372         _balances[from] -= 1;
1373         _balances[to] += 1;
1374         _owners[tokenId] = to;
1375 
1376         emit Transfer(from, to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev Approve `to` to operate on `tokenId`
1381      *
1382      * Emits a {Approval} event.
1383      */
1384     function _approve(address to, uint256 tokenId) internal virtual {
1385         _tokenApprovals[tokenId] = to;
1386         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev Approve `operator` to operate on all of `owner` tokens
1391      *
1392      * Emits a {ApprovalForAll} event.
1393      */
1394     function _setApprovalForAll(
1395         address owner,
1396         address operator,
1397         bool approved
1398     ) internal virtual {
1399         require(owner != operator, "ERC721: approve to caller");
1400         _operatorApprovals[owner][operator] = approved;
1401         emit ApprovalForAll(owner, operator, approved);
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
1422                 return retval == IERC721Receiver.onERC721Received.selector;
1423             } catch (bytes memory reason) {
1424                 if (reason.length == 0) {
1425                     revert("ERC721: transfer to non ERC721Receiver implementer");
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
1438      * @dev Hook that is called before any token transfer. This includes minting
1439      * and burning.
1440      *
1441      * Calling conditions:
1442      *
1443      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1444      * transferred to `to`.
1445      * - When `from` is zero, `tokenId` will be minted for `to`.
1446      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1447      * - `from` and `to` are never both zero.
1448      *
1449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1450      */
1451     function _beforeTokenTransfer(
1452         address from,
1453         address to,
1454         uint256 tokenId
1455     ) internal virtual {}
1456 }
1457 
1458 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1459 
1460 
1461 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 
1466 
1467 /**
1468  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1469  * enumerability of all the token ids in the contract as well as all token ids owned by each
1470  * account.
1471  */
1472 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1473     // Mapping from owner to list of owned token IDs
1474     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1475 
1476     // Mapping from token ID to index of the owner tokens list
1477     mapping(uint256 => uint256) private _ownedTokensIndex;
1478 
1479     // Array with all token ids, used for enumeration
1480     uint256[] private _allTokens;
1481 
1482     // Mapping from token id to position in the allTokens array
1483     mapping(uint256 => uint256) private _allTokensIndex;
1484 
1485     /**
1486      * @dev See {IERC165-supportsInterface}.
1487      */
1488     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1489         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1490     }
1491 
1492     /**
1493      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1494      */
1495     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1496         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1497         return _ownedTokens[owner][index];
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Enumerable-totalSupply}.
1502      */
1503     function totalSupply() public view virtual override returns (uint256) {
1504         return _allTokens.length;
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Enumerable-tokenByIndex}.
1509      */
1510     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1511         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1512         return _allTokens[index];
1513     }
1514 
1515     /**
1516      * @dev Hook that is called before any token transfer. This includes minting
1517      * and burning.
1518      *
1519      * Calling conditions:
1520      *
1521      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1522      * transferred to `to`.
1523      * - When `from` is zero, `tokenId` will be minted for `to`.
1524      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1525      * - `from` cannot be the zero address.
1526      * - `to` cannot be the zero address.
1527      *
1528      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1529      */
1530     function _beforeTokenTransfer(
1531         address from,
1532         address to,
1533         uint256 tokenId
1534     ) internal virtual override {
1535         super._beforeTokenTransfer(from, to, tokenId);
1536 
1537         if (from == address(0)) {
1538             _addTokenToAllTokensEnumeration(tokenId);
1539         } else if (from != to) {
1540             _removeTokenFromOwnerEnumeration(from, tokenId);
1541         }
1542         if (to == address(0)) {
1543             _removeTokenFromAllTokensEnumeration(tokenId);
1544         } else if (to != from) {
1545             _addTokenToOwnerEnumeration(to, tokenId);
1546         }
1547     }
1548 
1549     /**
1550      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1551      * @param to address representing the new owner of the given token ID
1552      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1553      */
1554     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1555         uint256 length = ERC721.balanceOf(to);
1556         _ownedTokens[to][length] = tokenId;
1557         _ownedTokensIndex[tokenId] = length;
1558     }
1559 
1560     /**
1561      * @dev Private function to add a token to this extension's token tracking data structures.
1562      * @param tokenId uint256 ID of the token to be added to the tokens list
1563      */
1564     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1565         _allTokensIndex[tokenId] = _allTokens.length;
1566         _allTokens.push(tokenId);
1567     }
1568 
1569     /**
1570      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1571      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1572      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1573      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1574      * @param from address representing the previous owner of the given token ID
1575      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1576      */
1577     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1578         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1579         // then delete the last slot (swap and pop).
1580 
1581         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1582         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1583 
1584         // When the token to delete is the last token, the swap operation is unnecessary
1585         if (tokenIndex != lastTokenIndex) {
1586             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1587 
1588             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1589             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1590         }
1591 
1592         // This also deletes the contents at the last position of the array
1593         delete _ownedTokensIndex[tokenId];
1594         delete _ownedTokens[from][lastTokenIndex];
1595     }
1596 
1597     /**
1598      * @dev Private function to remove a token from this extension's token tracking data structures.
1599      * This has O(1) time complexity, but alters the order of the _allTokens array.
1600      * @param tokenId uint256 ID of the token to be removed from the tokens list
1601      */
1602     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1603         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1604         // then delete the last slot (swap and pop).
1605 
1606         uint256 lastTokenIndex = _allTokens.length - 1;
1607         uint256 tokenIndex = _allTokensIndex[tokenId];
1608 
1609         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1610         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1611         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1612         uint256 lastTokenId = _allTokens[lastTokenIndex];
1613 
1614         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1615         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1616 
1617         // This also deletes the contents at the last position of the array
1618         delete _allTokensIndex[tokenId];
1619         _allTokens.pop();
1620     }
1621 }
1622 
1623 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1624 
1625 
1626 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1627 
1628 pragma solidity ^0.8.0;
1629 
1630 
1631 
1632 /**
1633  * @title ERC721 Burnable Token
1634  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1635  */
1636 abstract contract ERC721Burnable is Context, ERC721 {
1637     /**
1638      * @dev Burns `tokenId`. See {ERC721-_burn}.
1639      *
1640      * Requirements:
1641      *
1642      * - The caller must own `tokenId` or be an approved operator.
1643      */
1644     function burn(uint256 tokenId) public virtual {
1645         //solhint-disable-next-line max-line-length
1646         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1647         _burn(tokenId);
1648     }
1649 }
1650 
1651 // File: contracts/WgmiNFTContract.sol
1652 
1653 
1654 
1655 pragma solidity 0.8.7;
1656 
1657 
1658 
1659 
1660 
1661 
1662 
1663 
1664 /**
1665  * @title WgmiNFT Contract
1666  * @author @wgmi_io
1667  * https://wgmi.io
1668  */
1669 
1670 interface IWgmiRegister {
1671     function isAddressRegistered(address _account) external view returns (bool);
1672 }
1673 
1674 contract WgmiNFT is ERC721Burnable, ERC721Enumerable, ReentrancyGuard, Ownable {
1675     using Counters for Counters.Counter;
1676     using SafeMath for uint256;
1677 
1678     // Events
1679     event Claim(address indexed _address);
1680 
1681     Counters.Counter private _tokenIdTracker;
1682 
1683     // set on contract deployment
1684     uint256 public maxSupply;
1685 
1686     address private _wgmiRegisterAddress;
1687     string private _baseTokenURI;
1688     string private _contractURI;
1689 
1690     // 50 reserved for promotional purposes (i.e giveaways & contests)
1691     uint256 public wgmiReserve = 50;
1692     // Reserve can only be minted once
1693     bool public hasMintedReserve = false;
1694 
1695     // Enable/disable claim
1696     bool public isClaimActive = false;
1697 
1698     mapping(address => bool) private hasClaimed;
1699 
1700     // Construct with a name, symbol, max supply, and base token URI.
1701     constructor(
1702         string memory name,
1703         string memory symbol,
1704         uint256 _maxSupply,
1705         string memory baseTokenURI
1706     ) ERC721(name, symbol) {
1707         maxSupply = _maxSupply;
1708         _baseTokenURI = baseTokenURI;
1709         // Sets token ID to start at '1' for UX.
1710         _tokenIdTracker.increment();
1711     }
1712 
1713     function _baseURI() internal view override returns (string memory) {
1714         return _baseTokenURI;
1715     }
1716 
1717     function baseURI() public view returns (string memory) {
1718         return _baseURI();
1719     }
1720 
1721     function wgmiRegisterAddress() public view returns (address) {
1722         return _wgmiRegisterAddress;
1723     }
1724 
1725     function contractURI() public view returns (string memory) {
1726         return _contractURI;
1727     }
1728 
1729     function _beforeTokenTransfer(
1730         address from,
1731         address to,
1732         uint256 tokenId
1733     ) internal override(ERC721, ERC721Enumerable) {
1734         super._beforeTokenTransfer(from, to, tokenId);
1735     }
1736 
1737     // See {IERC165-supportsInterface}.
1738     function supportsInterface(bytes4 interfaceId)
1739     public
1740     view
1741     override(ERC721, ERC721Enumerable)
1742     returns (bool)
1743     {
1744         return super.supportsInterface(interfaceId);
1745     }
1746 
1747     // Check if an address is eligible to claim NFT
1748     function canClaim(address _address) public view returns (bool) {
1749         return
1750         IWgmiRegister(_wgmiRegisterAddress).isAddressRegistered(_address) &&
1751         !hasClaimed[_address];
1752     }
1753 
1754     // Claim WgmiNFT
1755     function claim() external nonReentrant {
1756         require(isClaimActive == true, "Claim is not active");
1757         address _claimer = _msgSender();
1758 
1759         bool _canClaim = canClaim(_claimer);
1760         require(_canClaim == true, "Not eligible to claim");
1761 
1762         uint256 _totalSupply = totalSupply();
1763         uint256 total = _totalSupply.add(1);
1764         require(total <= maxSupply, "Claim would exceed max supply");
1765 
1766         hasClaimed[_claimer] = true;
1767         _safeMint(_msgSender(), _tokenIdTracker.current());
1768         _tokenIdTracker.increment();
1769 
1770         emit Claim(_claimer);
1771     }
1772 
1773     /*
1774      *   ADMIN FUNCTIONS
1775      */
1776 
1777     // Allows `owner` to toggle if claiming is active
1778     function toggleIsClaimActive() external nonReentrant onlyOwner {
1779         isClaimActive = !isClaimActive;
1780     }
1781 
1782     function withdraw() external nonReentrant onlyOwner {
1783         address owner = _msgSender();
1784         uint256 balance = address(this).balance;
1785         payable(owner).transfer(balance);
1786     }
1787 
1788     // Ability to change the URI. i.e self hosted api -> ipfs
1789     function setBaseURI(string memory _newBaseURI)
1790     external
1791     nonReentrant
1792     onlyOwner
1793     {
1794         _baseTokenURI = _newBaseURI;
1795     }
1796 
1797     // Ability to change the contractURI. i.e self hosted api -> ipfs
1798     function setContractURI(string memory _newContractURI)
1799     external
1800     nonReentrant
1801     onlyOwner
1802     {
1803         _contractURI = _newContractURI;
1804     }
1805 
1806     // Set the OG WGMI Contract
1807     function setWgmiRegisterAddress(address _newWgmiRegisterAddress)
1808     external
1809     nonReentrant
1810     onlyOwner
1811     {
1812         _wgmiRegisterAddress = _newWgmiRegisterAddress;
1813     }
1814 
1815     // 50 reserved for promotional purposes (i.e giveaways & contests).
1816     function mintReserve() external nonReentrant onlyOwner {
1817         require(hasMintedReserve == false, "Has already claimed reserve");
1818         uint256 _totalSupply = totalSupply();
1819         uint256 total = _totalSupply.add(wgmiReserve);
1820         require(total <= maxSupply, "Claim would exceed max supply");
1821 
1822         for (uint256 i = 0; i < wgmiReserve; i++) {
1823             if (totalSupply() <= maxSupply) {
1824                 _safeMint(_msgSender(), _tokenIdTracker.current());
1825                 _tokenIdTracker.increment();
1826             }
1827         }
1828         hasMintedReserve = true;
1829     }
1830 }