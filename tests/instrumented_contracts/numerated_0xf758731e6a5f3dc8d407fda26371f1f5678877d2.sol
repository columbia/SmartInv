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
277 // File: @openzeppelin/contracts/utils/Strings.sol
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
347 // File: @openzeppelin/contracts/utils/Context.sol
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
374 // File: @openzeppelin/contracts/access/Ownable.sol
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
452 // File: @openzeppelin/contracts/utils/Address.sol
453 
454 
455 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
456 
457 pragma solidity ^0.8.1;
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
677 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
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
707 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
735 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
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
766 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
911 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 
919 /**
920  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
921  * @dev See https://eips.ethereum.org/EIPS/eip-721
922  */
923 interface IERC721Metadata is IERC721 {
924     /**
925      * @dev Returns the token collection name.
926      */
927     function name() external view returns (string memory);
928 
929     /**
930      * @dev Returns the token collection symbol.
931      */
932     function symbol() external view returns (string memory);
933 
934     /**
935      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
936      */
937     function tokenURI(uint256 tokenId) external view returns (string memory);
938 }
939 
940 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
941 
942 
943 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
944 
945 pragma solidity ^0.8.0;
946 
947 
948 
949 
950 
951 
952 
953 
954 /**
955  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
956  * the Metadata extension, but not including the Enumerable extension, which is available separately as
957  * {ERC721Enumerable}.
958  */
959 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
960     using Address for address;
961     using Strings for uint256;
962 
963     // Token name
964     string private _name;
965 
966     // Token symbol
967     string private _symbol;
968 
969     // Mapping from token ID to owner address
970     mapping(uint256 => address) private _owners;
971 
972     // Mapping owner address to token count
973     mapping(address => uint256) private _balances;
974 
975     // Mapping from token ID to approved address
976     mapping(uint256 => address) private _tokenApprovals;
977 
978     // Mapping from owner to operator approvals
979     mapping(address => mapping(address => bool)) private _operatorApprovals;
980 
981     /**
982      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
983      */
984     constructor(string memory name_, string memory symbol_) {
985         _name = name_;
986         _symbol = symbol_;
987     }
988 
989     /**
990      * @dev See {IERC165-supportsInterface}.
991      */
992     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
993         return
994             interfaceId == type(IERC721).interfaceId ||
995             interfaceId == type(IERC721Metadata).interfaceId ||
996             super.supportsInterface(interfaceId);
997     }
998 
999     /**
1000      * @dev See {IERC721-balanceOf}.
1001      */
1002     function balanceOf(address owner) public view virtual override returns (uint256) {
1003         require(owner != address(0), "ERC721: balance query for the zero address");
1004         return _balances[owner];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-ownerOf}.
1009      */
1010     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1011         address owner = _owners[tokenId];
1012         require(owner != address(0), "ERC721: owner query for nonexistent token");
1013         return owner;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-name}.
1018      */
1019     function name() public view virtual override returns (string memory) {
1020         return _name;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Metadata-symbol}.
1025      */
1026     function symbol() public view virtual override returns (string memory) {
1027         return _symbol;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Metadata-tokenURI}.
1032      */
1033     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1034         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1035 
1036         string memory baseURI = _baseURI();
1037         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1038     }
1039 
1040     /**
1041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1042      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1043      * by default, can be overriden in child contracts.
1044      */
1045     function _baseURI() internal view virtual returns (string memory) {
1046         return "";
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-approve}.
1051      */
1052     function approve(address to, uint256 tokenId) public virtual override {
1053         address owner = ERC721.ownerOf(tokenId);
1054         require(to != owner, "ERC721: approval to current owner");
1055 
1056         require(
1057             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1058             "ERC721: approve caller is not owner nor approved for all"
1059         );
1060 
1061         _approve(to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-getApproved}.
1066      */
1067     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1068         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1069 
1070         return _tokenApprovals[tokenId];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-setApprovalForAll}.
1075      */
1076     function setApprovalForAll(address operator, bool approved) public virtual override {
1077         _setApprovalForAll(_msgSender(), operator, approved);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-isApprovedForAll}.
1082      */
1083     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1084         return _operatorApprovals[owner][operator];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-transferFrom}.
1089      */
1090     function transferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         //solhint-disable-next-line max-line-length
1096         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1097 
1098         _transfer(from, to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) public virtual override {
1109         safeTransferFrom(from, to, tokenId, "");
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-safeTransferFrom}.
1114      */
1115     function safeTransferFrom(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) public virtual override {
1121         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1122         _safeTransfer(from, to, tokenId, _data);
1123     }
1124 
1125     /**
1126      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1127      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1128      *
1129      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1130      *
1131      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1132      * implement alternative mechanisms to perform token transfer, such as signature-based.
1133      *
1134      * Requirements:
1135      *
1136      * - `from` cannot be the zero address.
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must exist and be owned by `from`.
1139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _safeTransfer(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory _data
1148     ) internal virtual {
1149         _transfer(from, to, tokenId);
1150         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1151     }
1152 
1153     /**
1154      * @dev Returns whether `tokenId` exists.
1155      *
1156      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1157      *
1158      * Tokens start existing when they are minted (`_mint`),
1159      * and stop existing when they are burned (`_burn`).
1160      */
1161     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1162         return _owners[tokenId] != address(0);
1163     }
1164 
1165     /**
1166      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      */
1172     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1173         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1174         address owner = ERC721.ownerOf(tokenId);
1175         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1176     }
1177 
1178     /**
1179      * @dev Safely mints `tokenId` and transfers it to `to`.
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must not exist.
1184      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _safeMint(address to, uint256 tokenId) internal virtual {
1189         _safeMint(to, tokenId, "");
1190     }
1191 
1192     /**
1193      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1194      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1195      */
1196     function _safeMint(
1197         address to,
1198         uint256 tokenId,
1199         bytes memory _data
1200     ) internal virtual {
1201         _mint(to, tokenId);
1202         require(
1203             _checkOnERC721Received(address(0), to, tokenId, _data),
1204             "ERC721: transfer to non ERC721Receiver implementer"
1205         );
1206     }
1207 
1208     /**
1209      * @dev Mints `tokenId` and transfers it to `to`.
1210      *
1211      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must not exist.
1216      * - `to` cannot be the zero address.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _mint(address to, uint256 tokenId) internal virtual {
1221         require(to != address(0), "ERC721: mint to the zero address");
1222         require(!_exists(tokenId), "ERC721: token already minted");
1223 
1224         _beforeTokenTransfer(address(0), to, tokenId);
1225 
1226         _balances[to] += 1;
1227         _owners[tokenId] = to;
1228 
1229         emit Transfer(address(0), to, tokenId);
1230 
1231         _afterTokenTransfer(address(0), to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId) internal virtual {
1245         address owner = ERC721.ownerOf(tokenId);
1246 
1247         _beforeTokenTransfer(owner, address(0), tokenId);
1248 
1249         // Clear approvals
1250         _approve(address(0), tokenId);
1251 
1252         _balances[owner] -= 1;
1253         delete _owners[tokenId];
1254 
1255         emit Transfer(owner, address(0), tokenId);
1256 
1257         _afterTokenTransfer(owner, address(0), tokenId);
1258     }
1259 
1260     /**
1261      * @dev Transfers `tokenId` from `from` to `to`.
1262      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1263      *
1264      * Requirements:
1265      *
1266      * - `to` cannot be the zero address.
1267      * - `tokenId` token must be owned by `from`.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _transfer(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) internal virtual {
1276         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1277         require(to != address(0), "ERC721: transfer to the zero address");
1278 
1279         _beforeTokenTransfer(from, to, tokenId);
1280 
1281         // Clear approvals from the previous owner
1282         _approve(address(0), tokenId);
1283 
1284         _balances[from] -= 1;
1285         _balances[to] += 1;
1286         _owners[tokenId] = to;
1287 
1288         emit Transfer(from, to, tokenId);
1289 
1290         _afterTokenTransfer(from, to, tokenId);
1291     }
1292 
1293     /**
1294      * @dev Approve `to` to operate on `tokenId`
1295      *
1296      * Emits a {Approval} event.
1297      */
1298     function _approve(address to, uint256 tokenId) internal virtual {
1299         _tokenApprovals[tokenId] = to;
1300         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Approve `operator` to operate on all of `owner` tokens
1305      *
1306      * Emits a {ApprovalForAll} event.
1307      */
1308     function _setApprovalForAll(
1309         address owner,
1310         address operator,
1311         bool approved
1312     ) internal virtual {
1313         require(owner != operator, "ERC721: approve to caller");
1314         _operatorApprovals[owner][operator] = approved;
1315         emit ApprovalForAll(owner, operator, approved);
1316     }
1317 
1318     /**
1319      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1320      * The call is not executed if the target address is not a contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkOnERC721Received(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes memory _data
1333     ) private returns (bool) {
1334         if (to.isContract()) {
1335             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1336                 return retval == IERC721Receiver.onERC721Received.selector;
1337             } catch (bytes memory reason) {
1338                 if (reason.length == 0) {
1339                     revert("ERC721: transfer to non ERC721Receiver implementer");
1340                 } else {
1341                     assembly {
1342                         revert(add(32, reason), mload(reason))
1343                     }
1344                 }
1345             }
1346         } else {
1347             return true;
1348         }
1349     }
1350 
1351     /**
1352      * @dev Hook that is called before any token transfer. This includes minting
1353      * and burning.
1354      *
1355      * Calling conditions:
1356      *
1357      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1358      * transferred to `to`.
1359      * - When `from` is zero, `tokenId` will be minted for `to`.
1360      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1361      * - `from` and `to` are never both zero.
1362      *
1363      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1364      */
1365     function _beforeTokenTransfer(
1366         address from,
1367         address to,
1368         uint256 tokenId
1369     ) internal virtual {}
1370 
1371     /**
1372      * @dev Hook that is called after any transfer of tokens. This includes
1373      * minting and burning.
1374      *
1375      * Calling conditions:
1376      *
1377      * - when `from` and `to` are both non-zero.
1378      * - `from` and `to` are never both zero.
1379      *
1380      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1381      */
1382     function _afterTokenTransfer(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) internal virtual {}
1387 }
1388 
1389 // File: contracts/MonsterFriends.sol
1390 
1391 
1392 
1393 pragma solidity 0.8.7;
1394 
1395 
1396 
1397 
1398 
1399 contract MonsterFriends is ERC721, Ownable {
1400 
1401     using SafeMath for uint256;
1402     using Counters for Counters.Counter;
1403 
1404     Counters.Counter private supply;
1405 
1406     string public baseTokenURI;
1407 
1408     uint256 public price = 0.044 ether;
1409     uint256 public saleState = 0;  // 0 = paused, 1 = live
1410     uint256 public max_monsters = 5555;
1411     uint256 public purchase_limit = 50;
1412     uint256 public reserved_amount = 700;
1413 
1414     // withdraw address
1415     address public a1 = 0xA24237b3702A7E98878a71d0C018511AcA61E1a1;
1416 
1417     // doxxd withdraw address - immutable
1418     address public a2_immutable = 0xC1FDc68dc63d3316F32420d4d2c3DeA43091bCDD;
1419 
1420     //constructor
1421     constructor(string memory _baseTokenURI) ERC721("MonsterFriends","MONSTER") {
1422         baseTokenURI = _baseTokenURI;
1423     }    
1424 
1425     //mint functions
1426     function mintMonsters(uint256 num) public payable {
1427 
1428         require( msg.value >= price * num,  "Ether sent is insufficient" );
1429 
1430         _mintMonsters(num);
1431     }
1432 
1433     //private function
1434     function _mintMonsters(uint256 num) private {
1435         
1436         require( saleState > 0,             "Main sale is not active" );
1437         require( num <= purchase_limit,     "Requested mints exceed maximum" );
1438         require(supply.current() + num <= (max_monsters - reserved_amount), "Requested mints exceed remaining supply");
1439             for(uint256 i; i < num; i++){
1440                 unchecked {
1441                     supply.increment();
1442                 }
1443                 _safeMint( msg.sender, supply.current());
1444             }
1445 
1446     }
1447 
1448     //views
1449 
1450     //override so openzeppelin tokenURI() can utilize the baseTokenURI we set
1451     function _baseURI() internal view virtual override returns (string memory) {
1452         return baseTokenURI;
1453     }
1454 
1455     function totalSupply() public view returns (uint256) {
1456         return supply.current();
1457     }
1458 
1459     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1460         uint256 tokenCount = balanceOf(_owner);
1461         uint256[] memory tokenIds = new uint256[](tokenCount);
1462         uint256 currentTokenId = 1;
1463         uint256 ownedTokenIndex = 0;
1464 
1465         while (ownedTokenIndex < tokenCount && currentTokenId <= max_monsters) 
1466         {
1467             address currentTokenOwner = ownerOf(currentTokenId);
1468 
1469             if (currentTokenOwner == _owner) 
1470             {
1471                 tokenIds[ownedTokenIndex] = currentTokenId;
1472                 ownedTokenIndex++;
1473             }
1474 
1475             currentTokenId++;
1476         }
1477 
1478         return tokenIds;
1479     }
1480 
1481 
1482     //setters
1483 
1484     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1485         baseTokenURI = _baseTokenURI;
1486     }
1487 
1488     function setPrice(uint256 _newPrice) public onlyOwner() {
1489         price = _newPrice;
1490     }
1491 
1492     function setMaxMonsters(uint256 _newMax) public onlyOwner{
1493         max_monsters = _newMax;
1494     }    
1495     // 0 = paused, 1 = live 
1496     function setSaleState(uint256 _saleState) public onlyOwner {
1497         saleState = _saleState;
1498     }
1499 
1500     function setPurchaseLimit(uint256 _newLimit) public onlyOwner{
1501         purchase_limit = _newLimit;
1502     }
1503 
1504     function setWithdrawAddress(address _a) public onlyOwner {
1505         a1 = _a;
1506     }
1507 
1508     function setReservedAmount(uint256 _reservedAmount) public onlyOwner {
1509         reserved_amount = _reservedAmount;
1510     }
1511 
1512     //utils
1513     
1514     function giveAway(address _to, uint256 _count) external onlyOwner() {
1515 
1516         require(supply.current() + _count <= max_monsters, "Requested mints exceed remaining supply");
1517         
1518             for(uint256 i; i < _count; i++){
1519                 unchecked {
1520                     supply.increment();
1521                 }
1522                 _safeMint( _to, supply.current());
1523             }
1524     }
1525 
1526     function withdrawBalance() public payable onlyOwner {
1527         uint256 _tenth = address(this).balance / 10;
1528         uint256 _payment = _tenth * 7;
1529         uint256 _doxxdPayment = _tenth * 3;
1530         
1531         (bool success, ) = payable(a1).call{value: _payment}("");
1532         require(success, "Transfer failed to a1.");
1533         (bool success2, ) = payable(a2_immutable).call{value: _doxxdPayment}("");
1534         require(success2, "Transfer failed to a2.");
1535     }
1536 
1537 
1538 }