1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
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
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
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
231 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Contract module that helps prevent reentrant calls to a function.
240  *
241  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
242  * available, which can be applied to functions to make sure there are no nested
243  * (reentrant) calls to them.
244  *
245  * Note that because there is a single `nonReentrant` guard, functions marked as
246  * `nonReentrant` may not call one another. This can be worked around by making
247  * those functions `private`, and then adding `external` `nonReentrant` entry
248  * points to them.
249  *
250  * TIP: If you would like to learn more about reentrancy and alternative ways
251  * to protect against it, check out our blog post
252  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
253  */
254 abstract contract ReentrancyGuard {
255     // Booleans are more expensive than uint256 or any type that takes up a full
256     // word because each write operation emits an extra SLOAD to first read the
257     // slot's contents, replace the bits taken up by the boolean, and then write
258     // back. This is the compiler's defense against contract upgrades and
259     // pointer aliasing, and it cannot be disabled.
260 
261     // The values being non-zero value makes deployment a bit more expensive,
262     // but in exchange the refund on every call to nonReentrant will be lower in
263     // amount. Since refunds are capped to a percentage of the total
264     // transaction's gas, it is best to keep them low in cases like this one, to
265     // increase the likelihood of the full refund coming into effect.
266     uint256 private constant _NOT_ENTERED = 1;
267     uint256 private constant _ENTERED = 2;
268 
269     uint256 private _status;
270 
271     constructor() {
272         _status = _NOT_ENTERED;
273     }
274 
275     /**
276      * @dev Prevents a contract from calling itself, directly or indirectly.
277      * Calling a `nonReentrant` function from another `nonReentrant`
278      * function is not supported. It is possible to prevent this from happening
279      * by making the `nonReentrant` function external, and making it call a
280      * `private` function that does the actual work.
281      */
282     modifier nonReentrant() {
283         // On the first call to nonReentrant, _notEntered will be true
284         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
285 
286         // Any calls to nonReentrant after this point will fail
287         _status = _ENTERED;
288 
289         _;
290 
291         // By storing the original value once again, a refund is triggered (see
292         // https://eips.ethereum.org/EIPS/eip-2200)
293         _status = _NOT_ENTERED;
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Strings.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev String operations.
306  */
307 library Strings {
308     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
312      */
313     function toString(uint256 value) internal pure returns (string memory) {
314         // Inspired by OraclizeAPI's implementation - MIT licence
315         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
316 
317         if (value == 0) {
318             return "0";
319         }
320         uint256 temp = value;
321         uint256 digits;
322         while (temp != 0) {
323             digits++;
324             temp /= 10;
325         }
326         bytes memory buffer = new bytes(digits);
327         while (value != 0) {
328             digits -= 1;
329             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
330             value /= 10;
331         }
332         return string(buffer);
333     }
334 
335     /**
336      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
337      */
338     function toHexString(uint256 value) internal pure returns (string memory) {
339         if (value == 0) {
340             return "0x00";
341         }
342         uint256 temp = value;
343         uint256 length = 0;
344         while (temp != 0) {
345             length++;
346             temp >>= 8;
347         }
348         return toHexString(value, length);
349     }
350 
351     /**
352      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
353      */
354     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
355         bytes memory buffer = new bytes(2 * length + 2);
356         buffer[0] = "0";
357         buffer[1] = "x";
358         for (uint256 i = 2 * length + 1; i > 1; --i) {
359             buffer[i] = _HEX_SYMBOLS[value & 0xf];
360             value >>= 4;
361         }
362         require(value == 0, "Strings: hex length insufficient");
363         return string(buffer);
364     }
365 }
366 
367 // File: @openzeppelin/contracts/utils/Context.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes calldata) {
390         return msg.data;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/access/Ownable.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 abstract contract Ownable is Context {
415     address private _owner;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor() {
423         _transferOwnership(_msgSender());
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view virtual returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(owner() == _msgSender(), "Ownable: caller is not the owner");
438         _;
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/Address.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
476 
477 pragma solidity ^0.8.1;
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      *
500      * [IMPORTANT]
501      * ====
502      * You shouldn't rely on `isContract` to protect against flash loan attacks!
503      *
504      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
505      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
506      * constructor.
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // This method relies on extcodesize/address.code.length, which returns 0
511         // for contracts in construction, since the code is only stored at the end
512         // of the constructor execution.
513 
514         return account.code.length > 0;
515     }
516 
517     /**
518      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
519      * `recipient`, forwarding all available gas and reverting on errors.
520      *
521      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
522      * of certain opcodes, possibly making contracts go over the 2300 gas limit
523      * imposed by `transfer`, making them unable to receive funds via
524      * `transfer`. {sendValue} removes this limitation.
525      *
526      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
527      *
528      * IMPORTANT: because control is transferred to `recipient`, care must be
529      * taken to not create reentrancy vulnerabilities. Consider using
530      * {ReentrancyGuard} or the
531      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
532      */
533     function sendValue(address payable recipient, uint256 amount) internal {
534         require(address(this).balance >= amount, "Address: insufficient balance");
535 
536         (bool success, ) = recipient.call{value: amount}("");
537         require(success, "Address: unable to send value, recipient may have reverted");
538     }
539 
540     /**
541      * @dev Performs a Solidity function call using a low level `call`. A
542      * plain `call` is an unsafe replacement for a function call: use this
543      * function instead.
544      *
545      * If `target` reverts with a revert reason, it is bubbled up by this
546      * function (like regular Solidity function calls).
547      *
548      * Returns the raw returned data. To convert to the expected return value,
549      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
550      *
551      * Requirements:
552      *
553      * - `target` must be a contract.
554      * - calling `target` with `data` must not revert.
555      *
556      * _Available since v3.1._
557      */
558     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionCall(target, data, "Address: low-level call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
564      * `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, 0, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but also transferring `value` wei to `target`.
579      *
580      * Requirements:
581      *
582      * - the calling contract must have an ETH balance of at least `value`.
583      * - the called Solidity function must be `payable`.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value
591     ) internal returns (bytes memory) {
592         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
597      * with `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(address(this).balance >= value, "Address: insufficient balance for call");
608         require(isContract(target), "Address: call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.call{value: value}(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a static call.
617      *
618      * _Available since v3.3._
619      */
620     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
621         return functionStaticCall(target, data, "Address: low-level static call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal view returns (bytes memory) {
635         require(isContract(target), "Address: static call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.staticcall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but performing a delegate call.
644      *
645      * _Available since v3.4._
646      */
647     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
648         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal returns (bytes memory) {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.delegatecall(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
670      * revert reason using the provided one.
671      *
672      * _Available since v4.3._
673      */
674     function verifyCallResult(
675         bool success,
676         bytes memory returndata,
677         string memory errorMessage
678     ) internal pure returns (bytes memory) {
679         if (success) {
680             return returndata;
681         } else {
682             // Look for revert reason and bubble it up if present
683             if (returndata.length > 0) {
684                 // The easiest way to bubble the revert reason is using memory via assembly
685 
686                 assembly {
687                     let returndata_size := mload(returndata)
688                     revert(add(32, returndata), returndata_size)
689                 }
690             } else {
691                 revert(errorMessage);
692             }
693         }
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @title ERC721 token receiver interface
706  * @dev Interface for any contract that wants to support safeTransfers
707  * from ERC721 asset contracts.
708  */
709 interface IERC721Receiver {
710     /**
711      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
712      * by `operator` from `from`, this function is called.
713      *
714      * It must return its Solidity selector to confirm the token transfer.
715      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
716      *
717      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
718      */
719     function onERC721Received(
720         address operator,
721         address from,
722         uint256 tokenId,
723         bytes calldata data
724     ) external returns (bytes4);
725 }
726 
727 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
758 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Implementation of the {IERC165} interface.
765  *
766  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
767  * for the additional interface id that will be supported. For example:
768  *
769  * ```solidity
770  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
772  * }
773  * ```
774  *
775  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
776  */
777 abstract contract ERC165 is IERC165 {
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
787 
788 
789 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Required interface of an ERC721 compliant contract.
796  */
797 interface IERC721 is IERC165 {
798     /**
799      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
800      */
801     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
805      */
806     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
807 
808     /**
809      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
810      */
811     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
812 
813     /**
814      * @dev Returns the number of tokens in ``owner``'s account.
815      */
816     function balanceOf(address owner) external view returns (uint256 balance);
817 
818     /**
819      * @dev Returns the owner of the `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function ownerOf(uint256 tokenId) external view returns (address owner);
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must exist and be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes calldata data
845     ) external;
846 
847     /**
848      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
849      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
850      *
851      * Requirements:
852      *
853      * - `from` cannot be the zero address.
854      * - `to` cannot be the zero address.
855      * - `tokenId` token must exist and be owned by `from`.
856      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) external;
866 
867     /**
868      * @dev Transfers `tokenId` token from `from` to `to`.
869      *
870      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must be owned by `from`.
877      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
878      *
879      * Emits a {Transfer} event.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) external;
886 
887     /**
888      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
889      * The approval is cleared when the token is transferred.
890      *
891      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
892      *
893      * Requirements:
894      *
895      * - The caller must own the token or be an approved operator.
896      * - `tokenId` must exist.
897      *
898      * Emits an {Approval} event.
899      */
900     function approve(address to, uint256 tokenId) external;
901 
902     /**
903      * @dev Approve or remove `operator` as an operator for the caller.
904      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
905      *
906      * Requirements:
907      *
908      * - The `operator` cannot be the caller.
909      *
910      * Emits an {ApprovalForAll} event.
911      */
912     function setApprovalForAll(address operator, bool _approved) external;
913 
914     /**
915      * @dev Returns the account approved for `tokenId` token.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function getApproved(uint256 tokenId) external view returns (address operator);
922 
923     /**
924      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
925      *
926      * See {setApprovalForAll}
927      */
928     function isApprovedForAll(address owner, address operator) external view returns (bool);
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
932 
933 
934 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Enumerable is IERC721 {
944     /**
945      * @dev Returns the total amount of tokens stored by the contract.
946      */
947     function totalSupply() external view returns (uint256);
948 
949     /**
950      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
951      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
952      */
953     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
957      * Use along with {totalSupply} to enumerate all tokens.
958      */
959     function tokenByIndex(uint256 index) external view returns (uint256);
960 }
961 
962 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 
970 /**
971  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
972  * @dev See https://eips.ethereum.org/EIPS/eip-721
973  */
974 interface IERC721Metadata is IERC721 {
975     /**
976      * @dev Returns the token collection name.
977      */
978     function name() external view returns (string memory);
979 
980     /**
981      * @dev Returns the token collection symbol.
982      */
983     function symbol() external view returns (string memory);
984 
985     /**
986      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
987      */
988     function tokenURI(uint256 tokenId) external view returns (string memory);
989 }
990 
991 // File: erc721a/contracts/ERC721A.sol
992 
993 
994 // Creator: Chiru Labs
995 
996 pragma solidity ^0.8.4;
997 
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 error ApprovalCallerNotOwnerNorApproved();
1006 error ApprovalQueryForNonexistentToken();
1007 error ApproveToCaller();
1008 error ApprovalToCurrentOwner();
1009 error BalanceQueryForZeroAddress();
1010 error MintToZeroAddress();
1011 error MintZeroQuantity();
1012 error OwnerQueryForNonexistentToken();
1013 error TransferCallerNotOwnerNorApproved();
1014 error TransferFromIncorrectOwner();
1015 error TransferToNonERC721ReceiverImplementer();
1016 error TransferToZeroAddress();
1017 error URIQueryForNonexistentToken();
1018 
1019 /**
1020  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1021  * the Metadata extension. Built to optimize for lower gas during batch mints.
1022  *
1023  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1024  *
1025  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1026  *
1027  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1028  */
1029 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1030     using Address for address;
1031     using Strings for uint256;
1032 
1033     // Compiler will pack this into a single 256bit word.
1034     struct TokenOwnership {
1035         // The address of the owner.
1036         address addr;
1037         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1038         uint64 startTimestamp;
1039         // Whether the token has been burned.
1040         bool burned;
1041     }
1042 
1043     // Compiler will pack this into a single 256bit word.
1044     struct AddressData {
1045         // Realistically, 2**64-1 is more than enough.
1046         uint64 balance;
1047         // Keeps track of mint count with minimal overhead for tokenomics.
1048         uint64 numberMinted;
1049         // Keeps track of burn count with minimal overhead for tokenomics.
1050         uint64 numberBurned;
1051         // For miscellaneous variable(s) pertaining to the address
1052         // (e.g. number of whitelist mint slots used).
1053         // If there are multiple variables, please pack them into a uint64.
1054         uint64 aux;
1055     }
1056 
1057     // The tokenId of the next token to be minted.
1058     uint256 internal _currentIndex;
1059 
1060     // The number of tokens burned.
1061     uint256 internal _burnCounter;
1062 
1063     // Token name
1064     string private _name;
1065 
1066     // Token symbol
1067     string private _symbol;
1068 
1069     // Mapping from token ID to ownership details
1070     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1071     mapping(uint256 => TokenOwnership) internal _ownerships;
1072 
1073     // Mapping owner address to address data
1074     mapping(address => AddressData) private _addressData;
1075 
1076     // Mapping from token ID to approved address
1077     mapping(uint256 => address) private _tokenApprovals;
1078 
1079     // Mapping from owner to operator approvals
1080     mapping(address => mapping(address => bool)) private _operatorApprovals;
1081 
1082     constructor(string memory name_, string memory symbol_) {
1083         _name = name_;
1084         _symbol = symbol_;
1085         _currentIndex = _startTokenId();
1086     }
1087 
1088     /**
1089      * To change the starting tokenId, please override this function.
1090      */
1091     function _startTokenId() internal view virtual returns (uint256) {
1092         return 0;
1093     }
1094 
1095     /**
1096      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1097      */
1098     function totalSupply() public view returns (uint256) {
1099         // Counter underflow is impossible as _burnCounter cannot be incremented
1100         // more than _currentIndex - _startTokenId() times
1101         unchecked {
1102             return _currentIndex - _burnCounter - _startTokenId();
1103         }
1104     }
1105 
1106     /**
1107      * Returns the total amount of tokens minted in the contract.
1108      */
1109     function _totalMinted() internal view returns (uint256) {
1110         // Counter underflow is impossible as _currentIndex does not decrement,
1111         // and it is initialized to _startTokenId()
1112         unchecked {
1113             return _currentIndex - _startTokenId();
1114         }
1115     }
1116 
1117     /**
1118      * @dev See {IERC165-supportsInterface}.
1119      */
1120     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1121         return
1122             interfaceId == type(IERC721).interfaceId ||
1123             interfaceId == type(IERC721Metadata).interfaceId ||
1124             super.supportsInterface(interfaceId);
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-balanceOf}.
1129      */
1130     function balanceOf(address owner) public view override returns (uint256) {
1131         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1132         return uint256(_addressData[owner].balance);
1133     }
1134 
1135     /**
1136      * Returns the number of tokens minted by `owner`.
1137      */
1138     function _numberMinted(address owner) internal view returns (uint256) {
1139         return uint256(_addressData[owner].numberMinted);
1140     }
1141 
1142     /**
1143      * Returns the number of tokens burned by or on behalf of `owner`.
1144      */
1145     function _numberBurned(address owner) internal view returns (uint256) {
1146         return uint256(_addressData[owner].numberBurned);
1147     }
1148 
1149     /**
1150      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1151      */
1152     function _getAux(address owner) internal view returns (uint64) {
1153         return _addressData[owner].aux;
1154     }
1155 
1156     /**
1157      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1158      * If there are multiple variables, please pack them into a uint64.
1159      */
1160     function _setAux(address owner, uint64 aux) internal {
1161         _addressData[owner].aux = aux;
1162     }
1163 
1164     /**
1165      * Gas spent here starts off proportional to the maximum mint batch size.
1166      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1167      */
1168     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1169         uint256 curr = tokenId;
1170 
1171         unchecked {
1172             if (_startTokenId() <= curr && curr < _currentIndex) {
1173                 TokenOwnership memory ownership = _ownerships[curr];
1174                 if (!ownership.burned) {
1175                     if (ownership.addr != address(0)) {
1176                         return ownership;
1177                     }
1178                     // Invariant:
1179                     // There will always be an ownership that has an address and is not burned
1180                     // before an ownership that does not have an address and is not burned.
1181                     // Hence, curr will not underflow.
1182                     while (true) {
1183                         curr--;
1184                         ownership = _ownerships[curr];
1185                         if (ownership.addr != address(0)) {
1186                             return ownership;
1187                         }
1188                     }
1189                 }
1190             }
1191         }
1192         revert OwnerQueryForNonexistentToken();
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-ownerOf}.
1197      */
1198     function ownerOf(uint256 tokenId) public view override returns (address) {
1199         return _ownershipOf(tokenId).addr;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Metadata-name}.
1204      */
1205     function name() public view virtual override returns (string memory) {
1206         return _name;
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Metadata-symbol}.
1211      */
1212     function symbol() public view virtual override returns (string memory) {
1213         return _symbol;
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Metadata-tokenURI}.
1218      */
1219     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1220         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1221 
1222         string memory baseURI = _baseURI();
1223         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1224     }
1225 
1226     /**
1227      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1228      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1229      * by default, can be overriden in child contracts.
1230      */
1231     function _baseURI() internal view virtual returns (string memory) {
1232         return '';
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-approve}.
1237      */
1238     function approve(address to, uint256 tokenId) public override {
1239         address owner = ERC721A.ownerOf(tokenId);
1240         if (to == owner) revert ApprovalToCurrentOwner();
1241 
1242         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1243             revert ApprovalCallerNotOwnerNorApproved();
1244         }
1245 
1246         _approve(to, tokenId, owner);
1247     }
1248 
1249     /**
1250      * @dev See {IERC721-getApproved}.
1251      */
1252     function getApproved(uint256 tokenId) public view override returns (address) {
1253         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1254 
1255         return _tokenApprovals[tokenId];
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-setApprovalForAll}.
1260      */
1261     function setApprovalForAll(address operator, bool approved) public virtual override {
1262         if (operator == _msgSender()) revert ApproveToCaller();
1263 
1264         _operatorApprovals[_msgSender()][operator] = approved;
1265         emit ApprovalForAll(_msgSender(), operator, approved);
1266     }
1267 
1268     /**
1269      * @dev See {IERC721-isApprovedForAll}.
1270      */
1271     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1272         return _operatorApprovals[owner][operator];
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-transferFrom}.
1277      */
1278     function transferFrom(
1279         address from,
1280         address to,
1281         uint256 tokenId
1282     ) public virtual override {
1283         _transfer(from, to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-safeTransferFrom}.
1288      */
1289     function safeTransferFrom(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) public virtual override {
1294         safeTransferFrom(from, to, tokenId, '');
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-safeTransferFrom}.
1299      */
1300     function safeTransferFrom(
1301         address from,
1302         address to,
1303         uint256 tokenId,
1304         bytes memory _data
1305     ) public virtual override {
1306         _transfer(from, to, tokenId);
1307         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1308             revert TransferToNonERC721ReceiverImplementer();
1309         }
1310     }
1311 
1312     /**
1313      * @dev Returns whether `tokenId` exists.
1314      *
1315      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1316      *
1317      * Tokens start existing when they are minted (`_mint`),
1318      */
1319     function _exists(uint256 tokenId) internal view returns (bool) {
1320         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1321     }
1322 
1323     function _safeMint(address to, uint256 quantity) internal {
1324         _safeMint(to, quantity, '');
1325     }
1326 
1327     /**
1328      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1329      *
1330      * Requirements:
1331      *
1332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1333      * - `quantity` must be greater than 0.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _safeMint(
1338         address to,
1339         uint256 quantity,
1340         bytes memory _data
1341     ) internal {
1342         _mint(to, quantity, _data, true);
1343     }
1344 
1345     /**
1346      * @dev Mints `quantity` tokens and transfers them to `to`.
1347      *
1348      * Requirements:
1349      *
1350      * - `to` cannot be the zero address.
1351      * - `quantity` must be greater than 0.
1352      *
1353      * Emits a {Transfer} event.
1354      */
1355     function _mint(
1356         address to,
1357         uint256 quantity,
1358         bytes memory _data,
1359         bool safe
1360     ) internal {
1361         uint256 startTokenId = _currentIndex;
1362         if (to == address(0)) revert MintToZeroAddress();
1363         if (quantity == 0) revert MintZeroQuantity();
1364 
1365         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1366 
1367         // Overflows are incredibly unrealistic.
1368         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1369         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1370         unchecked {
1371             _addressData[to].balance += uint64(quantity);
1372             _addressData[to].numberMinted += uint64(quantity);
1373 
1374             _ownerships[startTokenId].addr = to;
1375             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1376 
1377             uint256 updatedIndex = startTokenId;
1378             uint256 end = updatedIndex + quantity;
1379 
1380             if (safe && to.isContract()) {
1381                 do {
1382                     emit Transfer(address(0), to, updatedIndex);
1383                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1384                         revert TransferToNonERC721ReceiverImplementer();
1385                     }
1386                 } while (updatedIndex != end);
1387                 // Reentrancy protection
1388                 if (_currentIndex != startTokenId) revert();
1389             } else {
1390                 do {
1391                     emit Transfer(address(0), to, updatedIndex++);
1392                 } while (updatedIndex != end);
1393             }
1394             _currentIndex = updatedIndex;
1395         }
1396         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1397     }
1398 
1399     /**
1400      * @dev Transfers `tokenId` from `from` to `to`.
1401      *
1402      * Requirements:
1403      *
1404      * - `to` cannot be the zero address.
1405      * - `tokenId` token must be owned by `from`.
1406      *
1407      * Emits a {Transfer} event.
1408      */
1409     function _transfer(
1410         address from,
1411         address to,
1412         uint256 tokenId
1413     ) private {
1414         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1415 
1416         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1417 
1418         bool isApprovedOrOwner = (_msgSender() == from ||
1419             isApprovedForAll(from, _msgSender()) ||
1420             getApproved(tokenId) == _msgSender());
1421 
1422         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1423         if (to == address(0)) revert TransferToZeroAddress();
1424 
1425         _beforeTokenTransfers(from, to, tokenId, 1);
1426 
1427         // Clear approvals from the previous owner
1428         _approve(address(0), tokenId, from);
1429 
1430         // Underflow of the sender's balance is impossible because we check for
1431         // ownership above and the recipient's balance can't realistically overflow.
1432         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1433         unchecked {
1434             _addressData[from].balance -= 1;
1435             _addressData[to].balance += 1;
1436 
1437             TokenOwnership storage currSlot = _ownerships[tokenId];
1438             currSlot.addr = to;
1439             currSlot.startTimestamp = uint64(block.timestamp);
1440 
1441             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1442             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1443             uint256 nextTokenId = tokenId + 1;
1444             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1445             if (nextSlot.addr == address(0)) {
1446                 // This will suffice for checking _exists(nextTokenId),
1447                 // as a burned slot cannot contain the zero address.
1448                 if (nextTokenId != _currentIndex) {
1449                     nextSlot.addr = from;
1450                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1451                 }
1452             }
1453         }
1454 
1455         emit Transfer(from, to, tokenId);
1456         _afterTokenTransfers(from, to, tokenId, 1);
1457     }
1458 
1459     /**
1460      * @dev This is equivalent to _burn(tokenId, false)
1461      */
1462     function _burn(uint256 tokenId) internal virtual {
1463         _burn(tokenId, false);
1464     }
1465 
1466     /**
1467      * @dev Destroys `tokenId`.
1468      * The approval is cleared when the token is burned.
1469      *
1470      * Requirements:
1471      *
1472      * - `tokenId` must exist.
1473      *
1474      * Emits a {Transfer} event.
1475      */
1476     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1477         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1478 
1479         address from = prevOwnership.addr;
1480 
1481         if (approvalCheck) {
1482             bool isApprovedOrOwner = (_msgSender() == from ||
1483                 isApprovedForAll(from, _msgSender()) ||
1484                 getApproved(tokenId) == _msgSender());
1485 
1486             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1487         }
1488 
1489         _beforeTokenTransfers(from, address(0), tokenId, 1);
1490 
1491         // Clear approvals from the previous owner
1492         _approve(address(0), tokenId, from);
1493 
1494         // Underflow of the sender's balance is impossible because we check for
1495         // ownership above and the recipient's balance can't realistically overflow.
1496         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1497         unchecked {
1498             AddressData storage addressData = _addressData[from];
1499             addressData.balance -= 1;
1500             addressData.numberBurned += 1;
1501 
1502             // Keep track of who burned the token, and the timestamp of burning.
1503             TokenOwnership storage currSlot = _ownerships[tokenId];
1504             currSlot.addr = from;
1505             currSlot.startTimestamp = uint64(block.timestamp);
1506             currSlot.burned = true;
1507 
1508             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1509             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1510             uint256 nextTokenId = tokenId + 1;
1511             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1512             if (nextSlot.addr == address(0)) {
1513                 // This will suffice for checking _exists(nextTokenId),
1514                 // as a burned slot cannot contain the zero address.
1515                 if (nextTokenId != _currentIndex) {
1516                     nextSlot.addr = from;
1517                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1518                 }
1519             }
1520         }
1521 
1522         emit Transfer(from, address(0), tokenId);
1523         _afterTokenTransfers(from, address(0), tokenId, 1);
1524 
1525         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1526         unchecked {
1527             _burnCounter++;
1528         }
1529     }
1530 
1531     /**
1532      * @dev Approve `to` to operate on `tokenId`
1533      *
1534      * Emits a {Approval} event.
1535      */
1536     function _approve(
1537         address to,
1538         uint256 tokenId,
1539         address owner
1540     ) private {
1541         _tokenApprovals[tokenId] = to;
1542         emit Approval(owner, to, tokenId);
1543     }
1544 
1545     /**
1546      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1547      *
1548      * @param from address representing the previous owner of the given token ID
1549      * @param to target address that will receive the tokens
1550      * @param tokenId uint256 ID of the token to be transferred
1551      * @param _data bytes optional data to send along with the call
1552      * @return bool whether the call correctly returned the expected magic value
1553      */
1554     function _checkContractOnERC721Received(
1555         address from,
1556         address to,
1557         uint256 tokenId,
1558         bytes memory _data
1559     ) private returns (bool) {
1560         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1561             return retval == IERC721Receiver(to).onERC721Received.selector;
1562         } catch (bytes memory reason) {
1563             if (reason.length == 0) {
1564                 revert TransferToNonERC721ReceiverImplementer();
1565             } else {
1566                 assembly {
1567                     revert(add(32, reason), mload(reason))
1568                 }
1569             }
1570         }
1571     }
1572 
1573     /**
1574      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1575      * And also called before burning one token.
1576      *
1577      * startTokenId - the first token id to be transferred
1578      * quantity - the amount to be transferred
1579      *
1580      * Calling conditions:
1581      *
1582      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1583      * transferred to `to`.
1584      * - When `from` is zero, `tokenId` will be minted for `to`.
1585      * - When `to` is zero, `tokenId` will be burned by `from`.
1586      * - `from` and `to` are never both zero.
1587      */
1588     function _beforeTokenTransfers(
1589         address from,
1590         address to,
1591         uint256 startTokenId,
1592         uint256 quantity
1593     ) internal virtual {}
1594 
1595     /**
1596      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1597      * minting.
1598      * And also called after one token has been burned.
1599      *
1600      * startTokenId - the first token id to be transferred
1601      * quantity - the amount to be transferred
1602      *
1603      * Calling conditions:
1604      *
1605      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1606      * transferred to `to`.
1607      * - When `from` is zero, `tokenId` has been minted for `to`.
1608      * - When `to` is zero, `tokenId` has been burned by `from`.
1609      * - `from` and `to` are never both zero.
1610      */
1611     function _afterTokenTransfers(
1612         address from,
1613         address to,
1614         uint256 startTokenId,
1615         uint256 quantity
1616     ) internal virtual {}
1617 }
1618 
1619 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1620 
1621 
1622 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1623 
1624 pragma solidity ^0.8.0;
1625 
1626 
1627 
1628 
1629 
1630 
1631 
1632 
1633 /**
1634  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1635  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1636  * {ERC721Enumerable}.
1637  */
1638 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1639     using Address for address;
1640     using Strings for uint256;
1641 
1642     // Token name
1643     string private _name;
1644 
1645     // Token symbol
1646     string private _symbol;
1647 
1648     // Mapping from token ID to owner address
1649     mapping(uint256 => address) private _owners;
1650 
1651     // Mapping owner address to token count
1652     mapping(address => uint256) private _balances;
1653 
1654     // Mapping from token ID to approved address
1655     mapping(uint256 => address) private _tokenApprovals;
1656 
1657     // Mapping from owner to operator approvals
1658     mapping(address => mapping(address => bool)) private _operatorApprovals;
1659 
1660     /**
1661      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1662      */
1663     constructor(string memory name_, string memory symbol_) {
1664         _name = name_;
1665         _symbol = symbol_;
1666     }
1667 
1668     /**
1669      * @dev See {IERC165-supportsInterface}.
1670      */
1671     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1672         return
1673             interfaceId == type(IERC721).interfaceId ||
1674             interfaceId == type(IERC721Metadata).interfaceId ||
1675             super.supportsInterface(interfaceId);
1676     }
1677 
1678     /**
1679      * @dev See {IERC721-balanceOf}.
1680      */
1681     function balanceOf(address owner) public view virtual override returns (uint256) {
1682         require(owner != address(0), "ERC721: balance query for the zero address");
1683         return _balances[owner];
1684     }
1685 
1686     /**
1687      * @dev See {IERC721-ownerOf}.
1688      */
1689     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1690         address owner = _owners[tokenId];
1691         require(owner != address(0), "ERC721: owner query for nonexistent token");
1692         return owner;
1693     }
1694 
1695     /**
1696      * @dev See {IERC721Metadata-name}.
1697      */
1698     function name() public view virtual override returns (string memory) {
1699         return _name;
1700     }
1701 
1702     /**
1703      * @dev See {IERC721Metadata-symbol}.
1704      */
1705     function symbol() public view virtual override returns (string memory) {
1706         return _symbol;
1707     }
1708 
1709     /**
1710      * @dev See {IERC721Metadata-tokenURI}.
1711      */
1712     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1713         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1714 
1715         string memory baseURI = _baseURI();
1716         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1717     }
1718 
1719     /**
1720      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1721      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1722      * by default, can be overridden in child contracts.
1723      */
1724     function _baseURI() internal view virtual returns (string memory) {
1725         return "";
1726     }
1727 
1728     /**
1729      * @dev See {IERC721-approve}.
1730      */
1731     function approve(address to, uint256 tokenId) public virtual override {
1732         address owner = ERC721.ownerOf(tokenId);
1733         require(to != owner, "ERC721: approval to current owner");
1734 
1735         require(
1736             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1737             "ERC721: approve caller is not owner nor approved for all"
1738         );
1739 
1740         _approve(to, tokenId);
1741     }
1742 
1743     /**
1744      * @dev See {IERC721-getApproved}.
1745      */
1746     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1747         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1748 
1749         return _tokenApprovals[tokenId];
1750     }
1751 
1752     /**
1753      * @dev See {IERC721-setApprovalForAll}.
1754      */
1755     function setApprovalForAll(address operator, bool approved) public virtual override {
1756         _setApprovalForAll(_msgSender(), operator, approved);
1757     }
1758 
1759     /**
1760      * @dev See {IERC721-isApprovedForAll}.
1761      */
1762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1763         return _operatorApprovals[owner][operator];
1764     }
1765 
1766     /**
1767      * @dev See {IERC721-transferFrom}.
1768      */
1769     function transferFrom(
1770         address from,
1771         address to,
1772         uint256 tokenId
1773     ) public virtual override {
1774         //solhint-disable-next-line max-line-length
1775         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1776 
1777         _transfer(from, to, tokenId);
1778     }
1779 
1780     /**
1781      * @dev See {IERC721-safeTransferFrom}.
1782      */
1783     function safeTransferFrom(
1784         address from,
1785         address to,
1786         uint256 tokenId
1787     ) public virtual override {
1788         safeTransferFrom(from, to, tokenId, "");
1789     }
1790 
1791     /**
1792      * @dev See {IERC721-safeTransferFrom}.
1793      */
1794     function safeTransferFrom(
1795         address from,
1796         address to,
1797         uint256 tokenId,
1798         bytes memory _data
1799     ) public virtual override {
1800         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1801         _safeTransfer(from, to, tokenId, _data);
1802     }
1803 
1804     /**
1805      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1806      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1807      *
1808      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1809      *
1810      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1811      * implement alternative mechanisms to perform token transfer, such as signature-based.
1812      *
1813      * Requirements:
1814      *
1815      * - `from` cannot be the zero address.
1816      * - `to` cannot be the zero address.
1817      * - `tokenId` token must exist and be owned by `from`.
1818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1819      *
1820      * Emits a {Transfer} event.
1821      */
1822     function _safeTransfer(
1823         address from,
1824         address to,
1825         uint256 tokenId,
1826         bytes memory _data
1827     ) internal virtual {
1828         _transfer(from, to, tokenId);
1829         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1830     }
1831 
1832     /**
1833      * @dev Returns whether `tokenId` exists.
1834      *
1835      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1836      *
1837      * Tokens start existing when they are minted (`_mint`),
1838      * and stop existing when they are burned (`_burn`).
1839      */
1840     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1841         return _owners[tokenId] != address(0);
1842     }
1843 
1844     /**
1845      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1846      *
1847      * Requirements:
1848      *
1849      * - `tokenId` must exist.
1850      */
1851     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1852         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1853         address owner = ERC721.ownerOf(tokenId);
1854         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1855     }
1856 
1857     /**
1858      * @dev Safely mints `tokenId` and transfers it to `to`.
1859      *
1860      * Requirements:
1861      *
1862      * - `tokenId` must not exist.
1863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1864      *
1865      * Emits a {Transfer} event.
1866      */
1867     function _safeMint(address to, uint256 tokenId) internal virtual {
1868         _safeMint(to, tokenId, "");
1869     }
1870 
1871     /**
1872      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1873      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1874      */
1875     function _safeMint(
1876         address to,
1877         uint256 tokenId,
1878         bytes memory _data
1879     ) internal virtual {
1880         _mint(to, tokenId);
1881         require(
1882             _checkOnERC721Received(address(0), to, tokenId, _data),
1883             "ERC721: transfer to non ERC721Receiver implementer"
1884         );
1885     }
1886 
1887     /**
1888      * @dev Mints `tokenId` and transfers it to `to`.
1889      *
1890      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1891      *
1892      * Requirements:
1893      *
1894      * - `tokenId` must not exist.
1895      * - `to` cannot be the zero address.
1896      *
1897      * Emits a {Transfer} event.
1898      */
1899     function _mint(address to, uint256 tokenId) internal virtual {
1900         require(to != address(0), "ERC721: mint to the zero address");
1901         require(!_exists(tokenId), "ERC721: token already minted");
1902 
1903         _beforeTokenTransfer(address(0), to, tokenId);
1904 
1905         _balances[to] += 1;
1906         _owners[tokenId] = to;
1907 
1908         emit Transfer(address(0), to, tokenId);
1909 
1910         _afterTokenTransfer(address(0), to, tokenId);
1911     }
1912 
1913     /**
1914      * @dev Destroys `tokenId`.
1915      * The approval is cleared when the token is burned.
1916      *
1917      * Requirements:
1918      *
1919      * - `tokenId` must exist.
1920      *
1921      * Emits a {Transfer} event.
1922      */
1923     function _burn(uint256 tokenId) internal virtual {
1924         address owner = ERC721.ownerOf(tokenId);
1925 
1926         _beforeTokenTransfer(owner, address(0), tokenId);
1927 
1928         // Clear approvals
1929         _approve(address(0), tokenId);
1930 
1931         _balances[owner] -= 1;
1932         delete _owners[tokenId];
1933 
1934         emit Transfer(owner, address(0), tokenId);
1935 
1936         _afterTokenTransfer(owner, address(0), tokenId);
1937     }
1938 
1939     /**
1940      * @dev Transfers `tokenId` from `from` to `to`.
1941      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1942      *
1943      * Requirements:
1944      *
1945      * - `to` cannot be the zero address.
1946      * - `tokenId` token must be owned by `from`.
1947      *
1948      * Emits a {Transfer} event.
1949      */
1950     function _transfer(
1951         address from,
1952         address to,
1953         uint256 tokenId
1954     ) internal virtual {
1955         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1956         require(to != address(0), "ERC721: transfer to the zero address");
1957 
1958         _beforeTokenTransfer(from, to, tokenId);
1959 
1960         // Clear approvals from the previous owner
1961         _approve(address(0), tokenId);
1962 
1963         _balances[from] -= 1;
1964         _balances[to] += 1;
1965         _owners[tokenId] = to;
1966 
1967         emit Transfer(from, to, tokenId);
1968 
1969         _afterTokenTransfer(from, to, tokenId);
1970     }
1971 
1972     /**
1973      * @dev Approve `to` to operate on `tokenId`
1974      *
1975      * Emits a {Approval} event.
1976      */
1977     function _approve(address to, uint256 tokenId) internal virtual {
1978         _tokenApprovals[tokenId] = to;
1979         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1980     }
1981 
1982     /**
1983      * @dev Approve `operator` to operate on all of `owner` tokens
1984      *
1985      * Emits a {ApprovalForAll} event.
1986      */
1987     function _setApprovalForAll(
1988         address owner,
1989         address operator,
1990         bool approved
1991     ) internal virtual {
1992         require(owner != operator, "ERC721: approve to caller");
1993         _operatorApprovals[owner][operator] = approved;
1994         emit ApprovalForAll(owner, operator, approved);
1995     }
1996 
1997     /**
1998      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1999      * The call is not executed if the target address is not a contract.
2000      *
2001      * @param from address representing the previous owner of the given token ID
2002      * @param to target address that will receive the tokens
2003      * @param tokenId uint256 ID of the token to be transferred
2004      * @param _data bytes optional data to send along with the call
2005      * @return bool whether the call correctly returned the expected magic value
2006      */
2007     function _checkOnERC721Received(
2008         address from,
2009         address to,
2010         uint256 tokenId,
2011         bytes memory _data
2012     ) private returns (bool) {
2013         if (to.isContract()) {
2014             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2015                 return retval == IERC721Receiver.onERC721Received.selector;
2016             } catch (bytes memory reason) {
2017                 if (reason.length == 0) {
2018                     revert("ERC721: transfer to non ERC721Receiver implementer");
2019                 } else {
2020                     assembly {
2021                         revert(add(32, reason), mload(reason))
2022                     }
2023                 }
2024             }
2025         } else {
2026             return true;
2027         }
2028     }
2029 
2030     /**
2031      * @dev Hook that is called before any token transfer. This includes minting
2032      * and burning.
2033      *
2034      * Calling conditions:
2035      *
2036      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2037      * transferred to `to`.
2038      * - When `from` is zero, `tokenId` will be minted for `to`.
2039      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2040      * - `from` and `to` are never both zero.
2041      *
2042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2043      */
2044     function _beforeTokenTransfer(
2045         address from,
2046         address to,
2047         uint256 tokenId
2048     ) internal virtual {}
2049 
2050     /**
2051      * @dev Hook that is called after any transfer of tokens. This includes
2052      * minting and burning.
2053      *
2054      * Calling conditions:
2055      *
2056      * - when `from` and `to` are both non-zero.
2057      * - `from` and `to` are never both zero.
2058      *
2059      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2060      */
2061     function _afterTokenTransfer(
2062         address from,
2063         address to,
2064         uint256 tokenId
2065     ) internal virtual {}
2066 }
2067 
2068 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2069 
2070 
2071 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2072 
2073 pragma solidity ^0.8.0;
2074 
2075 
2076 
2077 /**
2078  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2079  * enumerability of all the token ids in the contract as well as all token ids owned by each
2080  * account.
2081  */
2082 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2083     // Mapping from owner to list of owned token IDs
2084     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2085 
2086     // Mapping from token ID to index of the owner tokens list
2087     mapping(uint256 => uint256) private _ownedTokensIndex;
2088 
2089     // Array with all token ids, used for enumeration
2090     uint256[] private _allTokens;
2091 
2092     // Mapping from token id to position in the allTokens array
2093     mapping(uint256 => uint256) private _allTokensIndex;
2094 
2095     /**
2096      * @dev See {IERC165-supportsInterface}.
2097      */
2098     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2099         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2100     }
2101 
2102     /**
2103      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2104      */
2105     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2106         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2107         return _ownedTokens[owner][index];
2108     }
2109 
2110     /**
2111      * @dev See {IERC721Enumerable-totalSupply}.
2112      */
2113     function totalSupply() public view virtual override returns (uint256) {
2114         return _allTokens.length;
2115     }
2116 
2117     /**
2118      * @dev See {IERC721Enumerable-tokenByIndex}.
2119      */
2120     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2121         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2122         return _allTokens[index];
2123     }
2124 
2125     /**
2126      * @dev Hook that is called before any token transfer. This includes minting
2127      * and burning.
2128      *
2129      * Calling conditions:
2130      *
2131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2132      * transferred to `to`.
2133      * - When `from` is zero, `tokenId` will be minted for `to`.
2134      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2135      * - `from` cannot be the zero address.
2136      * - `to` cannot be the zero address.
2137      *
2138      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2139      */
2140     function _beforeTokenTransfer(
2141         address from,
2142         address to,
2143         uint256 tokenId
2144     ) internal virtual override {
2145         super._beforeTokenTransfer(from, to, tokenId);
2146 
2147         if (from == address(0)) {
2148             _addTokenToAllTokensEnumeration(tokenId);
2149         } else if (from != to) {
2150             _removeTokenFromOwnerEnumeration(from, tokenId);
2151         }
2152         if (to == address(0)) {
2153             _removeTokenFromAllTokensEnumeration(tokenId);
2154         } else if (to != from) {
2155             _addTokenToOwnerEnumeration(to, tokenId);
2156         }
2157     }
2158 
2159     /**
2160      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2161      * @param to address representing the new owner of the given token ID
2162      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2163      */
2164     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2165         uint256 length = ERC721.balanceOf(to);
2166         _ownedTokens[to][length] = tokenId;
2167         _ownedTokensIndex[tokenId] = length;
2168     }
2169 
2170     /**
2171      * @dev Private function to add a token to this extension's token tracking data structures.
2172      * @param tokenId uint256 ID of the token to be added to the tokens list
2173      */
2174     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2175         _allTokensIndex[tokenId] = _allTokens.length;
2176         _allTokens.push(tokenId);
2177     }
2178 
2179     /**
2180      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2181      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2182      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2183      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2184      * @param from address representing the previous owner of the given token ID
2185      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2186      */
2187     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2188         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2189         // then delete the last slot (swap and pop).
2190 
2191         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2192         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2193 
2194         // When the token to delete is the last token, the swap operation is unnecessary
2195         if (tokenIndex != lastTokenIndex) {
2196             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2197 
2198             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2199             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2200         }
2201 
2202         // This also deletes the contents at the last position of the array
2203         delete _ownedTokensIndex[tokenId];
2204         delete _ownedTokens[from][lastTokenIndex];
2205     }
2206 
2207     /**
2208      * @dev Private function to remove a token from this extension's token tracking data structures.
2209      * This has O(1) time complexity, but alters the order of the _allTokens array.
2210      * @param tokenId uint256 ID of the token to be removed from the tokens list
2211      */
2212     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2213         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2214         // then delete the last slot (swap and pop).
2215 
2216         uint256 lastTokenIndex = _allTokens.length - 1;
2217         uint256 tokenIndex = _allTokensIndex[tokenId];
2218 
2219         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2220         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2221         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2222         uint256 lastTokenId = _allTokens[lastTokenIndex];
2223 
2224         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2225         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2226 
2227         // This also deletes the contents at the last position of the array
2228         delete _allTokensIndex[tokenId];
2229         _allTokens.pop();
2230     }
2231 }
2232 
2233 // File: contracts/the_little_surfers.sol
2234 
2235 
2236 
2237 pragma solidity ^0.8.4;
2238 
2239 
2240 
2241 
2242 
2243 
2244 
2245 contract TheLittleSurfers is ERC721A, Ownable, ReentrancyGuard {
2246     using SafeMath for uint256;
2247     using Strings for uint256;
2248 
2249     bool public preSaleActive = true;
2250     bool public publicSaleActive = false;
2251 
2252     bool public paused = true;
2253     bool public revealed = false;
2254 
2255     uint256 public maxSupply = 5555;
2256     uint256 public preSalePrice = 0.08 ether;
2257     uint256 public preSaleOgPrice = 0.05 ether;
2258     uint256 public publicSalePrice = 0.1 ether;
2259 
2260     uint256 public maxPreSale = 7;
2261     uint256 public maxPreSaleOg = 8;
2262     uint256 public maxPublicSale = 5;
2263 
2264     string private _baseURIextended;
2265     
2266     string public NETWORK_PROVENANCE = "4544338203310281430";
2267     string public notRevealedUri = "ipfs://QmdSHzmB6EEBkuBzc84Gg5QaewjwZX1KkiTykN2HJBU6ZB";
2268 
2269     mapping(address => bool) public isWhiteListed;
2270     mapping(address => bool) public isOgListed;
2271     mapping(address => uint256) public preSaleCounter;
2272     mapping(address => uint256) public publicSaleCounter;
2273 
2274     constructor(string memory name, string memory symbol) ERC721A(name, symbol) ReentrancyGuard() {
2275     }
2276 
2277     function _startTokenId() internal view virtual override returns (uint256) {
2278         return 1;
2279     }
2280 
2281     function preSaleMint(uint256 _amount) external payable nonReentrant{
2282         require(preSaleActive, "TLS Pre Sale is not Active");
2283         require(isWhiteListed[msg.sender] || isOgListed[msg.sender], "TLS User is not White/OG Listed");
2284         if(isOgListed[msg.sender])
2285         {
2286             require(preSaleCounter[msg.sender].add(_amount) <= maxPreSaleOg, "TLS Maximum Pre Sale OG Minting Limit Reached");
2287             require(preSaleOgPrice*_amount <= msg.value, "TLS ETH Value Sent for Pre Sale Og is not enough");
2288         }
2289         else{
2290             require(preSaleCounter[msg.sender].add(_amount) <= maxPreSale, "TLS Maximum Pre Sale Minting Limit Reached");
2291             require(preSalePrice*_amount <= msg.value, "TLS ETH Value Sent for Pre Sale is not enough");
2292         }
2293         mint(_amount, true);
2294     }
2295 
2296     function publicSaleMint(uint256 _amount) external payable nonReentrant {
2297         require(publicSaleActive, "TLS Public Sale is not Active");
2298         require(publicSaleCounter[msg.sender].add(_amount) <= maxPublicSale, "TLS Maximum Minting Limit Reached");
2299         mint(_amount, false);
2300     }
2301 
2302     function mint(uint256 amount,bool state) internal {
2303         require(!paused, "TLS Minting is Paused");
2304         require(totalSupply().add(amount) <= maxSupply, "TLS Maximum Supply Reached");
2305         if(state){
2306             preSaleCounter[msg.sender] = preSaleCounter[msg.sender].add(amount);
2307         }
2308         else{
2309             require(publicSalePrice*amount <= msg.value, "TLS ETH Value Sent for Public Sale is not enough");
2310             publicSaleCounter[msg.sender] = publicSaleCounter[msg.sender].add(amount);
2311         }
2312         _safeMint(msg.sender, amount);
2313     }
2314 
2315     function _baseURI() internal view virtual override returns (string memory){
2316         return _baseURIextended;
2317     }
2318 
2319     function setBaseURI(string calldata baseURI_) external onlyOwner {
2320         _baseURIextended = baseURI_;
2321     }
2322 
2323     function togglePauseState() external onlyOwner {
2324         paused = !paused;
2325     }
2326 
2327     function togglePreSale() external onlyOwner {
2328         preSaleActive = !preSaleActive;
2329         publicSaleActive = false;
2330     }
2331 
2332     function togglePublicSale() external onlyOwner {
2333         publicSaleActive = !publicSaleActive;
2334         preSaleActive = false;
2335     }
2336 
2337     function addWhiteListedAddresses(address[] memory _address) external onlyOwner {
2338         for (uint256 i = 0; i < _address.length; i++) {
2339             isWhiteListed[_address[i]] = true;
2340         }
2341     }
2342 
2343     function addOgListedAddresses(address[] memory _address) external onlyOwner {
2344         for (uint256 i = 0; i < _address.length; i++) {
2345             isOgListed[_address[i]] = true;
2346         }
2347     }
2348 
2349     function setPreSalePrice(uint256 _preSalePrice) external onlyOwner {
2350         preSalePrice = _preSalePrice;
2351     }
2352 
2353     function setPublicSalePrice(uint256 _publicSalePrice) external onlyOwner {
2354         publicSalePrice = _publicSalePrice;
2355     }
2356 
2357     function airDrop(address[] memory _address) external onlyOwner {
2358         require(totalSupply().add(_address.length) <= maxSupply, "TLS Maximum Supply Reached");
2359         for(uint i=0; i < _address.length; i++){
2360             _safeMint(_address[i], 1);
2361         }
2362     }
2363 
2364     function reveal() external onlyOwner {
2365         revealed = true;
2366     }
2367 
2368     function withdrawTotal() external onlyOwner {
2369         uint balance = address(this).balance;
2370         payable(address(0x3e89Fbf78021D067060CC91496E604EFb69cbb15)).transfer(balance.mul(125).div(10000));
2371         payable(address(0xebD47AaebdeEBE67DFB2092DB728e86cC62fFac6)).transfer(balance.mul(125).div(10000));
2372         payable(address(0x345A8760D24CAd15E00387FCA6Da6Cbb85334482)).transfer(balance.mul(30).div(100)); // Mystery pearls
2373         payable(address(0xB6cD3e633b4D1072557c236767c38C26e09039b7)).transfer(balance.mul(10).div(100)); // DAO
2374         payable(address(0x8102c63993151973c0F334CE3bFB3B48B611e1C1)).transfer(balance.mul(15).div(100)); // Operational budget
2375         payable(address(0xB6cD3e633b4D1072557c236767c38C26e09039b7)).transfer(balance.mul(10).div(100));
2376         payable(address(0x70148a9f077D4836d9a790ce1c1b637FAB2A9d8f)).transfer(balance.mul(15).div(100));
2377 
2378         balance = address(this).balance;
2379         payable(address(0xF1e25b6935aC967dC62A39Af295c1E6d5F725940)).transfer(balance); // 27.5, rest of balance
2380     }
2381 
2382     function setNotRevealedURI(string memory _notRevealedUri) external onlyOwner {
2383         notRevealedUri = _notRevealedUri;
2384     }
2385 
2386     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2387         require(_exists(_tokenId), "TLS URI For Token Non-existent");
2388         if(!revealed){
2389             return notRevealedUri;
2390         }
2391         string memory currentBaseURI = _baseURI();
2392         return bytes(currentBaseURI).length > 0 ?
2393         string(abi.encodePacked(currentBaseURI,_tokenId.toString(),".json")) : "";
2394     }
2395 }