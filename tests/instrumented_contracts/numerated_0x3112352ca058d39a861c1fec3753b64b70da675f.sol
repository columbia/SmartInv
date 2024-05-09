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
280 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev String operations.
286  */
287 library Strings {
288     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
289     uint8 private constant _ADDRESS_LENGTH = 20;
290 
291     /**
292      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
293      */
294     function toString(uint256 value) internal pure returns (string memory) {
295         // Inspired by OraclizeAPI's implementation - MIT licence
296         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
297 
298         if (value == 0) {
299             return "0";
300         }
301         uint256 temp = value;
302         uint256 digits;
303         while (temp != 0) {
304             digits++;
305             temp /= 10;
306         }
307         bytes memory buffer = new bytes(digits);
308         while (value != 0) {
309             digits -= 1;
310             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
311             value /= 10;
312         }
313         return string(buffer);
314     }
315 
316     /**
317      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
318      */
319     function toHexString(uint256 value) internal pure returns (string memory) {
320         if (value == 0) {
321             return "0x00";
322         }
323         uint256 temp = value;
324         uint256 length = 0;
325         while (temp != 0) {
326             length++;
327             temp >>= 8;
328         }
329         return toHexString(value, length);
330     }
331 
332     /**
333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
334      */
335     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
336         bytes memory buffer = new bytes(2 * length + 2);
337         buffer[0] = "0";
338         buffer[1] = "x";
339         for (uint256 i = 2 * length + 1; i > 1; --i) {
340             buffer[i] = _HEX_SYMBOLS[value & 0xf];
341             value >>= 4;
342         }
343         require(value == 0, "Strings: hex length insufficient");
344         return string(buffer);
345     }
346 
347     /**
348      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
349      */
350     function toHexString(address addr) internal pure returns (string memory) {
351         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
352     }
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/access/Ownable.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Contract module which provides a basic access control mechanism, where
392  * there is an account (an owner) that can be granted exclusive access to
393  * specific functions.
394  *
395  * By default, the owner account will be the one that deploys the contract. This
396  * can later be changed with {transferOwnership}.
397  *
398  * This module is used through inheritance. It will make available the modifier
399  * `onlyOwner`, which can be applied to your functions to restrict their use to
400  * the owner.
401  */
402 abstract contract Ownable is Context {
403     address private _owner;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor() {
411         _transferOwnership(_msgSender());
412     }
413 
414     /**
415      * @dev Throws if called by any account other than the owner.
416      */
417     modifier onlyOwner() {
418         _checkOwner();
419         _;
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view virtual returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if the sender is not the owner.
431      */
432     function _checkOwner() internal view virtual {
433         require(owner() == _msgSender(), "Ownable: caller is not the owner");
434     }
435 
436     /**
437      * @dev Leaves the contract without owner. It will not be possible to call
438      * `onlyOwner` functions anymore. Can only be called by the current owner.
439      *
440      * NOTE: Renouncing ownership will leave the contract without an owner,
441      * thereby removing any functionality that is only available to the owner.
442      */
443     function renounceOwnership() public virtual onlyOwner {
444         _transferOwnership(address(0));
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Can only be called by the current owner.
450      */
451     function transferOwnership(address newOwner) public virtual onlyOwner {
452         require(newOwner != address(0), "Ownable: new owner is the zero address");
453         _transferOwnership(newOwner);
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Internal function without access restriction.
459      */
460     function _transferOwnership(address newOwner) internal virtual {
461         address oldOwner = _owner;
462         _owner = newOwner;
463         emit OwnershipTransferred(oldOwner, newOwner);
464     }
465 }
466 
467 // File: @openzeppelin/contracts/utils/Address.sol
468 
469 
470 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
471 
472 pragma solidity ^0.8.1;
473 
474 /**
475  * @dev Collection of functions related to the address type
476  */
477 library Address {
478     /**
479      * @dev Returns true if `account` is a contract.
480      *
481      * [IMPORTANT]
482      * ====
483      * It is unsafe to assume that an address for which this function returns
484      * false is an externally-owned account (EOA) and not a contract.
485      *
486      * Among others, `isContract` will return false for the following
487      * types of addresses:
488      *
489      *  - an externally-owned account
490      *  - a contract in construction
491      *  - an address where a contract will be created
492      *  - an address where a contract lived, but was destroyed
493      * ====
494      *
495      * [IMPORTANT]
496      * ====
497      * You shouldn't rely on `isContract` to protect against flash loan attacks!
498      *
499      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
500      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
501      * constructor.
502      * ====
503      */
504     function isContract(address account) internal view returns (bool) {
505         // This method relies on extcodesize/address.code.length, which returns 0
506         // for contracts in construction, since the code is only stored at the end
507         // of the constructor execution.
508 
509         return account.code.length > 0;
510     }
511 
512     /**
513      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
514      * `recipient`, forwarding all available gas and reverting on errors.
515      *
516      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
517      * of certain opcodes, possibly making contracts go over the 2300 gas limit
518      * imposed by `transfer`, making them unable to receive funds via
519      * `transfer`. {sendValue} removes this limitation.
520      *
521      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
522      *
523      * IMPORTANT: because control is transferred to `recipient`, care must be
524      * taken to not create reentrancy vulnerabilities. Consider using
525      * {ReentrancyGuard} or the
526      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
527      */
528     function sendValue(address payable recipient, uint256 amount) internal {
529         require(address(this).balance >= amount, "Address: insufficient balance");
530 
531         (bool success, ) = recipient.call{value: amount}("");
532         require(success, "Address: unable to send value, recipient may have reverted");
533     }
534 
535     /**
536      * @dev Performs a Solidity function call using a low level `call`. A
537      * plain `call` is an unsafe replacement for a function call: use this
538      * function instead.
539      *
540      * If `target` reverts with a revert reason, it is bubbled up by this
541      * function (like regular Solidity function calls).
542      *
543      * Returns the raw returned data. To convert to the expected return value,
544      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
545      *
546      * Requirements:
547      *
548      * - `target` must be a contract.
549      * - calling `target` with `data` must not revert.
550      *
551      * _Available since v3.1._
552      */
553     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
554         return functionCall(target, data, "Address: low-level call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
559      * `errorMessage` as a fallback revert reason when `target` reverts.
560      *
561      * _Available since v3.1._
562      */
563     function functionCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, 0, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but also transferring `value` wei to `target`.
574      *
575      * Requirements:
576      *
577      * - the calling contract must have an ETH balance of at least `value`.
578      * - the called Solidity function must be `payable`.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(
583         address target,
584         bytes memory data,
585         uint256 value
586     ) internal returns (bytes memory) {
587         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
592      * with `errorMessage` as a fallback revert reason when `target` reverts.
593      *
594      * _Available since v3.1._
595      */
596     function functionCallWithValue(
597         address target,
598         bytes memory data,
599         uint256 value,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         require(address(this).balance >= value, "Address: insufficient balance for call");
603         require(isContract(target), "Address: call to non-contract");
604 
605         (bool success, bytes memory returndata) = target.call{value: value}(data);
606         return verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
611      * but performing a static call.
612      *
613      * _Available since v3.3._
614      */
615     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
616         return functionStaticCall(target, data, "Address: low-level static call failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
621      * but performing a static call.
622      *
623      * _Available since v3.3._
624      */
625     function functionStaticCall(
626         address target,
627         bytes memory data,
628         string memory errorMessage
629     ) internal view returns (bytes memory) {
630         require(isContract(target), "Address: static call to non-contract");
631 
632         (bool success, bytes memory returndata) = target.staticcall(data);
633         return verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but performing a delegate call.
639      *
640      * _Available since v3.4._
641      */
642     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
643         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
648      * but performing a delegate call.
649      *
650      * _Available since v3.4._
651      */
652     function functionDelegateCall(
653         address target,
654         bytes memory data,
655         string memory errorMessage
656     ) internal returns (bytes memory) {
657         require(isContract(target), "Address: delegate call to non-contract");
658 
659         (bool success, bytes memory returndata) = target.delegatecall(data);
660         return verifyCallResult(success, returndata, errorMessage);
661     }
662 
663     /**
664      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
665      * revert reason using the provided one.
666      *
667      * _Available since v4.3._
668      */
669     function verifyCallResult(
670         bool success,
671         bytes memory returndata,
672         string memory errorMessage
673     ) internal pure returns (bytes memory) {
674         if (success) {
675             return returndata;
676         } else {
677             // Look for revert reason and bubble it up if present
678             if (returndata.length > 0) {
679                 // The easiest way to bubble the revert reason is using memory via assembly
680                 /// @solidity memory-safe-assembly
681                 assembly {
682                     let returndata_size := mload(returndata)
683                     revert(add(32, returndata), returndata_size)
684                 }
685             } else {
686                 revert(errorMessage);
687             }
688         }
689     }
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
693 
694 
695 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @title ERC721 token receiver interface
701  * @dev Interface for any contract that wants to support safeTransfers
702  * from ERC721 asset contracts.
703  */
704 interface IERC721Receiver {
705     /**
706      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
707      * by `operator` from `from`, this function is called.
708      *
709      * It must return its Solidity selector to confirm the token transfer.
710      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
711      *
712      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
713      */
714     function onERC721Received(
715         address operator,
716         address from,
717         uint256 tokenId,
718         bytes calldata data
719     ) external returns (bytes4);
720 }
721 
722 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @dev Interface of the ERC165 standard, as defined in the
731  * https://eips.ethereum.org/EIPS/eip-165[EIP].
732  *
733  * Implementers can declare support of contract interfaces, which can then be
734  * queried by others ({ERC165Checker}).
735  *
736  * For an implementation, see {ERC165}.
737  */
738 interface IERC165 {
739     /**
740      * @dev Returns true if this contract implements the interface defined by
741      * `interfaceId`. See the corresponding
742      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
743      * to learn more about how these ids are created.
744      *
745      * This function call must use less than 30 000 gas.
746      */
747     function supportsInterface(bytes4 interfaceId) external view returns (bool);
748 }
749 
750 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 
758 /**
759  * @dev Implementation of the {IERC165} interface.
760  *
761  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
762  * for the additional interface id that will be supported. For example:
763  *
764  * ```solidity
765  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
766  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
767  * }
768  * ```
769  *
770  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
771  */
772 abstract contract ERC165 is IERC165 {
773     /**
774      * @dev See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
777         return interfaceId == type(IERC165).interfaceId;
778     }
779 }
780 
781 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
782 
783 
784 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 
789 /**
790  * @dev Required interface of an ERC721 compliant contract.
791  */
792 interface IERC721 is IERC165 {
793     /**
794      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
795      */
796     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
797 
798     /**
799      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
800      */
801     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
805      */
806     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
807 
808     /**
809      * @dev Returns the number of tokens in ``owner``'s account.
810      */
811     function balanceOf(address owner) external view returns (uint256 balance);
812 
813     /**
814      * @dev Returns the owner of the `tokenId` token.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function ownerOf(uint256 tokenId) external view returns (address owner);
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId,
839         bytes calldata data
840     ) external;
841 
842     /**
843      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
844      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must exist and be owned by `from`.
851      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853      *
854      * Emits a {Transfer} event.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) external;
861 
862     /**
863      * @dev Transfers `tokenId` token from `from` to `to`.
864      *
865      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      *
874      * Emits a {Transfer} event.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) external;
881 
882     /**
883      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
884      * The approval is cleared when the token is transferred.
885      *
886      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
887      *
888      * Requirements:
889      *
890      * - The caller must own the token or be an approved operator.
891      * - `tokenId` must exist.
892      *
893      * Emits an {Approval} event.
894      */
895     function approve(address to, uint256 tokenId) external;
896 
897     /**
898      * @dev Approve or remove `operator` as an operator for the caller.
899      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
900      *
901      * Requirements:
902      *
903      * - The `operator` cannot be the caller.
904      *
905      * Emits an {ApprovalForAll} event.
906      */
907     function setApprovalForAll(address operator, bool _approved) external;
908 
909     /**
910      * @dev Returns the account approved for `tokenId` token.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      */
916     function getApproved(uint256 tokenId) external view returns (address operator);
917 
918     /**
919      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
920      *
921      * See {setApprovalForAll}
922      */
923     function isApprovedForAll(address owner, address operator) external view returns (bool);
924 }
925 
926 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 /**
935  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
936  * @dev See https://eips.ethereum.org/EIPS/eip-721
937  */
938 interface IERC721Metadata is IERC721 {
939     /**
940      * @dev Returns the token collection name.
941      */
942     function name() external view returns (string memory);
943 
944     /**
945      * @dev Returns the token collection symbol.
946      */
947     function symbol() external view returns (string memory);
948 
949     /**
950      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
951      */
952     function tokenURI(uint256 tokenId) external view returns (string memory);
953 }
954 
955 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
956 
957 
958 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
959 
960 pragma solidity ^0.8.0;
961 
962 
963 
964 
965 
966 
967 
968 
969 /**
970  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
971  * the Metadata extension, but not including the Enumerable extension, which is available separately as
972  * {ERC721Enumerable}.
973  */
974 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
975     using Address for address;
976     using Strings for uint256;
977 
978     // Token name
979     string private _name;
980 
981     // Token symbol
982     string private _symbol;
983 
984     // Mapping from token ID to owner address
985     mapping(uint256 => address) private _owners;
986 
987     // Mapping owner address to token count
988     mapping(address => uint256) private _balances;
989 
990     // Mapping from token ID to approved address
991     mapping(uint256 => address) private _tokenApprovals;
992 
993     // Mapping from owner to operator approvals
994     mapping(address => mapping(address => bool)) private _operatorApprovals;
995 
996     /**
997      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
998      */
999     constructor(string memory name_, string memory symbol_) {
1000         _name = name_;
1001         _symbol = symbol_;
1002     }
1003 
1004     /**
1005      * @dev See {IERC165-supportsInterface}.
1006      */
1007     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1008         return
1009             interfaceId == type(IERC721).interfaceId ||
1010             interfaceId == type(IERC721Metadata).interfaceId ||
1011             super.supportsInterface(interfaceId);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-balanceOf}.
1016      */
1017     function balanceOf(address owner) public view virtual override returns (uint256) {
1018         require(owner != address(0), "ERC721: address zero is not a valid owner");
1019         return _balances[owner];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-ownerOf}.
1024      */
1025     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1026         address owner = _owners[tokenId];
1027         require(owner != address(0), "ERC721: invalid token ID");
1028         return owner;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Metadata-name}.
1033      */
1034     function name() public view virtual override returns (string memory) {
1035         return _name;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Metadata-symbol}.
1040      */
1041     function symbol() public view virtual override returns (string memory) {
1042         return _symbol;
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Metadata-tokenURI}.
1047      */
1048     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1049         _requireMinted(tokenId);
1050 
1051         string memory baseURI = _baseURI();
1052         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1053     }
1054 
1055     /**
1056      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1057      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1058      * by default, can be overridden in child contracts.
1059      */
1060     function _baseURI() internal view virtual returns (string memory) {
1061         return "";
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-approve}.
1066      */
1067     function approve(address to, uint256 tokenId) public virtual override {
1068         address owner = ERC721.ownerOf(tokenId);
1069         require(to != owner, "ERC721: approval to current owner");
1070 
1071         require(
1072             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1073             "ERC721: approve caller is not token owner nor approved for all"
1074         );
1075 
1076         _approve(to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-getApproved}.
1081      */
1082     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1083         _requireMinted(tokenId);
1084 
1085         return _tokenApprovals[tokenId];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-setApprovalForAll}.
1090      */
1091     function setApprovalForAll(address operator, bool approved) public virtual override {
1092         _setApprovalForAll(_msgSender(), operator, approved);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-isApprovedForAll}.
1097      */
1098     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1099         return _operatorApprovals[owner][operator];
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-transferFrom}.
1104      */
1105     function transferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         //solhint-disable-next-line max-line-length
1111         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1112 
1113         _transfer(from, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-safeTransferFrom}.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) public virtual override {
1124         safeTransferFrom(from, to, tokenId, "");
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-safeTransferFrom}.
1129      */
1130     function safeTransferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory data
1135     ) public virtual override {
1136         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1137         _safeTransfer(from, to, tokenId, data);
1138     }
1139 
1140     /**
1141      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1142      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1143      *
1144      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1145      *
1146      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1147      * implement alternative mechanisms to perform token transfer, such as signature-based.
1148      *
1149      * Requirements:
1150      *
1151      * - `from` cannot be the zero address.
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must exist and be owned by `from`.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _safeTransfer(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory data
1163     ) internal virtual {
1164         _transfer(from, to, tokenId);
1165         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1166     }
1167 
1168     /**
1169      * @dev Returns whether `tokenId` exists.
1170      *
1171      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1172      *
1173      * Tokens start existing when they are minted (`_mint`),
1174      * and stop existing when they are burned (`_burn`).
1175      */
1176     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1177         return _owners[tokenId] != address(0);
1178     }
1179 
1180     /**
1181      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must exist.
1186      */
1187     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1188         address owner = ERC721.ownerOf(tokenId);
1189         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1190     }
1191 
1192     /**
1193      * @dev Safely mints `tokenId` and transfers it to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must not exist.
1198      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _safeMint(address to, uint256 tokenId) internal virtual {
1203         _safeMint(to, tokenId, "");
1204     }
1205 
1206     /**
1207      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1208      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1209      */
1210     function _safeMint(
1211         address to,
1212         uint256 tokenId,
1213         bytes memory data
1214     ) internal virtual {
1215         _mint(to, tokenId);
1216         require(
1217             _checkOnERC721Received(address(0), to, tokenId, data),
1218             "ERC721: transfer to non ERC721Receiver implementer"
1219         );
1220     }
1221 
1222     /**
1223      * @dev Mints `tokenId` and transfers it to `to`.
1224      *
1225      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must not exist.
1230      * - `to` cannot be the zero address.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _mint(address to, uint256 tokenId) internal virtual {
1235         require(to != address(0), "ERC721: mint to the zero address");
1236         require(!_exists(tokenId), "ERC721: token already minted");
1237 
1238         _beforeTokenTransfer(address(0), to, tokenId);
1239 
1240         _balances[to] += 1;
1241         _owners[tokenId] = to;
1242 
1243         emit Transfer(address(0), to, tokenId);
1244 
1245         _afterTokenTransfer(address(0), to, tokenId);
1246     }
1247 
1248     /**
1249      * @dev Destroys `tokenId`.
1250      * The approval is cleared when the token is burned.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _burn(uint256 tokenId) internal virtual {
1259         address owner = ERC721.ownerOf(tokenId);
1260 
1261         _beforeTokenTransfer(owner, address(0), tokenId);
1262 
1263         // Clear approvals
1264         _approve(address(0), tokenId);
1265 
1266         _balances[owner] -= 1;
1267         delete _owners[tokenId];
1268 
1269         emit Transfer(owner, address(0), tokenId);
1270 
1271         _afterTokenTransfer(owner, address(0), tokenId);
1272     }
1273 
1274     /**
1275      * @dev Transfers `tokenId` from `from` to `to`.
1276      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1277      *
1278      * Requirements:
1279      *
1280      * - `to` cannot be the zero address.
1281      * - `tokenId` token must be owned by `from`.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _transfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) internal virtual {
1290         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1291         require(to != address(0), "ERC721: transfer to the zero address");
1292 
1293         _beforeTokenTransfer(from, to, tokenId);
1294 
1295         // Clear approvals from the previous owner
1296         _approve(address(0), tokenId);
1297 
1298         _balances[from] -= 1;
1299         _balances[to] += 1;
1300         _owners[tokenId] = to;
1301 
1302         emit Transfer(from, to, tokenId);
1303 
1304         _afterTokenTransfer(from, to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev Approve `to` to operate on `tokenId`
1309      *
1310      * Emits an {Approval} event.
1311      */
1312     function _approve(address to, uint256 tokenId) internal virtual {
1313         _tokenApprovals[tokenId] = to;
1314         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev Approve `operator` to operate on all of `owner` tokens
1319      *
1320      * Emits an {ApprovalForAll} event.
1321      */
1322     function _setApprovalForAll(
1323         address owner,
1324         address operator,
1325         bool approved
1326     ) internal virtual {
1327         require(owner != operator, "ERC721: approve to caller");
1328         _operatorApprovals[owner][operator] = approved;
1329         emit ApprovalForAll(owner, operator, approved);
1330     }
1331 
1332     /**
1333      * @dev Reverts if the `tokenId` has not been minted yet.
1334      */
1335     function _requireMinted(uint256 tokenId) internal view virtual {
1336         require(_exists(tokenId), "ERC721: invalid token ID");
1337     }
1338 
1339     /**
1340      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1341      * The call is not executed if the target address is not a contract.
1342      *
1343      * @param from address representing the previous owner of the given token ID
1344      * @param to target address that will receive the tokens
1345      * @param tokenId uint256 ID of the token to be transferred
1346      * @param data bytes optional data to send along with the call
1347      * @return bool whether the call correctly returned the expected magic value
1348      */
1349     function _checkOnERC721Received(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory data
1354     ) private returns (bool) {
1355         if (to.isContract()) {
1356             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1357                 return retval == IERC721Receiver.onERC721Received.selector;
1358             } catch (bytes memory reason) {
1359                 if (reason.length == 0) {
1360                     revert("ERC721: transfer to non ERC721Receiver implementer");
1361                 } else {
1362                     /// @solidity memory-safe-assembly
1363                     assembly {
1364                         revert(add(32, reason), mload(reason))
1365                     }
1366                 }
1367             }
1368         } else {
1369             return true;
1370         }
1371     }
1372 
1373     /**
1374      * @dev Hook that is called before any token transfer. This includes minting
1375      * and burning.
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1383      * - `from` and `to` are never both zero.
1384      *
1385      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1386      */
1387     function _beforeTokenTransfer(
1388         address from,
1389         address to,
1390         uint256 tokenId
1391     ) internal virtual {}
1392 
1393     /**
1394      * @dev Hook that is called after any transfer of tokens. This includes
1395      * minting and burning.
1396      *
1397      * Calling conditions:
1398      *
1399      * - when `from` and `to` are both non-zero.
1400      * - `from` and `to` are never both zero.
1401      *
1402      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1403      */
1404     function _afterTokenTransfer(
1405         address from,
1406         address to,
1407         uint256 tokenId
1408     ) internal virtual {}
1409 }
1410 
1411 // File: contracts/OGPortalNFT.sol
1412 
1413 
1414 pragma solidity 0.8.9;
1415 
1416 
1417 
1418 
1419 
1420 
1421 contract ERC721Basic is ERC721, Ownable {
1422     using Counters for Counters.Counter;
1423     using SafeMath for uint256;
1424     using Strings for uint256;
1425 
1426     Counters.Counter internal _tokenIdCounter;
1427     Counters.Counter internal _tokenSupplyCounter;
1428     string internal baseURI;
1429     string public baseExtension = ".json";
1430     uint256 public maxSupply;
1431 
1432     constructor(
1433         string memory _name,
1434         string memory _symbol,
1435         string memory _initBaseURI,
1436         uint256 _maxSupply
1437     ) ERC721(_name, _symbol) {
1438         setBaseURI(_initBaseURI);
1439         maxSupply = _maxSupply;
1440     }
1441 
1442     // internal
1443     function _baseURI() internal view virtual override returns (string memory) {
1444         return baseURI;
1445     }
1446 
1447     function _batchMint(uint256 _qty, address _receiver) internal {
1448         for (uint256 i = 0; i < _qty; i++) {
1449             _incrementCounters();
1450             uint256 _tokenId = _tokenIdCounter.current();
1451             _safeMint(_receiver, _tokenId);
1452         }
1453     }
1454 
1455     function _incrementCounters() internal {
1456         _tokenIdCounter.increment();
1457         _tokenSupplyCounter.increment();
1458     }
1459 
1460     function _currentTokenId() internal view returns (uint256) {
1461         return _tokenIdCounter.current();
1462     }
1463 
1464     function totalSupply() external view returns (uint256) {
1465         return _tokenSupplyCounter.current();
1466     }
1467 
1468     function _tokenURI(uint256 tokenId) public view returns (string memory) {
1469         require(
1470             _exists(tokenId),
1471             "ERC721Metadata: URI query for nonexistent token"
1472         );
1473 
1474         string memory currentBaseURI = _baseURI();
1475         return
1476             bytes(currentBaseURI).length > 0
1477                 ? string(
1478                     abi.encodePacked(
1479                         currentBaseURI,
1480                         tokenId.toString(),
1481                         baseExtension
1482                     )
1483                 )
1484                 : "";
1485     }
1486 
1487     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1488         baseURI = _newBaseURI;
1489     }
1490 
1491     function setBaseExtension(string memory _newBaseExtension)
1492         public
1493         onlyOwner
1494     {
1495         baseExtension = _newBaseExtension;
1496     }
1497 
1498     function burn(uint256 tokenId) public {
1499         require(
1500             _isApprovedOrOwner(_msgSender(), tokenId),
1501             "ERC721Burnable: caller is not owner nor approved"
1502         );
1503         _tokenSupplyCounter.decrement();
1504         _burn(tokenId);
1505     }
1506 }
1507 
1508 contract EktaNFT is ERC721Basic {
1509     using SafeMath for uint256;
1510 
1511     struct QtyRecipient {
1512         uint256 qty;
1513         address[] recipients;
1514     }
1515 
1516     constructor(
1517         string memory _name,
1518         string memory _symbol,
1519         string memory _initBaseURI,
1520         string memory _baseUriExtension,
1521         uint256 _maxSupply
1522     ) ERC721Basic(_name, _symbol, _initBaseURI, _maxSupply) {
1523         baseExtension = _baseUriExtension;
1524     }
1525 
1526     function mintAndTransfer(QtyRecipient[] memory _qtyRecipients)
1527         external
1528         onlyOwner
1529     {
1530         uint256 totalQtys = 0;
1531         for (uint256 i = 0; i < _qtyRecipients.length; i++) {
1532             totalQtys +=
1533                 _qtyRecipients[i].qty *
1534                 _qtyRecipients[i].recipients.length;
1535         }
1536 
1537         require(
1538             totalQtys.add(_currentTokenId()) <= maxSupply,
1539             "Exceeds max supply"
1540         );
1541         for (uint256 i = 0; i < _qtyRecipients.length; i++) {
1542             for (uint256 j = 0; j < _qtyRecipients[i].recipients.length; j++) {
1543                 _batchMint(
1544                     _qtyRecipients[i].qty,
1545                     _qtyRecipients[i].recipients[j]
1546                 );
1547             }
1548         }
1549     }
1550 
1551     function tokenURI(uint256 tokenId)
1552         public
1553         view
1554         virtual
1555         override
1556         returns (string memory)
1557     {
1558         return _tokenURI(tokenId);
1559     }
1560 }