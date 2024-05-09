1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Interface of the ERC20 standard as defined in the EIP.
100  */
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `to`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address to, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `from` to `to` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address from,
157         address to,
158         uint256 amount
159     ) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 pragma solidity ^0.8.1;
177 
178 /**
179  * @dev Collection of functions related to the address type
180  */
181 library Address {
182     /**
183      * @dev Returns true if `account` is a contract.
184      *
185      * [IMPORTANT]
186      * ====
187      * It is unsafe to assume that an address for which this function returns
188      * false is an externally-owned account (EOA) and not a contract.
189      *
190      * Among others, `isContract` will return false for the following
191      * types of addresses:
192      *
193      *  - an externally-owned account
194      *  - a contract in construction
195      *  - an address where a contract will be created
196      *  - an address where a contract lived, but was destroyed
197      * ====
198      *
199      * [IMPORTANT]
200      * ====
201      * You shouldn't rely on `isContract` to protect against flash loan attacks!
202      *
203      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
204      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
205      * constructor.
206      * ====
207      */
208     function isContract(address account) internal view returns (bool) {
209         // This method relies on extcodesize/address.code.length, which returns 0
210         // for contracts in construction, since the code is only stored at the end
211         // of the constructor execution.
212 
213         return account.code.length > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         (bool success, ) = recipient.call{value: amount}("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
296      * with `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
320         return functionStaticCall(target, data, "Address: low-level static call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         require(isContract(target), "Address: static call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(isContract(target), "Address: delegate call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
369      * revert reason using the provided one.
370      *
371      * _Available since v4.3._
372      */
373     function verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) internal pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev String operations.
401  */
402 library Strings {
403     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
404 
405     /**
406      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
407      */
408     function toString(uint256 value) internal pure returns (string memory) {
409         // Inspired by OraclizeAPI's implementation - MIT licence
410         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
411 
412         if (value == 0) {
413             return "0";
414         }
415         uint256 temp = value;
416         uint256 digits;
417         while (temp != 0) {
418             digits++;
419             temp /= 10;
420         }
421         bytes memory buffer = new bytes(digits);
422         while (value != 0) {
423             digits -= 1;
424             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
425             value /= 10;
426         }
427         return string(buffer);
428     }
429 
430     /**
431      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
432      */
433     function toHexString(uint256 value) internal pure returns (string memory) {
434         if (value == 0) {
435             return "0x00";
436         }
437         uint256 temp = value;
438         uint256 length = 0;
439         while (temp != 0) {
440             length++;
441             temp >>= 8;
442         }
443         return toHexString(value, length);
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
448      */
449     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
450         bytes memory buffer = new bytes(2 * length + 2);
451         buffer[0] = "0";
452         buffer[1] = "x";
453         for (uint256 i = 2 * length + 1; i > 1; --i) {
454             buffer[i] = _HEX_SYMBOLS[value & 0xf];
455             value >>= 4;
456         }
457         require(value == 0, "Strings: hex length insufficient");
458         return string(buffer);
459     }
460 }
461 
462 pragma solidity ^0.8.0;
463 
464 // CAUTION
465 // This version of SafeMath should only be used with Solidity 0.8 or later,
466 // because it relies on the compiler's built in overflow checks.
467 
468 /**
469  * @dev Wrappers over Solidity's arithmetic operations.
470  *
471  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
472  * now has built in overflow checking.
473  */
474 library SafeMath {
475     /**
476      * @dev Returns the addition of two unsigned integers, with an overflow flag.
477      *
478      * _Available since v3.4._
479      */
480     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
481         unchecked {
482             uint256 c = a + b;
483             if (c < a) return (false, 0);
484             return (true, c);
485         }
486     }
487 
488     /**
489      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
490      *
491      * _Available since v3.4._
492      */
493     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
494         unchecked {
495             if (b > a) return (false, 0);
496             return (true, a - b);
497         }
498     }
499 
500     /**
501      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
502      *
503      * _Available since v3.4._
504      */
505     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
506         unchecked {
507             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
508             // benefit is lost if 'b' is also tested.
509             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
510             if (a == 0) return (true, 0);
511             uint256 c = a * b;
512             if (c / a != b) return (false, 0);
513             return (true, c);
514         }
515     }
516 
517     /**
518      * @dev Returns the division of two unsigned integers, with a division by zero flag.
519      *
520      * _Available since v3.4._
521      */
522     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
523         unchecked {
524             if (b == 0) return (false, 0);
525             return (true, a / b);
526         }
527     }
528 
529     /**
530      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
531      *
532      * _Available since v3.4._
533      */
534     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
535         unchecked {
536             if (b == 0) return (false, 0);
537             return (true, a % b);
538         }
539     }
540 
541     /**
542      * @dev Returns the addition of two unsigned integers, reverting on
543      * overflow.
544      *
545      * Counterpart to Solidity's `+` operator.
546      *
547      * Requirements:
548      *
549      * - Addition cannot overflow.
550      */
551     function add(uint256 a, uint256 b) internal pure returns (uint256) {
552         return a + b;
553     }
554 
555     /**
556      * @dev Returns the subtraction of two unsigned integers, reverting on
557      * overflow (when the result is negative).
558      *
559      * Counterpart to Solidity's `-` operator.
560      *
561      * Requirements:
562      *
563      * - Subtraction cannot overflow.
564      */
565     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
566         return a - b;
567     }
568 
569     /**
570      * @dev Returns the multiplication of two unsigned integers, reverting on
571      * overflow.
572      *
573      * Counterpart to Solidity's `*` operator.
574      *
575      * Requirements:
576      *
577      * - Multiplication cannot overflow.
578      */
579     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
580         return a * b;
581     }
582 
583     /**
584      * @dev Returns the integer division of two unsigned integers, reverting on
585      * division by zero. The result is rounded towards zero.
586      *
587      * Counterpart to Solidity's `/` operator.
588      *
589      * Requirements:
590      *
591      * - The divisor cannot be zero.
592      */
593     function div(uint256 a, uint256 b) internal pure returns (uint256) {
594         return a / b;
595     }
596 
597     /**
598      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
599      * reverting when dividing by zero.
600      *
601      * Counterpart to Solidity's `%` operator. This function uses a `revert`
602      * opcode (which leaves remaining gas untouched) while Solidity uses an
603      * invalid opcode to revert (consuming all remaining gas).
604      *
605      * Requirements:
606      *
607      * - The divisor cannot be zero.
608      */
609     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a % b;
611     }
612 
613     /**
614      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
615      * overflow (when the result is negative).
616      *
617      * CAUTION: This function is deprecated because it requires allocating memory for the error
618      * message unnecessarily. For custom revert reasons use {trySub}.
619      *
620      * Counterpart to Solidity's `-` operator.
621      *
622      * Requirements:
623      *
624      * - Subtraction cannot overflow.
625      */
626     function sub(
627         uint256 a,
628         uint256 b,
629         string memory errorMessage
630     ) internal pure returns (uint256) {
631         unchecked {
632             require(b <= a, errorMessage);
633             return a - b;
634         }
635     }
636 
637     /**
638      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
639      * division by zero. The result is rounded towards zero.
640      *
641      * Counterpart to Solidity's `/` operator. Note: this function uses a
642      * `revert` opcode (which leaves remaining gas untouched) while Solidity
643      * uses an invalid opcode to revert (consuming all remaining gas).
644      *
645      * Requirements:
646      *
647      * - The divisor cannot be zero.
648      */
649     function div(
650         uint256 a,
651         uint256 b,
652         string memory errorMessage
653     ) internal pure returns (uint256) {
654         unchecked {
655             require(b > 0, errorMessage);
656             return a / b;
657         }
658     }
659 
660     /**
661      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
662      * reverting with custom message when dividing by zero.
663      *
664      * CAUTION: This function is deprecated because it requires allocating memory for the error
665      * message unnecessarily. For custom revert reasons use {tryMod}.
666      *
667      * Counterpart to Solidity's `%` operator. This function uses a `revert`
668      * opcode (which leaves remaining gas untouched) while Solidity uses an
669      * invalid opcode to revert (consuming all remaining gas).
670      *
671      * Requirements:
672      *
673      * - The divisor cannot be zero.
674      */
675     function mod(
676         uint256 a,
677         uint256 b,
678         string memory errorMessage
679     ) internal pure returns (uint256) {
680         unchecked {
681             require(b > 0, errorMessage);
682             return a % b;
683         }
684     }
685 }
686 
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Interface for the optional metadata functions from the ERC20 standard.
692  *
693  * _Available since v4.1._
694  */
695 interface IERC20Metadata is IERC20 {
696     /**
697      * @dev Returns the name of the token.
698      */
699     function name() external view returns (string memory);
700 
701     /**
702      * @dev Returns the symbol of the token.
703      */
704     function symbol() external view returns (string memory);
705 
706     /**
707      * @dev Returns the decimals places of the token.
708      */
709     function decimals() external view returns (uint8);
710 }
711 
712 pragma solidity ^0.8.0;
713 
714 
715 
716 /**
717  * @dev Implementation of the {IERC20} interface.
718  *
719  * This implementation is agnostic to the way tokens are created. This means
720  * that a supply mechanism has to be added in a derived contract using {_mint}.
721  * For a generic mechanism see {ERC20PresetMinterPauser}.
722  *
723  * TIP: For a detailed writeup see our guide
724  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
725  * to implement supply mechanisms].
726  *
727  * We have followed general OpenZeppelin Contracts guidelines: functions revert
728  * instead returning `false` on failure. This behavior is nonetheless
729  * conventional and does not conflict with the expectations of ERC20
730  * applications.
731  *
732  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
733  * This allows applications to reconstruct the allowance for all accounts just
734  * by listening to said events. Other implementations of the EIP may not emit
735  * these events, as it isn't required by the specification.
736  *
737  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
738  * functions have been added to mitigate the well-known issues around setting
739  * allowances. See {IERC20-approve}.
740  */
741 contract ERC20 is Context, IERC20, IERC20Metadata {
742     mapping(address => uint256) private _balances;
743 
744     mapping(address => mapping(address => uint256)) private _allowances;
745 
746     uint256 private _totalSupply;
747 
748     string private _name;
749     string private _symbol;
750 
751     /**
752      * @dev Sets the values for {name} and {symbol}.
753      *
754      * The default value of {decimals} is 18. To select a different value for
755      * {decimals} you should overload it.
756      *
757      * All two of these values are immutable: they can only be set once during
758      * construction.
759      */
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763     }
764 
765     /**
766      * @dev Returns the name of the token.
767      */
768     function name() public view virtual override returns (string memory) {
769         return _name;
770     }
771 
772     /**
773      * @dev Returns the symbol of the token, usually a shorter version of the
774      * name.
775      */
776     function symbol() public view virtual override returns (string memory) {
777         return _symbol;
778     }
779 
780     /**
781      * @dev Returns the number of decimals used to get its user representation.
782      * For example, if `decimals` equals `2`, a balance of `505` tokens should
783      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
784      *
785      * Tokens usually opt for a value of 18, imitating the relationship between
786      * Ether and Wei. This is the value {ERC20} uses, unless this function is
787      * overridden;
788      *
789      * NOTE: This information is only used for _display_ purposes: it in
790      * no way affects any of the arithmetic of the contract, including
791      * {IERC20-balanceOf} and {IERC20-transfer}.
792      */
793     function decimals() public view virtual override returns (uint8) {
794         return 18;
795     }
796 
797     /**
798      * @dev See {IERC20-totalSupply}.
799      */
800     function totalSupply() public view virtual override returns (uint256) {
801         return _totalSupply;
802     }
803 
804     /**
805      * @dev See {IERC20-balanceOf}.
806      */
807     function balanceOf(address account) public view virtual override returns (uint256) {
808         return _balances[account];
809     }
810 
811     /**
812      * @dev See {IERC20-transfer}.
813      *
814      * Requirements:
815      *
816      * - `to` cannot be the zero address.
817      * - the caller must have a balance of at least `amount`.
818      */
819     function transfer(address to, uint256 amount) public virtual override returns (bool) {
820         address owner = _msgSender();
821         _transfer(owner, to, amount);
822         return true;
823     }
824 
825     /**
826      * @dev See {IERC20-allowance}.
827      */
828     function allowance(address owner, address spender) public view virtual override returns (uint256) {
829         return _allowances[owner][spender];
830     }
831 
832     /**
833      * @dev See {IERC20-approve}.
834      *
835      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
836      * `transferFrom`. This is semantically equivalent to an infinite approval.
837      *
838      * Requirements:
839      *
840      * - `spender` cannot be the zero address.
841      */
842     function approve(address spender, uint256 amount) public virtual override returns (bool) {
843         address owner = _msgSender();
844         _approve(owner, spender, amount);
845         return true;
846     }
847 
848     /**
849      * @dev See {IERC20-transferFrom}.
850      *
851      * Emits an {Approval} event indicating the updated allowance. This is not
852      * required by the EIP. See the note at the beginning of {ERC20}.
853      *
854      * NOTE: Does not update the allowance if the current allowance
855      * is the maximum `uint256`.
856      *
857      * Requirements:
858      *
859      * - `from` and `to` cannot be the zero address.
860      * - `from` must have a balance of at least `amount`.
861      * - the caller must have allowance for ``from``'s tokens of at least
862      * `amount`.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 amount
868     ) public virtual override returns (bool) {
869         address spender = _msgSender();
870         _spendAllowance(from, spender, amount);
871         _transfer(from, to, amount);
872         return true;
873     }
874 
875     /**
876      * @dev Atomically increases the allowance granted to `spender` by the caller.
877      *
878      * This is an alternative to {approve} that can be used as a mitigation for
879      * problems described in {IERC20-approve}.
880      *
881      * Emits an {Approval} event indicating the updated allowance.
882      *
883      * Requirements:
884      *
885      * - `spender` cannot be the zero address.
886      */
887     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
888         address owner = _msgSender();
889         _approve(owner, spender, _allowances[owner][spender] + addedValue);
890         return true;
891     }
892 
893     /**
894      * @dev Atomically decreases the allowance granted to `spender` by the caller.
895      *
896      * This is an alternative to {approve} that can be used as a mitigation for
897      * problems described in {IERC20-approve}.
898      *
899      * Emits an {Approval} event indicating the updated allowance.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      * - `spender` must have allowance for the caller of at least
905      * `subtractedValue`.
906      */
907     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
908         address owner = _msgSender();
909         uint256 currentAllowance = _allowances[owner][spender];
910         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
911         unchecked {
912             _approve(owner, spender, currentAllowance - subtractedValue);
913         }
914 
915         return true;
916     }
917 
918     /**
919      * @dev Moves `amount` of tokens from `sender` to `recipient`.
920      *
921      * This internal function is equivalent to {transfer}, and can be used to
922      * e.g. implement automatic token fees, slashing mechanisms, etc.
923      *
924      * Emits a {Transfer} event.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `from` must have a balance of at least `amount`.
931      */
932     function _transfer(
933         address from,
934         address to,
935         uint256 amount
936     ) internal virtual {
937         require(from != address(0), "ERC20: transfer from the zero address");
938         require(to != address(0), "ERC20: transfer to the zero address");
939 
940         _beforeTokenTransfer(from, to, amount);
941 
942         uint256 fromBalance = _balances[from];
943         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
944         unchecked {
945             _balances[from] = fromBalance - amount;
946         }
947         _balances[to] += amount;
948 
949         emit Transfer(from, to, amount);
950 
951         _afterTokenTransfer(from, to, amount);
952     }
953 
954     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
955      * the total supply.
956      *
957      * Emits a {Transfer} event with `from` set to the zero address.
958      *
959      * Requirements:
960      *
961      * - `account` cannot be the zero address.
962      */
963     function _mint(address account, uint256 amount) internal virtual {
964         require(account != address(0), "ERC20: mint to the zero address");
965 
966         _beforeTokenTransfer(address(0), account, amount);
967 
968         _totalSupply += amount;
969         _balances[account] += amount;
970         emit Transfer(address(0), account, amount);
971 
972         _afterTokenTransfer(address(0), account, amount);
973     }
974 
975     /**
976      * @dev Destroys `amount` tokens from `account`, reducing the
977      * total supply.
978      *
979      * Emits a {Transfer} event with `to` set to the zero address.
980      *
981      * Requirements:
982      *
983      * - `account` cannot be the zero address.
984      * - `account` must have at least `amount` tokens.
985      */
986     function _burn(address account, uint256 amount) internal virtual {
987         require(account != address(0), "ERC20: burn from the zero address");
988 
989         _beforeTokenTransfer(account, address(0), amount);
990 
991         uint256 accountBalance = _balances[account];
992         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
993         unchecked {
994             _balances[account] = accountBalance - amount;
995         }
996         _totalSupply -= amount;
997 
998         emit Transfer(account, address(0), amount);
999 
1000         _afterTokenTransfer(account, address(0), amount);
1001     }
1002 
1003     /**
1004      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1005      *
1006      * This internal function is equivalent to `approve`, and can be used to
1007      * e.g. set automatic allowances for certain subsystems, etc.
1008      *
1009      * Emits an {Approval} event.
1010      *
1011      * Requirements:
1012      *
1013      * - `owner` cannot be the zero address.
1014      * - `spender` cannot be the zero address.
1015      */
1016     function _approve(
1017         address owner,
1018         address spender,
1019         uint256 amount
1020     ) internal virtual {
1021         require(owner != address(0), "ERC20: approve from the zero address");
1022         require(spender != address(0), "ERC20: approve to the zero address");
1023 
1024         _allowances[owner][spender] = amount;
1025         emit Approval(owner, spender, amount);
1026     }
1027 
1028     /**
1029      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1030      *
1031      * Does not update the allowance amount in case of infinite allowance.
1032      * Revert if not enough allowance is available.
1033      *
1034      * Might emit an {Approval} event.
1035      */
1036     function _spendAllowance(
1037         address owner,
1038         address spender,
1039         uint256 amount
1040     ) internal virtual {
1041         uint256 currentAllowance = allowance(owner, spender);
1042         if (currentAllowance != type(uint256).max) {
1043             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1044             unchecked {
1045                 _approve(owner, spender, currentAllowance - amount);
1046             }
1047         }
1048     }
1049 
1050     /**
1051      * @dev Hook that is called before any transfer of tokens. This includes
1052      * minting and burning.
1053      *
1054      * Calling conditions:
1055      *
1056      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1057      * will be transferred to `to`.
1058      * - when `from` is zero, `amount` tokens will be minted for `to`.
1059      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1060      * - `from` and `to` are never both zero.
1061      *
1062      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1063      */
1064     function _beforeTokenTransfer(
1065         address from,
1066         address to,
1067         uint256 amount
1068     ) internal virtual {}
1069 
1070     /**
1071      * @dev Hook that is called after any transfer of tokens. This includes
1072      * minting and burning.
1073      *
1074      * Calling conditions:
1075      *
1076      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1077      * has been transferred to `to`.
1078      * - when `from` is zero, `amount` tokens have been minted for `to`.
1079      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1080      * - `from` and `to` are never both zero.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _afterTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 amount
1088     ) internal virtual {}
1089 }
1090 
1091 
1092 // File contracts/VINUNETWORK/ERC20.sol
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 contract VINUNetwork is ERC20, Ownable {
1098 
1099     constructor(string memory _name, string memory _symbol,address _to, uint256 _amount) ERC20(_name, _symbol) {
1100         super._mint(_to, _amount);
1101     }
1102 
1103     function burnByOwner(address _from, uint256 _amount) external onlyOwner {
1104         super._burn(_from, _amount);
1105     }
1106 
1107 }