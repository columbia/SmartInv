1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 
7 // 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 //
30 
31 // 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         uint256 c = a + b;
128         if (c < a) return (false, 0);
129         return (true, c);
130     }
131 
132     /**
133      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         if (b > a) return (false, 0);
139         return (true, a - b);
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) return (true, 0);
152         uint256 c = a * b;
153         if (c / a != b) return (false, 0);
154         return (true, c);
155     }
156 
157     /**
158      * @dev Returns the division of two unsigned integers, with a division by zero flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         if (b == 0) return (false, 0);
164         return (true, a / b);
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         if (b == 0) return (false, 0);
174         return (true, a % b);
175     }
176 
177     /**
178      * @dev Returns the addition of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `+` operator.
182      *
183      * Requirements:
184      *
185      * - Addition cannot overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         require(c >= a, "SafeMath: addition overflow");
190         return c;
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting on
195      * overflow (when the result is negative).
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      *
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204         require(b <= a, "SafeMath: subtraction overflow");
205         return a - b;
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `*` operator.
213      *
214      * Requirements:
215      *
216      * - Multiplication cannot overflow.
217      */
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         if (a == 0) return 0;
220         uint256 c = a * b;
221         require(c / a == b, "SafeMath: multiplication overflow");
222         return c;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers, reverting on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b > 0, "SafeMath: division by zero");
239         return a / b;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         require(b > 0, "SafeMath: modulo by zero");
256         return a % b;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
261      * overflow (when the result is negative).
262      *
263      * CAUTION: This function is deprecated because it requires allocating memory for the error
264      * message unnecessarily. For custom revert reasons use {trySub}.
265      *
266      * Counterpart to Solidity's `-` operator.
267      *
268      * Requirements:
269      *
270      * - Subtraction cannot overflow.
271      */
272     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b <= a, errorMessage);
274         return a - b;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * CAUTION: This function is deprecated because it requires allocating memory for the error
282      * message unnecessarily. For custom revert reasons use {tryDiv}.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b > 0, errorMessage);
294         return a / b;
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * reverting with custom message when dividing by zero.
300      *
301      * CAUTION: This function is deprecated because it requires allocating memory for the error
302      * message unnecessarily. For custom revert reasons use {tryMod}.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b > 0, errorMessage);
314         return a % b;
315     }
316 }
317 
318 // 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize, which returns 0 for contracts in
342         // construction, since the code is only stored at the end of the
343         // constructor execution.
344 
345         uint256 size;
346         // solhint-disable-next-line no-inline-assembly
347         assembly { size := extcodesize(account) }
348         return size > 0;
349     }
350 
351     /**
352      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
353      * `recipient`, forwarding all available gas and reverting on errors.
354      *
355      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
356      * of certain opcodes, possibly making contracts go over the 2300 gas limit
357      * imposed by `transfer`, making them unable to receive funds via
358      * `transfer`. {sendValue} removes this limitation.
359      *
360      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
361      *
362      * IMPORTANT: because control is transferred to `recipient`, care must be
363      * taken to not create reentrancy vulnerabilities. Consider using
364      * {ReentrancyGuard} or the
365      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
366      */
367     function sendValue(address payable recipient, uint256 amount) internal {
368         require(address(this).balance >= amount, "Address: insufficient balance");
369 
370         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
371         (bool success, ) = recipient.call{ value: amount }("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain`call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394       return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         require(isContract(target), "Address: call to non-contract");
431 
432         // solhint-disable-next-line avoid-low-level-calls
433         (bool success, bytes memory returndata) = target.call{ value: value }(data);
434         return _verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
454         require(isContract(target), "Address: static call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.staticcall(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
468         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
478         require(isContract(target), "Address: delegate call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = target.delegatecall(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
486         if (success) {
487             return returndata;
488         } else {
489             // Look for revert reason and bubble it up if present
490             if (returndata.length > 0) {
491                 // The easiest way to bubble the revert reason is using memory via assembly
492 
493                 // solhint-disable-next-line no-inline-assembly
494                 assembly {
495                     let returndata_size := mload(returndata)
496                     revert(add(32, returndata), returndata_size)
497                 }
498             } else {
499                 revert(errorMessage);
500             }
501         }
502     }
503 }
504 
505 // 
506 /**
507  * @dev Contract module which provides a basic access control mechanism, where
508  * there is an account (an owner) that can be granted exclusive access to
509  * specific functions.
510  *
511  * By default, the owner account will be the one that deploys the contract. This
512  * can later be changed with {transferOwnership}.
513  *
514  * This module is used through inheritance. It will make available the modifier
515  * `onlyOwner`, which can be applied to your functions to restrict their use to
516  * the owner.
517  */
518 abstract contract Ownable is Context {
519     address private _owner;
520 
521     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
522 
523     /**
524      * @dev Initializes the contract setting the deployer as the initial owner.
525      */
526     constructor () internal {
527         address msgSender = _msgSender();
528         _owner = msgSender;
529         emit OwnershipTransferred(address(0), msgSender);
530     }
531 
532     /**
533      * @dev Returns the address of the current owner.
534      */
535     function owner() public view virtual returns (address) {
536         return _owner;
537     }
538 
539     /**
540      * @dev Throws if called by any account other than the owner.
541      */
542     modifier onlyOwner() {
543         require(owner() == _msgSender(), "Ownable: caller is not the owner");
544         _;
545     }
546 
547     /**
548      * @dev Leaves the contract without owner. It will not be possible to call
549      * `onlyOwner` functions anymore. Can only be called by the current owner.
550      *
551      * NOTE: Renouncing ownership will leave the contract without an owner,
552      * thereby removing any functionality that is only available to the owner.
553      */
554     function renounceOwnership() public virtual onlyOwner {
555         emit OwnershipTransferred(_owner, address(0));
556         _owner = address(0);
557     }
558 
559     /**
560      * @dev Transfers ownership of the contract to a new account (`newOwner`).
561      * Can only be called by the current owner.
562      */
563     function transferOwnership(address newOwner) public virtual onlyOwner {
564         require(newOwner != address(0), "Ownable: new owner is the zero address");
565         emit OwnershipTransferred(_owner, newOwner);
566         _owner = newOwner;
567     }
568 }
569 
570 // 
571 /**
572  * @dev Contract module which allows children to implement an emergency stop
573  * mechanism that can be triggered by an authorized account.
574  *
575  * This module is used through inheritance. It will make available the
576  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
577  * the functions of your contract. Note that they will not be pausable by
578  * simply including this module, only once the modifiers are put in place.
579  */
580 abstract contract Pausable is Context {
581     /**
582      * @dev Emitted when the pause is triggered by `account`.
583      */
584     event Paused(address account);
585 
586     /**
587      * @dev Emitted when the pause is lifted by `account`.
588      */
589     event Unpaused(address account);
590 
591     bool private _paused;
592 
593     /**
594      * @dev Initializes the contract in unpaused state.
595      */
596     constructor () internal {
597         _paused = false;
598     }
599 
600     /**
601      * @dev Returns true if the contract is paused, and false otherwise.
602      */
603     function paused() public view virtual returns (bool) {
604         return _paused;
605     }
606 
607     /**
608      * @dev Modifier to make a function callable only when the contract is not paused.
609      *
610      * Requirements:
611      *
612      * - The contract must not be paused.
613      */
614     modifier whenNotPaused() {
615         require(!paused(), "Pausable: paused");
616         _;
617     }
618 
619     /**
620      * @dev Modifier to make a function callable only when the contract is paused.
621      *
622      * Requirements:
623      *
624      * - The contract must be paused.
625      */
626     modifier whenPaused() {
627         require(paused(), "Pausable: not paused");
628         _;
629     }
630 
631     /**
632      * @dev Triggers stopped state.
633      *
634      * Requirements:
635      *
636      * - The contract must not be paused.
637      */
638     function _pause() internal virtual whenNotPaused {
639         _paused = true;
640         emit Paused(_msgSender());
641     }
642 
643     /**
644      * @dev Returns to normal state.
645      *
646      * Requirements:
647      *
648      * - The contract must be paused.
649      */
650     function _unpause() internal virtual whenPaused {
651         _paused = false;
652         emit Unpaused(_msgSender());
653     }
654 }
655 
656 /**
657  * @dev Implementation of the {IERC20} interface.
658  *
659  * This implementation is agnostic to the way tokens are created. This means
660  * that a supply mechanism has to be added in a derived contract using {_mint}.
661  * For a generic mechanism see {ERC20PresetMinterPauser}.
662  *
663  * TIP: For a detailed writeup see our guide
664  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
665  * to implement supply mechanisms].
666  *
667  * We have followed general OpenZeppelin guidelines: functions revert instead
668  * of returning `false` on failure. This behavior is nonetheless conventional
669  * and does not conflict with the expectations of ERC20 applications.
670  *
671  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
672  * This allows applications to reconstruct the allowance for all accounts just
673  * by listening to said events. Other implementations of the EIP may not emit
674  * these events, as it isn't required by the specification.
675  *
676  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
677  * functions have been added to mitigate the well-known issues around setting
678  * allowances. See {IERC20-approve}.
679  */
680 contract BEP20 is Context, IERC20, Pausable {
681     using SafeMath for uint256;
682     using Address for address;
683 
684     mapping (address => uint256) private _balances;
685 
686     mapping (address => mapping (address => uint256)) private _allowances;
687 
688     uint256 private _totalSupply;
689 
690     string private _name;
691     string private _symbol;
692     uint8 private _decimals;
693     
694     /// @notice A record of each accounts delegate
695     mapping (address => address) public delegates;
696 
697     /// @notice A checkpoint for marking number of votes from a given block
698     struct Checkpoint {
699         uint32 fromBlock;
700         uint256 votes;
701     }
702 
703     /// @notice A record of votes checkpoints for each account, by index
704     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
705 
706     /// @notice The number of checkpoints for each account
707     mapping (address => uint32) public numCheckpoints;
708 
709     /// @notice The EIP-712 typehash for the contract's domain
710     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
711 
712     /// @notice The EIP-712 typehash for the delegation struct used by the contract
713     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
714 
715     /// @notice A record of states for signing / validating signatures
716     mapping (address => uint) public nonces;
717 
718     /// @notice An event thats emitted when an account changes its delegate
719     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
720 
721     /// @notice An event thats emitted when a delegate account's vote balance changes
722     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
723 
724     /**
725      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
726      * a default value of 18.
727      *
728      * To select a different value for {decimals}, use {_setupDecimals}.
729      *
730      * All three of these values are immutable: they can only be set once during
731      * construction.
732      */
733     constructor (string memory name, string memory symbol) public {
734         _name = name;
735         _symbol = symbol;
736         _decimals = 18;
737     }
738 
739     /**
740      * @dev Returns the name of the token.
741      */
742     function name() public view returns (string memory) {
743         return _name;
744     }
745 
746     /**
747      * @dev Returns the symbol of the token, usually a shorter version of the
748      * name.
749      */
750     function symbol() public view returns (string memory) {
751         return _symbol;
752     }
753 
754     /**
755      * @dev Returns the number of decimals used to get its user representation.
756      * For example, if `decimals` equals `2`, a balance of `505` tokens should
757      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
758      *
759      * Tokens usually opt for a value of 18, imitating the relationship between
760      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
761      * called.
762      *
763      * NOTE: This information is only used for _display_ purposes: it in
764      * no way affects any of the arithmetic of the contract, including
765      * {IERC20-balanceOf} and {IERC20-transfer}.
766      */
767     function decimals() public view returns (uint8) {
768         return _decimals;
769     }
770 
771     /**
772      * @dev See {IERC20-totalSupply}.
773      */
774     function totalSupply() public view override returns (uint256) {
775         return _totalSupply;
776     }
777 
778     /**
779      * @dev See {IERC20-balanceOf}.
780      */
781     function balanceOf(address account) public view override returns (uint256) {
782         return _balances[account];
783     }
784 
785     /**
786      * @dev See {IERC20-transfer}.
787      *
788      * Requirements:
789      *
790      * - `recipient` cannot be the zero address.
791      * - the caller must have a balance of at least `amount`.
792      */
793     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
794         _transfer(_msgSender(), recipient, amount);
795         return true;
796     }
797 
798     /**
799      * @dev See {IERC20-allowance}.
800      */
801     function allowance(address owner, address spender) public view virtual override returns (uint256) {
802         return _allowances[owner][spender];
803     }
804 
805     /**
806      * @dev See {IERC20-approve}.
807      *
808      * Requirements:
809      *
810      * - `spender` cannot be the zero address.
811      */
812     function approve(address spender, uint256 amount) public virtual override returns (bool) {
813         _approve(_msgSender(), spender, amount);
814         return true;
815     }
816 
817     /**
818      * @dev See {IERC20-transferFrom}.
819      *
820      * Emits an {Approval} event indicating the updated allowance. This is not
821      * required by the EIP. See the note at the beginning of {ERC20};
822      *
823      * Requirements:
824      * - `sender` and `recipient` cannot be the zero address.
825      * - `sender` must have a balance of at least `amount`.
826      * - the caller must have allowance for ``sender``'s tokens of at least
827      * `amount`.
828      */
829     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
830         _transfer(sender, recipient, amount);
831         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
832         return true;
833     }
834 
835     /**
836      * @dev Atomically increases the allowance granted to `spender` by the caller.
837      *
838      * This is an alternative to {approve} that can be used as a mitigation for
839      * problems described in {IERC20-approve}.
840      *
841      * Emits an {Approval} event indicating the updated allowance.
842      *
843      * Requirements:
844      *
845      * - `spender` cannot be the zero address.
846      */
847     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
848         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
849         return true;
850     }
851 
852     /**
853      * @dev Atomically decreases the allowance granted to `spender` by the caller.
854      *
855      * This is an alternative to {approve} that can be used as a mitigation for
856      * problems described in {IERC20-approve}.
857      *
858      * Emits an {Approval} event indicating the updated allowance.
859      *
860      * Requirements:
861      *
862      * - `spender` cannot be the zero address.
863      * - `spender` must have allowance for the caller of at least
864      * `subtractedValue`.
865      */
866     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
867         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
868         return true;
869     }
870 
871     /**
872      * @dev Moves tokens `amount` from `sender` to `recipient`.
873      *
874      * This is internal function is equivalent to {transfer}, and can be used to
875      * e.g. implement automatic token fees, slashing mechanisms, etc.
876      *
877      * Emits a {Transfer} event.
878      *
879      * Requirements:
880      *
881      * - `sender` cannot be the zero address.
882      * - `recipient` cannot be the zero address.
883      * - `sender` must have a balance of at least `amount`.
884      */
885     function _transfer(address sender, address recipient, uint256 amount) internal virtual whenPaused {
886         require(sender != address(0), "ERC20: transfer from the zero address");
887         require(recipient != address(0), "ERC20: transfer to the zero address");
888 
889         _beforeTokenTransfer(sender, recipient, amount);
890 
891         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
892         _balances[recipient] = _balances[recipient].add(amount);
893         emit Transfer(sender, recipient, amount);
894         
895         _moveDelegates(delegates[sender], delegates[recipient], amount);
896     }
897 
898     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
899      * the total supply.
900      *
901      * Emits a {Transfer} event with `from` set to the zero address.
902      *
903      * Requirements
904      *
905      * - `to` cannot be the zero address.
906      */
907     function _mint(address account, uint256 amount) internal virtual {
908         require(account != address(0), "ERC20: mint to the zero address");
909 
910         _beforeTokenTransfer(address(0), account, amount);
911 
912         _totalSupply = _totalSupply.add(amount);
913         _balances[account] = _balances[account].add(amount);
914         emit Transfer(address(0), account, amount);
915         
916         _moveDelegates(address(0), delegates[account], amount);
917     }
918 
919     /**
920      * @dev Destroys `amount` tokens from `account`, reducing the
921      * total supply.
922      *
923      * Emits a {Transfer} event with `to` set to the zero address.
924      *
925      * Requirements
926      *
927      * - `account` cannot be the zero address.
928      * - `account` must have at least `amount` tokens.
929      */
930     function _burn(address account, uint256 amount) internal virtual {
931         require(account != address(0), "ERC20: burn from the zero address");
932 
933         _beforeTokenTransfer(account, address(0), amount);
934 
935         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
936         _totalSupply = _totalSupply.sub(amount);
937         emit Transfer(account, address(0), amount);
938     }
939 
940     /**
941      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
942      *
943      * This is internal function is equivalent to `approve`, and can be used to
944      * e.g. set automatic allowances for certain subsystems, etc.
945      *
946      * Emits an {Approval} event.
947      *
948      * Requirements:
949      *
950      * - `owner` cannot be the zero address.
951      * - `spender` cannot be the zero address.
952      */
953     function _approve(address owner, address spender, uint256 amount) internal virtual {
954         require(owner != address(0), "ERC20: approve from the zero address");
955         require(spender != address(0), "ERC20: approve to the zero address");
956 
957         _allowances[owner][spender] = amount;
958         emit Approval(owner, spender, amount);
959     }
960 
961     /**
962      * @dev Sets {decimals} to a value other than the default one of 18.
963      *
964      * WARNING: This function should only be called from the constructor. Most
965      * applications that interact with token contracts will not expect
966      * {decimals} to ever change, and may work incorrectly if it does.
967      */
968     function _setupDecimals(uint8 decimals_) internal {
969         _decimals = decimals_;
970     }
971 
972     /**
973      * @dev Hook that is called before any transfer of tokens. This includes
974      * minting and burning.
975      *
976      * Calling conditions:
977      *
978      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
979      * will be to transferred to `to`.
980      * - when `from` is zero, `amount` tokens will be minted for `to`.
981      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
982      * - `from` and `to` are never both zero.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
987 
988     /**
989      * @notice Delegate votes from `msg.sender` to `delegatee`
990      * @param delegatee The address to delegate votes to
991      */
992     function delegate(address delegatee) external {
993         return _delegate(msg.sender, delegatee);
994     }
995     
996     /**
997      * @notice Delegates votes from signatory to `delegatee`
998      * @param delegatee The address to delegate votes to
999      * @param nonce The contract state required to match the signature
1000      * @param expiry The time at which to expire the signature
1001      * @param v The recovery byte of the signature
1002      * @param r Half of the ECDSA signature pair
1003      * @param s Half of the ECDSA signature pair
1004      */
1005     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
1006         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this)));
1007         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
1008         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1009         address signatory = ecrecover(digest, v, r, s);
1010         require(signatory != address(0), "xVemp::delegateBySig: invalid signature");
1011         require(nonce == nonces[signatory]++, "xVemp::delegateBySig: invalid nonce");
1012         require(now <= expiry, "xVemp::delegateBySig: signature expired");
1013         return _delegate(signatory, delegatee);
1014     }
1015 
1016     /**
1017      * @notice Gets the current votes balance for `account`
1018      * @param account The address to get votes balance
1019      * @return The number of current votes for `account`
1020      */
1021     function getCurrentVotes(address account) external view returns (uint256) {
1022         uint32 nCheckpoints = numCheckpoints[account];
1023         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1024     }
1025 
1026     /**
1027      * @notice Determine the prior number of votes for an account as of a block number
1028      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1029      * @param account The address of the account to check
1030      * @param blockNumber The block number to get the vote balance at
1031      * @return The number of votes the account had as of the given block
1032      */
1033     function getPriorVotes(address account, uint blockNumber) public view returns (uint256) {
1034         require(blockNumber < block.number, "xVemp::getPriorVotes: not yet determined");
1035 
1036         uint32 nCheckpoints = numCheckpoints[account];
1037         if (nCheckpoints == 0) {
1038             return 0;
1039         }
1040 
1041         // First check most recent balance
1042         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1043             return checkpoints[account][nCheckpoints - 1].votes;
1044         }
1045 
1046         // Next check implicit zero balance
1047         if (checkpoints[account][0].fromBlock > blockNumber) {
1048             return 0;
1049         }
1050 
1051         uint32 lower = 0;
1052         uint32 upper = nCheckpoints - 1;
1053         while (upper > lower) {
1054             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1055             Checkpoint memory cp = checkpoints[account][center];
1056             if (cp.fromBlock == blockNumber) {
1057                 return cp.votes;
1058             } else if (cp.fromBlock < blockNumber) {
1059                 lower = center;
1060             } else {
1061                 upper = center - 1;
1062             }
1063         }
1064         return checkpoints[account][lower].votes;
1065     }
1066 
1067     function _delegate(address delegator, address delegatee) internal {
1068         address currentDelegate = delegates[delegator];
1069         uint256 delegatorBalance = uint256(_balances[delegator]);
1070         delegates[delegator] = delegatee;
1071 
1072         emit DelegateChanged(delegator, currentDelegate, delegatee);
1073 
1074         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1075     }
1076     
1077     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1078         if (srcRep != dstRep && amount > 0) {
1079             if (srcRep != address(0)) {
1080                 uint32 srcRepNum = numCheckpoints[srcRep];
1081                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1082                 uint256 srcRepNew = sub96(srcRepOld, amount, "xVemp::_moveVotes: vote amount underflows");
1083                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1084             }
1085 
1086             if (dstRep != address(0)) {
1087                 uint32 dstRepNum = numCheckpoints[dstRep];
1088                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1089                 uint256 dstRepNew = add96(dstRepOld, amount, "xVemp::_moveVotes: vote amount overflows");
1090                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1091             }
1092         }
1093     }
1094 
1095     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
1096       uint32 blockNumber = safe32(block.number, "xVemp::_writeCheckpoint: block number exceeds 32 bits");
1097 
1098       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1099           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1100       } else {
1101           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1102           numCheckpoints[delegatee] = nCheckpoints + 1;
1103       }
1104 
1105       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1106     }
1107 
1108     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1109         require(n < 2**32, errorMessage);
1110         return uint32(n);
1111     }
1112 
1113     function safe96(uint n, string memory errorMessage) internal pure returns (uint256) {
1114         require(n < 2**96, errorMessage);
1115         return uint256(n);
1116     }
1117 
1118     function add96(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1119         uint256 c = a + b;
1120         require(c >= a, errorMessage);
1121         return c;
1122     }
1123 
1124     function sub96(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1125         require(b <= a, errorMessage);
1126         return a - b;
1127     }
1128 
1129     function getChainId() internal pure returns (uint) {
1130         uint256 chainId;
1131         assembly { chainId := chainid() }
1132         return chainId;
1133     }
1134 
1135     function _updatePauseStatus() internal {
1136         if (paused()) {
1137             _unpause();
1138         } else {
1139             _pause();
1140         }
1141     }
1142 }
1143 
1144 /**
1145  * @title Roles
1146  * @dev Library for managing addresses assigned to a Role.
1147  */
1148 library Roles {
1149     struct Role {
1150         mapping (address => bool) bearer;
1151     }
1152 
1153     /**
1154      * @dev Give an account access to this role.
1155      */
1156     function add(Role storage role, address[] memory account) internal {
1157         for(uint256 i=0; i<account.length; i++) {
1158             require(!has(role, account[i]), "Roles: account already has role");
1159             role.bearer[account[i]] = true;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Remove an account's access to this role.
1165      */
1166     function remove(Role storage role, address account) internal {
1167         require(has(role, account), "Roles: account does not have role");
1168         role.bearer[account] = false;
1169     }
1170 
1171     /**
1172      * @dev Check if an account has this role.
1173      * @return bool
1174      */
1175     function has(Role storage role, address account) internal view returns (bool) {
1176         require(account != address(0), "Roles: account is the zero address");
1177         return role.bearer[account];
1178     }
1179 }
1180 
1181 contract MinterRole is Context, Ownable {
1182     using Roles for Roles.Role;
1183 
1184     event MinterAdded(address[] account);
1185     event MinterRemoved(address indexed account);
1186 
1187     Roles.Role private _minters;
1188 
1189     constructor () internal {
1190         address[] memory admins = new address[](1);
1191         admins[0] = _msgSender();
1192         _addMinter(admins);
1193     }
1194 
1195     modifier onlyMinter() {
1196         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1197         _;
1198     }
1199 
1200     function isMinter(address account) public view returns (bool) {
1201         return _minters.has(account);
1202     }
1203 
1204     function addMinter(address[] memory account) public onlyMinter {
1205         _addMinter(account);
1206     }
1207     
1208     function removeMinter(address account) public onlyOwner {
1209         _removeMinter(account);
1210     }
1211 
1212     function renounceMinter() public {
1213         _removeMinter(_msgSender());
1214     }
1215 
1216     function _addMinter(address[] memory account) internal {
1217         _minters.add(account);
1218         emit MinterAdded(account);
1219     }
1220 
1221     function _removeMinter(address account) internal {
1222         _minters.remove(account);
1223         emit MinterRemoved(account);
1224     }
1225 }
1226 
1227 /**
1228  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1229  * which have permission to mint (create) new tokens as they see fit.
1230  *
1231  * At construction, the deployer of the contract is the only minter.
1232  */
1233 abstract contract BEP20Mintable is BEP20, MinterRole {
1234     /**
1235      * @dev See {ERC20-_mint}.
1236      *
1237      * Requirements:
1238      *
1239      * - the caller must have the {MinterRole}.
1240      */
1241     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1242         _mint(account, amount);
1243         return true;
1244     }
1245 }
1246 
1247 /**
1248  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1249  * tokens and those that they have an allowance for, in a way that can be
1250  * recognized off-chain (via event analysis).
1251  */
1252 abstract contract BEP20Burnable is Context, BEP20 {
1253     /**
1254      * @dev Destroys `amount` tokens from the caller.
1255      *
1256      * See {ERC20-_burn}.
1257      */
1258     function burn(uint256 amount) public virtual {
1259         _burn(_msgSender(), amount);
1260     }
1261 
1262     /**
1263      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1264      * allowance.
1265      *
1266      * See {ERC20-_burn} and {ERC20-allowance}.
1267      *
1268      * Requirements:
1269      *
1270      * - the caller must have allowance for ``accounts``'s tokens of at least
1271      * `amount`.
1272      */
1273     function burnFrom(address account, uint256 amount) public virtual {
1274         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "BEP20: burn amount exceeds allowance");
1275 
1276         _approve(account, _msgSender(), decreasedAllowance);
1277         _burn(account, amount);
1278     }
1279 }
1280 
1281 contract xVEMPBEP20Token is BEP20, BEP20Mintable, BEP20Burnable {
1282     constructor(string memory tokenName, string memory tokenSymbol)
1283     BEP20(tokenName, tokenSymbol)
1284     public
1285     { }
1286 
1287     function updatePauseStatus() public onlyOwner {
1288         _updatePauseStatus();
1289     }
1290 }