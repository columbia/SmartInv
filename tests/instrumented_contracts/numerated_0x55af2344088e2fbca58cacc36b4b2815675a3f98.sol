1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b <= a, errorMessage);
174             return a - b;
175         }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         unchecked {
196             require(b > 0, errorMessage);
197             return a / b;
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a % b;
224         }
225     }
226 }
227 
228 
229 pragma solidity ^0.8.1;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      *
252      * [IMPORTANT]
253      * ====
254      * You shouldn't rely on `isContract` to protect against flash loan attacks!
255      *
256      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
257      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
258      * constructor.
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize/address.code.length, which returns 0
263         // for contracts in construction, since the code is only stored at the end
264         // of the constructor execution.
265 
266         return account.code.length > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         (bool success, ) = recipient.call{value: amount}("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.call{value: value}(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
373         return functionStaticCall(target, data, "Address: low-level static call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.staticcall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(isContract(target), "Address: delegate call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
422      * revert reason using the provided one.
423      *
424      * _Available since v4.3._
425      */
426     function verifyCallResult(
427         bool success,
428         bytes memory returndata,
429         string memory errorMessage
430     ) internal pure returns (bytes memory) {
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev Provides information about the current execution context, including the
454  * sender of the transaction and its data. While these are generally available
455  * via msg.sender and msg.data, they should not be accessed in such a direct
456  * manner, since when dealing with meta-transactions the account sending and
457  * paying for execution may not be the actual sender (as far as an application
458  * is concerned).
459  *
460  * This contract is only required for intermediate, library-like contracts.
461  */
462 abstract contract Context {
463     function _msgSender() internal view virtual returns (address) {
464         return msg.sender;
465     }
466 
467     function _msgData() internal view virtual returns (bytes calldata) {
468         return msg.data;
469     }
470 }
471 
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev Contract module which provides a basic access control mechanism, where
477  * there is an account (an owner) that can be granted exclusive access to
478  * specific functions.
479  *
480  * By default, the owner account will be the one that deploys the contract. This
481  * can later be changed with {transferOwnership}.
482  *
483  * This module is used through inheritance. It will make available the modifier
484  * `onlyOwner`, which can be applied to your functions to restrict their use to
485  * the owner.
486  */
487 abstract contract Ownable is Context {
488     address private _owner;
489 
490     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
491 
492     /**
493      * @dev Initializes the contract setting the deployer as the initial owner.
494      */
495     constructor() {
496         _transferOwnership(_msgSender());
497     }
498 
499     /**
500      * @dev Returns the address of the current owner.
501      */
502     function owner() public view virtual returns (address) {
503         return _owner;
504     }
505 
506     /**
507      * @dev Throws if called by any account other than the owner.
508      */
509     modifier onlyOwner() {
510         require(owner() == _msgSender(), "Ownable: caller is not the owner");
511         _;
512     }
513 
514     /**
515      * @dev Leaves the contract without owner. It will not be possible to call
516      * `onlyOwner` functions anymore. Can only be called by the current owner.
517      *
518      * NOTE: Renouncing ownership will leave the contract without an owner,
519      * thereby removing any functionality that is only available to the owner.
520      */
521     function renounceOwnership() public virtual onlyOwner {
522         _transferOwnership(address(0));
523     }
524 
525     /**
526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
527      * Can only be called by the current owner.
528      */
529     function transferOwnership(address newOwner) public virtual onlyOwner {
530         require(newOwner != address(0), "Ownable: new owner is the zero address");
531         _transferOwnership(newOwner);
532     }
533 
534     /**
535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
536      * Internal function without access restriction.
537      */
538     function _transferOwnership(address newOwner) internal virtual {
539         address oldOwner = _owner;
540         _owner = newOwner;
541         emit OwnershipTransferred(oldOwner, newOwner);
542     }
543 }
544 
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Interface of the ERC20 standard as defined in the EIP.
550  */
551 interface IERC20 {
552     /**
553      * @dev Emitted when `value` tokens are moved from one account (`from`) to
554      * another (`to`).
555      *
556      * Note that `value` may be zero.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 value);
559 
560     /**
561      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
562      * a call to {approve}. `value` is the new allowance.
563      */
564     event Approval(address indexed owner, address indexed spender, uint256 value);
565 
566     /**
567      * @dev Returns the amount of tokens in existence.
568      */
569     function totalSupply() external view returns (uint256);
570 
571     /**
572      * @dev Returns the amount of tokens owned by `account`.
573      */
574     function balanceOf(address account) external view returns (uint256);
575 
576     /**
577      * @dev Moves `amount` tokens from the caller's account to `to`.
578      *
579      * Returns a boolean value indicating whether the operation succeeded.
580      *
581      * Emits a {Transfer} event.
582      */
583     function transfer(address to, uint256 amount) external returns (bool);
584 
585     /**
586      * @dev Returns the remaining number of tokens that `spender` will be
587      * allowed to spend on behalf of `owner` through {transferFrom}. This is
588      * zero by default.
589      *
590      * This value changes when {approve} or {transferFrom} are called.
591      */
592     function allowance(address owner, address spender) external view returns (uint256);
593 
594     /**
595      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
596      *
597      * Returns a boolean value indicating whether the operation succeeded.
598      *
599      * IMPORTANT: Beware that changing an allowance with this method brings the risk
600      * that someone may use both the old and the new allowance by unfortunate
601      * transaction ordering. One possible solution to mitigate this race
602      * condition is to first reduce the spender's allowance to 0 and set the
603      * desired value afterwards:
604      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
605      *
606      * Emits an {Approval} event.
607      */
608     function approve(address spender, uint256 amount) external returns (bool);
609 
610     /**
611      * @dev Moves `amount` tokens from `from` to `to` using the
612      * allowance mechanism. `amount` is then deducted from the caller's
613      * allowance.
614      *
615      * Returns a boolean value indicating whether the operation succeeded.
616      *
617      * Emits a {Transfer} event.
618      */
619     function transferFrom(
620         address from,
621         address to,
622         uint256 amount
623     ) external returns (bool);
624 }
625 
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Interface for the optional metadata functions from the ERC20 standard.
631  *
632  * _Available since v4.1._
633  */
634 interface IERC20Metadata is IERC20 {
635     /**
636      * @dev Returns the name of the token.
637      */
638     function name() external view returns (string memory);
639 
640     /**
641      * @dev Returns the symbol of the token.
642      */
643     function symbol() external view returns (string memory);
644 
645     /**
646      * @dev Returns the decimals places of the token.
647      */
648     function decimals() external view returns (uint8);
649 }
650 
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Implementation of the {IERC20} interface.
656  *
657  * This implementation is agnostic to the way tokens are created. This means
658  * that a supply mechanism has to be added in a derived contract using {_mint}.
659  * For a generic mechanism see {ERC20PresetMinterPauser}.
660  *
661  * TIP: For a detailed writeup see our guide
662  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
663  * to implement supply mechanisms].
664  *
665  * We have followed general OpenZeppelin Contracts guidelines: functions revert
666  * instead returning `false` on failure. This behavior is nonetheless
667  * conventional and does not conflict with the expectations of ERC20
668  * applications.
669  *
670  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
671  * This allows applications to reconstruct the allowance for all accounts just
672  * by listening to said events. Other implementations of the EIP may not emit
673  * these events, as it isn't required by the specification.
674  *
675  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
676  * functions have been added to mitigate the well-known issues around setting
677  * allowances. See {IERC20-approve}.
678  */
679 contract ERC20 is Context, IERC20, IERC20Metadata {
680     using SafeMath for uint256;
681     using Address for address;
682 
683     mapping(address => uint256) private _balances;
684 
685     mapping(address => mapping(address => uint256)) private _allowances;
686 
687     uint256 private _totalSupply;
688 
689     string private _name;
690     string private _symbol;
691 
692     /**
693      * @dev Sets the values for {name} and {symbol}.
694      *
695      * The default value of {decimals} is 18. To select a different value for
696      * {decimals} you should overload it.
697      *
698      * All two of these values are immutable: they can only be set once during
699      * construction.
700      */
701     constructor(string memory name_, string memory symbol_) {
702         _name = name_;
703         _symbol = symbol_;
704     }
705 
706     /**
707      * @dev Returns the name of the token.
708      */
709     function name() public view virtual override returns (string memory) {
710         return _name;
711     }
712 
713     /**
714      * @dev Returns the symbol of the token, usually a shorter version of the
715      * name.
716      */
717     function symbol() public view virtual override returns (string memory) {
718         return _symbol;
719     }
720 
721     /**
722      * @dev Returns the number of decimals used to get its user representation.
723      * For example, if `decimals` equals `2`, a balance of `505` tokens should
724      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
725      *
726      * Tokens usually opt for a value of 18, imitating the relationship between
727      * Ether and Wei. This is the value {ERC20} uses, unless this function is
728      * overridden;
729      *
730      * NOTE: This information is only used for _display_ purposes: it in
731      * no way affects any of the arithmetic of the contract, including
732      * {IERC20-balanceOf} and {IERC20-transfer}.
733      */
734     function decimals() public view virtual override returns (uint8) {
735         return 18;
736     }
737 
738     /**
739      * @dev See {IERC20-totalSupply}.
740      */
741     function totalSupply() public view virtual override returns (uint256) {
742         return _totalSupply;
743     }
744 
745     /**
746      * @dev See {IERC20-balanceOf}.
747      */
748     function balanceOf(address account) public view virtual override returns (uint256) {
749         return _balances[account];
750     }
751 
752     /**
753      * @dev See {IERC20-transfer}.
754      *
755      * Requirements:
756      *
757      * - `to` cannot be the zero address.
758      * - the caller must have a balance of at least `amount`.
759      */
760     function transfer(address to, uint256 amount) public virtual override returns (bool) {
761         address owner = _msgSender();
762         _transfer(owner, to, amount);
763         return true;
764     }
765 
766     /**
767      * @dev See {IERC20-allowance}.
768      */
769     function allowance(address owner, address spender) public view virtual override returns (uint256) {
770         return _allowances[owner][spender];
771     }
772 
773     /**
774      * @dev See {IERC20-approve}.
775      *
776      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
777      * `transferFrom`. This is semantically equivalent to an infinite approval.
778      *
779      * Requirements:
780      *
781      * - `spender` cannot be the zero address.
782      */
783     function approve(address spender, uint256 amount) public virtual override returns (bool) {
784         address owner = _msgSender();
785         _approve(owner, spender, amount);
786         return true;
787     }
788 
789     /**
790      * @dev See {IERC20-transferFrom}.
791      *
792      * Emits an {Approval} event indicating the updated allowance. This is not
793      * required by the EIP. See the note at the beginning of {ERC20}.
794      *
795      * NOTE: Does not update the allowance if the current allowance
796      * is the maximum `uint256`.
797      *
798      * Requirements:
799      *
800      * - `from` and `to` cannot be the zero address.
801      * - `from` must have a balance of at least `amount`.
802      * - the caller must have allowance for ``from``'s tokens of at least
803      * `amount`.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 amount
809     ) public virtual override returns (bool) {
810         address spender = _msgSender();
811         _spendAllowance(from, spender, amount);
812         _transfer(from, to, amount);
813         return true;
814     }
815 
816     /**
817      * @dev Atomically increases the allowance granted to `spender` by the caller.
818      *
819      * This is an alternative to {approve} that can be used as a mitigation for
820      * problems described in {IERC20-approve}.
821      *
822      * Emits an {Approval} event indicating the updated allowance.
823      *
824      * Requirements:
825      *
826      * - `spender` cannot be the zero address.
827      */
828     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
829         address owner = _msgSender();
830         _approve(owner, spender, allowance(owner, spender) + addedValue);
831         return true;
832     }
833 
834     /**
835      * @dev Atomically decreases the allowance granted to `spender` by the caller.
836      *
837      * This is an alternative to {approve} that can be used as a mitigation for
838      * problems described in {IERC20-approve}.
839      *
840      * Emits an {Approval} event indicating the updated allowance.
841      *
842      * Requirements:
843      *
844      * - `spender` cannot be the zero address.
845      * - `spender` must have allowance for the caller of at least
846      * `subtractedValue`.
847      */
848     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
849         address owner = _msgSender();
850         uint256 currentAllowance = allowance(owner, spender);
851         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
852         unchecked {
853             _approve(owner, spender, currentAllowance - subtractedValue);
854         }
855 
856         return true;
857     }
858 
859     /**
860      * @dev Moves `amount` of tokens from `sender` to `recipient`.
861      *
862      * This internal function is equivalent to {transfer}, and can be used to
863      * e.g. implement automatic token fees, slashing mechanisms, etc.
864      *
865      * Emits a {Transfer} event.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `from` must have a balance of at least `amount`.
872      */
873     function _transfer(
874         address from,
875         address to,
876         uint256 amount
877     ) internal virtual {
878         require(from != address(0), "ERC20: transfer from the zero address");
879         require(to != address(0), "ERC20: transfer to the zero address");
880 
881         _beforeTokenTransfer(from, to, amount);
882 
883         uint256 fromBalance = _balances[from];
884         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
885         unchecked {
886             _balances[from] = fromBalance - amount;
887         }
888         _balances[to] += amount;
889 
890         emit Transfer(from, to, amount);
891 
892         _afterTokenTransfer(from, to, amount);
893     }
894 
895     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
896      * the total supply.
897      *
898      * Emits a {Transfer} event with `from` set to the zero address.
899      *
900      * Requirements:
901      *
902      * - `account` cannot be the zero address.
903      */
904     function _mint(address account, uint256 amount) internal virtual {
905         require(account != address(0), "ERC20: mint to the zero address");
906 
907         _beforeTokenTransfer(address(0), account, amount);
908 
909         _totalSupply += amount;
910         _balances[account] += amount;
911         emit Transfer(address(0), account, amount);
912 
913         _afterTokenTransfer(address(0), account, amount);
914     }
915 
916     /**
917      * @dev Destroys `amount` tokens from `account`, reducing the
918      * total supply.
919      *
920      * Emits a {Transfer} event with `to` set to the zero address.
921      *
922      * Requirements:
923      *
924      * - `account` cannot be the zero address.
925      * - `account` must have at least `amount` tokens.
926      */
927     function _burn(address account, uint256 amount) internal virtual {
928         require(account != address(0), "ERC20: burn from the zero address");
929 
930         _beforeTokenTransfer(account, address(0), amount);
931 
932         uint256 accountBalance = _balances[account];
933         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
934         unchecked {
935             _balances[account] = accountBalance - amount;
936         }
937         _totalSupply -= amount;
938 
939         emit Transfer(account, address(0), amount);
940 
941         _afterTokenTransfer(account, address(0), amount);
942     }
943 
944     /**
945      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
946      *
947      * This internal function is equivalent to `approve`, and can be used to
948      * e.g. set automatic allowances for certain subsystems, etc.
949      *
950      * Emits an {Approval} event.
951      *
952      * Requirements:
953      *
954      * - `owner` cannot be the zero address.
955      * - `spender` cannot be the zero address.
956      */
957     function _approve(
958         address owner,
959         address spender,
960         uint256 amount
961     ) internal virtual {
962         require(owner != address(0), "ERC20: approve from the zero address");
963         require(spender != address(0), "ERC20: approve to the zero address");
964 
965         _allowances[owner][spender] = amount;
966         emit Approval(owner, spender, amount);
967     }
968 
969     /**
970      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
971      *
972      * Does not update the allowance amount in case of infinite allowance.
973      * Revert if not enough allowance is available.
974      *
975      * Might emit an {Approval} event.
976      */
977     function _spendAllowance(
978         address owner,
979         address spender,
980         uint256 amount
981     ) internal virtual {
982         uint256 currentAllowance = allowance(owner, spender);
983         if (currentAllowance != type(uint256).max) {
984             require(currentAllowance >= amount, "ERC20: insufficient allowance");
985             unchecked {
986                 _approve(owner, spender, currentAllowance - amount);
987             }
988         }
989     }
990 
991     /**
992      * @dev Hook that is called before any transfer of tokens. This includes
993      * minting and burning.
994      *
995      * Calling conditions:
996      *
997      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
998      * will be transferred to `to`.
999      * - when `from` is zero, `amount` tokens will be minted for `to`.
1000      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1001      * - `from` and `to` are never both zero.
1002      *
1003      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1004      */
1005     function _beforeTokenTransfer(
1006         address from,
1007         address to,
1008         uint256 amount
1009     ) internal virtual {}
1010 
1011     /**
1012      * @dev Hook that is called after any transfer of tokens. This includes
1013      * minting and burning.
1014      *
1015      * Calling conditions:
1016      *
1017      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1018      * has been transferred to `to`.
1019      * - when `from` is zero, `amount` tokens have been minted for `to`.
1020      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1021      * - `from` and `to` are never both zero.
1022      *
1023      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1024      */
1025     function _afterTokenTransfer(
1026         address from,
1027         address to,
1028         uint256 amount
1029     ) internal virtual {}
1030 }
1031 
1032 pragma solidity ^0.8.0;
1033 
1034 contract ERC20Base is Context, ERC20, Ownable {
1035     constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){}
1036 
1037     function mint(address account, uint256 amount) internal virtual onlyOwner {
1038         _mint(account, amount);
1039     }
1040 
1041     function burn(uint256 amount) public virtual onlyOwner {
1042         _burn(_msgSender(), amount*(10**uint256(decimals())));
1043     }
1044 }
1045 
1046 contract Create_Token is ERC20Base {
1047     constructor() ERC20Base("Vehicle Mining System", "VMS") {
1048         mint(msg.sender, 40*(10**8)*(10**uint256(decimals())));
1049     }
1050 }