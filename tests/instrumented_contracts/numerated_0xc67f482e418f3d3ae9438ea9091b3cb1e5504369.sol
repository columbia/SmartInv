1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
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
48 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
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
62  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
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
278 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Provides information about the current execution context, including the
287  * sender of the transaction and its data. While these are generally available
288  * via msg.sender and msg.data, they should not be accessed in such a direct
289  * manner, since when dealing with meta-transactions the account sending and
290  * paying for execution may not be the actual sender (as far as an application
291  * is concerned).
292  *
293  * This contract is only required for intermediate, library-like contracts.
294  */
295 abstract contract Context {
296     function _msgSender() internal view virtual returns (address) {
297         return msg.sender;
298     }
299 
300     function _msgData() internal view virtual returns (bytes calldata) {
301         return msg.data;
302     }
303 }
304 
305 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @dev Contract module which provides a basic access control mechanism, where
315  * there is an account (an owner) that can be granted exclusive access to
316  * specific functions.
317  *
318  * By default, the owner account will be the one that deploys the contract. This
319  * can later be changed with {transferOwnership}.
320  *
321  * This module is used through inheritance. It will make available the modifier
322  * `onlyOwner`, which can be applied to your functions to restrict their use to
323  * the owner.
324  */
325 abstract contract Ownable is Context {
326     address private _owner;
327 
328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
329 
330     /**
331      * @dev Initializes the contract setting the deployer as the initial owner.
332      */
333     constructor() {
334         _transferOwnership(_msgSender());
335     }
336 
337     /**
338      * @dev Returns the address of the current owner.
339      */
340     function owner() public view virtual returns (address) {
341         return _owner;
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         require(owner() == _msgSender(), "Ownable: caller is not the owner");
349         _;
350     }
351 
352     /**
353      * @dev Leaves the contract without owner. It will not be possible to call
354      * `onlyOwner` functions anymore. Can only be called by the current owner.
355      *
356      * NOTE: Renouncing ownership will leave the contract without an owner,
357      * thereby removing any functionality that is only available to the owner.
358      */
359     function renounceOwnership() public virtual onlyOwner {
360         _transferOwnership(address(0));
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Can only be called by the current owner.
366      */
367     function transferOwnership(address newOwner) public virtual onlyOwner {
368         require(newOwner != address(0), "Ownable: new owner is the zero address");
369         _transferOwnership(newOwner);
370     }
371 
372     /**
373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
374      * Internal function without access restriction.
375      */
376     function _transferOwnership(address newOwner) internal virtual {
377         address oldOwner = _owner;
378         _owner = newOwner;
379         emit OwnershipTransferred(oldOwner, newOwner);
380     }
381 }
382 
383 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @title ERC721 token receiver interface
392  * @dev Interface for any contract that wants to support safeTransfers
393  * from ERC721 asset contracts.
394  */
395 interface IERC721Receiver {
396     /**
397      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
398      * by `operator` from `from`, this function is called.
399      *
400      * It must return its Solidity selector to confirm the token transfer.
401      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
402      *
403      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
404      */
405     function onERC721Received(
406         address operator,
407         address from,
408         uint256 tokenId,
409         bytes calldata data
410     ) external returns (bytes4);
411 }
412 
413 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
417 
418 pragma solidity ^0.8.1;
419 
420 /**
421  * @dev Collection of functions related to the address type
422  */
423 library Address {
424     /**
425      * @dev Returns true if `account` is a contract.
426      *
427      * [IMPORTANT]
428      * ====
429      * It is unsafe to assume that an address for which this function returns
430      * false is an externally-owned account (EOA) and not a contract.
431      *
432      * Among others, `isContract` will return false for the following
433      * types of addresses:
434      *
435      *  - an externally-owned account
436      *  - a contract in construction
437      *  - an address where a contract will be created
438      *  - an address where a contract lived, but was destroyed
439      * ====
440      *
441      * [IMPORTANT]
442      * ====
443      * You shouldn't rely on `isContract` to protect against flash loan attacks!
444      *
445      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
446      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
447      * constructor.
448      * ====
449      */
450     function isContract(address account) internal view returns (bool) {
451         // This method relies on extcodesize/address.code.length, which returns 0
452         // for contracts in construction, since the code is only stored at the end
453         // of the constructor execution.
454 
455         return account.code.length > 0;
456     }
457 
458     /**
459      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
460      * `recipient`, forwarding all available gas and reverting on errors.
461      *
462      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
463      * of certain opcodes, possibly making contracts go over the 2300 gas limit
464      * imposed by `transfer`, making them unable to receive funds via
465      * `transfer`. {sendValue} removes this limitation.
466      *
467      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
468      *
469      * IMPORTANT: because control is transferred to `recipient`, care must be
470      * taken to not create reentrancy vulnerabilities. Consider using
471      * {ReentrancyGuard} or the
472      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
473      */
474     function sendValue(address payable recipient, uint256 amount) internal {
475         require(address(this).balance >= amount, "Address: insufficient balance");
476 
477         (bool success, ) = recipient.call{value: amount}("");
478         require(success, "Address: unable to send value, recipient may have reverted");
479     }
480 
481     /**
482      * @dev Performs a Solidity function call using a low level `call`. A
483      * plain `call` is an unsafe replacement for a function call: use this
484      * function instead.
485      *
486      * If `target` reverts with a revert reason, it is bubbled up by this
487      * function (like regular Solidity function calls).
488      *
489      * Returns the raw returned data. To convert to the expected return value,
490      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
491      *
492      * Requirements:
493      *
494      * - `target` must be a contract.
495      * - calling `target` with `data` must not revert.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionCall(target, data, "Address: low-level call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
505      * `errorMessage` as a fallback revert reason when `target` reverts.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, 0, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but also transferring `value` wei to `target`.
520      *
521      * Requirements:
522      *
523      * - the calling contract must have an ETH balance of at least `value`.
524      * - the called Solidity function must be `payable`.
525      *
526      * _Available since v3.1._
527      */
528     function functionCallWithValue(
529         address target,
530         bytes memory data,
531         uint256 value
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
538      * with `errorMessage` as a fallback revert reason when `target` reverts.
539      *
540      * _Available since v3.1._
541      */
542     function functionCallWithValue(
543         address target,
544         bytes memory data,
545         uint256 value,
546         string memory errorMessage
547     ) internal returns (bytes memory) {
548         require(address(this).balance >= value, "Address: insufficient balance for call");
549         require(isContract(target), "Address: call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.call{value: value}(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
562         return functionStaticCall(target, data, "Address: low-level static call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a static call.
568      *
569      * _Available since v3.3._
570      */
571     function functionStaticCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal view returns (bytes memory) {
576         require(isContract(target), "Address: static call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.staticcall(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
589         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
594      * but performing a delegate call.
595      *
596      * _Available since v3.4._
597      */
598     function functionDelegateCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         require(isContract(target), "Address: delegate call to non-contract");
604 
605         (bool success, bytes memory returndata) = target.delegatecall(data);
606         return verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     /**
610      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
611      * revert reason using the provided one.
612      *
613      * _Available since v4.3._
614      */
615     function verifyCallResult(
616         bool success,
617         bytes memory returndata,
618         string memory errorMessage
619     ) internal pure returns (bytes memory) {
620         if (success) {
621             return returndata;
622         } else {
623             // Look for revert reason and bubble it up if present
624             if (returndata.length > 0) {
625                 // The easiest way to bubble the revert reason is using memory via assembly
626 
627                 assembly {
628                     let returndata_size := mload(returndata)
629                     revert(add(32, returndata), returndata_size)
630                 }
631             } else {
632                 revert(errorMessage);
633             }
634         }
635     }
636 }
637 
638 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev String operations.
647  */
648 library Strings {
649     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
653      */
654     function toString(uint256 value) internal pure returns (string memory) {
655         // Inspired by OraclizeAPI's implementation - MIT licence
656         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
657 
658         if (value == 0) {
659             return "0";
660         }
661         uint256 temp = value;
662         uint256 digits;
663         while (temp != 0) {
664             digits++;
665             temp /= 10;
666         }
667         bytes memory buffer = new bytes(digits);
668         while (value != 0) {
669             digits -= 1;
670             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
671             value /= 10;
672         }
673         return string(buffer);
674     }
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
678      */
679     function toHexString(uint256 value) internal pure returns (string memory) {
680         if (value == 0) {
681             return "0x00";
682         }
683         uint256 temp = value;
684         uint256 length = 0;
685         while (temp != 0) {
686             length++;
687             temp >>= 8;
688         }
689         return toHexString(value, length);
690     }
691 
692     /**
693      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
694      */
695     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
696         bytes memory buffer = new bytes(2 * length + 2);
697         buffer[0] = "0";
698         buffer[1] = "x";
699         for (uint256 i = 2 * length + 1; i > 1; --i) {
700             buffer[i] = _HEX_SYMBOLS[value & 0xf];
701             value >>= 4;
702         }
703         require(value == 0, "Strings: hex length insufficient");
704         return string(buffer);
705     }
706 }
707 
708 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Interface of the ERC165 standard, as defined in the
717  * https://eips.ethereum.org/EIPS/eip-165[EIP].
718  *
719  * Implementers can declare support of contract interfaces, which can then be
720  * queried by others ({ERC165Checker}).
721  *
722  * For an implementation, see {ERC165}.
723  */
724 interface IERC165 {
725     /**
726      * @dev Returns true if this contract implements the interface defined by
727      * `interfaceId`. See the corresponding
728      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
729      * to learn more about how these ids are created.
730      *
731      * This function call must use less than 30 000 gas.
732      */
733     function supportsInterface(bytes4 interfaceId) external view returns (bool);
734 }
735 
736 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 /**
745  * @dev Implementation of the {IERC165} interface.
746  *
747  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
748  * for the additional interface id that will be supported. For example:
749  *
750  * ```solidity
751  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
753  * }
754  * ```
755  *
756  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
757  */
758 abstract contract ERC165 is IERC165 {
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763         return interfaceId == type(IERC165).interfaceId;
764     }
765 }
766 
767 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
768 
769 
770 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 
775 /**
776  * @dev Required interface of an ERC721 compliant contract.
777  */
778 interface IERC721 is IERC165 {
779     /**
780      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
781      */
782     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
783 
784     /**
785      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
786      */
787     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
788 
789     /**
790      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
791      */
792     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
793 
794     /**
795      * @dev Returns the number of tokens in ``owner``'s account.
796      */
797     function balanceOf(address owner) external view returns (uint256 balance);
798 
799     /**
800      * @dev Returns the owner of the `tokenId` token.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must exist.
805      */
806     function ownerOf(uint256 tokenId) external view returns (address owner);
807 
808     /**
809      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
810      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must exist and be owned by `from`.
817      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) external;
827 
828     /**
829      * @dev Transfers `tokenId` token from `from` to `to`.
830      *
831      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must be owned by `from`.
838      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
839      *
840      * Emits a {Transfer} event.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) external;
847 
848     /**
849      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
850      * The approval is cleared when the token is transferred.
851      *
852      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
853      *
854      * Requirements:
855      *
856      * - The caller must own the token or be an approved operator.
857      * - `tokenId` must exist.
858      *
859      * Emits an {Approval} event.
860      */
861     function approve(address to, uint256 tokenId) external;
862 
863     /**
864      * @dev Returns the account approved for `tokenId` token.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must exist.
869      */
870     function getApproved(uint256 tokenId) external view returns (address operator);
871 
872     /**
873      * @dev Approve or remove `operator` as an operator for the caller.
874      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
875      *
876      * Requirements:
877      *
878      * - The `operator` cannot be the caller.
879      *
880      * Emits an {ApprovalForAll} event.
881      */
882     function setApprovalForAll(address operator, bool _approved) external;
883 
884     /**
885      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
886      *
887      * See {setApprovalForAll}
888      */
889     function isApprovedForAll(address owner, address operator) external view returns (bool);
890 
891     /**
892      * @dev Safely transfers `tokenId` token from `from` to `to`.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes calldata data
909     ) external;
910 }
911 
912 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
913 
914 
915 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
916 
917 pragma solidity ^0.8.0;
918 
919 
920 /**
921  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
922  * @dev See https://eips.ethereum.org/EIPS/eip-721
923  */
924 interface IERC721Metadata is IERC721 {
925     /**
926      * @dev Returns the token collection name.
927      */
928     function name() external view returns (string memory);
929 
930     /**
931      * @dev Returns the token collection symbol.
932      */
933     function symbol() external view returns (string memory);
934 
935     /**
936      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
937      */
938     function tokenURI(uint256 tokenId) external view returns (string memory);
939 }
940 
941 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
942 
943 
944 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
945 
946 pragma solidity ^0.8.0;
947 
948 
949 
950 
951 
952 
953 
954 
955 /**
956  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
957  * the Metadata extension, but not including the Enumerable extension, which is available separately as
958  * {ERC721Enumerable}.
959  */
960 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
961     using Address for address;
962     using Strings for uint256;
963 
964     // Token name
965     string private _name;
966 
967     // Token symbol
968     string private _symbol;
969 
970     // Mapping from token ID to owner address
971     mapping(uint256 => address) private _owners;
972 
973     // Mapping owner address to token count
974     mapping(address => uint256) private _balances;
975 
976     // Mapping from token ID to approved address
977     mapping(uint256 => address) private _tokenApprovals;
978 
979     // Mapping from owner to operator approvals
980     mapping(address => mapping(address => bool)) private _operatorApprovals;
981 
982     /**
983      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
984      */
985     constructor(string memory name_, string memory symbol_) {
986         _name = name_;
987         _symbol = symbol_;
988     }
989 
990     /**
991      * @dev See {IERC165-supportsInterface}.
992      */
993     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
994         return
995             interfaceId == type(IERC721).interfaceId ||
996             interfaceId == type(IERC721Metadata).interfaceId ||
997             super.supportsInterface(interfaceId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-balanceOf}.
1002      */
1003     function balanceOf(address owner) public view virtual override returns (uint256) {
1004         require(owner != address(0), "ERC721: balance query for the zero address");
1005         return _balances[owner];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-ownerOf}.
1010      */
1011     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1012         address owner = _owners[tokenId];
1013         require(owner != address(0), "ERC721: owner query for nonexistent token");
1014         return owner;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-name}.
1019      */
1020     function name() public view virtual override returns (string memory) {
1021         return _name;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-symbol}.
1026      */
1027     function symbol() public view virtual override returns (string memory) {
1028         return _symbol;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Metadata-tokenURI}.
1033      */
1034     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1035         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1036 
1037         string memory baseURI = _baseURI();
1038         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1039     }
1040 
1041     /**
1042      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1043      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1044      * by default, can be overriden in child contracts.
1045      */
1046     function _baseURI() internal view virtual returns (string memory) {
1047         return "";
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-approve}.
1052      */
1053     function approve(address to, uint256 tokenId) public virtual override {
1054         address owner = ERC721.ownerOf(tokenId);
1055         require(to != owner, "ERC721: approval to current owner");
1056 
1057         require(
1058             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1059             "ERC721: approve caller is not owner nor approved for all"
1060         );
1061 
1062         _approve(to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-getApproved}.
1067      */
1068     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1069         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1070 
1071         return _tokenApprovals[tokenId];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-setApprovalForAll}.
1076      */
1077     function setApprovalForAll(address operator, bool approved) public virtual override {
1078         _setApprovalForAll(_msgSender(), operator, approved);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-isApprovedForAll}.
1083      */
1084     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1085         return _operatorApprovals[owner][operator];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-transferFrom}.
1090      */
1091     function transferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         //solhint-disable-next-line max-line-length
1097         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1098 
1099         _transfer(from, to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-safeTransferFrom}.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         safeTransferFrom(from, to, tokenId, "");
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-safeTransferFrom}.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory _data
1121     ) public virtual override {
1122         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1123         _safeTransfer(from, to, tokenId, _data);
1124     }
1125 
1126     /**
1127      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1128      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1129      *
1130      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1131      *
1132      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1133      * implement alternative mechanisms to perform token transfer, such as signature-based.
1134      *
1135      * Requirements:
1136      *
1137      * - `from` cannot be the zero address.
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must exist and be owned by `from`.
1140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _safeTransfer(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) internal virtual {
1150         _transfer(from, to, tokenId);
1151         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1152     }
1153 
1154     /**
1155      * @dev Returns whether `tokenId` exists.
1156      *
1157      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1158      *
1159      * Tokens start existing when they are minted (`_mint`),
1160      * and stop existing when they are burned (`_burn`).
1161      */
1162     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1163         return _owners[tokenId] != address(0);
1164     }
1165 
1166     /**
1167      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must exist.
1172      */
1173     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1174         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1175         address owner = ERC721.ownerOf(tokenId);
1176         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1177     }
1178 
1179     /**
1180      * @dev Safely mints `tokenId` and transfers it to `to`.
1181      *
1182      * Requirements:
1183      *
1184      * - `tokenId` must not exist.
1185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _safeMint(address to, uint256 tokenId) internal virtual {
1190         _safeMint(to, tokenId, "");
1191     }
1192 
1193     /**
1194      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1195      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1196      */
1197     function _safeMint(
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) internal virtual {
1202         _mint(to, tokenId);
1203         require(
1204             _checkOnERC721Received(address(0), to, tokenId, _data),
1205             "ERC721: transfer to non ERC721Receiver implementer"
1206         );
1207     }
1208 
1209     /**
1210      * @dev Mints `tokenId` and transfers it to `to`.
1211      *
1212      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must not exist.
1217      * - `to` cannot be the zero address.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _mint(address to, uint256 tokenId) internal virtual {
1222         require(to != address(0), "ERC721: mint to the zero address");
1223         require(!_exists(tokenId), "ERC721: token already minted");
1224 
1225         _beforeTokenTransfer(address(0), to, tokenId);
1226 
1227         _balances[to] += 1;
1228         _owners[tokenId] = to;
1229 
1230         emit Transfer(address(0), to, tokenId);
1231 
1232         _afterTokenTransfer(address(0), to, tokenId);
1233     }
1234 
1235     /**
1236      * @dev Destroys `tokenId`.
1237      * The approval is cleared when the token is burned.
1238      *
1239      * Requirements:
1240      *
1241      * - `tokenId` must exist.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _burn(uint256 tokenId) internal virtual {
1246         address owner = ERC721.ownerOf(tokenId);
1247 
1248         _beforeTokenTransfer(owner, address(0), tokenId);
1249 
1250         // Clear approvals
1251         _approve(address(0), tokenId);
1252 
1253         _balances[owner] -= 1;
1254         delete _owners[tokenId];
1255 
1256         emit Transfer(owner, address(0), tokenId);
1257 
1258         _afterTokenTransfer(owner, address(0), tokenId);
1259     }
1260 
1261     /**
1262      * @dev Transfers `tokenId` from `from` to `to`.
1263      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1264      *
1265      * Requirements:
1266      *
1267      * - `to` cannot be the zero address.
1268      * - `tokenId` token must be owned by `from`.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function _transfer(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) internal virtual {
1277         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1278         require(to != address(0), "ERC721: transfer to the zero address");
1279 
1280         _beforeTokenTransfer(from, to, tokenId);
1281 
1282         // Clear approvals from the previous owner
1283         _approve(address(0), tokenId);
1284 
1285         _balances[from] -= 1;
1286         _balances[to] += 1;
1287         _owners[tokenId] = to;
1288 
1289         emit Transfer(from, to, tokenId);
1290 
1291         _afterTokenTransfer(from, to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Approve `to` to operate on `tokenId`
1296      *
1297      * Emits a {Approval} event.
1298      */
1299     function _approve(address to, uint256 tokenId) internal virtual {
1300         _tokenApprovals[tokenId] = to;
1301         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Approve `operator` to operate on all of `owner` tokens
1306      *
1307      * Emits a {ApprovalForAll} event.
1308      */
1309     function _setApprovalForAll(
1310         address owner,
1311         address operator,
1312         bool approved
1313     ) internal virtual {
1314         require(owner != operator, "ERC721: approve to caller");
1315         _operatorApprovals[owner][operator] = approved;
1316         emit ApprovalForAll(owner, operator, approved);
1317     }
1318 
1319     /**
1320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1321      * The call is not executed if the target address is not a contract.
1322      *
1323      * @param from address representing the previous owner of the given token ID
1324      * @param to target address that will receive the tokens
1325      * @param tokenId uint256 ID of the token to be transferred
1326      * @param _data bytes optional data to send along with the call
1327      * @return bool whether the call correctly returned the expected magic value
1328      */
1329     function _checkOnERC721Received(
1330         address from,
1331         address to,
1332         uint256 tokenId,
1333         bytes memory _data
1334     ) private returns (bool) {
1335         if (to.isContract()) {
1336             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1337                 return retval == IERC721Receiver.onERC721Received.selector;
1338             } catch (bytes memory reason) {
1339                 if (reason.length == 0) {
1340                     revert("ERC721: transfer to non ERC721Receiver implementer");
1341                 } else {
1342                     assembly {
1343                         revert(add(32, reason), mload(reason))
1344                     }
1345                 }
1346             }
1347         } else {
1348             return true;
1349         }
1350     }
1351 
1352     /**
1353      * @dev Hook that is called before any token transfer. This includes minting
1354      * and burning.
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` will be minted for `to`.
1361      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1362      * - `from` and `to` are never both zero.
1363      *
1364      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1365      */
1366     function _beforeTokenTransfer(
1367         address from,
1368         address to,
1369         uint256 tokenId
1370     ) internal virtual {}
1371 
1372     /**
1373      * @dev Hook that is called after any transfer of tokens. This includes
1374      * minting and burning.
1375      *
1376      * Calling conditions:
1377      *
1378      * - when `from` and `to` are both non-zero.
1379      * - `from` and `to` are never both zero.
1380      *
1381      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1382      */
1383     function _afterTokenTransfer(
1384         address from,
1385         address to,
1386         uint256 tokenId
1387     ) internal virtual {}
1388 }
1389 
1390 // File: PastelPenguins.sol
1391 
1392 
1393 //
1394 //    ____    __    ___  ____  ____  __        ____  ____  _  _   ___  __  __  ____  _  _  ___ 
1395 //   (  _ \  /__\  / __)(_  _)( ___)(  )      (  _ \( ___)( \( ) / __)(  )(  )(_  _)( \( )/ __)
1396 //    )___/ /(  )\ \__ \  )(   )__)  )(__      )___/ )__)  )  ( ( (_-. )(__)(  _)(_  )  ( \__ \
1397 //   (__)  (__)(__)(___/ (__) (____)(____)    (__)  (____)(_)\_) \___/(______)(____)(_)\_)(___/
1398 //
1399 //   Twitter: @penguins_pastel
1400 
1401 
1402 
1403 
1404 
1405 
1406 
1407 
1408 
1409 
1410 
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 contract PastelPenguins is Ownable, ERC721 {
1415   
1416   using SafeMath for uint256;
1417   using Counters for Counters.Counter;
1418   Counters.Counter private _tokenIdCounter;
1419   
1420   uint256 public mintPrice = .0055 ether;
1421   uint256 public maxSupply = 5555;
1422   uint256 public freeMintAmount =1000;
1423   uint256 private mintLimit = 5;
1424   string private baseURI = "ipfs://QmUEJzKyAH8mXXsActmiWrjJgYL8kV6ffPAX9qMvBaHpvz/";
1425   bool public publicSaleState = true;
1426   bool public revealed = true;
1427   string private base_URI_tail = ".json";
1428   string private hiddenURI = "";
1429 
1430   constructor() ERC721("Pastel Penguins", "PASTELS") { 
1431   }
1432 
1433   function _hiddenURI() internal view returns (string memory) {
1434     return hiddenURI;
1435   }
1436   
1437   function _baseURI() internal view override returns (string memory) {
1438     return baseURI;
1439   }
1440 
1441   function setBaseURI(string calldata newBaseURI) external onlyOwner {
1442       baseURI = newBaseURI;
1443   }
1444 
1445   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1446     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1447     if(revealed == false) {
1448         return hiddenURI; 
1449     }
1450   string memory currentBaseURI = _baseURI();
1451   return string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), base_URI_tail));
1452   }  
1453 
1454   function reveal() public onlyOwner returns(bool) {
1455     revealed = !revealed;
1456     return revealed;
1457   }
1458       
1459   function changeStatePublicSale() public onlyOwner returns(bool) {
1460     publicSaleState = !publicSaleState;
1461     return publicSaleState;
1462   }
1463 
1464   function mint(uint numberOfTokens) external payable {
1465     require(publicSaleState, "Sale is not active");
1466     require(_tokenIdCounter.current() <= maxSupply, "Not enough tokens left");
1467     require(numberOfTokens <= mintLimit, "Too many tokens for one transaction");
1468     if(_tokenIdCounter.current() >= freeMintAmount){
1469         require(msg.value >= mintPrice.mul(numberOfTokens), "Insufficient payment");
1470     }
1471     mintInternal(msg.sender, numberOfTokens);
1472   }
1473  
1474   function mintInternal(address wallet, uint amount) internal {
1475     uint currentTokenSupply = _tokenIdCounter.current();
1476     require(currentTokenSupply.add(amount) <= maxSupply, "Not enough tokens left");
1477         for(uint i = 0; i< amount; i++){
1478         currentTokenSupply++;
1479         _safeMint(wallet, currentTokenSupply);
1480         _tokenIdCounter.increment();
1481     }
1482   }
1483   
1484   function reserve(uint256 numberOfTokens) external onlyOwner {
1485     mintInternal(msg.sender, numberOfTokens);
1486   }
1487   function setfreeAmount(uint16 _newFreeMints) public onlyOwner() {
1488     freeMintAmount = _newFreeMints;
1489   }
1490 
1491   function totalSupply() public view returns (uint){
1492     return _tokenIdCounter.current();
1493   }
1494 
1495   function withdraw() public onlyOwner {
1496     require(address(this).balance > 0, "No balance to withdraw");
1497     payable(owner()).transfer(address(this).balance); 
1498     }
1499 }