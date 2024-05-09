1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin\contracts\utils\Pausable.sol
28 
29 
30 pragma solidity ^0.6.0;
31 
32 
33 /**
34  * @dev Contract module which allows children to implement an emergency stop
35  * mechanism that can be triggered by an authorized account.
36  *
37  * This module is used through inheritance. It will make available the
38  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
39  * the functions of your contract. Note that they will not be pausable by
40  * simply including this module, only once the modifiers are put in place.
41  */
42 contract Pausable is Context {
43     /**
44      * @dev Emitted when the pause is triggered by `account`.
45      */
46     event Paused(address account);
47 
48     /**
49      * @dev Emitted when the pause is lifted by `account`.
50      */
51     event Unpaused(address account);
52 
53     bool private _paused;
54 
55     /**
56      * @dev Initializes the contract in unpaused state.
57      */
58     constructor () internal {
59         _paused = false;
60     }
61 
62     /**
63      * @dev Returns true if the contract is paused, and false otherwise.
64      */
65     function paused() public view returns (bool) {
66         return _paused;
67     }
68 
69     /**
70      * @dev Modifier to make a function callable only when the contract is not paused.
71      *
72      * Requirements:
73      *
74      * - The contract must not be paused.
75      */
76     modifier whenNotPaused() {
77         require(!_paused, "Pausable: paused");
78         _;
79     }
80 
81     /**
82      * @dev Modifier to make a function callable only when the contract is paused.
83      *
84      * Requirements:
85      *
86      * - The contract must be paused.
87      */
88     modifier whenPaused() {
89         require(_paused, "Pausable: not paused");
90         _;
91     }
92 
93     /**
94      * @dev Triggers stopped state.
95      *
96      * Requirements:
97      *
98      * - The contract must not be paused.
99      */
100     function _pause() internal virtual whenNotPaused {
101         _paused = true;
102         emit Paused(_msgSender());
103     }
104 
105     /**
106      * @dev Returns to normal state.
107      *
108      * Requirements:
109      *
110      * - The contract must be paused.
111      */
112     function _unpause() internal virtual whenPaused {
113         _paused = false;
114         emit Unpaused(_msgSender());
115     }
116 }
117 
118 // File: @openzeppelin\contracts\access\Ownable.sol
119 
120 
121 pragma solidity ^0.6.0;
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor () internal {
144         address msgSender = _msgSender();
145         _owner = msgSender;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(_owner == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Can only be called by the current owner.
179      */
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
188 
189 
190 pragma solidity ^0.6.0;
191 
192 /**
193  * @dev Interface of the ERC20 standard as defined in the EIP.
194  */
195 interface IERC20 {
196     /**
197      * @dev Returns the amount of tokens in existence.
198      */
199     function totalSupply() external view returns (uint256);
200 
201     /**
202      * @dev Returns the amount of tokens owned by `account`.
203      */
204     function balanceOf(address account) external view returns (uint256);
205 
206     /**
207      * @dev Moves `amount` tokens from the caller's account to `recipient`.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transfer(address recipient, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Returns the remaining number of tokens that `spender` will be
217      * allowed to spend on behalf of `owner` through {transferFrom}. This is
218      * zero by default.
219      *
220      * This value changes when {approve} or {transferFrom} are called.
221      */
222     function allowance(address owner, address spender) external view returns (uint256);
223 
224     /**
225      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * IMPORTANT: Beware that changing an allowance with this method brings the risk
230      * that someone may use both the old and the new allowance by unfortunate
231      * transaction ordering. One possible solution to mitigate this race
232      * condition is to first reduce the spender's allowance to 0 and set the
233      * desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address spender, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Moves `amount` tokens from `sender` to `recipient` using the
242      * allowance mechanism. `amount` is then deducted from the caller's
243      * allowance.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Emitted when `value` tokens are moved from one account (`from`) to
253      * another (`to`).
254      *
255      * Note that `value` may be zero.
256      */
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     /**
260      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
261      * a call to {approve}. `value` is the new allowance.
262      */
263     event Approval(address indexed owner, address indexed spender, uint256 value);
264 }
265 
266 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
267 
268 
269 pragma solidity ^0.6.0;
270 
271 /**
272  * @dev Wrappers over Solidity's arithmetic operations with added overflow
273  * checks.
274  *
275  * Arithmetic operations in Solidity wrap on overflow. This can easily result
276  * in bugs, because programmers usually assume that an overflow raises an
277  * error, which is the standard behavior in high level programming languages.
278  * `SafeMath` restores this intuition by reverting the transaction when an
279  * operation overflows.
280  *
281  * Using this library instead of the unchecked operations eliminates an entire
282  * class of bugs, so it's recommended to use it always.
283  */
284 library SafeMath {
285     /**
286      * @dev Returns the addition of two unsigned integers, reverting on
287      * overflow.
288      *
289      * Counterpart to Solidity's `+` operator.
290      *
291      * Requirements:
292      *
293      * - Addition cannot overflow.
294      */
295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
296         uint256 c = a + b;
297         require(c >= a, "SafeMath: addition overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the subtraction of two unsigned integers, reverting on
304      * overflow (when the result is negative).
305      *
306      * Counterpart to Solidity's `-` operator.
307      *
308      * Requirements:
309      *
310      * - Subtraction cannot overflow.
311      */
312     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313         return sub(a, b, "SafeMath: subtraction overflow");
314     }
315 
316     /**
317      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
318      * overflow (when the result is negative).
319      *
320      * Counterpart to Solidity's `-` operator.
321      *
322      * Requirements:
323      *
324      * - Subtraction cannot overflow.
325      */
326     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b <= a, errorMessage);
328         uint256 c = a - b;
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the multiplication of two unsigned integers, reverting on
335      * overflow.
336      *
337      * Counterpart to Solidity's `*` operator.
338      *
339      * Requirements:
340      *
341      * - Multiplication cannot overflow.
342      */
343     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
344         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
345         // benefit is lost if 'b' is also tested.
346         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
347         if (a == 0) {
348             return 0;
349         }
350 
351         uint256 c = a * b;
352         require(c / a == b, "SafeMath: multiplication overflow");
353 
354         return c;
355     }
356 
357     /**
358      * @dev Returns the integer division of two unsigned integers. Reverts on
359      * division by zero. The result is rounded towards zero.
360      *
361      * Counterpart to Solidity's `/` operator. Note: this function uses a
362      * `revert` opcode (which leaves remaining gas untouched) while Solidity
363      * uses an invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      *
367      * - The divisor cannot be zero.
368      */
369     function div(uint256 a, uint256 b) internal pure returns (uint256) {
370         return div(a, b, "SafeMath: division by zero");
371     }
372 
373     /**
374      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
375      * division by zero. The result is rounded towards zero.
376      *
377      * Counterpart to Solidity's `/` operator. Note: this function uses a
378      * `revert` opcode (which leaves remaining gas untouched) while Solidity
379      * uses an invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      *
383      * - The divisor cannot be zero.
384      */
385     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
386         require(b > 0, errorMessage);
387         uint256 c = a / b;
388         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
389 
390         return c;
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * Reverts when dividing by zero.
396      *
397      * Counterpart to Solidity's `%` operator. This function uses a `revert`
398      * opcode (which leaves remaining gas untouched) while Solidity uses an
399      * invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
406         return mod(a, b, "SafeMath: modulo by zero");
407     }
408 
409     /**
410      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
411      * Reverts with custom message when dividing by zero.
412      *
413      * Counterpart to Solidity's `%` operator. This function uses a `revert`
414      * opcode (which leaves remaining gas untouched) while Solidity uses an
415      * invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      *
419      * - The divisor cannot be zero.
420      */
421     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
422         require(b != 0, errorMessage);
423         return a % b;
424     }
425 }
426 
427 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
428 
429 
430 pragma solidity ^0.6.2;
431 
432 /**
433  * @dev Collection of functions related to the address type
434  */
435 library Address {
436     /**
437      * @dev Returns true if `account` is a contract.
438      *
439      * [IMPORTANT]
440      * ====
441      * It is unsafe to assume that an address for which this function returns
442      * false is an externally-owned account (EOA) and not a contract.
443      *
444      * Among others, `isContract` will return false for the following
445      * types of addresses:
446      *
447      *  - an externally-owned account
448      *  - a contract in construction
449      *  - an address where a contract will be created
450      *  - an address where a contract lived, but was destroyed
451      * ====
452      */
453     function isContract(address account) internal view returns (bool) {
454         // This method relies in extcodesize, which returns 0 for contracts in
455         // construction, since the code is only stored at the end of the
456         // constructor execution.
457 
458         uint256 size;
459         // solhint-disable-next-line no-inline-assembly
460         assembly { size := extcodesize(account) }
461         return size > 0;
462     }
463 
464     /**
465      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
466      * `recipient`, forwarding all available gas and reverting on errors.
467      *
468      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
469      * of certain opcodes, possibly making contracts go over the 2300 gas limit
470      * imposed by `transfer`, making them unable to receive funds via
471      * `transfer`. {sendValue} removes this limitation.
472      *
473      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
474      *
475      * IMPORTANT: because control is transferred to `recipient`, care must be
476      * taken to not create reentrancy vulnerabilities. Consider using
477      * {ReentrancyGuard} or the
478      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
479      */
480     function sendValue(address payable recipient, uint256 amount) internal {
481         require(address(this).balance >= amount, "Address: insufficient balance");
482 
483         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
484         (bool success, ) = recipient.call{ value: amount }("");
485         require(success, "Address: unable to send value, recipient may have reverted");
486     }
487 
488     /**
489      * @dev Performs a Solidity function call using a low level `call`. A
490      * plain`call` is an unsafe replacement for a function call: use this
491      * function instead.
492      *
493      * If `target` reverts with a revert reason, it is bubbled up by this
494      * function (like regular Solidity function calls).
495      *
496      * Returns the raw returned data. To convert to the expected return value,
497      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
498      *
499      * Requirements:
500      *
501      * - `target` must be a contract.
502      * - calling `target` with `data` must not revert.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
507       return functionCall(target, data, "Address: low-level call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
512      * `errorMessage` as a fallback revert reason when `target` reverts.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
517         return _functionCallWithValue(target, data, 0, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but also transferring `value` wei to `target`.
523      *
524      * Requirements:
525      *
526      * - the calling contract must have an ETH balance of at least `value`.
527      * - the called Solidity function must be `payable`.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
537      * with `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
542         require(address(this).balance >= value, "Address: insufficient balance for call");
543         return _functionCallWithValue(target, data, value, errorMessage);
544     }
545 
546     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
547         require(isContract(target), "Address: call to non-contract");
548 
549         // solhint-disable-next-line avoid-low-level-calls
550         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
551         if (success) {
552             return returndata;
553         } else {
554             // Look for revert reason and bubble it up if present
555             if (returndata.length > 0) {
556                 // The easiest way to bubble the revert reason is using memory via assembly
557 
558                 // solhint-disable-next-line no-inline-assembly
559                 assembly {
560                     let returndata_size := mload(returndata)
561                     revert(add(32, returndata), returndata_size)
562                 }
563             } else {
564                 revert(errorMessage);
565             }
566         }
567     }
568 }
569 
570 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
571 
572 
573 pragma solidity ^0.6.0;
574 
575 
576 
577 
578 
579 /**
580  * @dev Implementation of the {IERC20} interface.
581  *
582  * This implementation is agnostic to the way tokens are created. This means
583  * that a supply mechanism has to be added in a derived contract using {_mint}.
584  * For a generic mechanism see {ERC20PresetMinterPauser}.
585  *
586  * TIP: For a detailed writeup see our guide
587  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
588  * to implement supply mechanisms].
589  *
590  * We have followed general OpenZeppelin guidelines: functions revert instead
591  * of returning `false` on failure. This behavior is nonetheless conventional
592  * and does not conflict with the expectations of ERC20 applications.
593  *
594  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
595  * This allows applications to reconstruct the allowance for all accounts just
596  * by listening to said events. Other implementations of the EIP may not emit
597  * these events, as it isn't required by the specification.
598  *
599  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
600  * functions have been added to mitigate the well-known issues around setting
601  * allowances. See {IERC20-approve}.
602  */
603 contract ERC20 is Context, IERC20 {
604     using SafeMath for uint256;
605     using Address for address;
606 
607     mapping (address => uint256) private _balances;
608 
609     mapping (address => mapping (address => uint256)) private _allowances;
610 
611     uint256 private _totalSupply;
612 
613     string private _name;
614     string private _symbol;
615     uint8 private _decimals;
616 
617     /**
618      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
619      * a default value of 18.
620      *
621      * To select a different value for {decimals}, use {_setupDecimals}.
622      *
623      * All three of these values are immutable: they can only be set once during
624      * construction.
625      */
626     constructor (string memory name, string memory symbol) public {
627         _name = name;
628         _symbol = symbol;
629         _decimals = 18;
630     }
631 
632     /**
633      * @dev Returns the name of the token.
634      */
635     function name() public view returns (string memory) {
636         return _name;
637     }
638 
639     /**
640      * @dev Returns the symbol of the token, usually a shorter version of the
641      * name.
642      */
643     function symbol() public view returns (string memory) {
644         return _symbol;
645     }
646 
647     /**
648      * @dev Returns the number of decimals used to get its user representation.
649      * For example, if `decimals` equals `2`, a balance of `505` tokens should
650      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
651      *
652      * Tokens usually opt for a value of 18, imitating the relationship between
653      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
654      * called.
655      *
656      * NOTE: This information is only used for _display_ purposes: it in
657      * no way affects any of the arithmetic of the contract, including
658      * {IERC20-balanceOf} and {IERC20-transfer}.
659      */
660     function decimals() public view returns (uint8) {
661         return _decimals;
662     }
663 
664     /**
665      * @dev See {IERC20-totalSupply}.
666      */
667     function totalSupply() public view override returns (uint256) {
668         return _totalSupply;
669     }
670 
671     /**
672      * @dev See {IERC20-balanceOf}.
673      */
674     function balanceOf(address account) public view override returns (uint256) {
675         return _balances[account];
676     }
677 
678     /**
679      * @dev See {IERC20-transfer}.
680      *
681      * Requirements:
682      *
683      * - `recipient` cannot be the zero address.
684      * - the caller must have a balance of at least `amount`.
685      */
686     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
687         _transfer(_msgSender(), recipient, amount);
688         return true;
689     }
690 
691     /**
692      * @dev See {IERC20-allowance}.
693      */
694     function allowance(address owner, address spender) public view virtual override returns (uint256) {
695         return _allowances[owner][spender];
696     }
697 
698     /**
699      * @dev See {IERC20-approve}.
700      *
701      * Requirements:
702      *
703      * - `spender` cannot be the zero address.
704      */
705     function approve(address spender, uint256 amount) public virtual override returns (bool) {
706         _approve(_msgSender(), spender, amount);
707         return true;
708     }
709 
710     /**
711      * @dev See {IERC20-transferFrom}.
712      *
713      * Emits an {Approval} event indicating the updated allowance. This is not
714      * required by the EIP. See the note at the beginning of {ERC20};
715      *
716      * Requirements:
717      * - `sender` and `recipient` cannot be the zero address.
718      * - `sender` must have a balance of at least `amount`.
719      * - the caller must have allowance for ``sender``'s tokens of at least
720      * `amount`.
721      */
722     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
723         _transfer(sender, recipient, amount);
724         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
725         return true;
726     }
727 
728     /**
729      * @dev Atomically increases the allowance granted to `spender` by the caller.
730      *
731      * This is an alternative to {approve} that can be used as a mitigation for
732      * problems described in {IERC20-approve}.
733      *
734      * Emits an {Approval} event indicating the updated allowance.
735      *
736      * Requirements:
737      *
738      * - `spender` cannot be the zero address.
739      */
740     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
741         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
742         return true;
743     }
744 
745     /**
746      * @dev Atomically decreases the allowance granted to `spender` by the caller.
747      *
748      * This is an alternative to {approve} that can be used as a mitigation for
749      * problems described in {IERC20-approve}.
750      *
751      * Emits an {Approval} event indicating the updated allowance.
752      *
753      * Requirements:
754      *
755      * - `spender` cannot be the zero address.
756      * - `spender` must have allowance for the caller of at least
757      * `subtractedValue`.
758      */
759     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
760         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
761         return true;
762     }
763 
764     /**
765      * @dev Moves tokens `amount` from `sender` to `recipient`.
766      *
767      * This is internal function is equivalent to {transfer}, and can be used to
768      * e.g. implement automatic token fees, slashing mechanisms, etc.
769      *
770      * Emits a {Transfer} event.
771      *
772      * Requirements:
773      *
774      * - `sender` cannot be the zero address.
775      * - `recipient` cannot be the zero address.
776      * - `sender` must have a balance of at least `amount`.
777      */
778     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
779         require(sender != address(0), "ERC20: transfer from the zero address");
780         require(recipient != address(0), "ERC20: transfer to the zero address");
781 
782         _beforeTokenTransfer(sender, recipient, amount);
783 
784         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
785         _balances[recipient] = _balances[recipient].add(amount);
786         emit Transfer(sender, recipient, amount);
787     }
788 
789     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
790      * the total supply.
791      *
792      * Emits a {Transfer} event with `from` set to the zero address.
793      *
794      * Requirements
795      *
796      * - `to` cannot be the zero address.
797      */
798     function _mint(address account, uint256 amount) internal virtual {
799         require(account != address(0), "ERC20: mint to the zero address");
800 
801         _beforeTokenTransfer(address(0), account, amount);
802 
803         _totalSupply = _totalSupply.add(amount);
804         _balances[account] = _balances[account].add(amount);
805         emit Transfer(address(0), account, amount);
806     }
807 
808     /**
809      * @dev Destroys `amount` tokens from `account`, reducing the
810      * total supply.
811      *
812      * Emits a {Transfer} event with `to` set to the zero address.
813      *
814      * Requirements
815      *
816      * - `account` cannot be the zero address.
817      * - `account` must have at least `amount` tokens.
818      */
819     function _burn(address account, uint256 amount) internal virtual {
820         require(account != address(0), "ERC20: burn from the zero address");
821 
822         _beforeTokenTransfer(account, address(0), amount);
823 
824         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
825         _totalSupply = _totalSupply.sub(amount);
826         emit Transfer(account, address(0), amount);
827     }
828 
829     /**
830      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
831      *
832      * This internal function is equivalent to `approve`, and can be used to
833      * e.g. set automatic allowances for certain subsystems, etc.
834      *
835      * Emits an {Approval} event.
836      *
837      * Requirements:
838      *
839      * - `owner` cannot be the zero address.
840      * - `spender` cannot be the zero address.
841      */
842     function _approve(address owner, address spender, uint256 amount) internal virtual {
843         require(owner != address(0), "ERC20: approve from the zero address");
844         require(spender != address(0), "ERC20: approve to the zero address");
845 
846         _allowances[owner][spender] = amount;
847         emit Approval(owner, spender, amount);
848     }
849 
850     /**
851      * @dev Sets {decimals} to a value other than the default one of 18.
852      *
853      * WARNING: This function should only be called from the constructor. Most
854      * applications that interact with token contracts will not expect
855      * {decimals} to ever change, and may work incorrectly if it does.
856      */
857     function _setupDecimals(uint8 decimals_) internal {
858         _decimals = decimals_;
859     }
860 
861     /**
862      * @dev Hook that is called before any transfer of tokens. This includes
863      * minting and burning.
864      *
865      * Calling conditions:
866      *
867      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
868      * will be to transferred to `to`.
869      * - when `from` is zero, `amount` tokens will be minted for `to`.
870      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
871      * - `from` and `to` are never both zero.
872      *
873      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
874      */
875     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
876 }
877 
878 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
879 
880 
881 pragma solidity ^0.6.0;
882 
883 /**
884  * @dev Library for managing
885  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
886  * types.
887  *
888  * Sets have the following properties:
889  *
890  * - Elements are added, removed, and checked for existence in constant time
891  * (O(1)).
892  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
893  *
894  * ```
895  * contract Example {
896  *     // Add the library methods
897  *     using EnumerableSet for EnumerableSet.AddressSet;
898  *
899  *     // Declare a set state variable
900  *     EnumerableSet.AddressSet private mySet;
901  * }
902  * ```
903  *
904  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
905  * (`UintSet`) are supported.
906  */
907 library EnumerableSet {
908     // To implement this library for multiple types with as little code
909     // repetition as possible, we write it in terms of a generic Set type with
910     // bytes32 values.
911     // The Set implementation uses private functions, and user-facing
912     // implementations (such as AddressSet) are just wrappers around the
913     // underlying Set.
914     // This means that we can only create new EnumerableSets for types that fit
915     // in bytes32.
916 
917     struct Set {
918         // Storage of set values
919         bytes32[] _values;
920 
921         // Position of the value in the `values` array, plus 1 because index 0
922         // means a value is not in the set.
923         mapping (bytes32 => uint256) _indexes;
924     }
925 
926     /**
927      * @dev Add a value to a set. O(1).
928      *
929      * Returns true if the value was added to the set, that is if it was not
930      * already present.
931      */
932     function _add(Set storage set, bytes32 value) private returns (bool) {
933         if (!_contains(set, value)) {
934             set._values.push(value);
935             // The value is stored at length-1, but we add 1 to all indexes
936             // and use 0 as a sentinel value
937             set._indexes[value] = set._values.length;
938             return true;
939         } else {
940             return false;
941         }
942     }
943 
944     /**
945      * @dev Removes a value from a set. O(1).
946      *
947      * Returns true if the value was removed from the set, that is if it was
948      * present.
949      */
950     function _remove(Set storage set, bytes32 value) private returns (bool) {
951         // We read and store the value's index to prevent multiple reads from the same storage slot
952         uint256 valueIndex = set._indexes[value];
953 
954         if (valueIndex != 0) { // Equivalent to contains(set, value)
955             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
956             // the array, and then remove the last element (sometimes called as 'swap and pop').
957             // This modifies the order of the array, as noted in {at}.
958 
959             uint256 toDeleteIndex = valueIndex - 1;
960             uint256 lastIndex = set._values.length - 1;
961 
962             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
963             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
964 
965             bytes32 lastvalue = set._values[lastIndex];
966 
967             // Move the last value to the index where the value to delete is
968             set._values[toDeleteIndex] = lastvalue;
969             // Update the index for the moved value
970             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
971 
972             // Delete the slot where the moved value was stored
973             set._values.pop();
974 
975             // Delete the index for the deleted slot
976             delete set._indexes[value];
977 
978             return true;
979         } else {
980             return false;
981         }
982     }
983 
984     /**
985      * @dev Returns true if the value is in the set. O(1).
986      */
987     function _contains(Set storage set, bytes32 value) private view returns (bool) {
988         return set._indexes[value] != 0;
989     }
990 
991     /**
992      * @dev Returns the number of values on the set. O(1).
993      */
994     function _length(Set storage set) private view returns (uint256) {
995         return set._values.length;
996     }
997 
998    /**
999     * @dev Returns the value stored at position `index` in the set. O(1).
1000     *
1001     * Note that there are no guarantees on the ordering of values inside the
1002     * array, and it may change when more values are added or removed.
1003     *
1004     * Requirements:
1005     *
1006     * - `index` must be strictly less than {length}.
1007     */
1008     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1009         require(set._values.length > index, "EnumerableSet: index out of bounds");
1010         return set._values[index];
1011     }
1012 
1013     // AddressSet
1014 
1015     struct AddressSet {
1016         Set _inner;
1017     }
1018 
1019     /**
1020      * @dev Add a value to a set. O(1).
1021      *
1022      * Returns true if the value was added to the set, that is if it was not
1023      * already present.
1024      */
1025     function add(AddressSet storage set, address value) internal returns (bool) {
1026         return _add(set._inner, bytes32(uint256(value)));
1027     }
1028 
1029     /**
1030      * @dev Removes a value from a set. O(1).
1031      *
1032      * Returns true if the value was removed from the set, that is if it was
1033      * present.
1034      */
1035     function remove(AddressSet storage set, address value) internal returns (bool) {
1036         return _remove(set._inner, bytes32(uint256(value)));
1037     }
1038 
1039     /**
1040      * @dev Returns true if the value is in the set. O(1).
1041      */
1042     function contains(AddressSet storage set, address value) internal view returns (bool) {
1043         return _contains(set._inner, bytes32(uint256(value)));
1044     }
1045 
1046     /**
1047      * @dev Returns the number of values in the set. O(1).
1048      */
1049     function length(AddressSet storage set) internal view returns (uint256) {
1050         return _length(set._inner);
1051     }
1052 
1053    /**
1054     * @dev Returns the value stored at position `index` in the set. O(1).
1055     *
1056     * Note that there are no guarantees on the ordering of values inside the
1057     * array, and it may change when more values are added or removed.
1058     *
1059     * Requirements:
1060     *
1061     * - `index` must be strictly less than {length}.
1062     */
1063     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1064         return address(uint256(_at(set._inner, index)));
1065     }
1066 
1067 
1068     // UintSet
1069 
1070     struct UintSet {
1071         Set _inner;
1072     }
1073 
1074     /**
1075      * @dev Add a value to a set. O(1).
1076      *
1077      * Returns true if the value was added to the set, that is if it was not
1078      * already present.
1079      */
1080     function add(UintSet storage set, uint256 value) internal returns (bool) {
1081         return _add(set._inner, bytes32(value));
1082     }
1083 
1084     /**
1085      * @dev Removes a value from a set. O(1).
1086      *
1087      * Returns true if the value was removed from the set, that is if it was
1088      * present.
1089      */
1090     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1091         return _remove(set._inner, bytes32(value));
1092     }
1093 
1094     /**
1095      * @dev Returns true if the value is in the set. O(1).
1096      */
1097     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1098         return _contains(set._inner, bytes32(value));
1099     }
1100 
1101     /**
1102      * @dev Returns the number of values on the set. O(1).
1103      */
1104     function length(UintSet storage set) internal view returns (uint256) {
1105         return _length(set._inner);
1106     }
1107 
1108    /**
1109     * @dev Returns the value stored at position `index` in the set. O(1).
1110     *
1111     * Note that there are no guarantees on the ordering of values inside the
1112     * array, and it may change when more values are added or removed.
1113     *
1114     * Requirements:
1115     *
1116     * - `index` must be strictly less than {length}.
1117     */
1118     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1119         return uint256(_at(set._inner, index));
1120     }
1121 }
1122 
1123 // File: @openzeppelin\contracts\access\AccessControl.sol
1124 
1125 
1126 pragma solidity ^0.6.0;
1127 
1128 
1129 
1130 
1131 /**
1132  * @dev Contract module that allows children to implement role-based access
1133  * control mechanisms.
1134  *
1135  * Roles are referred to by their `bytes32` identifier. These should be exposed
1136  * in the external API and be unique. The best way to achieve this is by
1137  * using `public constant` hash digests:
1138  *
1139  * ```
1140  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1141  * ```
1142  *
1143  * Roles can be used to represent a set of permissions. To restrict access to a
1144  * function call, use {hasRole}:
1145  *
1146  * ```
1147  * function foo() public {
1148  *     require(hasRole(MY_ROLE, msg.sender));
1149  *     ...
1150  * }
1151  * ```
1152  *
1153  * Roles can be granted and revoked dynamically via the {grantRole} and
1154  * {revokeRole} functions. Each role has an associated admin role, and only
1155  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1156  *
1157  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1158  * that only accounts with this role will be able to grant or revoke other
1159  * roles. More complex role relationships can be created by using
1160  * {_setRoleAdmin}.
1161  *
1162  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1163  * grant and revoke this role. Extra precautions should be taken to secure
1164  * accounts that have been granted it.
1165  */
1166 abstract contract AccessControl is Context {
1167     using EnumerableSet for EnumerableSet.AddressSet;
1168     using Address for address;
1169 
1170     struct RoleData {
1171         EnumerableSet.AddressSet members;
1172         bytes32 adminRole;
1173     }
1174 
1175     mapping (bytes32 => RoleData) private _roles;
1176 
1177     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1178 
1179     /**
1180      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1181      *
1182      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1183      * {RoleAdminChanged} not being emitted signaling this.
1184      *
1185      * _Available since v3.1._
1186      */
1187     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1188 
1189     /**
1190      * @dev Emitted when `account` is granted `role`.
1191      *
1192      * `sender` is the account that originated the contract call, an admin role
1193      * bearer except when using {_setupRole}.
1194      */
1195     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1196 
1197     /**
1198      * @dev Emitted when `account` is revoked `role`.
1199      *
1200      * `sender` is the account that originated the contract call:
1201      *   - if using `revokeRole`, it is the admin role bearer
1202      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1203      */
1204     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1205 
1206     /**
1207      * @dev Returns `true` if `account` has been granted `role`.
1208      */
1209     function hasRole(bytes32 role, address account) public view returns (bool) {
1210         return _roles[role].members.contains(account);
1211     }
1212 
1213     /**
1214      * @dev Returns the number of accounts that have `role`. Can be used
1215      * together with {getRoleMember} to enumerate all bearers of a role.
1216      */
1217     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1218         return _roles[role].members.length();
1219     }
1220 
1221     /**
1222      * @dev Returns one of the accounts that have `role`. `index` must be a
1223      * value between 0 and {getRoleMemberCount}, non-inclusive.
1224      *
1225      * Role bearers are not sorted in any particular way, and their ordering may
1226      * change at any point.
1227      *
1228      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1229      * you perform all queries on the same block. See the following
1230      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1231      * for more information.
1232      */
1233     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1234         return _roles[role].members.at(index);
1235     }
1236 
1237     /**
1238      * @dev Returns the admin role that controls `role`. See {grantRole} and
1239      * {revokeRole}.
1240      *
1241      * To change a role's admin, use {_setRoleAdmin}.
1242      */
1243     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1244         return _roles[role].adminRole;
1245     }
1246 
1247     /**
1248      * @dev Grants `role` to `account`.
1249      *
1250      * If `account` had not been already granted `role`, emits a {RoleGranted}
1251      * event.
1252      *
1253      * Requirements:
1254      *
1255      * - the caller must have ``role``'s admin role.
1256      */
1257     function grantRole(bytes32 role, address account) public virtual {
1258         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1259 
1260         _grantRole(role, account);
1261     }
1262 
1263     /**
1264      * @dev Revokes `role` from `account`.
1265      *
1266      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1267      *
1268      * Requirements:
1269      *
1270      * - the caller must have ``role``'s admin role.
1271      */
1272     function revokeRole(bytes32 role, address account) public virtual {
1273         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1274 
1275         _revokeRole(role, account);
1276     }
1277 
1278     /**
1279      * @dev Revokes `role` from the calling account.
1280      *
1281      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1282      * purpose is to provide a mechanism for accounts to lose their privileges
1283      * if they are compromised (such as when a trusted device is misplaced).
1284      *
1285      * If the calling account had been granted `role`, emits a {RoleRevoked}
1286      * event.
1287      *
1288      * Requirements:
1289      *
1290      * - the caller must be `account`.
1291      */
1292     function renounceRole(bytes32 role, address account) public virtual {
1293         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1294 
1295         _revokeRole(role, account);
1296     }
1297 
1298     /**
1299      * @dev Grants `role` to `account`.
1300      *
1301      * If `account` had not been already granted `role`, emits a {RoleGranted}
1302      * event. Note that unlike {grantRole}, this function doesn't perform any
1303      * checks on the calling account.
1304      *
1305      * [WARNING]
1306      * ====
1307      * This function should only be called from the constructor when setting
1308      * up the initial roles for the system.
1309      *
1310      * Using this function in any other way is effectively circumventing the admin
1311      * system imposed by {AccessControl}.
1312      * ====
1313      */
1314     function _setupRole(bytes32 role, address account) internal virtual {
1315         _grantRole(role, account);
1316     }
1317 
1318     /**
1319      * @dev Sets `adminRole` as ``role``'s admin role.
1320      *
1321      * Emits a {RoleAdminChanged} event.
1322      */
1323     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1324         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1325         _roles[role].adminRole = adminRole;
1326     }
1327 
1328     function _grantRole(bytes32 role, address account) private {
1329         if (_roles[role].members.add(account)) {
1330             emit RoleGranted(role, account, _msgSender());
1331         }
1332     }
1333 
1334     function _revokeRole(bytes32 role, address account) private {
1335         if (_roles[role].members.remove(account)) {
1336             emit RoleRevoked(role, account, _msgSender());
1337         }
1338     }
1339 }
1340 
1341 // File: contracts\TransferAccess.sol
1342 
1343 pragma solidity ^0.6.0;
1344 
1345 
1346 
1347 contract TransferAccess is AccessControl, Ownable {
1348 
1349     bytes32 internal constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
1350     bool private _enable;
1351 
1352     constructor (bool enable) internal {
1353         _enable = enable;
1354         address msgSender = _msgSender();
1355         super._setRoleAdmin(TRANSFER_ROLE, DEFAULT_ADMIN_ROLE);
1356         super._setupRole(TRANSFER_ROLE, msgSender);
1357         super._setupRole(DEFAULT_ADMIN_ROLE, msgSender);
1358     }
1359 
1360     /**
1361      * @dev Returns true if the contract is recipient access status, and false otherwise.
1362      */
1363     function transferAccessStatus() public view returns (bool) {
1364         return _enable;
1365     }
1366 
1367     function enableTransferAccess() public onlyOwner {
1368         _enable = true;
1369     }
1370 
1371     function disableTransferAccess() public onlyOwner {
1372         _enable = false;
1373     }
1374 
1375     function hasTransferRole(address account) public view returns(bool) {
1376         return super.hasRole(TRANSFER_ROLE, account);
1377     }
1378 
1379     function setupTransferRole(address account) public onlyOwner {
1380         super._setupRole(TRANSFER_ROLE, account);
1381     }
1382 
1383     function revokeTransferRole(address account) public onlyOwner {
1384         super.revokeRole(TRANSFER_ROLE, account);
1385     }
1386 
1387     modifier transferable(address recipient, address sender) {
1388         if (_enable) {
1389             require(hasTransferRole(recipient) || hasTransferRole(sender), "TransferAccess: recipient and sender do not have the transfer role");
1390         }
1391         _;
1392     }
1393 }
1394 
1395 // File: contracts\MinterAccess.sol
1396 
1397 pragma solidity ^0.6.0;
1398 
1399 
1400 
1401 
1402 contract MinterAccess is AccessControl, Ownable {
1403 
1404     bytes32 internal constant MINTER_ROLE = keccak256("MINTER_ROLE");
1405 
1406     constructor() public {
1407         address owner = _msgSender();
1408         super._setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);
1409         super._setupRole(MINTER_ROLE, owner);
1410         super._setupRole(DEFAULT_ADMIN_ROLE, owner);
1411     }
1412 
1413     function hasMinterRole(address account) public view returns(bool) {
1414         return super.hasRole(MINTER_ROLE, account);
1415     }
1416 
1417     function setupMinterRole(address account) public onlyOwner {
1418         super._setupRole(MINTER_ROLE, account);
1419     }
1420 
1421     function revokeMinterRole(address account) public onlyOwner {
1422         super.revokeRole(MINTER_ROLE, account);
1423     }
1424 
1425     modifier onlyMinter() {
1426         require(hasMinterRole(_msgSender()), "MinterAccess: sender do not have the minter role");
1427         _;
1428     }
1429 }
1430 
1431 // File: contracts\BaseFil.sol
1432 
1433 // SPDX-License-Identifier: MIT
1434 pragma solidity ^0.6.0;
1435 
1436 
1437 
1438 
1439 
1440 //import "./EarnERC20.sol";
1441 
1442 
1443 contract BaseFil is ERC20, Pausable, Ownable, TransferAccess, MinterAccess {
1444 
1445     //holders count
1446     uint private holders;
1447 
1448     event Released(address indexed _from, address indexed _to, uint256 amount, bytes data);
1449     event Minted(address indexed _from, address indexed _to, uint256 amount);
1450 
1451     constructor (
1452         string memory name,
1453         string memory symbol,
1454         bool enableTransferAccess
1455     )
1456     ERC20(name, symbol)
1457     TransferAccess(enableTransferAccess)
1458     public {
1459 
1460     }
1461 
1462     function mint(address recipient, uint256 amount) external onlyMinter {
1463         checkNewHolder(recipient);
1464         super._mint(recipient, amount);
1465         emit Minted(address(0), recipient, amount);
1466     }
1467 
1468     /**
1469      * @dev Destroys `amount` tokens from the caller.
1470      *
1471      * See {ERC20-_burn}.
1472      */
1473     function burn(uint256 amount) public {
1474         address account = _msgSender();
1475         _burn(account, amount);
1476         checkOldHolder(account);
1477     }
1478 
1479     /**
1480      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1481      * allowance.
1482      *
1483      * See {ERC20-_burn} and {ERC20-allowance}.
1484      *
1485      * Requirements:
1486      *
1487      * - the caller must have allowance for ``accounts``'s tokens of at least
1488      * `amount`.
1489      */
1490     function burnFrom(address account, uint256 amount) public {
1491         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1492 
1493         _approve(account, _msgSender(), decreasedAllowance);
1494         _burn(account, amount);
1495         checkOldHolder(account);
1496     }
1497 
1498     /**
1499      * @dev Destroys `amount` tokens from `account`, reducing the
1500      * total supply銆?
1501      *
1502      * Emits a {Release} event with `to` set to the zero address锛?and with additional data.
1503      *
1504      * Requirements
1505      *
1506      * - `data` cannot be the empty.
1507      * - `sender` must have at least `amount` tokens.
1508      */
1509     function release(bytes memory data, uint256 amount) external {
1510         require(data.length != 0, "ERC20: release data is empty");
1511 
1512         address account = _msgSender();
1513         super._burn(account, amount);
1514         checkOldHolder(account);
1515         emit Released(account, address(0), amount, data);
1516     }
1517 
1518     /**
1519      * @dev See {IERC20-transfer}.
1520      *
1521      * Requirements:
1522      *
1523      * - `recipient` cannot be the zero address.
1524      * - the caller must have a balance of at least `amount`.
1525      */
1526     function transfer(address recipient, uint256 amount) public transferable(recipient, _msgSender()) override returns (bool) {
1527         checkNewHolder(recipient);
1528         bool res = super.transfer(recipient, amount);
1529         address account = _msgSender();
1530         checkOldHolder(account);
1531         return res;
1532     }
1533 
1534     /**
1535      * @dev See {IERC20-transferFrom}.
1536      *
1537      * Emits an {Approval} event indicating the updated allowance. This is not
1538      * required by the EIP. See the note at the beginning of {ERC20};
1539      *
1540      * Requirements:
1541      * - `sender` and `recipient` cannot be the zero address.
1542      * - `sender` must have a balance of at least `amount`.
1543      * - the caller must have allowance for ``sender``'s tokens of at least
1544      * `amount`.
1545      */
1546     function transferFrom(address sender, address recipient, uint256 amount) public transferable(recipient, sender) override returns (bool) {
1547         checkNewHolder(recipient);
1548         bool res = super.transferFrom(sender, recipient, amount);
1549         checkOldHolder(sender);
1550         return res;
1551     }
1552 
1553     function holdersCount() public view returns(uint) {
1554         return holders;
1555     }
1556 
1557     function checkNewHolder(address account) internal {
1558         uint256 b = balanceOf(account);
1559         if (b == 0) {
1560             holders ++;
1561         }
1562     }
1563 
1564     function checkOldHolder(address account) internal {
1565         uint256 b = balanceOf(account);
1566         if (b == 0) {
1567             holders --;
1568         }
1569     }
1570 
1571     /**
1572      * @dev See {ERC20-_beforeTokenTransfer}.
1573      *
1574      * Requirements:
1575      *
1576      * - the contract must not be paused.
1577      */
1578     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
1579         super._beforeTokenTransfer(from, to, amount);
1580 
1581         require(!paused(), "ERC20Pausable: token transfer while paused");
1582     }
1583 
1584     /**
1585      * @dev Called by a pauser to pause, triggers stopped state.
1586      */
1587     function pause() public onlyOwner whenNotPaused {
1588         _pause();
1589     }
1590 
1591     /**
1592      * @dev Called by a pauser to unpause, returns to normal state.
1593      */
1594     function unpause() public onlyOwner whenPaused {
1595         _unpause();
1596     }
1597 }
1598 
1599 
1600 pragma solidity ^0.6.0;
1601 
1602 contract EFIL is BaseFil {
1603 
1604     constructor() BaseFil("Ethereum FIL", "eFIL", false) public {
1605 
1606     }
1607 }