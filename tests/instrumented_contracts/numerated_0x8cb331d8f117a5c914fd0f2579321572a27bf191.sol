1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Pausable.sol
99 
100 // SPDX-License-Identifier: MIT
101 
102 pragma solidity ^0.6.0;
103 
104 
105 /**
106  * @dev Contract module which allows children to implement an emergency stop
107  * mechanism that can be triggered by an authorized account.
108  *
109  * This module is used through inheritance. It will make available the
110  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
111  * the functions of your contract. Note that they will not be pausable by
112  * simply including this module, only once the modifiers are put in place.
113  */
114 contract Pausable is Context {
115     /**
116      * @dev Emitted when the pause is triggered by `account`.
117      */
118     event Paused(address account);
119 
120     /**
121      * @dev Emitted when the pause is lifted by `account`.
122      */
123     event Unpaused(address account);
124 
125     bool private _paused;
126 
127     /**
128      * @dev Initializes the contract in unpaused state.
129      */
130     constructor () internal {
131         _paused = false;
132     }
133 
134     /**
135      * @dev Returns true if the contract is paused, and false otherwise.
136      */
137     function paused() public view returns (bool) {
138         return _paused;
139     }
140 
141     /**
142      * @dev Modifier to make a function callable only when the contract is not paused.
143      *
144      * Requirements:
145      *
146      * - The contract must not be paused.
147      */
148     modifier whenNotPaused() {
149         require(!_paused, "Pausable: paused");
150         _;
151     }
152 
153     /**
154      * @dev Modifier to make a function callable only when the contract is paused.
155      *
156      * Requirements:
157      *
158      * - The contract must be paused.
159      */
160     modifier whenPaused() {
161         require(_paused, "Pausable: not paused");
162         _;
163     }
164 
165     /**
166      * @dev Triggers stopped state.
167      *
168      * Requirements:
169      *
170      * - The contract must not be paused.
171      */
172     function _pause() internal virtual whenNotPaused {
173         _paused = true;
174         emit Paused(_msgSender());
175     }
176 
177     /**
178      * @dev Returns to normal state.
179      *
180      * Requirements:
181      *
182      * - The contract must be paused.
183      */
184     function _unpause() internal virtual whenPaused {
185         _paused = false;
186         emit Unpaused(_msgSender());
187     }
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
191 
192 // SPDX-License-Identifier: MIT
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
270 // File: @openzeppelin/contracts/math/SafeMath.sol
271 
272 // SPDX-License-Identifier: MIT
273 
274 pragma solidity ^0.6.0;
275 
276 /**
277  * @dev Wrappers over Solidity's arithmetic operations with added overflow
278  * checks.
279  *
280  * Arithmetic operations in Solidity wrap on overflow. This can easily result
281  * in bugs, because programmers usually assume that an overflow raises an
282  * error, which is the standard behavior in high level programming languages.
283  * `SafeMath` restores this intuition by reverting the transaction when an
284  * operation overflows.
285  *
286  * Using this library instead of the unchecked operations eliminates an entire
287  * class of bugs, so it's recommended to use it always.
288  */
289 library SafeMath {
290     /**
291      * @dev Returns the addition of two unsigned integers, reverting on
292      * overflow.
293      *
294      * Counterpart to Solidity's `+` operator.
295      *
296      * Requirements:
297      *
298      * - Addition cannot overflow.
299      */
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         uint256 c = a + b;
302         require(c >= a, "SafeMath: addition overflow");
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the subtraction of two unsigned integers, reverting on
309      * overflow (when the result is negative).
310      *
311      * Counterpart to Solidity's `-` operator.
312      *
313      * Requirements:
314      *
315      * - Subtraction cannot overflow.
316      */
317     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318         return sub(a, b, "SafeMath: subtraction overflow");
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
323      * overflow (when the result is negative).
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      *
329      * - Subtraction cannot overflow.
330      */
331     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b <= a, errorMessage);
333         uint256 c = a - b;
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the multiplication of two unsigned integers, reverting on
340      * overflow.
341      *
342      * Counterpart to Solidity's `*` operator.
343      *
344      * Requirements:
345      *
346      * - Multiplication cannot overflow.
347      */
348     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
349         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350         // benefit is lost if 'b' is also tested.
351         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
352         if (a == 0) {
353             return 0;
354         }
355 
356         uint256 c = a * b;
357         require(c / a == b, "SafeMath: multiplication overflow");
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the integer division of two unsigned integers. Reverts on
364      * division by zero. The result is rounded towards zero.
365      *
366      * Counterpart to Solidity's `/` operator. Note: this function uses a
367      * `revert` opcode (which leaves remaining gas untouched) while Solidity
368      * uses an invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function div(uint256 a, uint256 b) internal pure returns (uint256) {
375         return div(a, b, "SafeMath: division by zero");
376     }
377 
378     /**
379      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
380      * division by zero. The result is rounded towards zero.
381      *
382      * Counterpart to Solidity's `/` operator. Note: this function uses a
383      * `revert` opcode (which leaves remaining gas untouched) while Solidity
384      * uses an invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
391         require(b > 0, errorMessage);
392         uint256 c = a / b;
393         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
394 
395         return c;
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
400      * Reverts when dividing by zero.
401      *
402      * Counterpart to Solidity's `%` operator. This function uses a `revert`
403      * opcode (which leaves remaining gas untouched) while Solidity uses an
404      * invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
411         return mod(a, b, "SafeMath: modulo by zero");
412     }
413 
414     /**
415      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
416      * Reverts with custom message when dividing by zero.
417      *
418      * Counterpart to Solidity's `%` operator. This function uses a `revert`
419      * opcode (which leaves remaining gas untouched) while Solidity uses an
420      * invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      *
424      * - The divisor cannot be zero.
425      */
426     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
427         require(b != 0, errorMessage);
428         return a % b;
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Address.sol
433 
434 // SPDX-License-Identifier: MIT
435 
436 pragma solidity ^0.6.2;
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if `account` is a contract.
444      *
445      * [IMPORTANT]
446      * ====
447      * It is unsafe to assume that an address for which this function returns
448      * false is an externally-owned account (EOA) and not a contract.
449      *
450      * Among others, `isContract` will return false for the following
451      * types of addresses:
452      *
453      *  - an externally-owned account
454      *  - a contract in construction
455      *  - an address where a contract will be created
456      *  - an address where a contract lived, but was destroyed
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // This method relies in extcodesize, which returns 0 for contracts in
461         // construction, since the code is only stored at the end of the
462         // constructor execution.
463 
464         uint256 size;
465         // solhint-disable-next-line no-inline-assembly
466         assembly { size := extcodesize(account) }
467         return size > 0;
468     }
469 
470     /**
471      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
472      * `recipient`, forwarding all available gas and reverting on errors.
473      *
474      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
475      * of certain opcodes, possibly making contracts go over the 2300 gas limit
476      * imposed by `transfer`, making them unable to receive funds via
477      * `transfer`. {sendValue} removes this limitation.
478      *
479      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
480      *
481      * IMPORTANT: because control is transferred to `recipient`, care must be
482      * taken to not create reentrancy vulnerabilities. Consider using
483      * {ReentrancyGuard} or the
484      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
485      */
486     function sendValue(address payable recipient, uint256 amount) internal {
487         require(address(this).balance >= amount, "Address: insufficient balance");
488 
489         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
490         (bool success, ) = recipient.call{ value: amount }("");
491         require(success, "Address: unable to send value, recipient may have reverted");
492     }
493 
494     /**
495      * @dev Performs a Solidity function call using a low level `call`. A
496      * plain`call` is an unsafe replacement for a function call: use this
497      * function instead.
498      *
499      * If `target` reverts with a revert reason, it is bubbled up by this
500      * function (like regular Solidity function calls).
501      *
502      * Returns the raw returned data. To convert to the expected return value,
503      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
504      *
505      * Requirements:
506      *
507      * - `target` must be a contract.
508      * - calling `target` with `data` must not revert.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
513       return functionCall(target, data, "Address: low-level call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
518      * `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
523         return _functionCallWithValue(target, data, 0, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but also transferring `value` wei to `target`.
529      *
530      * Requirements:
531      *
532      * - the calling contract must have an ETH balance of at least `value`.
533      * - the called Solidity function must be `payable`.
534      *
535      * _Available since v3.1._
536      */
537     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
543      * with `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
548         require(address(this).balance >= value, "Address: insufficient balance for call");
549         return _functionCallWithValue(target, data, value, errorMessage);
550     }
551 
552     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
553         require(isContract(target), "Address: call to non-contract");
554 
555         // solhint-disable-next-line avoid-low-level-calls
556         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
557         if (success) {
558             return returndata;
559         } else {
560             // Look for revert reason and bubble it up if present
561             if (returndata.length > 0) {
562                 // The easiest way to bubble the revert reason is using memory via assembly
563 
564                 // solhint-disable-next-line no-inline-assembly
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
577 
578 // SPDX-License-Identifier: MIT
579 
580 pragma solidity ^0.6.0;
581 
582 
583 
584 
585 
586 /**
587  * @dev Implementation of the {IERC20} interface.
588  *
589  * This implementation is agnostic to the way tokens are created. This means
590  * that a supply mechanism has to be added in a derived contract using {_mint}.
591  * For a generic mechanism see {ERC20PresetMinterPauser}.
592  *
593  * TIP: For a detailed writeup see our guide
594  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
595  * to implement supply mechanisms].
596  *
597  * We have followed general OpenZeppelin guidelines: functions revert instead
598  * of returning `false` on failure. This behavior is nonetheless conventional
599  * and does not conflict with the expectations of ERC20 applications.
600  *
601  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
602  * This allows applications to reconstruct the allowance for all accounts just
603  * by listening to said events. Other implementations of the EIP may not emit
604  * these events, as it isn't required by the specification.
605  *
606  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
607  * functions have been added to mitigate the well-known issues around setting
608  * allowances. See {IERC20-approve}.
609  */
610 contract ERC20 is Context, IERC20 {
611     using SafeMath for uint256;
612     using Address for address;
613 
614     mapping (address => uint256) private _balances;
615 
616     mapping (address => mapping (address => uint256)) private _allowances;
617 
618     uint256 private _totalSupply;
619 
620     string private _name;
621     string private _symbol;
622     uint8 private _decimals;
623 
624     /**
625      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
626      * a default value of 18.
627      *
628      * To select a different value for {decimals}, use {_setupDecimals}.
629      *
630      * All three of these values are immutable: they can only be set once during
631      * construction.
632      */
633     constructor (string memory name, string memory symbol) public {
634         _name = name;
635         _symbol = symbol;
636         _decimals = 18;
637     }
638 
639     /**
640      * @dev Returns the name of the token.
641      */
642     function name() public view returns (string memory) {
643         return _name;
644     }
645 
646     /**
647      * @dev Returns the symbol of the token, usually a shorter version of the
648      * name.
649      */
650     function symbol() public view returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @dev Returns the number of decimals used to get its user representation.
656      * For example, if `decimals` equals `2`, a balance of `505` tokens should
657      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
658      *
659      * Tokens usually opt for a value of 18, imitating the relationship between
660      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
661      * called.
662      *
663      * NOTE: This information is only used for _display_ purposes: it in
664      * no way affects any of the arithmetic of the contract, including
665      * {IERC20-balanceOf} and {IERC20-transfer}.
666      */
667     function decimals() public view returns (uint8) {
668         return _decimals;
669     }
670 
671     /**
672      * @dev See {IERC20-totalSupply}.
673      */
674     function totalSupply() public view override returns (uint256) {
675         return _totalSupply;
676     }
677 
678     /**
679      * @dev See {IERC20-balanceOf}.
680      */
681     function balanceOf(address account) public view override returns (uint256) {
682         return _balances[account];
683     }
684 
685     /**
686      * @dev See {IERC20-transfer}.
687      *
688      * Requirements:
689      *
690      * - `recipient` cannot be the zero address.
691      * - the caller must have a balance of at least `amount`.
692      */
693     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
694         _transfer(_msgSender(), recipient, amount);
695         return true;
696     }
697 
698     /**
699      * @dev See {IERC20-allowance}.
700      */
701     function allowance(address owner, address spender) public view virtual override returns (uint256) {
702         return _allowances[owner][spender];
703     }
704 
705     /**
706      * @dev See {IERC20-approve}.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      */
712     function approve(address spender, uint256 amount) public virtual override returns (bool) {
713         _approve(_msgSender(), spender, amount);
714         return true;
715     }
716 
717     /**
718      * @dev See {IERC20-transferFrom}.
719      *
720      * Emits an {Approval} event indicating the updated allowance. This is not
721      * required by the EIP. See the note at the beginning of {ERC20};
722      *
723      * Requirements:
724      * - `sender` and `recipient` cannot be the zero address.
725      * - `sender` must have a balance of at least `amount`.
726      * - the caller must have allowance for ``sender``'s tokens of at least
727      * `amount`.
728      */
729     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
730         _transfer(sender, recipient, amount);
731         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
732         return true;
733     }
734 
735     /**
736      * @dev Atomically increases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      */
747     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
748         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
749         return true;
750     }
751 
752     /**
753      * @dev Atomically decreases the allowance granted to `spender` by the caller.
754      *
755      * This is an alternative to {approve} that can be used as a mitigation for
756      * problems described in {IERC20-approve}.
757      *
758      * Emits an {Approval} event indicating the updated allowance.
759      *
760      * Requirements:
761      *
762      * - `spender` cannot be the zero address.
763      * - `spender` must have allowance for the caller of at least
764      * `subtractedValue`.
765      */
766     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
767         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
768         return true;
769     }
770 
771     /**
772      * @dev Moves tokens `amount` from `sender` to `recipient`.
773      *
774      * This is internal function is equivalent to {transfer}, and can be used to
775      * e.g. implement automatic token fees, slashing mechanisms, etc.
776      *
777      * Emits a {Transfer} event.
778      *
779      * Requirements:
780      *
781      * - `sender` cannot be the zero address.
782      * - `recipient` cannot be the zero address.
783      * - `sender` must have a balance of at least `amount`.
784      */
785     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
786         require(sender != address(0), "ERC20: transfer from the zero address");
787         require(recipient != address(0), "ERC20: transfer to the zero address");
788 
789         _beforeTokenTransfer(sender, recipient, amount);
790 
791         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
792         _balances[recipient] = _balances[recipient].add(amount);
793         emit Transfer(sender, recipient, amount);
794     }
795 
796     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
797      * the total supply.
798      *
799      * Emits a {Transfer} event with `from` set to the zero address.
800      *
801      * Requirements
802      *
803      * - `to` cannot be the zero address.
804      */
805     function _mint(address account, uint256 amount) internal virtual {
806         require(account != address(0), "ERC20: mint to the zero address");
807 
808         _beforeTokenTransfer(address(0), account, amount);
809 
810         _totalSupply = _totalSupply.add(amount);
811         _balances[account] = _balances[account].add(amount);
812         emit Transfer(address(0), account, amount);
813     }
814 
815     /**
816      * @dev Destroys `amount` tokens from `account`, reducing the
817      * total supply.
818      *
819      * Emits a {Transfer} event with `to` set to the zero address.
820      *
821      * Requirements
822      *
823      * - `account` cannot be the zero address.
824      * - `account` must have at least `amount` tokens.
825      */
826     function _burn(address account, uint256 amount) internal virtual {
827         require(account != address(0), "ERC20: burn from the zero address");
828 
829         _beforeTokenTransfer(account, address(0), amount);
830 
831         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
832         _totalSupply = _totalSupply.sub(amount);
833         emit Transfer(account, address(0), amount);
834     }
835 
836     /**
837      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
838      *
839      * This internal function is equivalent to `approve`, and can be used to
840      * e.g. set automatic allowances for certain subsystems, etc.
841      *
842      * Emits an {Approval} event.
843      *
844      * Requirements:
845      *
846      * - `owner` cannot be the zero address.
847      * - `spender` cannot be the zero address.
848      */
849     function _approve(address owner, address spender, uint256 amount) internal virtual {
850         require(owner != address(0), "ERC20: approve from the zero address");
851         require(spender != address(0), "ERC20: approve to the zero address");
852 
853         _allowances[owner][spender] = amount;
854         emit Approval(owner, spender, amount);
855     }
856 
857     /**
858      * @dev Sets {decimals} to a value other than the default one of 18.
859      *
860      * WARNING: This function should only be called from the constructor. Most
861      * applications that interact with token contracts will not expect
862      * {decimals} to ever change, and may work incorrectly if it does.
863      */
864     function _setupDecimals(uint8 decimals_) internal {
865         _decimals = decimals_;
866     }
867 
868     /**
869      * @dev Hook that is called before any transfer of tokens. This includes
870      * minting and burning.
871      *
872      * Calling conditions:
873      *
874      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
875      * will be to transferred to `to`.
876      * - when `from` is zero, `amount` tokens will be minted for `to`.
877      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
878      * - `from` and `to` are never both zero.
879      *
880      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
881      */
882     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
883 }
884 
885 // File: contracts/TadGenesisMiningStorage.sol
886 
887 //SPDX-License-Identifier: MIT
888 
889 
890 pragma solidity ^0.6.0;
891 
892 contract OwnableStorage{
893     address internal _owner;
894 }
895 
896 contract PausableStorage{
897     bool internal _paused;
898 }
899 
900 contract TadGenesisMiningStorage {
901   using SafeMath for uint256;
902 
903   bool constant public isTadGenesisMining = true;
904   bool public initiated = false;
905 
906   // proxy storage
907   address public admin;
908   address public implementation;
909   
910   ERC20 public TenToken;
911   ERC20 public TadToken;
912   
913   uint public startMiningBlockNum = 0;
914   uint public totalGenesisBlockNum = 172800;
915   uint public endMiningBlockNum = startMiningBlockNum + totalGenesisBlockNum;
916   uint public tadPerBlock = 1150000000000000000;
917   
918   uint public constant stakeInitialIndex = 1e36;
919   
920   uint public miningStateBlock = startMiningBlockNum;
921   uint public miningStateIndex = stakeInitialIndex;
922   
923   mapping (address => uint) public stakeHolders;
924   uint public totalStaked;
925 
926   mapping (address => uint) public stakerIndexes;
927   mapping (address => uint) public stakerClaimed;
928   uint public totalClaimed;
929 
930 }
931 
932 // File: contracts/TadGenesisMining.sol
933 
934 //SPDX-License-Identifier: MIT
935 
936 pragma solidity ^0.6.0;
937 
938 
939 
940 
941 
942 contract TadGenesisMining is Ownable, Pausable, TadGenesisMiningStorage {
943   
944   event Staked(address indexed user, uint256 amount, uint256 total);
945   event Unstaked(address indexed user, uint256 amount, uint256 total);
946   event ClaimedTad(address indexed user, uint amount, uint total);
947 
948   function initiate(uint _startMiningBlocknum, uint _totalGenesisBlockNum, uint _tadPerBlock, ERC20 _tad, ERC20 _ten) public onlyOwner{
949     require(initiated==false, "contract is already initiated");
950     initiated = true;
951 
952     require(_totalGenesisBlockNum >= 100, "totalGenesisBlockNum is too small");
953 
954     if(_startMiningBlocknum == 0){
955       _startMiningBlocknum = block.number;
956     }
957 
958     _tad.totalSupply(); //sanity check
959     _ten.totalSupply(); //sanity check
960 
961     startMiningBlockNum = _startMiningBlocknum;
962     totalGenesisBlockNum = _totalGenesisBlockNum;
963     endMiningBlockNum = startMiningBlockNum + totalGenesisBlockNum;
964     miningStateBlock = startMiningBlockNum;
965     tadPerBlock = _tadPerBlock;
966     TadToken = _tad;
967     TenToken = _ten;
968 
969   }
970 
971   // @notice stake some TEN
972   // @param _amount some amount of TEN, requires enought allowence from TEN smart contract
973   function stake(uint256 _amount) public whenNotPaused{
974       
975       createStake(msg.sender, _amount);
976   }
977   
978   // @notice internal function for staking
979   function createStake(
980     address _address,
981     uint256 _amount
982   )
983     internal
984   {
985 
986     claimTad();
987     
988     require(block.number<endMiningBlockNum, "staking period has ended");
989       
990     require(
991       TenToken.transferFrom(_address, address(this), _amount),
992       "Stake required");
993 
994     stakeHolders[_address] = stakeHolders[_address].add(_amount);
995 
996 
997     totalStaked = totalStaked.add(_amount);
998     
999 
1000     emit Staked(
1001       _address,
1002       _amount,
1003       stakeHolders[_address]);
1004   }
1005   
1006   // @notice unstake TEN token
1007   // @param _amount if 0, unstake all TEN available
1008   function unstake(uint256 _amount) public whenNotPaused{
1009   
1010     if(_amount==0){
1011       _amount = stakeHolders[msg.sender];
1012     }
1013 
1014     if(_amount == 0){ // if staking balance == 0, do nothing
1015       return;
1016     }
1017 
1018     withdrawStake(msg.sender, _amount);
1019       
1020   }
1021   
1022   // @notice internal function for unstaking
1023   function withdrawStake(
1024     address _address,
1025     uint256 _amount
1026   )
1027     internal
1028   {
1029 
1030     claimTad();
1031 
1032     if(_amount > stakeHolders[_address]){ //if amount is larger than owned
1033       _amount = stakeHolders[_address];
1034     }
1035 
1036     require(
1037       TenToken.transfer(_address, _amount),
1038       "Unable to withdraw stake");
1039 
1040     stakeHolders[_address] = stakeHolders[_address].sub(_amount);
1041     totalStaked = totalStaked.sub(_amount);
1042 
1043     updateMiningState();
1044 
1045     emit Unstaked(
1046       _address,
1047       _amount,
1048       stakeHolders[_address]);
1049   }
1050   
1051   // @notice internal function for updating mining state
1052   function updateMiningState() internal{
1053     
1054     if(miningStateBlock == endMiningBlockNum){ //if miningStateBlock is already the end of program, dont update state
1055         return;
1056     }
1057     
1058     (miningStateIndex, miningStateBlock) = getMiningState(block.number);
1059     
1060   }
1061   
1062   // @notice calculate current mining state
1063   function getMiningState(uint _blockNum) public view returns(uint, uint){
1064 
1065     require(_blockNum >= miningStateBlock, "_blockNum must be >= miningStateBlock");
1066       
1067     uint blockNumber = _blockNum;
1068       
1069     if(_blockNum>endMiningBlockNum){ //if current block.number is bigger than the end of program, only update the state to endMiningBlockNum
1070         blockNumber = endMiningBlockNum;   
1071     }
1072       
1073     uint deltaBlocks = blockNumber.sub(miningStateBlock);
1074     
1075     uint _miningStateBlock = miningStateBlock;
1076     uint _miningStateIndex = miningStateIndex;
1077     
1078     if (deltaBlocks > 0 && totalStaked > 0) {
1079         uint tadAccrued = deltaBlocks.mul(tadPerBlock);
1080         uint ratio = tadAccrued.mul(1e18).div(totalStaked); //multiple ratio to 1e18 to prevent rounding error
1081         _miningStateIndex = miningStateIndex.add(ratio); //index is 1e18 precision
1082         _miningStateBlock = blockNumber;
1083     } 
1084     
1085     return (_miningStateIndex, _miningStateBlock);
1086     
1087   }
1088   
1089   // @notice claim TAD based on current state 
1090   function claimTad() public whenNotPaused {
1091       
1092       updateMiningState();
1093       
1094       uint claimableTad = claimableTad(msg.sender);
1095       
1096       stakerIndexes[msg.sender] = miningStateIndex;
1097       
1098       if(claimableTad > 0){
1099           
1100           stakerClaimed[msg.sender] = stakerClaimed[msg.sender].add(claimableTad);
1101           totalClaimed = totalClaimed.add(claimableTad);
1102           TadToken.transfer(msg.sender, claimableTad);
1103           emit ClaimedTad(msg.sender, claimableTad, stakerClaimed[msg.sender]);
1104           
1105       }
1106   }
1107   
1108   // @notice calculate claimable tad based on current state
1109   function claimableTad(address _address) public view returns(uint){
1110       uint stakerIndex = stakerIndexes[_address];
1111         
1112         // if it's the first stake for user and the first stake for entire mining program, set stakerIndex as stakeInitialIndex
1113         if (stakerIndex == 0 && totalStaked == 0) {
1114             stakerIndex = stakeInitialIndex;
1115         }
1116         
1117         //else if it's the first stake for user, set stakerIndex as current miningStateIndex
1118         if(stakerIndex == 0){
1119             stakerIndex = miningStateIndex;
1120         }
1121       
1122       uint deltaIndex = miningStateIndex.sub(stakerIndex);
1123       uint tadDelta = deltaIndex.mul(stakeHolders[_address]).div(1e18);
1124       
1125       return tadDelta;
1126           
1127   }
1128 
1129     // @notice test function
1130     function doNothing() public{
1131     }
1132 
1133     /*======== admin functions =========*/
1134 
1135     // @notice admin function to pause the contract
1136     function pause() public onlyOwner{
1137       _pause();
1138     }
1139 
1140     // @notice admin function to unpause the contract
1141     function unpause() public onlyOwner{
1142       _unpause();
1143     }
1144 
1145     // @notice admin function to send TAD to external address, for emergency use
1146     function sendTad(address _to, uint _amount) public onlyOwner{
1147       TadToken.transfer(_to, _amount);
1148     }
1149     
1150 }
1151 
1152 // File: contracts/TadGenesisMiningProxy.sol
1153 
1154 //SPDX-License-Identifier: MIT
1155 
1156 pragma solidity ^0.6.0;
1157 
1158 
1159 
1160 contract TadGenesisMiningProxy is OwnableStorage, PausableStorage, TadGenesisMiningStorage {
1161 
1162     event NewImplementation(address oldImplementation, address newImplementation);
1163 
1164     event NewAdmin(address oldAdmin, address newAdmin);
1165 
1166     constructor(TadGenesisMining newImplementation) public {
1167 
1168         admin = msg.sender;
1169         _owner = msg.sender;
1170 
1171         require(newImplementation.isTadGenesisMining() == true, "invalid implementation");
1172         implementation = address(newImplementation);
1173 
1174         emit NewImplementation(address(0), implementation);
1175     }
1176 
1177     /*** Admin Functions ***/
1178     function _setImplementation(TadGenesisMining  newImplementation) public {
1179 
1180         require(msg.sender==admin, "UNAUTHORIZED");
1181 
1182         require(newImplementation.isTadGenesisMining() == true, "invalid implementation");
1183 
1184         address oldImplementation = implementation;
1185 
1186         implementation = address(newImplementation);
1187 
1188         emit NewImplementation(oldImplementation, implementation);
1189 
1190     }
1191 
1192 
1193     /**
1194       * @notice Transfer of admin rights
1195       * @dev Admin function to change admin
1196       * @param newAdmin New admin.
1197       */
1198     function _setAdmin(address newAdmin) public {
1199         // Check caller = admin
1200         require(msg.sender==admin, "UNAUTHORIZED");
1201 
1202         // Save current value, if any, for inclusion in log
1203         address oldAdmin = admin;
1204 
1205         admin = newAdmin;
1206 
1207         emit NewAdmin(oldAdmin, newAdmin);
1208 
1209     }
1210 
1211     /**
1212      * @dev Delegates execution to an implementation contract.
1213      * It returns to the external caller whatever the implementation returns
1214      * or forwards reverts.
1215      */
1216     fallback() external {
1217         // delegate all other functions to current implementation
1218         (bool success, ) = implementation.delegatecall(msg.data);
1219 
1220         assembly {
1221               let free_mem_ptr := mload(0x40)
1222               returndatacopy(free_mem_ptr, 0, returndatasize())
1223 
1224               switch success
1225               case 0 { revert(free_mem_ptr, returndatasize()) }
1226               default { return(free_mem_ptr, returndatasize()) }
1227         }
1228     }
1229 }