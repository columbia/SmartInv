1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-20
3 */
4 
5 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
6 
7 
8 pragma solidity ^0.6.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin\contracts\utils\Pausable.sol
32 
33 
34 pragma solidity ^0.6.0;
35 
36 
37 /**
38  * @dev Contract module which allows children to implement an emergency stop
39  * mechanism that can be triggered by an authorized account.
40  *
41  * This module is used through inheritance. It will make available the
42  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
43  * the functions of your contract. Note that they will not be pausable by
44  * simply including this module, only once the modifiers are put in place.
45  */
46 contract Pausable is Context {
47     /**
48      * @dev Emitted when the pause is triggered by `account`.
49      */
50     event Paused(address account);
51 
52     /**
53      * @dev Emitted when the pause is lifted by `account`.
54      */
55     event Unpaused(address account);
56 
57     bool private _paused;
58 
59     /**
60      * @dev Initializes the contract in unpaused state.
61      */
62     constructor () internal {
63         _paused = false;
64     }
65 
66     /**
67      * @dev Returns true if the contract is paused, and false otherwise.
68      */
69     function paused() public view returns (bool) {
70         return _paused;
71     }
72 
73     /**
74      * @dev Modifier to make a function callable only when the contract is not paused.
75      *
76      * Requirements:
77      *
78      * - The contract must not be paused.
79      */
80     modifier whenNotPaused() {
81         require(!_paused, "Pausable: paused");
82         _;
83     }
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is paused.
87      *
88      * Requirements:
89      *
90      * - The contract must be paused.
91      */
92     modifier whenPaused() {
93         require(_paused, "Pausable: not paused");
94         _;
95     }
96 
97     /**
98      * @dev Triggers stopped state.
99      *
100      * Requirements:
101      *
102      * - The contract must not be paused.
103      */
104     function _pause() internal virtual whenNotPaused {
105         _paused = true;
106         emit Paused(_msgSender());
107     }
108 
109     /**
110      * @dev Returns to normal state.
111      *
112      * Requirements:
113      *
114      * - The contract must be paused.
115      */
116     function _unpause() internal virtual whenPaused {
117         _paused = false;
118         emit Unpaused(_msgSender());
119     }
120 }
121 
122 // File: @openzeppelin\contracts\access\Ownable.sol
123 
124 
125 pragma solidity ^0.6.0;
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor () internal {
148         address msgSender = _msgSender();
149         _owner = msgSender;
150         emit OwnershipTransferred(address(0), msgSender);
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(_owner == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(newOwner != address(0), "Ownable: new owner is the zero address");
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
192 
193 
194 pragma solidity ^0.6.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP.
198  */
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
271 
272 
273 pragma solidity ^0.6.0;
274 
275 /**
276  * @dev Wrappers over Solidity's arithmetic operations with added overflow
277  * checks.
278  *
279  * Arithmetic operations in Solidity wrap on overflow. This can easily result
280  * in bugs, because programmers usually assume that an overflow raises an
281  * error, which is the standard behavior in high level programming languages.
282  * `SafeMath` restores this intuition by reverting the transaction when an
283  * operation overflows.
284  *
285  * Using this library instead of the unchecked operations eliminates an entire
286  * class of bugs, so it's recommended to use it always.
287  */
288 library SafeMath {
289     /**
290      * @dev Returns the addition of two unsigned integers, reverting on
291      * overflow.
292      *
293      * Counterpart to Solidity's `+` operator.
294      *
295      * Requirements:
296      *
297      * - Addition cannot overflow.
298      */
299     function add(uint256 a, uint256 b) internal pure returns (uint256) {
300         uint256 c = a + b;
301         require(c >= a, "SafeMath: addition overflow");
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the subtraction of two unsigned integers, reverting on
308      * overflow (when the result is negative).
309      *
310      * Counterpart to Solidity's `-` operator.
311      *
312      * Requirements:
313      *
314      * - Subtraction cannot overflow.
315      */
316     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
317         return sub(a, b, "SafeMath: subtraction overflow");
318     }
319 
320     /**
321      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
322      * overflow (when the result is negative).
323      *
324      * Counterpart to Solidity's `-` operator.
325      *
326      * Requirements:
327      *
328      * - Subtraction cannot overflow.
329      */
330     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         require(b <= a, errorMessage);
332         uint256 c = a - b;
333 
334         return c;
335     }
336 
337     /**
338      * @dev Returns the multiplication of two unsigned integers, reverting on
339      * overflow.
340      *
341      * Counterpart to Solidity's `*` operator.
342      *
343      * Requirements:
344      *
345      * - Multiplication cannot overflow.
346      */
347     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
348         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
349         // benefit is lost if 'b' is also tested.
350         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
351         if (a == 0) {
352             return 0;
353         }
354 
355         uint256 c = a * b;
356         require(c / a == b, "SafeMath: multiplication overflow");
357 
358         return c;
359     }
360 
361     /**
362      * @dev Returns the integer division of two unsigned integers. Reverts on
363      * division by zero. The result is rounded towards zero.
364      *
365      * Counterpart to Solidity's `/` operator. Note: this function uses a
366      * `revert` opcode (which leaves remaining gas untouched) while Solidity
367      * uses an invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function div(uint256 a, uint256 b) internal pure returns (uint256) {
374         return div(a, b, "SafeMath: division by zero");
375     }
376 
377     /**
378      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
379      * division by zero. The result is rounded towards zero.
380      *
381      * Counterpart to Solidity's `/` operator. Note: this function uses a
382      * `revert` opcode (which leaves remaining gas untouched) while Solidity
383      * uses an invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      *
387      * - The divisor cannot be zero.
388      */
389     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
390         require(b > 0, errorMessage);
391         uint256 c = a / b;
392         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
393 
394         return c;
395     }
396 
397     /**
398      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
399      * Reverts when dividing by zero.
400      *
401      * Counterpart to Solidity's `%` operator. This function uses a `revert`
402      * opcode (which leaves remaining gas untouched) while Solidity uses an
403      * invalid opcode to revert (consuming all remaining gas).
404      *
405      * Requirements:
406      *
407      * - The divisor cannot be zero.
408      */
409     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
410         return mod(a, b, "SafeMath: modulo by zero");
411     }
412 
413     /**
414      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
415      * Reverts with custom message when dividing by zero.
416      *
417      * Counterpart to Solidity's `%` operator. This function uses a `revert`
418      * opcode (which leaves remaining gas untouched) while Solidity uses an
419      * invalid opcode to revert (consuming all remaining gas).
420      *
421      * Requirements:
422      *
423      * - The divisor cannot be zero.
424      */
425     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
426         require(b != 0, errorMessage);
427         return a % b;
428     }
429 }
430 
431 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
432 
433 
434 pragma solidity ^0.6.2;
435 
436 /**
437  * @dev Collection of functions related to the address type
438  */
439 library Address {
440     /**
441      * @dev Returns true if `account` is a contract.
442      *
443      * [IMPORTANT]
444      * ====
445      * It is unsafe to assume that an address for which this function returns
446      * false is an externally-owned account (EOA) and not a contract.
447      *
448      * Among others, `isContract` will return false for the following
449      * types of addresses:
450      *
451      *  - an externally-owned account
452      *  - a contract in construction
453      *  - an address where a contract will be created
454      *  - an address where a contract lived, but was destroyed
455      * ====
456      */
457     function isContract(address account) internal view returns (bool) {
458         // This method relies in extcodesize, which returns 0 for contracts in
459         // construction, since the code is only stored at the end of the
460         // constructor execution.
461 
462         uint256 size;
463         // solhint-disable-next-line no-inline-assembly
464         assembly { size := extcodesize(account) }
465         return size > 0;
466     }
467 
468     /**
469      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
470      * `recipient`, forwarding all available gas and reverting on errors.
471      *
472      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
473      * of certain opcodes, possibly making contracts go over the 2300 gas limit
474      * imposed by `transfer`, making them unable to receive funds via
475      * `transfer`. {sendValue} removes this limitation.
476      *
477      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
478      *
479      * IMPORTANT: because control is transferred to `recipient`, care must be
480      * taken to not create reentrancy vulnerabilities. Consider using
481      * {ReentrancyGuard} or the
482      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
483      */
484     function sendValue(address payable recipient, uint256 amount) internal {
485         require(address(this).balance >= amount, "Address: insufficient balance");
486 
487         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
488         (bool success, ) = recipient.call{ value: amount }("");
489         require(success, "Address: unable to send value, recipient may have reverted");
490     }
491 
492     /**
493      * @dev Performs a Solidity function call using a low level `call`. A
494      * plain`call` is an unsafe replacement for a function call: use this
495      * function instead.
496      *
497      * If `target` reverts with a revert reason, it is bubbled up by this
498      * function (like regular Solidity function calls).
499      *
500      * Returns the raw returned data. To convert to the expected return value,
501      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
502      *
503      * Requirements:
504      *
505      * - `target` must be a contract.
506      * - calling `target` with `data` must not revert.
507      *
508      * _Available since v3.1._
509      */
510     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
511       return functionCall(target, data, "Address: low-level call failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
516      * `errorMessage` as a fallback revert reason when `target` reverts.
517      *
518      * _Available since v3.1._
519      */
520     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
521         return _functionCallWithValue(target, data, 0, errorMessage);
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
526      * but also transferring `value` wei to `target`.
527      *
528      * Requirements:
529      *
530      * - the calling contract must have an ETH balance of at least `value`.
531      * - the called Solidity function must be `payable`.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
536         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
541      * with `errorMessage` as a fallback revert reason when `target` reverts.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
546         require(address(this).balance >= value, "Address: insufficient balance for call");
547         return _functionCallWithValue(target, data, value, errorMessage);
548     }
549 
550     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
551         require(isContract(target), "Address: call to non-contract");
552 
553         // solhint-disable-next-line avoid-low-level-calls
554         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
555         if (success) {
556             return returndata;
557         } else {
558             // Look for revert reason and bubble it up if present
559             if (returndata.length > 0) {
560                 // The easiest way to bubble the revert reason is using memory via assembly
561 
562                 // solhint-disable-next-line no-inline-assembly
563                 assembly {
564                     let returndata_size := mload(returndata)
565                     revert(add(32, returndata), returndata_size)
566                 }
567             } else {
568                 revert(errorMessage);
569             }
570         }
571     }
572 }
573 
574 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
575 
576 
577 pragma solidity ^0.6.0;
578 
579 
580 
581 
582 
583 /**
584  * @dev Implementation of the {IERC20} interface.
585  *
586  * This implementation is agnostic to the way tokens are created. This means
587  * that a supply mechanism has to be added in a derived contract using {_mint}.
588  * For a generic mechanism see {ERC20PresetMinterPauser}.
589  *
590  * TIP: For a detailed writeup see our guide
591  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
592  * to implement supply mechanisms].
593  *
594  * We have followed general OpenZeppelin guidelines: functions revert instead
595  * of returning `false` on failure. This behavior is nonetheless conventional
596  * and does not conflict with the expectations of ERC20 applications.
597  *
598  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
599  * This allows applications to reconstruct the allowance for all accounts just
600  * by listening to said events. Other implementations of the EIP may not emit
601  * these events, as it isn't required by the specification.
602  *
603  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
604  * functions have been added to mitigate the well-known issues around setting
605  * allowances. See {IERC20-approve}.
606  */
607 contract ERC20 is Context, IERC20 {
608     using SafeMath for uint256;
609     using Address for address;
610 
611     mapping (address => uint256) private _balances;
612 
613     mapping (address => mapping (address => uint256)) private _allowances;
614 
615     uint256 private _totalSupply;
616 
617     string private _name;
618     string private _symbol;
619     uint8 private _decimals;
620 
621     /**
622      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
623      * a default value of 18.
624      *
625      * To select a different value for {decimals}, use {_setupDecimals}.
626      *
627      * All three of these values are immutable: they can only be set once during
628      * construction.
629      */
630     constructor (string memory name, string memory symbol) public {
631         _name = name;
632         _symbol = symbol;
633         _decimals = 18;
634     }
635 
636     /**
637      * @dev Returns the name of the token.
638      */
639     function name() public view returns (string memory) {
640         return _name;
641     }
642 
643     /**
644      * @dev Returns the symbol of the token, usually a shorter version of the
645      * name.
646      */
647     function symbol() public view returns (string memory) {
648         return _symbol;
649     }
650 
651     /**
652      * @dev Returns the number of decimals used to get its user representation.
653      * For example, if `decimals` equals `2`, a balance of `505` tokens should
654      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
655      *
656      * Tokens usually opt for a value of 18, imitating the relationship between
657      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
658      * called.
659      *
660      * NOTE: This information is only used for _display_ purposes: it in
661      * no way affects any of the arithmetic of the contract, including
662      * {IERC20-balanceOf} and {IERC20-transfer}.
663      */
664     function decimals() public view returns (uint8) {
665         return _decimals;
666     }
667 
668     /**
669      * @dev See {IERC20-totalSupply}.
670      */
671     function totalSupply() public view override returns (uint256) {
672         return _totalSupply;
673     }
674 
675     /**
676      * @dev See {IERC20-balanceOf}.
677      */
678     function balanceOf(address account) public view override returns (uint256) {
679         return _balances[account];
680     }
681 
682     /**
683      * @dev See {IERC20-transfer}.
684      *
685      * Requirements:
686      *
687      * - `recipient` cannot be the zero address.
688      * - the caller must have a balance of at least `amount`.
689      */
690     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
691         _transfer(_msgSender(), recipient, amount);
692         return true;
693     }
694 
695     /**
696      * @dev See {IERC20-allowance}.
697      */
698     function allowance(address owner, address spender) public view virtual override returns (uint256) {
699         return _allowances[owner][spender];
700     }
701 
702     /**
703      * @dev See {IERC20-approve}.
704      *
705      * Requirements:
706      *
707      * - `spender` cannot be the zero address.
708      */
709     function approve(address spender, uint256 amount) public virtual override returns (bool) {
710         _approve(_msgSender(), spender, amount);
711         return true;
712     }
713 
714     /**
715      * @dev See {IERC20-transferFrom}.
716      *
717      * Emits an {Approval} event indicating the updated allowance. This is not
718      * required by the EIP. See the note at the beginning of {ERC20};
719      *
720      * Requirements:
721      * - `sender` and `recipient` cannot be the zero address.
722      * - `sender` must have a balance of at least `amount`.
723      * - the caller must have allowance for ``sender``'s tokens of at least
724      * `amount`.
725      */
726     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
727         _transfer(sender, recipient, amount);
728         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
729         return true;
730     }
731 
732     /**
733      * @dev Atomically increases the allowance granted to `spender` by the caller.
734      *
735      * This is an alternative to {approve} that can be used as a mitigation for
736      * problems described in {IERC20-approve}.
737      *
738      * Emits an {Approval} event indicating the updated allowance.
739      *
740      * Requirements:
741      *
742      * - `spender` cannot be the zero address.
743      */
744     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
745         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
746         return true;
747     }
748 
749     /**
750      * @dev Atomically decreases the allowance granted to `spender` by the caller.
751      *
752      * This is an alternative to {approve} that can be used as a mitigation for
753      * problems described in {IERC20-approve}.
754      *
755      * Emits an {Approval} event indicating the updated allowance.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      * - `spender` must have allowance for the caller of at least
761      * `subtractedValue`.
762      */
763     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
764         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
765         return true;
766     }
767 
768     /**
769      * @dev Moves tokens `amount` from `sender` to `recipient`.
770      *
771      * This is internal function is equivalent to {transfer}, and can be used to
772      * e.g. implement automatic token fees, slashing mechanisms, etc.
773      *
774      * Emits a {Transfer} event.
775      *
776      * Requirements:
777      *
778      * - `sender` cannot be the zero address.
779      * - `recipient` cannot be the zero address.
780      * - `sender` must have a balance of at least `amount`.
781      */
782     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
783         require(sender != address(0), "ERC20: transfer from the zero address");
784         require(recipient != address(0), "ERC20: transfer to the zero address");
785 
786         _beforeTokenTransfer(sender, recipient, amount);
787 
788         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
789         _balances[recipient] = _balances[recipient].add(amount);
790         emit Transfer(sender, recipient, amount);
791     }
792 
793     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
794      * the total supply.
795      *
796      * Emits a {Transfer} event with `from` set to the zero address.
797      *
798      * Requirements
799      *
800      * - `to` cannot be the zero address.
801      */
802     function _mint(address account, uint256 amount) internal virtual {
803         require(account != address(0), "ERC20: mint to the zero address");
804 
805         _beforeTokenTransfer(address(0), account, amount);
806 
807         _totalSupply = _totalSupply.add(amount);
808         _balances[account] = _balances[account].add(amount);
809         emit Transfer(address(0), account, amount);
810     }
811 
812     /**
813      * @dev Destroys `amount` tokens from `account`, reducing the
814      * total supply.
815      *
816      * Emits a {Transfer} event with `to` set to the zero address.
817      *
818      * Requirements
819      *
820      * - `account` cannot be the zero address.
821      * - `account` must have at least `amount` tokens.
822      */
823     function _burn(address account, uint256 amount) internal virtual {
824         require(account != address(0), "ERC20: burn from the zero address");
825 
826         _beforeTokenTransfer(account, address(0), amount);
827 
828         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
829         _totalSupply = _totalSupply.sub(amount);
830         emit Transfer(account, address(0), amount);
831     }
832 
833     /**
834      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
835      *
836      * This internal function is equivalent to `approve`, and can be used to
837      * e.g. set automatic allowances for certain subsystems, etc.
838      *
839      * Emits an {Approval} event.
840      *
841      * Requirements:
842      *
843      * - `owner` cannot be the zero address.
844      * - `spender` cannot be the zero address.
845      */
846     function _approve(address owner, address spender, uint256 amount) internal virtual {
847         require(owner != address(0), "ERC20: approve from the zero address");
848         require(spender != address(0), "ERC20: approve to the zero address");
849 
850         _allowances[owner][spender] = amount;
851         emit Approval(owner, spender, amount);
852     }
853 
854     /**
855      * @dev Sets {decimals} to a value other than the default one of 18.
856      *
857      * WARNING: This function should only be called from the constructor. Most
858      * applications that interact with token contracts will not expect
859      * {decimals} to ever change, and may work incorrectly if it does.
860      */
861     function _setupDecimals(uint8 decimals_) internal {
862         _decimals = decimals_;
863     }
864 
865     /**
866      * @dev Hook that is called before any transfer of tokens. This includes
867      * minting and burning.
868      *
869      * Calling conditions:
870      *
871      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
872      * will be to transferred to `to`.
873      * - when `from` is zero, `amount` tokens will be minted for `to`.
874      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
875      * - `from` and `to` are never both zero.
876      *
877      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
878      */
879     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
880 }
881 
882 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
883 
884 
885 pragma solidity ^0.6.0;
886 
887 /**
888  * @dev Library for managing
889  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
890  * types.
891  *
892  * Sets have the following properties:
893  *
894  * - Elements are added, removed, and checked for existence in constant time
895  * (O(1)).
896  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
897  *
898  * ```
899  * contract Example {
900  *     // Add the library methods
901  *     using EnumerableSet for EnumerableSet.AddressSet;
902  *
903  *     // Declare a set state variable
904  *     EnumerableSet.AddressSet private mySet;
905  * }
906  * ```
907  *
908  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
909  * (`UintSet`) are supported.
910  */
911 library EnumerableSet {
912     // To implement this library for multiple types with as little code
913     // repetition as possible, we write it in terms of a generic Set type with
914     // bytes32 values.
915     // The Set implementation uses private functions, and user-facing
916     // implementations (such as AddressSet) are just wrappers around the
917     // underlying Set.
918     // This means that we can only create new EnumerableSets for types that fit
919     // in bytes32.
920 
921     struct Set {
922         // Storage of set values
923         bytes32[] _values;
924 
925         // Position of the value in the `values` array, plus 1 because index 0
926         // means a value is not in the set.
927         mapping (bytes32 => uint256) _indexes;
928     }
929 
930     /**
931      * @dev Add a value to a set. O(1).
932      *
933      * Returns true if the value was added to the set, that is if it was not
934      * already present.
935      */
936     function _add(Set storage set, bytes32 value) private returns (bool) {
937         if (!_contains(set, value)) {
938             set._values.push(value);
939             // The value is stored at length-1, but we add 1 to all indexes
940             // and use 0 as a sentinel value
941             set._indexes[value] = set._values.length;
942             return true;
943         } else {
944             return false;
945         }
946     }
947 
948     /**
949      * @dev Removes a value from a set. O(1).
950      *
951      * Returns true if the value was removed from the set, that is if it was
952      * present.
953      */
954     function _remove(Set storage set, bytes32 value) private returns (bool) {
955         // We read and store the value's index to prevent multiple reads from the same storage slot
956         uint256 valueIndex = set._indexes[value];
957 
958         if (valueIndex != 0) { // Equivalent to contains(set, value)
959             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
960             // the array, and then remove the last element (sometimes called as 'swap and pop').
961             // This modifies the order of the array, as noted in {at}.
962 
963             uint256 toDeleteIndex = valueIndex - 1;
964             uint256 lastIndex = set._values.length - 1;
965 
966             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
967             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
968 
969             bytes32 lastvalue = set._values[lastIndex];
970 
971             // Move the last value to the index where the value to delete is
972             set._values[toDeleteIndex] = lastvalue;
973             // Update the index for the moved value
974             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
975 
976             // Delete the slot where the moved value was stored
977             set._values.pop();
978 
979             // Delete the index for the deleted slot
980             delete set._indexes[value];
981 
982             return true;
983         } else {
984             return false;
985         }
986     }
987 
988     /**
989      * @dev Returns true if the value is in the set. O(1).
990      */
991     function _contains(Set storage set, bytes32 value) private view returns (bool) {
992         return set._indexes[value] != 0;
993     }
994 
995     /**
996      * @dev Returns the number of values on the set. O(1).
997      */
998     function _length(Set storage set) private view returns (uint256) {
999         return set._values.length;
1000     }
1001 
1002    /**
1003     * @dev Returns the value stored at position `index` in the set. O(1).
1004     *
1005     * Note that there are no guarantees on the ordering of values inside the
1006     * array, and it may change when more values are added or removed.
1007     *
1008     * Requirements:
1009     *
1010     * - `index` must be strictly less than {length}.
1011     */
1012     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1013         require(set._values.length > index, "EnumerableSet: index out of bounds");
1014         return set._values[index];
1015     }
1016 
1017     // AddressSet
1018 
1019     struct AddressSet {
1020         Set _inner;
1021     }
1022 
1023     /**
1024      * @dev Add a value to a set. O(1).
1025      *
1026      * Returns true if the value was added to the set, that is if it was not
1027      * already present.
1028      */
1029     function add(AddressSet storage set, address value) internal returns (bool) {
1030         return _add(set._inner, bytes32(uint256(value)));
1031     }
1032 
1033     /**
1034      * @dev Removes a value from a set. O(1).
1035      *
1036      * Returns true if the value was removed from the set, that is if it was
1037      * present.
1038      */
1039     function remove(AddressSet storage set, address value) internal returns (bool) {
1040         return _remove(set._inner, bytes32(uint256(value)));
1041     }
1042 
1043     /**
1044      * @dev Returns true if the value is in the set. O(1).
1045      */
1046     function contains(AddressSet storage set, address value) internal view returns (bool) {
1047         return _contains(set._inner, bytes32(uint256(value)));
1048     }
1049 
1050     /**
1051      * @dev Returns the number of values in the set. O(1).
1052      */
1053     function length(AddressSet storage set) internal view returns (uint256) {
1054         return _length(set._inner);
1055     }
1056 
1057    /**
1058     * @dev Returns the value stored at position `index` in the set. O(1).
1059     *
1060     * Note that there are no guarantees on the ordering of values inside the
1061     * array, and it may change when more values are added or removed.
1062     *
1063     * Requirements:
1064     *
1065     * - `index` must be strictly less than {length}.
1066     */
1067     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1068         return address(uint256(_at(set._inner, index)));
1069     }
1070 
1071 
1072     // UintSet
1073 
1074     struct UintSet {
1075         Set _inner;
1076     }
1077 
1078     /**
1079      * @dev Add a value to a set. O(1).
1080      *
1081      * Returns true if the value was added to the set, that is if it was not
1082      * already present.
1083      */
1084     function add(UintSet storage set, uint256 value) internal returns (bool) {
1085         return _add(set._inner, bytes32(value));
1086     }
1087 
1088     /**
1089      * @dev Removes a value from a set. O(1).
1090      *
1091      * Returns true if the value was removed from the set, that is if it was
1092      * present.
1093      */
1094     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1095         return _remove(set._inner, bytes32(value));
1096     }
1097 
1098     /**
1099      * @dev Returns true if the value is in the set. O(1).
1100      */
1101     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1102         return _contains(set._inner, bytes32(value));
1103     }
1104 
1105     /**
1106      * @dev Returns the number of values on the set. O(1).
1107      */
1108     function length(UintSet storage set) internal view returns (uint256) {
1109         return _length(set._inner);
1110     }
1111 
1112    /**
1113     * @dev Returns the value stored at position `index` in the set. O(1).
1114     *
1115     * Note that there are no guarantees on the ordering of values inside the
1116     * array, and it may change when more values are added or removed.
1117     *
1118     * Requirements:
1119     *
1120     * - `index` must be strictly less than {length}.
1121     */
1122     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1123         return uint256(_at(set._inner, index));
1124     }
1125 }
1126 
1127 // File: @openzeppelin\contracts\access\AccessControl.sol
1128 
1129 
1130 pragma solidity ^0.6.0;
1131 
1132 
1133 
1134 
1135 /**
1136  * @dev Contract module that allows children to implement role-based access
1137  * control mechanisms.
1138  *
1139  * Roles are referred to by their `bytes32` identifier. These should be exposed
1140  * in the external API and be unique. The best way to achieve this is by
1141  * using `public constant` hash digests:
1142  *
1143  * ```
1144  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1145  * ```
1146  *
1147  * Roles can be used to represent a set of permissions. To restrict access to a
1148  * function call, use {hasRole}:
1149  *
1150  * ```
1151  * function foo() public {
1152  *     require(hasRole(MY_ROLE, msg.sender));
1153  *     ...
1154  * }
1155  * ```
1156  *
1157  * Roles can be granted and revoked dynamically via the {grantRole} and
1158  * {revokeRole} functions. Each role has an associated admin role, and only
1159  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1160  *
1161  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1162  * that only accounts with this role will be able to grant or revoke other
1163  * roles. More complex role relationships can be created by using
1164  * {_setRoleAdmin}.
1165  *
1166  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1167  * grant and revoke this role. Extra precautions should be taken to secure
1168  * accounts that have been granted it.
1169  */
1170 abstract contract AccessControl is Context {
1171     using EnumerableSet for EnumerableSet.AddressSet;
1172     using Address for address;
1173 
1174     struct RoleData {
1175         EnumerableSet.AddressSet members;
1176         bytes32 adminRole;
1177     }
1178 
1179     mapping (bytes32 => RoleData) private _roles;
1180 
1181     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1182 
1183     /**
1184      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1185      *
1186      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1187      * {RoleAdminChanged} not being emitted signaling this.
1188      *
1189      * _Available since v3.1._
1190      */
1191     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1192 
1193     /**
1194      * @dev Emitted when `account` is granted `role`.
1195      *
1196      * `sender` is the account that originated the contract call, an admin role
1197      * bearer except when using {_setupRole}.
1198      */
1199     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1200 
1201     /**
1202      * @dev Emitted when `account` is revoked `role`.
1203      *
1204      * `sender` is the account that originated the contract call:
1205      *   - if using `revokeRole`, it is the admin role bearer
1206      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1207      */
1208     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1209 
1210     /**
1211      * @dev Returns `true` if `account` has been granted `role`.
1212      */
1213     function hasRole(bytes32 role, address account) public view returns (bool) {
1214         return _roles[role].members.contains(account);
1215     }
1216 
1217     /**
1218      * @dev Returns the number of accounts that have `role`. Can be used
1219      * together with {getRoleMember} to enumerate all bearers of a role.
1220      */
1221     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1222         return _roles[role].members.length();
1223     }
1224 
1225     /**
1226      * @dev Returns one of the accounts that have `role`. `index` must be a
1227      * value between 0 and {getRoleMemberCount}, non-inclusive.
1228      *
1229      * Role bearers are not sorted in any particular way, and their ordering may
1230      * change at any point.
1231      *
1232      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1233      * you perform all queries on the same block. See the following
1234      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1235      * for more information.
1236      */
1237     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1238         return _roles[role].members.at(index);
1239     }
1240 
1241     /**
1242      * @dev Returns the admin role that controls `role`. See {grantRole} and
1243      * {revokeRole}.
1244      *
1245      * To change a role's admin, use {_setRoleAdmin}.
1246      */
1247     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1248         return _roles[role].adminRole;
1249     }
1250 
1251     /**
1252      * @dev Grants `role` to `account`.
1253      *
1254      * If `account` had not been already granted `role`, emits a {RoleGranted}
1255      * event.
1256      *
1257      * Requirements:
1258      *
1259      * - the caller must have ``role``'s admin role.
1260      */
1261     function grantRole(bytes32 role, address account) public virtual {
1262         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1263 
1264         _grantRole(role, account);
1265     }
1266 
1267     /**
1268      * @dev Revokes `role` from `account`.
1269      *
1270      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1271      *
1272      * Requirements:
1273      *
1274      * - the caller must have ``role``'s admin role.
1275      */
1276     function revokeRole(bytes32 role, address account) public virtual {
1277         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1278 
1279         _revokeRole(role, account);
1280     }
1281 
1282     /**
1283      * @dev Revokes `role` from the calling account.
1284      *
1285      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1286      * purpose is to provide a mechanism for accounts to lose their privileges
1287      * if they are compromised (such as when a trusted device is misplaced).
1288      *
1289      * If the calling account had been granted `role`, emits a {RoleRevoked}
1290      * event.
1291      *
1292      * Requirements:
1293      *
1294      * - the caller must be `account`.
1295      */
1296     function renounceRole(bytes32 role, address account) public virtual {
1297         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1298 
1299         _revokeRole(role, account);
1300     }
1301 
1302     /**
1303      * @dev Grants `role` to `account`.
1304      *
1305      * If `account` had not been already granted `role`, emits a {RoleGranted}
1306      * event. Note that unlike {grantRole}, this function doesn't perform any
1307      * checks on the calling account.
1308      *
1309      * [WARNING]
1310      * ====
1311      * This function should only be called from the constructor when setting
1312      * up the initial roles for the system.
1313      *
1314      * Using this function in any other way is effectively circumventing the admin
1315      * system imposed by {AccessControl}.
1316      * ====
1317      */
1318     function _setupRole(bytes32 role, address account) internal virtual {
1319         _grantRole(role, account);
1320     }
1321 
1322     /**
1323      * @dev Sets `adminRole` as ``role``'s admin role.
1324      *
1325      * Emits a {RoleAdminChanged} event.
1326      */
1327     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1328         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1329         _roles[role].adminRole = adminRole;
1330     }
1331 
1332     function _grantRole(bytes32 role, address account) private {
1333         if (_roles[role].members.add(account)) {
1334             emit RoleGranted(role, account, _msgSender());
1335         }
1336     }
1337 
1338     function _revokeRole(bytes32 role, address account) private {
1339         if (_roles[role].members.remove(account)) {
1340             emit RoleRevoked(role, account, _msgSender());
1341         }
1342     }
1343 }
1344 
1345 // File: contracts\TransferAccess.sol
1346 
1347 pragma solidity ^0.6.0;
1348 
1349 
1350 
1351 contract TransferAccess is AccessControl, Ownable {
1352 
1353     bytes32 internal constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
1354     bool private _enable;
1355 
1356     constructor (bool enable) internal {
1357         _enable = enable;
1358         address msgSender = _msgSender();
1359         super._setRoleAdmin(TRANSFER_ROLE, DEFAULT_ADMIN_ROLE);
1360         super._setupRole(TRANSFER_ROLE, msgSender);
1361         super._setupRole(DEFAULT_ADMIN_ROLE, msgSender);
1362     }
1363 
1364     /**
1365      * @dev Returns true if the contract is recipient access status, and false otherwise.
1366      */
1367     function transferAccessStatus() public view returns (bool) {
1368         return _enable;
1369     }
1370 
1371     function enableTransferAccess() public onlyOwner {
1372         _enable = true;
1373     }
1374 
1375     function disableTransferAccess() public onlyOwner {
1376         _enable = false;
1377     }
1378 
1379     function hasTransferRole(address account) public view returns(bool) {
1380         return super.hasRole(TRANSFER_ROLE, account);
1381     }
1382 
1383     function setupTransferRole(address account) public onlyOwner {
1384         super._setupRole(TRANSFER_ROLE, account);
1385     }
1386 
1387     function revokeTransferRole(address account) public onlyOwner {
1388         super.revokeRole(TRANSFER_ROLE, account);
1389     }
1390 
1391     modifier transferable(address recipient, address sender) {
1392         if (_enable) {
1393             require(hasTransferRole(recipient) || hasTransferRole(sender), "TransferAccess: recipient and sender do not have the transfer role");
1394         }
1395         _;
1396     }
1397 }
1398 
1399 // File: contracts\MinterAccess.sol
1400 
1401 pragma solidity ^0.6.0;
1402 
1403 
1404 
1405 
1406 contract MinterAccess is AccessControl, Ownable {
1407 
1408     bytes32 internal constant MINTER_ROLE = keccak256("MINTER_ROLE");
1409 
1410     constructor() public {
1411         address owner = _msgSender();
1412         super._setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);
1413         super._setupRole(MINTER_ROLE, owner);
1414         super._setupRole(DEFAULT_ADMIN_ROLE, owner);
1415     }
1416 
1417     function hasMinterRole(address account) public view returns(bool) {
1418         return super.hasRole(MINTER_ROLE, account);
1419     }
1420 
1421     function setupMinterRole(address account) public onlyOwner {
1422         super._setupRole(MINTER_ROLE, account);
1423     }
1424 
1425     function revokeMinterRole(address account) public onlyOwner {
1426         super.revokeRole(MINTER_ROLE, account);
1427     }
1428 
1429     modifier onlyMinter() {
1430         require(hasMinterRole(_msgSender()), "MinterAccess: sender do not have the minter role");
1431         _;
1432     }
1433 }
1434 
1435 // File: contracts\BaseFil.sol
1436 
1437 // SPDX-License-Identifier: MIT
1438 pragma solidity ^0.6.0;
1439 
1440 
1441 
1442 
1443 
1444 //import "./EarnERC20.sol";
1445 
1446 
1447 contract BaseFil is ERC20, Pausable, Ownable, TransferAccess, MinterAccess {
1448 
1449     //holders count
1450     uint private holders;
1451 
1452     event Released(address indexed _from, address indexed _to, uint256 amount, bytes data);
1453     event Minted(address indexed _from, address indexed _to, uint256 amount);
1454 
1455     constructor (
1456         string memory name,
1457         string memory symbol,
1458         bool enableTransferAccess
1459     )
1460     ERC20(name, symbol)
1461     TransferAccess(enableTransferAccess)
1462     public {
1463 
1464     }
1465 
1466     function mint(address recipient, uint256 amount) external onlyMinter {
1467         checkNewHolder(recipient);
1468         super._mint(recipient, amount);
1469         emit Minted(address(0), recipient, amount);
1470     }
1471 
1472     /**
1473      * @dev Destroys `amount` tokens from the caller.
1474      *
1475      * See {ERC20-_burn}.
1476      */
1477     function burn(uint256 amount) public {
1478         address account = _msgSender();
1479         _burn(account, amount);
1480         checkOldHolder(account);
1481     }
1482 
1483     /**
1484      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1485      * allowance.
1486      *
1487      * See {ERC20-_burn} and {ERC20-allowance}.
1488      *
1489      * Requirements:
1490      *
1491      * - the caller must have allowance for ``accounts``'s tokens of at least
1492      * `amount`.
1493      */
1494     function burnFrom(address account, uint256 amount) public {
1495         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1496 
1497         _approve(account, _msgSender(), decreasedAllowance);
1498         _burn(account, amount);
1499         checkOldHolder(account);
1500     }
1501 
1502     /**
1503      * @dev Destroys `amount` tokens from `account`, reducing the
1504      * total supply銆?
1505      *
1506      * Emits a {Release} event with `to` set to the zero address锛?and with additional data.
1507      *
1508      * Requirements
1509      *
1510      * - `data` cannot be the empty.
1511      * - `sender` must have at least `amount` tokens.
1512      */
1513     function release(bytes memory data, uint256 amount) external {
1514         require(data.length != 0, "ERC20: release data is empty");
1515 
1516         address account = _msgSender();
1517         super._burn(account, amount);
1518         checkOldHolder(account);
1519         emit Released(account, address(0), amount, data);
1520     }
1521 
1522     /**
1523      * @dev See {IERC20-transfer}.
1524      *
1525      * Requirements:
1526      *
1527      * - `recipient` cannot be the zero address.
1528      * - the caller must have a balance of at least `amount`.
1529      */
1530     function transfer(address recipient, uint256 amount) public transferable(recipient, _msgSender()) override returns (bool) {
1531         checkNewHolder(recipient);
1532         bool res = super.transfer(recipient, amount);
1533         address account = _msgSender();
1534         checkOldHolder(account);
1535         return res;
1536     }
1537 
1538     /**
1539      * @dev See {IERC20-transferFrom}.
1540      *
1541      * Emits an {Approval} event indicating the updated allowance. This is not
1542      * required by the EIP. See the note at the beginning of {ERC20};
1543      *
1544      * Requirements:
1545      * - `sender` and `recipient` cannot be the zero address.
1546      * - `sender` must have a balance of at least `amount`.
1547      * - the caller must have allowance for ``sender``'s tokens of at least
1548      * `amount`.
1549      */
1550     function transferFrom(address sender, address recipient, uint256 amount) public transferable(recipient, sender) override returns (bool) {
1551         checkNewHolder(recipient);
1552         bool res = super.transferFrom(sender, recipient, amount);
1553         checkOldHolder(sender);
1554         return res;
1555     }
1556 
1557     function holdersCount() public view returns(uint) {
1558         return holders;
1559     }
1560 
1561     function checkNewHolder(address account) internal {
1562         uint256 b = balanceOf(account);
1563         if (b == 0) {
1564             holders ++;
1565         }
1566     }
1567 
1568     function checkOldHolder(address account) internal {
1569         uint256 b = balanceOf(account);
1570         if (b == 0) {
1571             holders --;
1572         }
1573     }
1574 
1575     /**
1576      * @dev See {ERC20-_beforeTokenTransfer}.
1577      *
1578      * Requirements:
1579      *
1580      * - the contract must not be paused.
1581      */
1582     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
1583         super._beforeTokenTransfer(from, to, amount);
1584 
1585         require(!paused(), "ERC20Pausable: token transfer while paused");
1586     }
1587 
1588     /**
1589      * @dev Called by a pauser to pause, triggers stopped state.
1590      */
1591     function pause() public onlyOwner whenNotPaused {
1592         _pause();
1593     }
1594 
1595     /**
1596      * @dev Called by a pauser to unpause, returns to normal state.
1597      */
1598     function unpause() public onlyOwner whenPaused {
1599         _unpause();
1600     }
1601 }
1602 
1603 
1604 pragma solidity ^0.6.0;
1605 
1606 contract EFIL is BaseFil {
1607 
1608     constructor() BaseFil("Ethereum FIL", "eFIL", false) public {
1609 
1610     }
1611 }