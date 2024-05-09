1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
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
61  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
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
277 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
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
347 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Provides information about the current execution context, including the
356  * sender of the transaction and its data. While these are generally available
357  * via msg.sender and msg.data, they should not be accessed in such a direct
358  * manner, since when dealing with meta-transactions the account sending and
359  * paying for execution may not be the actual sender (as far as an application
360  * is concerned).
361  *
362  * This contract is only required for intermediate, library-like contracts.
363  */
364 abstract contract Context {
365     function _msgSender() internal view virtual returns (address) {
366         return msg.sender;
367     }
368 
369     function _msgData() internal view virtual returns (bytes calldata) {
370         return msg.data;
371     }
372 }
373 
374 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
375 
376 
377 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 abstract contract Ownable is Context {
395     address private _owner;
396 
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor() {
403         _transferOwnership(_msgSender());
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view virtual returns (address) {
410         return _owner;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417         require(owner() == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         _transferOwnership(address(0));
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Can only be called by the current owner.
435      */
436     function transferOwnership(address newOwner) public virtual onlyOwner {
437         require(newOwner != address(0), "Ownable: new owner is the zero address");
438         _transferOwnership(newOwner);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Internal function without access restriction.
444      */
445     function _transferOwnership(address newOwner) internal virtual {
446         address oldOwner = _owner;
447         _owner = newOwner;
448         emit OwnershipTransferred(oldOwner, newOwner);
449     }
450 }
451 
452 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Collection of functions related to the address type
461  */
462 library Address {
463     /**
464      * @dev Returns true if `account` is a contract.
465      *
466      * [IMPORTANT]
467      * ====
468      * It is unsafe to assume that an address for which this function returns
469      * false is an externally-owned account (EOA) and not a contract.
470      *
471      * Among others, `isContract` will return false for the following
472      * types of addresses:
473      *
474      *  - an externally-owned account
475      *  - a contract in construction
476      *  - an address where a contract will be created
477      *  - an address where a contract lived, but was destroyed
478      * ====
479      *
480      * [IMPORTANT]
481      * ====
482      * You shouldn't rely on `isContract` to protect against flash loan attacks!
483      *
484      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
485      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
486      * constructor.
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // This method relies on extcodesize/address.code.length, which returns 0
491         // for contracts in construction, since the code is only stored at the end
492         // of the constructor execution.
493 
494         return account.code.length > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         (bool success, ) = recipient.call{value: amount}("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 
520     /**
521      * @dev Performs a Solidity function call using a low level `call`. A
522      * plain `call` is an unsafe replacement for a function call: use this
523      * function instead.
524      *
525      * If `target` reverts with a revert reason, it is bubbled up by this
526      * function (like regular Solidity function calls).
527      *
528      * Returns the raw returned data. To convert to the expected return value,
529      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
530      *
531      * Requirements:
532      *
533      * - `target` must be a contract.
534      * - calling `target` with `data` must not revert.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionCall(target, data, "Address: low-level call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
544      * `errorMessage` as a fallback revert reason when `target` reverts.
545      *
546      * _Available since v3.1._
547      */
548     function functionCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(address(this).balance >= value, "Address: insufficient balance for call");
588         require(isContract(target), "Address: call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.call{value: value}(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a static call.
597      *
598      * _Available since v3.3._
599      */
600     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
601         return functionStaticCall(target, data, "Address: low-level static call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a static call.
607      *
608      * _Available since v3.3._
609      */
610     function functionStaticCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal view returns (bytes memory) {
615         require(isContract(target), "Address: static call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.staticcall(data);
618         return verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a delegate call.
624      *
625      * _Available since v3.4._
626      */
627     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
628         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a delegate call.
634      *
635      * _Available since v3.4._
636      */
637     function functionDelegateCall(
638         address target,
639         bytes memory data,
640         string memory errorMessage
641     ) internal returns (bytes memory) {
642         require(isContract(target), "Address: delegate call to non-contract");
643 
644         (bool success, bytes memory returndata) = target.delegatecall(data);
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
650      * revert reason using the provided one.
651      *
652      * _Available since v4.3._
653      */
654     function verifyCallResult(
655         bool success,
656         bytes memory returndata,
657         string memory errorMessage
658     ) internal pure returns (bytes memory) {
659         if (success) {
660             return returndata;
661         } else {
662             // Look for revert reason and bubble it up if present
663             if (returndata.length > 0) {
664                 // The easiest way to bubble the revert reason is using memory via assembly
665 
666                 assembly {
667                     let returndata_size := mload(returndata)
668                     revert(add(32, returndata), returndata_size)
669                 }
670             } else {
671                 revert(errorMessage);
672             }
673         }
674     }
675 }
676 
677 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @title ERC721 token receiver interface
686  * @dev Interface for any contract that wants to support safeTransfers
687  * from ERC721 asset contracts.
688  */
689 interface IERC721Receiver {
690     /**
691      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
692      * by `operator` from `from`, this function is called.
693      *
694      * It must return its Solidity selector to confirm the token transfer.
695      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
696      *
697      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
698      */
699     function onERC721Received(
700         address operator,
701         address from,
702         uint256 tokenId,
703         bytes calldata data
704     ) external returns (bytes4);
705 }
706 
707 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 /**
715  * @dev Interface of the ERC165 standard, as defined in the
716  * https://eips.ethereum.org/EIPS/eip-165[EIP].
717  *
718  * Implementers can declare support of contract interfaces, which can then be
719  * queried by others ({ERC165Checker}).
720  *
721  * For an implementation, see {ERC165}.
722  */
723 interface IERC165 {
724     /**
725      * @dev Returns true if this contract implements the interface defined by
726      * `interfaceId`. See the corresponding
727      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
728      * to learn more about how these ids are created.
729      *
730      * This function call must use less than 30 000 gas.
731      */
732     function supportsInterface(bytes4 interfaceId) external view returns (bool);
733 }
734 
735 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Implementation of the {IERC165} interface.
745  *
746  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
747  * for the additional interface id that will be supported. For example:
748  *
749  * ```solidity
750  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
751  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
752  * }
753  * ```
754  *
755  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
756  */
757 abstract contract ERC165 is IERC165 {
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
762         return interfaceId == type(IERC165).interfaceId;
763     }
764 }
765 
766 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @dev Required interface of an ERC721 compliant contract.
776  */
777 interface IERC721 is IERC165 {
778     /**
779      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
780      */
781     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
782 
783     /**
784      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
785      */
786     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
787 
788     /**
789      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
790      */
791     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
792 
793     /**
794      * @dev Returns the number of tokens in ``owner``'s account.
795      */
796     function balanceOf(address owner) external view returns (uint256 balance);
797 
798     /**
799      * @dev Returns the owner of the `tokenId` token.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must exist.
804      */
805     function ownerOf(uint256 tokenId) external view returns (address owner);
806 
807     /**
808      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
809      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) external;
826 
827     /**
828      * @dev Transfers `tokenId` token from `from` to `to`.
829      *
830      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must be owned by `from`.
837      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
838      *
839      * Emits a {Transfer} event.
840      */
841     function transferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) external;
846 
847     /**
848      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
849      * The approval is cleared when the token is transferred.
850      *
851      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
852      *
853      * Requirements:
854      *
855      * - The caller must own the token or be an approved operator.
856      * - `tokenId` must exist.
857      *
858      * Emits an {Approval} event.
859      */
860     function approve(address to, uint256 tokenId) external;
861 
862     /**
863      * @dev Returns the account approved for `tokenId` token.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function getApproved(uint256 tokenId) external view returns (address operator);
870 
871     /**
872      * @dev Approve or remove `operator` as an operator for the caller.
873      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
874      *
875      * Requirements:
876      *
877      * - The `operator` cannot be the caller.
878      *
879      * Emits an {ApprovalForAll} event.
880      */
881     function setApprovalForAll(address operator, bool _approved) external;
882 
883     /**
884      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
885      *
886      * See {setApprovalForAll}
887      */
888     function isApprovedForAll(address owner, address operator) external view returns (bool);
889 
890     /**
891      * @dev Safely transfers `tokenId` token from `from` to `to`.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must exist and be owned by `from`.
898      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes calldata data
908     ) external;
909 }
910 
911 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 
919 /**
920  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
921  * @dev See https://eips.ethereum.org/EIPS/eip-721
922  */
923 interface IERC721Enumerable is IERC721 {
924     /**
925      * @dev Returns the total amount of tokens stored by the contract.
926      */
927     function totalSupply() external view returns (uint256);
928 
929     /**
930      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
931      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
932      */
933     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
934 
935     /**
936      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
937      * Use along with {totalSupply} to enumerate all tokens.
938      */
939     function tokenByIndex(uint256 index) external view returns (uint256);
940 }
941 
942 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
943 
944 
945 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
946 
947 pragma solidity ^0.8.0;
948 
949 
950 /**
951  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
952  * @dev See https://eips.ethereum.org/EIPS/eip-721
953  */
954 interface IERC721Metadata is IERC721 {
955     /**
956      * @dev Returns the token collection name.
957      */
958     function name() external view returns (string memory);
959 
960     /**
961      * @dev Returns the token collection symbol.
962      */
963     function symbol() external view returns (string memory);
964 
965     /**
966      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
967      */
968     function tokenURI(uint256 tokenId) external view returns (string memory);
969 }
970 
971 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
972 
973 
974 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
975 
976 pragma solidity ^0.8.0;
977 
978 
979 
980 
981 
982 
983 
984 
985 /**
986  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
987  * the Metadata extension, but not including the Enumerable extension, which is available separately as
988  * {ERC721Enumerable}.
989  */
990 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
991     using Address for address;
992     using Strings for uint256;
993 
994     // Token name
995     string private _name;
996 
997     // Token symbol
998     string private _symbol;
999 
1000     // Mapping from token ID to owner address
1001     mapping(uint256 => address) private _owners;
1002 
1003     // Mapping owner address to token count
1004     mapping(address => uint256) private _balances;
1005 
1006     // Mapping from token ID to approved address
1007     mapping(uint256 => address) private _tokenApprovals;
1008 
1009     // Mapping from owner to operator approvals
1010     mapping(address => mapping(address => bool)) private _operatorApprovals;
1011 
1012     /**
1013      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1014      */
1015     constructor(string memory name_, string memory symbol_) {
1016         _name = name_;
1017         _symbol = symbol_;
1018     }
1019 
1020     /**
1021      * @dev See {IERC165-supportsInterface}.
1022      */
1023     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1024         return
1025             interfaceId == type(IERC721).interfaceId ||
1026             interfaceId == type(IERC721Metadata).interfaceId ||
1027             super.supportsInterface(interfaceId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-balanceOf}.
1032      */
1033     function balanceOf(address owner) public view virtual override returns (uint256) {
1034         require(owner != address(0), "ERC721: balance query for the zero address");
1035         return _balances[owner];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-ownerOf}.
1040      */
1041     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1042         address owner = _owners[tokenId];
1043         require(owner != address(0), "ERC721: owner query for nonexistent token");
1044         return owner;
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Metadata-name}.
1049      */
1050     function name() public view virtual override returns (string memory) {
1051         return _name;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Metadata-symbol}.
1056      */
1057     function symbol() public view virtual override returns (string memory) {
1058         return _symbol;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-tokenURI}.
1063      */
1064     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1065         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1066 
1067         string memory baseURI = _baseURI();
1068         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1069     }
1070 
1071     /**
1072      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1073      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1074      * by default, can be overriden in child contracts.
1075      */
1076     function _baseURI() internal view virtual returns (string memory) {
1077         return "";
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-approve}.
1082      */
1083     function approve(address to, uint256 tokenId) public virtual override {
1084         address owner = ERC721.ownerOf(tokenId);
1085         require(to != owner, "ERC721: approval to current owner");
1086 
1087         require(
1088             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1089             "ERC721: approve caller is not owner nor approved for all"
1090         );
1091 
1092         _approve(to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-getApproved}.
1097      */
1098     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1099         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1100 
1101         return _tokenApprovals[tokenId];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-setApprovalForAll}.
1106      */
1107     function setApprovalForAll(address operator, bool approved) public virtual override {
1108         _setApprovalForAll(_msgSender(), operator, approved);
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-isApprovedForAll}.
1113      */
1114     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1115         return _operatorApprovals[owner][operator];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-transferFrom}.
1120      */
1121     function transferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) public virtual override {
1126         //solhint-disable-next-line max-line-length
1127         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1128 
1129         _transfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) public virtual override {
1140         safeTransferFrom(from, to, tokenId, "");
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-safeTransferFrom}.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) public virtual override {
1152         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1153         _safeTransfer(from, to, tokenId, _data);
1154     }
1155 
1156     /**
1157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1159      *
1160      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1161      *
1162      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1163      * implement alternative mechanisms to perform token transfer, such as signature-based.
1164      *
1165      * Requirements:
1166      *
1167      * - `from` cannot be the zero address.
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must exist and be owned by `from`.
1170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _safeTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) internal virtual {
1180         _transfer(from, to, tokenId);
1181         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1182     }
1183 
1184     /**
1185      * @dev Returns whether `tokenId` exists.
1186      *
1187      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1188      *
1189      * Tokens start existing when they are minted (`_mint`),
1190      * and stop existing when they are burned (`_burn`).
1191      */
1192     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1193         return _owners[tokenId] != address(0);
1194     }
1195 
1196     /**
1197      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      */
1203     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1204         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1205         address owner = ERC721.ownerOf(tokenId);
1206         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1207     }
1208 
1209     /**
1210      * @dev Safely mints `tokenId` and transfers it to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must not exist.
1215      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _safeMint(address to, uint256 tokenId) internal virtual {
1220         _safeMint(to, tokenId, "");
1221     }
1222 
1223     /**
1224      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1225      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1226      */
1227     function _safeMint(
1228         address to,
1229         uint256 tokenId,
1230         bytes memory _data
1231     ) internal virtual {
1232         _mint(to, tokenId);
1233         require(
1234             _checkOnERC721Received(address(0), to, tokenId, _data),
1235             "ERC721: transfer to non ERC721Receiver implementer"
1236         );
1237     }
1238 
1239     /**
1240      * @dev Mints `tokenId` and transfers it to `to`.
1241      *
1242      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must not exist.
1247      * - `to` cannot be the zero address.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _mint(address to, uint256 tokenId) internal virtual {
1252         require(to != address(0), "ERC721: mint to the zero address");
1253         require(!_exists(tokenId), "ERC721: token already minted");
1254 
1255         _beforeTokenTransfer(address(0), to, tokenId);
1256 
1257         _balances[to] += 1;
1258         _owners[tokenId] = to;
1259 
1260         emit Transfer(address(0), to, tokenId);
1261 
1262         _afterTokenTransfer(address(0), to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Destroys `tokenId`.
1267      * The approval is cleared when the token is burned.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _burn(uint256 tokenId) internal virtual {
1276         address owner = ERC721.ownerOf(tokenId);
1277 
1278         _beforeTokenTransfer(owner, address(0), tokenId);
1279 
1280         // Clear approvals
1281         _approve(address(0), tokenId);
1282 
1283         _balances[owner] -= 1;
1284         delete _owners[tokenId];
1285 
1286         emit Transfer(owner, address(0), tokenId);
1287 
1288         _afterTokenTransfer(owner, address(0), tokenId);
1289     }
1290 
1291     /**
1292      * @dev Transfers `tokenId` from `from` to `to`.
1293      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1294      *
1295      * Requirements:
1296      *
1297      * - `to` cannot be the zero address.
1298      * - `tokenId` token must be owned by `from`.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _transfer(
1303         address from,
1304         address to,
1305         uint256 tokenId
1306     ) internal virtual {
1307         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1308         require(to != address(0), "ERC721: transfer to the zero address");
1309 
1310         _beforeTokenTransfer(from, to, tokenId);
1311 
1312         // Clear approvals from the previous owner
1313         _approve(address(0), tokenId);
1314 
1315         _balances[from] -= 1;
1316         _balances[to] += 1;
1317         _owners[tokenId] = to;
1318 
1319         emit Transfer(from, to, tokenId);
1320 
1321         _afterTokenTransfer(from, to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Approve `to` to operate on `tokenId`
1326      *
1327      * Emits a {Approval} event.
1328      */
1329     function _approve(address to, uint256 tokenId) internal virtual {
1330         _tokenApprovals[tokenId] = to;
1331         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1332     }
1333 
1334     /**
1335      * @dev Approve `operator` to operate on all of `owner` tokens
1336      *
1337      * Emits a {ApprovalForAll} event.
1338      */
1339     function _setApprovalForAll(
1340         address owner,
1341         address operator,
1342         bool approved
1343     ) internal virtual {
1344         require(owner != operator, "ERC721: approve to caller");
1345         _operatorApprovals[owner][operator] = approved;
1346         emit ApprovalForAll(owner, operator, approved);
1347     }
1348 
1349     /**
1350      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1351      * The call is not executed if the target address is not a contract.
1352      *
1353      * @param from address representing the previous owner of the given token ID
1354      * @param to target address that will receive the tokens
1355      * @param tokenId uint256 ID of the token to be transferred
1356      * @param _data bytes optional data to send along with the call
1357      * @return bool whether the call correctly returned the expected magic value
1358      */
1359     function _checkOnERC721Received(
1360         address from,
1361         address to,
1362         uint256 tokenId,
1363         bytes memory _data
1364     ) private returns (bool) {
1365         if (to.isContract()) {
1366             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1367                 return retval == IERC721Receiver.onERC721Received.selector;
1368             } catch (bytes memory reason) {
1369                 if (reason.length == 0) {
1370                     revert("ERC721: transfer to non ERC721Receiver implementer");
1371                 } else {
1372                     assembly {
1373                         revert(add(32, reason), mload(reason))
1374                     }
1375                 }
1376             }
1377         } else {
1378             return true;
1379         }
1380     }
1381 
1382     /**
1383      * @dev Hook that is called before any token transfer. This includes minting
1384      * and burning.
1385      *
1386      * Calling conditions:
1387      *
1388      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1389      * transferred to `to`.
1390      * - When `from` is zero, `tokenId` will be minted for `to`.
1391      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1392      * - `from` and `to` are never both zero.
1393      *
1394      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1395      */
1396     function _beforeTokenTransfer(
1397         address from,
1398         address to,
1399         uint256 tokenId
1400     ) internal virtual {}
1401 
1402     /**
1403      * @dev Hook that is called after any transfer of tokens. This includes
1404      * minting and burning.
1405      *
1406      * Calling conditions:
1407      *
1408      * - when `from` and `to` are both non-zero.
1409      * - `from` and `to` are never both zero.
1410      *
1411      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1412      */
1413     function _afterTokenTransfer(
1414         address from,
1415         address to,
1416         uint256 tokenId
1417     ) internal virtual {}
1418 }
1419 
1420 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1421 
1422 
1423 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1424 
1425 pragma solidity ^0.8.0;
1426 
1427 
1428 
1429 /**
1430  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1431  * enumerability of all the token ids in the contract as well as all token ids owned by each
1432  * account.
1433  */
1434 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1435     // Mapping from owner to list of owned token IDs
1436     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1437 
1438     // Mapping from token ID to index of the owner tokens list
1439     mapping(uint256 => uint256) private _ownedTokensIndex;
1440 
1441     // Array with all token ids, used for enumeration
1442     uint256[] private _allTokens;
1443 
1444     // Mapping from token id to position in the allTokens array
1445     mapping(uint256 => uint256) private _allTokensIndex;
1446 
1447     /**
1448      * @dev See {IERC165-supportsInterface}.
1449      */
1450     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1451         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1452     }
1453 
1454     /**
1455      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1456      */
1457     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1458         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1459         return _ownedTokens[owner][index];
1460     }
1461 
1462     /**
1463      * @dev See {IERC721Enumerable-totalSupply}.
1464      */
1465     function totalSupply() public view virtual override returns (uint256) {
1466         return _allTokens.length;
1467     }
1468 
1469     /**
1470      * @dev See {IERC721Enumerable-tokenByIndex}.
1471      */
1472     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1473         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1474         return _allTokens[index];
1475     }
1476 
1477     /**
1478      * @dev Hook that is called before any token transfer. This includes minting
1479      * and burning.
1480      *
1481      * Calling conditions:
1482      *
1483      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1484      * transferred to `to`.
1485      * - When `from` is zero, `tokenId` will be minted for `to`.
1486      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1487      * - `from` cannot be the zero address.
1488      * - `to` cannot be the zero address.
1489      *
1490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1491      */
1492     function _beforeTokenTransfer(
1493         address from,
1494         address to,
1495         uint256 tokenId
1496     ) internal virtual override {
1497         super._beforeTokenTransfer(from, to, tokenId);
1498 
1499         if (from == address(0)) {
1500             _addTokenToAllTokensEnumeration(tokenId);
1501         } else if (from != to) {
1502             _removeTokenFromOwnerEnumeration(from, tokenId);
1503         }
1504         if (to == address(0)) {
1505             _removeTokenFromAllTokensEnumeration(tokenId);
1506         } else if (to != from) {
1507             _addTokenToOwnerEnumeration(to, tokenId);
1508         }
1509     }
1510 
1511     /**
1512      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1513      * @param to address representing the new owner of the given token ID
1514      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1515      */
1516     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1517         uint256 length = ERC721.balanceOf(to);
1518         _ownedTokens[to][length] = tokenId;
1519         _ownedTokensIndex[tokenId] = length;
1520     }
1521 
1522     /**
1523      * @dev Private function to add a token to this extension's token tracking data structures.
1524      * @param tokenId uint256 ID of the token to be added to the tokens list
1525      */
1526     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1527         _allTokensIndex[tokenId] = _allTokens.length;
1528         _allTokens.push(tokenId);
1529     }
1530 
1531     /**
1532      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1533      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1534      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1535      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1536      * @param from address representing the previous owner of the given token ID
1537      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1538      */
1539     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1540         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1541         // then delete the last slot (swap and pop).
1542 
1543         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1544         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1545 
1546         // When the token to delete is the last token, the swap operation is unnecessary
1547         if (tokenIndex != lastTokenIndex) {
1548             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1549 
1550             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1551             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1552         }
1553 
1554         // This also deletes the contents at the last position of the array
1555         delete _ownedTokensIndex[tokenId];
1556         delete _ownedTokens[from][lastTokenIndex];
1557     }
1558 
1559     /**
1560      * @dev Private function to remove a token from this extension's token tracking data structures.
1561      * This has O(1) time complexity, but alters the order of the _allTokens array.
1562      * @param tokenId uint256 ID of the token to be removed from the tokens list
1563      */
1564     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1565         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1566         // then delete the last slot (swap and pop).
1567 
1568         uint256 lastTokenIndex = _allTokens.length - 1;
1569         uint256 tokenIndex = _allTokensIndex[tokenId];
1570 
1571         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1572         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1573         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1574         uint256 lastTokenId = _allTokens[lastTokenIndex];
1575 
1576         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1577         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1578 
1579         // This also deletes the contents at the last position of the array
1580         delete _allTokensIndex[tokenId];
1581         _allTokens.pop();
1582     }
1583 }
1584 
1585 // File: contracts/1_PixelAliens.sol
1586 
1587 
1588 
1589 pragma solidity ^0.8.0;
1590 
1591 
1592 
1593 
1594 
1595 
1596 
1597 contract PixelAliens is ERC721Enumerable, Ownable{
1598 
1599     using SafeMath for uint256;
1600 
1601     using Counters for Counters.Counter;
1602 
1603     Counters.Counter private tokenCounter;
1604 
1605 
1606 
1607     constructor(string memory _value) ERC721("Pixel Aliens", "Alien") {
1608 
1609         setBaseURI(_value);
1610 
1611         mintGiveaway();
1612 
1613     }
1614 
1615 
1616 
1617     // Hash of images at original index: 159399aeae641247dd6103c9d7fd8916704f7abf495e431e4bb351a7ac470a2e
1618 
1619     string public PROVENANCE = '';
1620 
1621     function setProvenance(string memory _hash) public onlyOwner {
1622 
1623         PROVENANCE = _hash;
1624 
1625     }
1626 
1627 
1628 
1629     uint256 public offSetIndex;
1630 
1631     uint256 public offSetIndexBlock;
1632 
1633 
1634 
1635     address public constant Address1 = 0x97EdbB51Da68191a667B7d919C00EF6992Ae30D3; // Artist
1636 
1637     address public constant Address2 = 0x001934f98262Cb8A29eC329BE6c6Ae89dAA860C9; // Community lead
1638 
1639     address public constant Address3 = 0x3251B9F18aad322bF8b2753728CC1a42C8FbdA6D; // Dev
1640 
1641     address public constant Address4 = 0x399e8EE6C140eA41C9D2f818bba6fa3a1D20064D; // Community wallet
1642 
1643 
1644 
1645     uint256 public constant MAX_MINTED = 3333;
1646 
1647 
1648 
1649     uint256 public constant PURCHASE_LIMIT = 5;
1650 
1651     uint256 public constant WlistPURSHASE_LIMIT = 3;
1652 
1653 
1654 
1655     uint256 public constant PRICE = 0.05 ether;
1656 
1657     uint256 public constant wlistPRICE = 0.03 ether;
1658 
1659 
1660 
1661     // 0 - closed,  1 - whitelist, 2 - public
1662 
1663     uint256 public saleSTATE = 0;
1664 
1665     string public BaseURI;
1666 
1667 
1668 
1669     uint256 public constant WHITELIST_MAXMEMBERS = 555;
1670 
1671     uint256 public WHITELIST_MEMBERCOUNT = 0;
1672 
1673     mapping (address => whiteListStruct) public WHITELIST;
1674 
1675     struct whiteListStruct{
1676 
1677         uint256 amountPurchased;
1678 
1679         bool exists;
1680 
1681     }
1682 
1683 
1684 
1685     event SaleStateChanged(uint256 _value);
1686 
1687     event OffSetIndexBlockSet(uint256 _value);
1688 
1689     event offSetIndexSet(uint256 _value);
1690 
1691 
1692 
1693     function setBaseURI(string memory _value) public onlyOwner{
1694 
1695         BaseURI = _value;
1696 
1697     }
1698 
1699 
1700 
1701     function _baseURI() internal view virtual override returns (string memory) {
1702 
1703         return BaseURI;
1704 
1705     }
1706 
1707 
1708 
1709     // tokens minted for a giveaway
1710 
1711     function mintGiveaway() public onlyOwner{
1712 
1713         require(totalSupply() == 0, "Supply higher than 0!");
1714 
1715         for (uint256 i = 1; i <= 10; i++){
1716 
1717             tokenCounter.increment();
1718 
1719             _safeMint(msg.sender, i);
1720 
1721         }
1722 
1723     }
1724 
1725 
1726 
1727     function addToWhiteList(address[] calldata _addresses) public onlyOwner{
1728 
1729         uint256 arrayLength = _addresses.length;
1730 
1731         require( (WHITELIST_MEMBERCOUNT + arrayLength) <= WHITELIST_MAXMEMBERS);
1732 
1733         for(uint256 i = 0; i < arrayLength; i++){
1734 
1735             require(!WHITELIST[_addresses[i]].exists, "Wallet already whitelisted!");
1736 
1737             WHITELIST_MEMBERCOUNT++;
1738 
1739             WHITELIST[_addresses[i]].exists = true;
1740 
1741         }
1742 
1743     }
1744 
1745 
1746 
1747     function checkWhiteList(address _address) public view returns(bool){
1748 
1749         require(WHITELIST[_address].exists, "Wallet is not whitelisted!");
1750 
1751         require(WHITELIST[_address].amountPurchased < WlistPURSHASE_LIMIT, "Whitelist purchase limit reached!");
1752 
1753         return true;
1754 
1755     }
1756 
1757 
1758 
1759     function updateSaleState(uint256 _value) public onlyOwner{
1760 
1761         require(_value < 3, 'Bad value entered!');
1762 
1763         saleSTATE = _value;
1764 
1765         emit SaleStateChanged(saleSTATE);
1766 
1767     }
1768 
1769 
1770 
1771     function mintToken(uint256 _amount) public payable{
1772 
1773         require( (_amount + totalSupply() ) <= MAX_MINTED, "Amount is beyond available tokens");
1774 
1775         require(saleSTATE > 0, 'Sales currently closed!');
1776 
1777 
1778 
1779         address wallet = _msgSender();
1780 
1781 
1782 
1783         if(saleSTATE == 1){
1784 
1785             require(checkWhiteList(wallet), "Sale aborted!");
1786 
1787             require(wlistPRICE.mul(_amount) <= msg.value, "Purchase price too low");
1788 
1789             require( (_amount + WHITELIST[wallet].amountPurchased) <= WlistPURSHASE_LIMIT, 'Purchase amount too high!');
1790 
1791             while(_amount > 0){
1792 
1793                 WHITELIST[wallet].amountPurchased++;
1794 
1795                 createToken(wallet);
1796 
1797                 _amount--;
1798 
1799             }
1800 
1801         }
1802 
1803         else{
1804 
1805             require(PRICE.mul(_amount) <= msg.value, "Purchase price too low");
1806 
1807             require( _amount <= PURCHASE_LIMIT, 'Purchase amount too high!');
1808 
1809             while(_amount > 0){
1810 
1811                 createToken(wallet);
1812 
1813                 _amount--;
1814 
1815             }
1816 
1817         }
1818 
1819     }
1820 
1821 
1822 
1823     function createToken(address _wallet) private{
1824 
1825         tokenCounter.increment();
1826 
1827         _safeMint(_wallet, tokenCounter.current());
1828 
1829 
1830 
1831         if (offSetIndexBlock == 0 && totalSupply() == MAX_MINTED){
1832 
1833             offSetIndexBlock = block.number;
1834 
1835             emit OffSetIndexBlockSet(offSetIndexBlock);
1836 
1837         }
1838 
1839     } 
1840 
1841 
1842 
1843     function mintUnsoldTokens(uint256 _amount) public onlyOwner{
1844 
1845         require(saleSTATE == 0, 'Sales not closed!');
1846 
1847         require( (_amount + totalSupply()) <= MAX_MINTED, "Amount higher than availiable tokens");
1848 
1849         while (_amount > 0){
1850 
1851             _amount--;
1852 
1853             createToken(msg.sender);
1854 
1855         }
1856 
1857     }
1858 
1859 
1860 
1861 
1862 
1863     function generateOffsetIndex() public{
1864 
1865         require(offSetIndexBlock != 0, "offSetIndexBlock has not been set!");
1866 
1867         require(offSetIndex == 0, "offSet has already been set!");
1868 
1869 
1870 
1871         uint256 _offset = offSetIndexBlock % MAX_MINTED;
1872 
1873 
1874 
1875         // That apes guy is a hero!
1876 
1877         if (block.number.sub(offSetIndexBlock) > 255 && _offset == 0) {
1878 
1879             _offset = uint256(blockhash(offSetIndexBlock - 1)) % MAX_MINTED;
1880 
1881         }
1882 
1883 
1884 
1885         require(_offset != 0, "Invalid offset generated!");
1886 
1887         offSetIndex = _offset;
1888 
1889         emit offSetIndexSet(offSetIndex);
1890 
1891     }
1892 
1893 
1894 
1895     function retryOffsetIndexBlock() public onlyOwner{
1896 
1897         require(offSetIndexBlock == 0, "offSetIndexBlock has already been set!");
1898 
1899         require(saleSTATE == 0, 'Sales not closed!');
1900 
1901         offSetIndexBlock = block.number;
1902 
1903         emit OffSetIndexBlockSet(offSetIndexBlock);
1904 
1905     }
1906 
1907 
1908 
1909     function withdrawETH() public onlyOwner {
1910 
1911         uint256 balance = address(this).balance;
1912 
1913 
1914 
1915         uint256 amount = balance.mul(25).div(100);
1916 
1917         payable(Address1).transfer(amount);
1918 
1919         payable(Address2).transfer(amount);
1920 
1921         payable(Address3).transfer(amount);
1922 
1923         payable(Address4).transfer(address(this).balance);
1924 
1925     }
1926 
1927 
1928 
1929 }