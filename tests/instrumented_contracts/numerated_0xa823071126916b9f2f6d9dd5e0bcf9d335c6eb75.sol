1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 // CAUTION
94 // This version of SafeMath should only be used with Solidity 0.8 or later,
95 // because it relies on the compiler's built in overflow checks.
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations.
99  *
100  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
101  * now has built in overflow checking.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             uint256 c = a + b;
112             if (c < a) return (false, 0);
113             return (true, c);
114         }
115     }
116 
117     /**
118      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             if (b > a) return (false, 0);
125             return (true, a - b);
126         }
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137             // benefit is lost if 'b' is also tested.
138             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139             if (a == 0) return (true, 0);
140             uint256 c = a * b;
141             if (c / a != b) return (false, 0);
142             return (true, c);
143         }
144     }
145 
146     /**
147      * @dev Returns the division of two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a / b);
155         }
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         unchecked {
165             if (b == 0) return (false, 0);
166             return (true, a % b);
167         }
168     }
169 
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      *
178      * - Addition cannot overflow.
179      */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a + b;
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a - b;
196     }
197 
198     /**
199      * @dev Returns the multiplication of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `*` operator.
203      *
204      * Requirements:
205      *
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a * b;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers, reverting on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator.
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a / b;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * reverting when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(
256         uint256 a,
257         uint256 b,
258         string memory errorMessage
259     ) internal pure returns (uint256) {
260         unchecked {
261             require(b <= a, errorMessage);
262             return a - b;
263         }
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b > 0, errorMessage);
285             return a / b;
286         }
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * reverting with custom message when dividing by zero.
292      *
293      * CAUTION: This function is deprecated because it requires allocating memory for the error
294      * message unnecessarily. For custom revert reasons use {tryMod}.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b > 0, errorMessage);
311             return a % b;
312         }
313     }
314 }
315 
316 // File: @openzeppelin/contracts/utils/Counters.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @title Counters
325  * @author Matt Condon (@shrugs)
326  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
327  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
328  *
329  * Include with `using Counters for Counters.Counter;`
330  */
331 library Counters {
332     struct Counter {
333         // This variable should never be directly accessed by users of the library: interactions must be restricted to
334         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
335         // this feature: see https://github.com/ethereum/solidity/issues/4637
336         uint256 _value; // default: 0
337     }
338 
339     function current(Counter storage counter) internal view returns (uint256) {
340         return counter._value;
341     }
342 
343     function increment(Counter storage counter) internal {
344         unchecked {
345             counter._value += 1;
346         }
347     }
348 
349     function decrement(Counter storage counter) internal {
350         uint256 value = counter._value;
351         require(value > 0, "Counter: decrement overflow");
352         unchecked {
353             counter._value = value - 1;
354         }
355     }
356 
357     function reset(Counter storage counter) internal {
358         counter._value = 0;
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/Strings.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev String operations.
371  */
372 library Strings {
373     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
374 
375     /**
376      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
377      */
378     function toString(uint256 value) internal pure returns (string memory) {
379         // Inspired by OraclizeAPI's implementation - MIT licence
380         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
381 
382         if (value == 0) {
383             return "0";
384         }
385         uint256 temp = value;
386         uint256 digits;
387         while (temp != 0) {
388             digits++;
389             temp /= 10;
390         }
391         bytes memory buffer = new bytes(digits);
392         while (value != 0) {
393             digits -= 1;
394             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
395             value /= 10;
396         }
397         return string(buffer);
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
402      */
403     function toHexString(uint256 value) internal pure returns (string memory) {
404         if (value == 0) {
405             return "0x00";
406         }
407         uint256 temp = value;
408         uint256 length = 0;
409         while (temp != 0) {
410             length++;
411             temp >>= 8;
412         }
413         return toHexString(value, length);
414     }
415 
416     /**
417      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
418      */
419     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
420         bytes memory buffer = new bytes(2 * length + 2);
421         buffer[0] = "0";
422         buffer[1] = "x";
423         for (uint256 i = 2 * length + 1; i > 1; --i) {
424             buffer[i] = _HEX_SYMBOLS[value & 0xf];
425             value >>= 4;
426         }
427         require(value == 0, "Strings: hex length insufficient");
428         return string(buffer);
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Context.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Provides information about the current execution context, including the
441  * sender of the transaction and its data. While these are generally available
442  * via msg.sender and msg.data, they should not be accessed in such a direct
443  * manner, since when dealing with meta-transactions the account sending and
444  * paying for execution may not be the actual sender (as far as an application
445  * is concerned).
446  *
447  * This contract is only required for intermediate, library-like contracts.
448  */
449 abstract contract Context {
450     function _msgSender() internal view virtual returns (address) {
451         return msg.sender;
452     }
453 
454     function _msgData() internal view virtual returns (bytes calldata) {
455         return msg.data;
456     }
457 }
458 
459 // File: @openzeppelin/contracts/access/Ownable.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 abstract contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor() {
488         _transferOwnership(_msgSender());
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view virtual returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(owner() == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         _transferOwnership(address(0));
515     }
516 
517     /**
518      * @dev Transfers ownership of the contract to a new account (`newOwner`).
519      * Can only be called by the current owner.
520      */
521     function transferOwnership(address newOwner) public virtual onlyOwner {
522         require(newOwner != address(0), "Ownable: new owner is the zero address");
523         _transferOwnership(newOwner);
524     }
525 
526     /**
527      * @dev Transfers ownership of the contract to a new account (`newOwner`).
528      * Internal function without access restriction.
529      */
530     function _transferOwnership(address newOwner) internal virtual {
531         address oldOwner = _owner;
532         _owner = newOwner;
533         emit OwnershipTransferred(oldOwner, newOwner);
534     }
535 }
536 
537 // File: @openzeppelin/contracts/utils/Address.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Collection of functions related to the address type
546  */
547 library Address {
548     /**
549      * @dev Returns true if `account` is a contract.
550      *
551      * [IMPORTANT]
552      * ====
553      * It is unsafe to assume that an address for which this function returns
554      * false is an externally-owned account (EOA) and not a contract.
555      *
556      * Among others, `isContract` will return false for the following
557      * types of addresses:
558      *
559      *  - an externally-owned account
560      *  - a contract in construction
561      *  - an address where a contract will be created
562      *  - an address where a contract lived, but was destroyed
563      * ====
564      */
565     function isContract(address account) internal view returns (bool) {
566         // This method relies on extcodesize, which returns 0 for contracts in
567         // construction, since the code is only stored at the end of the
568         // constructor execution.
569 
570         uint256 size;
571         assembly {
572             size := extcodesize(account)
573         }
574         return size > 0;
575     }
576 
577     /**
578      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
579      * `recipient`, forwarding all available gas and reverting on errors.
580      *
581      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
582      * of certain opcodes, possibly making contracts go over the 2300 gas limit
583      * imposed by `transfer`, making them unable to receive funds via
584      * `transfer`. {sendValue} removes this limitation.
585      *
586      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
587      *
588      * IMPORTANT: because control is transferred to `recipient`, care must be
589      * taken to not create reentrancy vulnerabilities. Consider using
590      * {ReentrancyGuard} or the
591      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
592      */
593     function sendValue(address payable recipient, uint256 amount) internal {
594         require(address(this).balance >= amount, "Address: insufficient balance");
595 
596         (bool success, ) = recipient.call{value: amount}("");
597         require(success, "Address: unable to send value, recipient may have reverted");
598     }
599 
600     /**
601      * @dev Performs a Solidity function call using a low level `call`. A
602      * plain `call` is an unsafe replacement for a function call: use this
603      * function instead.
604      *
605      * If `target` reverts with a revert reason, it is bubbled up by this
606      * function (like regular Solidity function calls).
607      *
608      * Returns the raw returned data. To convert to the expected return value,
609      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
610      *
611      * Requirements:
612      *
613      * - `target` must be a contract.
614      * - calling `target` with `data` must not revert.
615      *
616      * _Available since v3.1._
617      */
618     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
619         return functionCall(target, data, "Address: low-level call failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
624      * `errorMessage` as a fallback revert reason when `target` reverts.
625      *
626      * _Available since v3.1._
627      */
628     function functionCall(
629         address target,
630         bytes memory data,
631         string memory errorMessage
632     ) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, 0, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but also transferring `value` wei to `target`.
639      *
640      * Requirements:
641      *
642      * - the calling contract must have an ETH balance of at least `value`.
643      * - the called Solidity function must be `payable`.
644      *
645      * _Available since v3.1._
646      */
647     function functionCallWithValue(
648         address target,
649         bytes memory data,
650         uint256 value
651     ) internal returns (bytes memory) {
652         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
657      * with `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCallWithValue(
662         address target,
663         bytes memory data,
664         uint256 value,
665         string memory errorMessage
666     ) internal returns (bytes memory) {
667         require(address(this).balance >= value, "Address: insufficient balance for call");
668         require(isContract(target), "Address: call to non-contract");
669 
670         (bool success, bytes memory returndata) = target.call{value: value}(data);
671         return verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
676      * but performing a static call.
677      *
678      * _Available since v3.3._
679      */
680     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
681         return functionStaticCall(target, data, "Address: low-level static call failed");
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
686      * but performing a static call.
687      *
688      * _Available since v3.3._
689      */
690     function functionStaticCall(
691         address target,
692         bytes memory data,
693         string memory errorMessage
694     ) internal view returns (bytes memory) {
695         require(isContract(target), "Address: static call to non-contract");
696 
697         (bool success, bytes memory returndata) = target.staticcall(data);
698         return verifyCallResult(success, returndata, errorMessage);
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
703      * but performing a delegate call.
704      *
705      * _Available since v3.4._
706      */
707     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
708         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
713      * but performing a delegate call.
714      *
715      * _Available since v3.4._
716      */
717     function functionDelegateCall(
718         address target,
719         bytes memory data,
720         string memory errorMessage
721     ) internal returns (bytes memory) {
722         require(isContract(target), "Address: delegate call to non-contract");
723 
724         (bool success, bytes memory returndata) = target.delegatecall(data);
725         return verifyCallResult(success, returndata, errorMessage);
726     }
727 
728     /**
729      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
730      * revert reason using the provided one.
731      *
732      * _Available since v4.3._
733      */
734     function verifyCallResult(
735         bool success,
736         bytes memory returndata,
737         string memory errorMessage
738     ) internal pure returns (bytes memory) {
739         if (success) {
740             return returndata;
741         } else {
742             // Look for revert reason and bubble it up if present
743             if (returndata.length > 0) {
744                 // The easiest way to bubble the revert reason is using memory via assembly
745 
746                 assembly {
747                     let returndata_size := mload(returndata)
748                     revert(add(32, returndata), returndata_size)
749                 }
750             } else {
751                 revert(errorMessage);
752             }
753         }
754     }
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 
766 /**
767  * @title SafeERC20
768  * @dev Wrappers around ERC20 operations that throw on failure (when the token
769  * contract returns false). Tokens that return no value (and instead revert or
770  * throw on failure) are also supported, non-reverting calls are assumed to be
771  * successful.
772  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
773  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
774  */
775 library SafeERC20 {
776     using Address for address;
777 
778     function safeTransfer(
779         IERC20 token,
780         address to,
781         uint256 value
782     ) internal {
783         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
784     }
785 
786     function safeTransferFrom(
787         IERC20 token,
788         address from,
789         address to,
790         uint256 value
791     ) internal {
792         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
793     }
794 
795     /**
796      * @dev Deprecated. This function has issues similar to the ones found in
797      * {IERC20-approve}, and its usage is discouraged.
798      *
799      * Whenever possible, use {safeIncreaseAllowance} and
800      * {safeDecreaseAllowance} instead.
801      */
802     function safeApprove(
803         IERC20 token,
804         address spender,
805         uint256 value
806     ) internal {
807         // safeApprove should only be called when setting an initial allowance,
808         // or when resetting it to zero. To increase and decrease it, use
809         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
810         require(
811             (value == 0) || (token.allowance(address(this), spender) == 0),
812             "SafeERC20: approve from non-zero to non-zero allowance"
813         );
814         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
815     }
816 
817     function safeIncreaseAllowance(
818         IERC20 token,
819         address spender,
820         uint256 value
821     ) internal {
822         uint256 newAllowance = token.allowance(address(this), spender) + value;
823         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
824     }
825 
826     function safeDecreaseAllowance(
827         IERC20 token,
828         address spender,
829         uint256 value
830     ) internal {
831         unchecked {
832             uint256 oldAllowance = token.allowance(address(this), spender);
833             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
834             uint256 newAllowance = oldAllowance - value;
835             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
836         }
837     }
838 
839     /**
840      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
841      * on the return value: the return value is optional (but if data is returned, it must not be false).
842      * @param token The token targeted by the call.
843      * @param data The call data (encoded using abi.encode or one of its variants).
844      */
845     function _callOptionalReturn(IERC20 token, bytes memory data) private {
846         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
847         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
848         // the target address contains contract code and also asserts for success in the low-level call.
849 
850         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
851         if (returndata.length > 0) {
852             // Return data is optional
853             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
854         }
855     }
856 }
857 
858 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
859 
860 
861 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
862 
863 pragma solidity ^0.8.0;
864 
865 
866 
867 
868 /**
869  * @title PaymentSplitter
870  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
871  * that the Ether will be split in this way, since it is handled transparently by the contract.
872  *
873  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
874  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
875  * an amount proportional to the percentage of total shares they were assigned.
876  *
877  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
878  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
879  * function.
880  *
881  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
882  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
883  * to run tests before sending real value to this contract.
884  */
885 contract PaymentSplitter is Context {
886     event PayeeAdded(address account, uint256 shares);
887     event PaymentReleased(address to, uint256 amount);
888     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
889     event PaymentReceived(address from, uint256 amount);
890 
891     uint256 private _totalShares;
892     uint256 private _totalReleased;
893 
894     mapping(address => uint256) private _shares;
895     mapping(address => uint256) private _released;
896     address[] private _payees;
897 
898     mapping(IERC20 => uint256) private _erc20TotalReleased;
899     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
900 
901     /**
902      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
903      * the matching position in the `shares` array.
904      *
905      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
906      * duplicates in `payees`.
907      */
908     constructor(address[] memory payees, uint256[] memory shares_) payable {
909         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
910         require(payees.length > 0, "PaymentSplitter: no payees");
911 
912         for (uint256 i = 0; i < payees.length; i++) {
913             _addPayee(payees[i], shares_[i]);
914         }
915     }
916 
917     /**
918      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
919      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
920      * reliability of the events, and not the actual splitting of Ether.
921      *
922      * To learn more about this see the Solidity documentation for
923      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
924      * functions].
925      */
926     receive() external payable virtual {
927         emit PaymentReceived(_msgSender(), msg.value);
928     }
929 
930     /**
931      * @dev Getter for the total shares held by payees.
932      */
933     function totalShares() public view returns (uint256) {
934         return _totalShares;
935     }
936 
937     /**
938      * @dev Getter for the total amount of Ether already released.
939      */
940     function totalReleased() public view returns (uint256) {
941         return _totalReleased;
942     }
943 
944     /**
945      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
946      * contract.
947      */
948     function totalReleased(IERC20 token) public view returns (uint256) {
949         return _erc20TotalReleased[token];
950     }
951 
952     /**
953      * @dev Getter for the amount of shares held by an account.
954      */
955     function shares(address account) public view returns (uint256) {
956         return _shares[account];
957     }
958 
959     /**
960      * @dev Getter for the amount of Ether already released to a payee.
961      */
962     function released(address account) public view returns (uint256) {
963         return _released[account];
964     }
965 
966     /**
967      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
968      * IERC20 contract.
969      */
970     function released(IERC20 token, address account) public view returns (uint256) {
971         return _erc20Released[token][account];
972     }
973 
974     /**
975      * @dev Getter for the address of the payee number `index`.
976      */
977     function payee(uint256 index) public view returns (address) {
978         return _payees[index];
979     }
980 
981     /**
982      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
983      * total shares and their previous withdrawals.
984      */
985     function release(address payable account) public virtual {
986         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
987 
988         uint256 totalReceived = address(this).balance + totalReleased();
989         uint256 payment = _pendingPayment(account, totalReceived, released(account));
990 
991         require(payment != 0, "PaymentSplitter: account is not due payment");
992 
993         _released[account] += payment;
994         _totalReleased += payment;
995 
996         Address.sendValue(account, payment);
997         emit PaymentReleased(account, payment);
998     }
999 
1000     /**
1001      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1002      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1003      * contract.
1004      */
1005     function release(IERC20 token, address account) public virtual {
1006         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1007 
1008         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1009         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1010 
1011         require(payment != 0, "PaymentSplitter: account is not due payment");
1012 
1013         _erc20Released[token][account] += payment;
1014         _erc20TotalReleased[token] += payment;
1015 
1016         SafeERC20.safeTransfer(token, account, payment);
1017         emit ERC20PaymentReleased(token, account, payment);
1018     }
1019 
1020     /**
1021      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1022      * already released amounts.
1023      */
1024     function _pendingPayment(
1025         address account,
1026         uint256 totalReceived,
1027         uint256 alreadyReleased
1028     ) private view returns (uint256) {
1029         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1030     }
1031 
1032     /**
1033      * @dev Add a new payee to the contract.
1034      * @param account The address of the payee to add.
1035      * @param shares_ The number of shares owned by the payee.
1036      */
1037     function _addPayee(address account, uint256 shares_) private {
1038         require(account != address(0), "PaymentSplitter: account is the zero address");
1039         require(shares_ > 0, "PaymentSplitter: shares are 0");
1040         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1041 
1042         _payees.push(account);
1043         _shares[account] = shares_;
1044         _totalShares = _totalShares + shares_;
1045         emit PayeeAdded(account, shares_);
1046     }
1047 }
1048 
1049 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1050 
1051 
1052 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 /**
1057  * @title ERC721 token receiver interface
1058  * @dev Interface for any contract that wants to support safeTransfers
1059  * from ERC721 asset contracts.
1060  */
1061 interface IERC721Receiver {
1062     /**
1063      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1064      * by `operator` from `from`, this function is called.
1065      *
1066      * It must return its Solidity selector to confirm the token transfer.
1067      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1068      *
1069      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1070      */
1071     function onERC721Received(
1072         address operator,
1073         address from,
1074         uint256 tokenId,
1075         bytes calldata data
1076     ) external returns (bytes4);
1077 }
1078 
1079 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1080 
1081 
1082 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1083 
1084 pragma solidity ^0.8.0;
1085 
1086 /**
1087  * @dev Interface of the ERC165 standard, as defined in the
1088  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1089  *
1090  * Implementers can declare support of contract interfaces, which can then be
1091  * queried by others ({ERC165Checker}).
1092  *
1093  * For an implementation, see {ERC165}.
1094  */
1095 interface IERC165 {
1096     /**
1097      * @dev Returns true if this contract implements the interface defined by
1098      * `interfaceId`. See the corresponding
1099      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1100      * to learn more about how these ids are created.
1101      *
1102      * This function call must use less than 30 000 gas.
1103      */
1104     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1105 }
1106 
1107 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1108 
1109 
1110 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 
1115 /**
1116  * @dev Implementation of the {IERC165} interface.
1117  *
1118  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1119  * for the additional interface id that will be supported. For example:
1120  *
1121  * ```solidity
1122  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1123  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1124  * }
1125  * ```
1126  *
1127  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1128  */
1129 abstract contract ERC165 is IERC165 {
1130     /**
1131      * @dev See {IERC165-supportsInterface}.
1132      */
1133     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1134         return interfaceId == type(IERC165).interfaceId;
1135     }
1136 }
1137 
1138 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1139 
1140 
1141 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 
1146 /**
1147  * @dev Required interface of an ERC721 compliant contract.
1148  */
1149 interface IERC721 is IERC165 {
1150     /**
1151      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1152      */
1153     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1154 
1155     /**
1156      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1157      */
1158     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1159 
1160     /**
1161      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1162      */
1163     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1164 
1165     /**
1166      * @dev Returns the number of tokens in ``owner``'s account.
1167      */
1168     function balanceOf(address owner) external view returns (uint256 balance);
1169 
1170     /**
1171      * @dev Returns the owner of the `tokenId` token.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must exist.
1176      */
1177     function ownerOf(uint256 tokenId) external view returns (address owner);
1178 
1179     /**
1180      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1181      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1182      *
1183      * Requirements:
1184      *
1185      * - `from` cannot be the zero address.
1186      * - `to` cannot be the zero address.
1187      * - `tokenId` token must exist and be owned by `from`.
1188      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function safeTransferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) external;
1198 
1199     /**
1200      * @dev Transfers `tokenId` token from `from` to `to`.
1201      *
1202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1203      *
1204      * Requirements:
1205      *
1206      * - `from` cannot be the zero address.
1207      * - `to` cannot be the zero address.
1208      * - `tokenId` token must be owned by `from`.
1209      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function transferFrom(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) external;
1218 
1219     /**
1220      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1221      * The approval is cleared when the token is transferred.
1222      *
1223      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1224      *
1225      * Requirements:
1226      *
1227      * - The caller must own the token or be an approved operator.
1228      * - `tokenId` must exist.
1229      *
1230      * Emits an {Approval} event.
1231      */
1232     function approve(address to, uint256 tokenId) external;
1233 
1234     /**
1235      * @dev Returns the account approved for `tokenId` token.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must exist.
1240      */
1241     function getApproved(uint256 tokenId) external view returns (address operator);
1242 
1243     /**
1244      * @dev Approve or remove `operator` as an operator for the caller.
1245      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1246      *
1247      * Requirements:
1248      *
1249      * - The `operator` cannot be the caller.
1250      *
1251      * Emits an {ApprovalForAll} event.
1252      */
1253     function setApprovalForAll(address operator, bool _approved) external;
1254 
1255     /**
1256      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1257      *
1258      * See {setApprovalForAll}
1259      */
1260     function isApprovedForAll(address owner, address operator) external view returns (bool);
1261 
1262     /**
1263      * @dev Safely transfers `tokenId` token from `from` to `to`.
1264      *
1265      * Requirements:
1266      *
1267      * - `from` cannot be the zero address.
1268      * - `to` cannot be the zero address.
1269      * - `tokenId` token must exist and be owned by `from`.
1270      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function safeTransferFrom(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes calldata data
1280     ) external;
1281 }
1282 
1283 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1284 
1285 
1286 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 
1291 /**
1292  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1293  * @dev See https://eips.ethereum.org/EIPS/eip-721
1294  */
1295 interface IERC721Metadata is IERC721 {
1296     /**
1297      * @dev Returns the token collection name.
1298      */
1299     function name() external view returns (string memory);
1300 
1301     /**
1302      * @dev Returns the token collection symbol.
1303      */
1304     function symbol() external view returns (string memory);
1305 
1306     /**
1307      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1308      */
1309     function tokenURI(uint256 tokenId) external view returns (string memory);
1310 }
1311 
1312 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1313 
1314 
1315 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 /**
1327  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1328  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1329  * {ERC721Enumerable}.
1330  */
1331 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1332     using Address for address;
1333     using Strings for uint256;
1334 
1335     // Token name
1336     string private _name;
1337 
1338     // Token symbol
1339     string private _symbol;
1340 
1341     // Mapping from token ID to owner address
1342     mapping(uint256 => address) private _owners;
1343 
1344     // Mapping owner address to token count
1345     mapping(address => uint256) private _balances;
1346 
1347     // Mapping from token ID to approved address
1348     mapping(uint256 => address) private _tokenApprovals;
1349 
1350     // Mapping from owner to operator approvals
1351     mapping(address => mapping(address => bool)) private _operatorApprovals;
1352 
1353     /**
1354      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1355      */
1356     constructor(string memory name_, string memory symbol_) {
1357         _name = name_;
1358         _symbol = symbol_;
1359     }
1360 
1361     /**
1362      * @dev See {IERC165-supportsInterface}.
1363      */
1364     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1365         return
1366             interfaceId == type(IERC721).interfaceId ||
1367             interfaceId == type(IERC721Metadata).interfaceId ||
1368             super.supportsInterface(interfaceId);
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-balanceOf}.
1373      */
1374     function balanceOf(address owner) public view virtual override returns (uint256) {
1375         require(owner != address(0), "ERC721: balance query for the zero address");
1376         return _balances[owner];
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-ownerOf}.
1381      */
1382     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1383         address owner = _owners[tokenId];
1384         require(owner != address(0), "ERC721: owner query for nonexistent token");
1385         return owner;
1386     }
1387 
1388     /**
1389      * @dev See {IERC721Metadata-name}.
1390      */
1391     function name() public view virtual override returns (string memory) {
1392         return _name;
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Metadata-symbol}.
1397      */
1398     function symbol() public view virtual override returns (string memory) {
1399         return _symbol;
1400     }
1401 
1402     /**
1403      * @dev See {IERC721Metadata-tokenURI}.
1404      */
1405     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1406         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1407 
1408         string memory baseURI = _baseURI();
1409         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1410     }
1411 
1412     /**
1413      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1414      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1415      * by default, can be overriden in child contracts.
1416      */
1417     function _baseURI() internal view virtual returns (string memory) {
1418         return "";
1419     }
1420 
1421     /**
1422      * @dev See {IERC721-approve}.
1423      */
1424     function approve(address to, uint256 tokenId) public virtual override {
1425         address owner = ERC721.ownerOf(tokenId);
1426         require(to != owner, "ERC721: approval to current owner");
1427 
1428         require(
1429             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1430             "ERC721: approve caller is not owner nor approved for all"
1431         );
1432 
1433         _approve(to, tokenId);
1434     }
1435 
1436     /**
1437      * @dev See {IERC721-getApproved}.
1438      */
1439     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1440         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1441 
1442         return _tokenApprovals[tokenId];
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-setApprovalForAll}.
1447      */
1448     function setApprovalForAll(address operator, bool approved) public virtual override {
1449         _setApprovalForAll(_msgSender(), operator, approved);
1450     }
1451 
1452     /**
1453      * @dev See {IERC721-isApprovedForAll}.
1454      */
1455     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1456         return _operatorApprovals[owner][operator];
1457     }
1458 
1459     /**
1460      * @dev See {IERC721-transferFrom}.
1461      */
1462     function transferFrom(
1463         address from,
1464         address to,
1465         uint256 tokenId
1466     ) public virtual override {
1467         //solhint-disable-next-line max-line-length
1468         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1469 
1470         _transfer(from, to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-safeTransferFrom}.
1475      */
1476     function safeTransferFrom(
1477         address from,
1478         address to,
1479         uint256 tokenId
1480     ) public virtual override {
1481         safeTransferFrom(from, to, tokenId, "");
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-safeTransferFrom}.
1486      */
1487     function safeTransferFrom(
1488         address from,
1489         address to,
1490         uint256 tokenId,
1491         bytes memory _data
1492     ) public virtual override {
1493         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1494         _safeTransfer(from, to, tokenId, _data);
1495     }
1496 
1497     /**
1498      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1499      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1500      *
1501      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1502      *
1503      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1504      * implement alternative mechanisms to perform token transfer, such as signature-based.
1505      *
1506      * Requirements:
1507      *
1508      * - `from` cannot be the zero address.
1509      * - `to` cannot be the zero address.
1510      * - `tokenId` token must exist and be owned by `from`.
1511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _safeTransfer(
1516         address from,
1517         address to,
1518         uint256 tokenId,
1519         bytes memory _data
1520     ) internal virtual {
1521         _transfer(from, to, tokenId);
1522         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1523     }
1524 
1525     /**
1526      * @dev Returns whether `tokenId` exists.
1527      *
1528      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1529      *
1530      * Tokens start existing when they are minted (`_mint`),
1531      * and stop existing when they are burned (`_burn`).
1532      */
1533     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1534         return _owners[tokenId] != address(0);
1535     }
1536 
1537     /**
1538      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1539      *
1540      * Requirements:
1541      *
1542      * - `tokenId` must exist.
1543      */
1544     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1545         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1546         address owner = ERC721.ownerOf(tokenId);
1547         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1548     }
1549 
1550     /**
1551      * @dev Safely mints `tokenId` and transfers it to `to`.
1552      *
1553      * Requirements:
1554      *
1555      * - `tokenId` must not exist.
1556      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _safeMint(address to, uint256 tokenId) internal virtual {
1561         _safeMint(to, tokenId, "");
1562     }
1563 
1564     /**
1565      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1566      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1567      */
1568     function _safeMint(
1569         address to,
1570         uint256 tokenId,
1571         bytes memory _data
1572     ) internal virtual {
1573         _mint(to, tokenId);
1574         require(
1575             _checkOnERC721Received(address(0), to, tokenId, _data),
1576             "ERC721: transfer to non ERC721Receiver implementer"
1577         );
1578     }
1579 
1580     /**
1581      * @dev Mints `tokenId` and transfers it to `to`.
1582      *
1583      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1584      *
1585      * Requirements:
1586      *
1587      * - `tokenId` must not exist.
1588      * - `to` cannot be the zero address.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function _mint(address to, uint256 tokenId) internal virtual {
1593         require(to != address(0), "ERC721: mint to the zero address");
1594         require(!_exists(tokenId), "ERC721: token already minted");
1595 
1596         _beforeTokenTransfer(address(0), to, tokenId);
1597 
1598         _balances[to] += 1;
1599         _owners[tokenId] = to;
1600 
1601         emit Transfer(address(0), to, tokenId);
1602     }
1603 
1604     /**
1605      * @dev Destroys `tokenId`.
1606      * The approval is cleared when the token is burned.
1607      *
1608      * Requirements:
1609      *
1610      * - `tokenId` must exist.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function _burn(uint256 tokenId) internal virtual {
1615         address owner = ERC721.ownerOf(tokenId);
1616 
1617         _beforeTokenTransfer(owner, address(0), tokenId);
1618 
1619         // Clear approvals
1620         _approve(address(0), tokenId);
1621 
1622         _balances[owner] -= 1;
1623         delete _owners[tokenId];
1624 
1625         emit Transfer(owner, address(0), tokenId);
1626     }
1627 
1628     /**
1629      * @dev Transfers `tokenId` from `from` to `to`.
1630      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1631      *
1632      * Requirements:
1633      *
1634      * - `to` cannot be the zero address.
1635      * - `tokenId` token must be owned by `from`.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _transfer(
1640         address from,
1641         address to,
1642         uint256 tokenId
1643     ) internal virtual {
1644         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1645         require(to != address(0), "ERC721: transfer to the zero address");
1646 
1647         _beforeTokenTransfer(from, to, tokenId);
1648 
1649         // Clear approvals from the previous owner
1650         _approve(address(0), tokenId);
1651 
1652         _balances[from] -= 1;
1653         _balances[to] += 1;
1654         _owners[tokenId] = to;
1655 
1656         emit Transfer(from, to, tokenId);
1657     }
1658 
1659     /**
1660      * @dev Approve `to` to operate on `tokenId`
1661      *
1662      * Emits a {Approval} event.
1663      */
1664     function _approve(address to, uint256 tokenId) internal virtual {
1665         _tokenApprovals[tokenId] = to;
1666         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1667     }
1668 
1669     /**
1670      * @dev Approve `operator` to operate on all of `owner` tokens
1671      *
1672      * Emits a {ApprovalForAll} event.
1673      */
1674     function _setApprovalForAll(
1675         address owner,
1676         address operator,
1677         bool approved
1678     ) internal virtual {
1679         require(owner != operator, "ERC721: approve to caller");
1680         _operatorApprovals[owner][operator] = approved;
1681         emit ApprovalForAll(owner, operator, approved);
1682     }
1683 
1684     /**
1685      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1686      * The call is not executed if the target address is not a contract.
1687      *
1688      * @param from address representing the previous owner of the given token ID
1689      * @param to target address that will receive the tokens
1690      * @param tokenId uint256 ID of the token to be transferred
1691      * @param _data bytes optional data to send along with the call
1692      * @return bool whether the call correctly returned the expected magic value
1693      */
1694     function _checkOnERC721Received(
1695         address from,
1696         address to,
1697         uint256 tokenId,
1698         bytes memory _data
1699     ) private returns (bool) {
1700         if (to.isContract()) {
1701             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1702                 return retval == IERC721Receiver.onERC721Received.selector;
1703             } catch (bytes memory reason) {
1704                 if (reason.length == 0) {
1705                     revert("ERC721: transfer to non ERC721Receiver implementer");
1706                 } else {
1707                     assembly {
1708                         revert(add(32, reason), mload(reason))
1709                     }
1710                 }
1711             }
1712         } else {
1713             return true;
1714         }
1715     }
1716 
1717     /**
1718      * @dev Hook that is called before any token transfer. This includes minting
1719      * and burning.
1720      *
1721      * Calling conditions:
1722      *
1723      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1724      * transferred to `to`.
1725      * - When `from` is zero, `tokenId` will be minted for `to`.
1726      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1727      * - `from` and `to` are never both zero.
1728      *
1729      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1730      */
1731     function _beforeTokenTransfer(
1732         address from,
1733         address to,
1734         uint256 tokenId
1735     ) internal virtual {}
1736 }
1737 
1738 // File: DojoWarriors.sol
1739 
1740 
1741 pragma solidity ^0.8.11;
1742 
1743 
1744 
1745 
1746 
1747 
1748 
1749 contract dojoWarriors is ERC721, Ownable, PaymentSplitter {
1750     using Counters for Counters.Counter;
1751     using SafeMath for uint256;
1752 
1753     Counters.Counter private _tokenIdCounter;
1754     
1755     //---------Variables-------------
1756     //  Max amount of tokens
1757     uint256 public maxAmntTokens;
1758     //  Max amount of tokens per transaction
1759     uint256 public maxTknPerTxs;
1760     //  Price per NFT
1761     uint256 public price;
1762     //  URI control
1763     string newURI;
1764     //  Sale is active
1765     bool public saleIsActive;
1766     //  URI locked
1767     bool public URIlocked;
1768     //  Mint counter per address
1769     mapping(address => uint) public mintCountPerAddress;
1770     
1771     constructor(address[] memory _payees, uint256[] memory _shares) ERC721("Dojo Warriors", "DOJO") PaymentSplitter(_payees, _shares) payable {
1772         //  Max amount of tokens
1773         maxAmntTokens = 8888;
1774         //  Max tokens per transaction
1775         maxTknPerTxs = 8;
1776         //  Price per NFT in wei
1777         price = 70000000000000000 wei;
1778         //  Deactivate sale
1779         saleIsActive = false;
1780         //  Unlock URI
1781         URIlocked = false;
1782     }
1783     
1784     //  Flip sale state
1785     function flipSaleState() public onlyOwner{
1786         saleIsActive = !saleIsActive;
1787     }
1788     
1789     //  Reserve NFTs, this won't cost ETH 
1790     function reserveNFT(uint256 reservedTokens)public onlyOwner{
1791         require ((reservedTokens.add(checkMintedTokens()) <= maxAmntTokens), "You are minting more NFTs than there are available, mint less tokens!");
1792         require (reservedTokens <= 20, "Sorry, the max amount of reserved tokens per transaction is set to 20");
1793         
1794         for (uint i=0; i<reservedTokens; i++){
1795             safeMint(msg.sender);
1796         }
1797     }
1798     
1799     //  Modify URI
1800     function changeURI(string calldata _newURI) public onlyOwner{
1801         require (URIlocked == false, "URI locked, you can't change it anymore");
1802         newURI = _newURI;
1803     }
1804 
1805     //  Lock URI
1806     function lockURI() public onlyOwner {
1807         require(URIlocked == false, "URI already locked");
1808         URIlocked = true;
1809     }
1810     
1811     //  Base URI function, this won't be callable, you will use the changeURI function instead
1812     function _baseURI() internal view override returns (string memory) {
1813         return newURI;
1814     }
1815     
1816     //  Base mint function, this won't be callable, you will use the mintNFT function instead
1817     function safeMint(address to) internal{
1818         _safeMint(to, _tokenIdCounter.current());
1819     _tokenIdCounter.increment();
1820     
1821     }
1822     //  Check amount of already minted NFTs
1823     function checkMintedTokens() public view returns(uint256) {
1824         return(_tokenIdCounter._value);
1825     }
1826     
1827     //  Function to mint tokens, this is the function that you are going to use
1828     //  instead of safeMint
1829     function mintNFT(uint256 amountTokens) public payable {
1830         
1831         //  Requires that the sale state is active
1832         require(saleIsActive, "Sale is not active at this moment");
1833         
1834         //  Requires that the amount of tokens user wants to mint + already minted tokens don't surpass the available tokens
1835         require ((amountTokens.add(checkMintedTokens()) <= maxAmntTokens), "You are minting more NFTs than there are available, mint less tokens!");
1836         require (amountTokens <= maxTknPerTxs, "Sorry, the max amount of tokens per transaction is set to 8");
1837 
1838         //  Requires the NFTs owned by the address to be less than 8, we update the mintCountPerAddress to this value
1839         if (balanceOf(msg.sender) < 8)  {
1840             mintCountPerAddress[msg.sender] = balanceOf(msg.sender);
1841         }
1842         
1843         //  Requires the NFT mint count of the user to be 8 NFTs or less
1844         require (mintCountPerAddress[msg.sender] + amountTokens <= 8, "You are not allowed to mint more than 8 NFTs, but you can buy more on secondary markets.");
1845         
1846         //  Requires the correct amount of ETH
1847         require (msg.value == (price.mul(amountTokens)), "Amount of Ether incorrect, try again.");
1848         
1849         //  Internal mint function
1850         for (uint i=0; i<amountTokens; i++){
1851             safeMint(msg.sender);
1852         }
1853 
1854         //  Update the mint count of the user
1855         mintCountPerAddress[msg.sender] += amountTokens;
1856     }
1857 }