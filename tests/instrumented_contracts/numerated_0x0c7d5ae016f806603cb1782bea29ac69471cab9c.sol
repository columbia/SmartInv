1 pragma solidity ^0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17 
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
28 /**
29  * @dev Contract module which allows children to implement an emergency stop
30  * mechanism that can be triggered by an authorized account.
31  *
32  * This module is used through inheritance. It will make available the
33  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
34  * the functions of your contract. Note that they will not be pausable by
35  * simply including this module, only once the modifiers are put in place.
36  */
37 contract Pausable is Context {
38     /**
39      * @dev Emitted when the pause is triggered by `account`.
40      */
41     event Paused(address account);
42 
43     /**
44      * @dev Emitted when the pause is lifted by `account`.
45      */
46     event Unpaused(address account);
47 
48     bool private _paused;
49 
50     /**
51      * @dev Initializes the contract in unpaused state.
52      */
53     constructor () internal {
54         _paused = false;
55     }
56 
57     /**
58      * @dev Returns true if the contract is paused, and false otherwise.
59      */
60     function paused() public view returns (bool) {
61         return _paused;
62     }
63 
64     /**
65      * @dev Modifier to make a function callable only when the contract is not paused.
66      *
67      * Requirements:
68      *
69      * - The contract must not be paused.
70      */
71     modifier whenNotPaused() {
72         require(!_paused, "Pausable: paused");
73         _;
74     }
75 
76     /**
77      * @dev Modifier to make a function callable only when the contract is paused.
78      *
79      * Requirements:
80      *
81      * - The contract must be paused.
82      */
83     modifier whenPaused() {
84         require(_paused, "Pausable: not paused");
85         _;
86     }
87 
88     /**
89      * @dev Triggers stopped state.
90      *
91      * Requirements:
92      *
93      * - The contract must not be paused.
94      */
95     function _pause() internal virtual whenNotPaused {
96         _paused = true;
97         emit Paused(_msgSender());
98     }
99 
100     /**
101      * @dev Returns to normal state.
102      *
103      * Requirements:
104      *
105      * - The contract must be paused.
106      */
107     function _unpause() internal virtual whenPaused {
108         _paused = false;
109         emit Unpaused(_msgSender());
110     }
111 }
112 
113 
114 
115 
116 // SPDX-License-Identifier: MIT
117 
118 /**
119  * @dev Contract module which provides a basic access control mechanism, where
120  * there is an account (an owner) that can be granted exclusive access to
121  * specific functions.
122  *
123  * By default, the owner account will be the one that deploys the contract. This
124  * can later be changed with {transferOwnership}.
125  *
126  * This module is used through inheritance. It will make available the modifier
127  * `onlyOwner`, which can be applied to your functions to restrict their use to
128  * the owner.
129  */
130 contract Ownable is Context {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     constructor () internal {
139         address msgSender = _msgSender();
140         _owner = msgSender;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(_owner == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         emit OwnershipTransferred(_owner, newOwner);
178         _owner = newOwner;
179     }
180 }
181 
182 
183 /**
184  * @dev Interface of the ERC20 standard as defined in the EIP.
185  */
186 interface IERC20 {
187     /**
188      * @dev Returns the amount of tokens in existence.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns the amount of tokens owned by `account`.
194      */
195     function balanceOf(address account) external view returns (uint256);
196 
197     /**
198      * @dev Moves `amount` tokens from the caller's account to `recipient`.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transfer(address recipient, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Returns the remaining number of tokens that `spender` will be
208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
209      * zero by default.
210      *
211      * This value changes when {approve} or {transferFrom} are called.
212      */
213     function allowance(address owner, address spender) external view returns (uint256);
214 
215     /**
216      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * IMPORTANT: Beware that changing an allowance with this method brings the risk
221      * that someone may use both the old and the new allowance by unfortunate
222      * transaction ordering. One possible solution to mitigate this race
223      * condition is to first reduce the spender's allowance to 0 and set the
224      * desired value afterwards:
225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address spender, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Moves `amount` tokens from `sender` to `recipient` using the
233      * allowance mechanism. `amount` is then deducted from the caller's
234      * allowance.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a {Transfer} event.
239      */
240     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Emitted when `value` tokens are moved from one account (`from`) to
244      * another (`to`).
245      *
246      * Note that `value` may be zero.
247      */
248     event Transfer(address indexed from, address indexed to, uint256 value);
249 
250     /**
251      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
252      * a call to {approve}. `value` is the new allowance.
253      */
254     event Approval(address indexed owner, address indexed spender, uint256 value);
255 }
256 
257 
258 
259 /**
260  * @dev Wrappers over Solidity's arithmetic operations with added overflow
261  * checks.
262  *
263  * Arithmetic operations in Solidity wrap on overflow. This can easily result
264  * in bugs, because programmers usually assume that an overflow raises an
265  * error, which is the standard behavior in high level programming languages.
266  * `SafeMath` restores this intuition by reverting the transaction when an
267  * operation overflows.
268  *
269  * Using this library instead of the unchecked operations eliminates an entire
270  * class of bugs, so it's recommended to use it always.
271  */
272 library SafeMath {
273     /**
274      * @dev Returns the addition of two unsigned integers, reverting on
275      * overflow.
276      *
277      * Counterpart to Solidity's `+` operator.
278      *
279      * Requirements:
280      * - Addition cannot overflow.
281      */
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         uint256 c = a + b;
284         require(c >= a, "SafeMath: addition overflow");
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the subtraction of two unsigned integers, reverting on
291      * overflow (when the result is negative).
292      *
293      * Counterpart to Solidity's `-` operator.
294      *
295      * Requirements:
296      * - Subtraction cannot overflow.
297      */
298     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
299         return sub(a, b, "SafeMath: subtraction overflow");
300     }
301 
302     /**
303      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
304      * overflow (when the result is negative).
305      *
306      * Counterpart to Solidity's `-` operator.
307      *
308      * Requirements:
309      * - Subtraction cannot overflow.
310      */
311     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         require(b <= a, errorMessage);
313         uint256 c = a - b;
314 
315         return c;
316     }
317 
318     /**
319      * @dev Returns the multiplication of two unsigned integers, reverting on
320      * overflow.
321      *
322      * Counterpart to Solidity's `*` operator.
323      *
324      * Requirements:
325      * - Multiplication cannot overflow.
326      */
327     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
328         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
329         // benefit is lost if 'b' is also tested.
330         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
331         if (a == 0) {
332             return 0;
333         }
334 
335         uint256 c = a * b;
336         require(c / a == b, "SafeMath: multiplication overflow");
337 
338         return c;
339     }
340 
341     /**
342      * @dev Returns the integer division of two unsigned integers. Reverts on
343      * division by zero. The result is rounded towards zero.
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      * - The divisor cannot be zero.
351      */
352     function div(uint256 a, uint256 b) internal pure returns (uint256) {
353         return div(a, b, "SafeMath: division by zero");
354     }
355 
356     /**
357      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
358      * division by zero. The result is rounded towards zero.
359      *
360      * Counterpart to Solidity's `/` operator. Note: this function uses a
361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
362      * uses an invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      * - The divisor cannot be zero.
366      */
367     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
368         // Solidity only automatically asserts when dividing by 0
369         require(b > 0, errorMessage);
370         uint256 c = a / b;
371         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
372 
373         return c;
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
378      * Reverts when dividing by zero.
379      *
380      * Counterpart to Solidity's `%` operator. This function uses a `revert`
381      * opcode (which leaves remaining gas untouched) while Solidity uses an
382      * invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      * - The divisor cannot be zero.
386      */
387     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
388         return mod(a, b, "SafeMath: modulo by zero");
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * Reverts with custom message when dividing by zero.
394      *
395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
396      * opcode (which leaves remaining gas untouched) while Solidity uses an
397      * invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      * - The divisor cannot be zero.
401      */
402     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
403         require(b != 0, errorMessage);
404         return a % b;
405     }
406 }
407 
408 
409 pragma solidity ^0.6.0;
410 
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * [IMPORTANT]
419      * ====
420      * It is unsafe to assume that an address for which this function returns
421      * false is an externally-owned account (EOA) and not a contract.
422      *
423      * Among others, `isContract` will return false for the following
424      * types of addresses:
425      *
426      *  - an externally-owned account
427      *  - a contract in construction
428      *  - an address where a contract will be created
429      *  - an address where a contract lived, but was destroyed
430      * ====
431      */
432     function isContract(address account) internal view returns (bool) {
433         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
434         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
435         // for accounts without code, i.e. `keccak256('')`
436         bytes32 codehash;
437         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
438         // solhint-disable-next-line no-inline-assembly
439         assembly { codehash := extcodehash(account) }
440         return (codehash != accountHash && codehash != 0x0);
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      */
459     function sendValue(address payable recipient, uint256 amount) internal {
460         require(address(this).balance >= amount, "Address: insufficient balance");
461 
462         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
463         (bool success, ) = recipient.call.value(amount)("");
464         require(success, "Address: unable to send value, recipient may have reverted");
465     }
466 }
467 
468 
469 
470 /**
471  * @dev Implementation of the {IERC20} interface.
472  *
473  * This implementation is agnostic to the way tokens are created.
474  *
475  * TIP: For a detailed writeup see our guide
476  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
477  * to implement supply mechanisms].
478  *
479  * We have followed general OpenZeppelin guidelines: functions revert instead
480  * of returning `false` on failure. This behavior is nonetheless conventional
481  * and does not conflict with the expectations of ERC20 applications.
482  *
483  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
484  * This allows applications to reconstruct the allowance for all accounts just
485  * by listening to said events. Other implementations of the EIP may not emit
486  * these events, as it isn't required by the specification.
487  *
488  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
489  * functions have been added to mitigate the well-known issues around setting
490  * allowances. See {IERC20-approve}.
491  */
492 contract ERC20 is Context, IERC20, Pausable, Ownable {
493     using SafeMath for uint256;
494     using Address for address;
495 
496     mapping (address => uint256) private _balances;
497 
498     mapping (address => mapping (address => uint256)) private _allowances;
499 
500     uint256 private _totalSupply;
501     string private constant _name = "Bifrost";
502     string private constant _symbol = "BFC";
503     uint8 private constant _decimals = 18;
504 
505 
506     /**
507      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
508      * a default value of 18.
509      *
510      * To select a different value for {decimals}, use {_setupDecimals}.
511      *
512      * All three of these values are immutable: they can only be set once during
513      * construction.
514      */
515 
516 
517     constructor () public {
518         _totalSupply = 4 * (10 ** 9) * (10 ** uint256(_decimals));
519         _balances[msg.sender] = _totalSupply;
520     }
521 
522     /**
523      * @dev Returns the name of the token.
524      */
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     /**
530      * @dev Returns the symbol of the token, usually a shorter version of the
531      * name.
532      */
533     function symbol() public view returns (string memory) {
534         return _symbol;
535     }
536 
537     /**
538      * @dev Returns the number of decimals used to get its user representation.
539      * For example, if `decimals` equals `2`, a balance of `505` tokens should
540      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
541      *
542      * Tokens usually opt for a value of 18, imitating the relationship between
543      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
544      * called.
545      *
546      * NOTE: This information is only used for _display_ purposes: it in
547      * no way affects any of the arithmetic of the contract, including
548      * {IERC20-balanceOf} and {IERC20-transfer}.
549      */
550     function decimals() public view returns (uint8) {
551         return _decimals;
552     }
553 
554     /**
555      * @dev See {IERC20-totalSupply}.
556      */
557     function totalSupply() public view override returns (uint256) {
558         return _totalSupply;
559     }
560 
561     /**
562      * @dev See {IERC20-balanceOf}.
563      */
564     function balanceOf(address account) public view override returns (uint256) {
565         return _balances[account];
566     }
567 
568     /**
569      * @dev See {IERC20-transfer}.
570      *
571      * Requirements:
572      *
573      * - `recipient` cannot be the zero address.
574      * - the caller must have a balance of at least `amount`.
575      */
576     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
577         _transfer(_msgSender(), recipient, amount);
578         return true;
579     }
580 
581     /**
582      * @dev See {IERC20-allowance}.
583      */
584     function allowance(address owner, address spender) public view virtual override returns (uint256) {
585         return _allowances[owner][spender];
586     }
587 
588     /**
589      * @dev See {IERC20-approve}.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      */
595     function approve(address spender, uint256 amount) public virtual override returns (bool) {
596         _approve(_msgSender(), spender, amount);
597         return true;
598     }
599 
600     /**
601      * @dev See {IERC20-transferFrom}.
602      *
603      * Emits an {Approval} event indicating the updated allowance. This is not
604      * required by the EIP. See the note at the beginning of {ERC20};
605      *
606      * Requirements:
607      * - `sender` and `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      * - the caller must have allowance for ``sender``'s tokens of at least
610      * `amount`.
611      */
612     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
613         _transfer(sender, recipient, amount);
614         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
615         return true;
616     }
617 
618     /**
619      * @dev Atomically increases the allowance granted to `spender` by the caller.
620      *
621      * This is an alternative to {approve} that can be used as a mitigation for
622      * problems described in {IERC20-approve}.
623      *
624      * Emits an {Approval} event indicating the updated allowance.
625      *
626      * Requirements:
627      *
628      * - `spender` cannot be the zero address.
629      */
630     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
631         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
632         return true;
633     }
634 
635     /**
636      * @dev Atomically decreases the allowance granted to `spender` by the caller.
637      *
638      * This is an alternative to {approve} that can be used as a mitigation for
639      * problems described in {IERC20-approve}.
640      *
641      * Emits an {Approval} event indicating the updated allowance.
642      *
643      * Requirements:
644      *
645      * - `spender` cannot be the zero address.
646      * - `spender` must have allowance for the caller of at least
647      * `subtractedValue`.
648      */
649     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
650         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
651         return true;
652     }
653 
654     /**
655      * @dev Moves tokens `amount` from `sender` to `recipient`.
656      *
657      * This is internal function is equivalent to {transfer}, and can be used to
658      * e.g. implement automatic token fees, slashing mechanisms, etc.
659      *
660      * Emits a {Transfer} event.
661      *
662      * Requirements:
663      *
664      * - `sender` cannot be the zero address.
665      * - `recipient` cannot be the zero address.
666      * - `sender` must have a balance of at least `amount`.
667      */
668     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
669         require(sender != address(0), "ERC20: transfer from the zero address");
670         require(recipient != address(0), "ERC20: transfer to the zero address");
671 
672         _beforeTokenTransfer(sender, recipient, amount);
673 
674         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
675         _balances[recipient] = _balances[recipient].add(amount);
676         emit Transfer(sender, recipient, amount);
677     }
678 
679     /**
680      * @dev Destroys `amount` tokens from `account`, reducing the
681      * total supply.
682      *
683      * Emits a {Transfer} event with `to` set to the zero address.
684      *
685      * Requirements
686      *
687      * - `account` cannot be the zero address.
688      * - `account` must have at least `amount` tokens.
689      */
690     function _burn(address account, uint256 amount) internal virtual {
691         require(account != address(0), "ERC20: burn from the zero address");
692 
693         _beforeTokenTransfer(account, address(0), amount);
694 
695         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
696         _totalSupply = _totalSupply.sub(amount);
697         emit Transfer(account, address(0), amount);
698     }
699 
700     /**
701      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
702      *
703      * This is internal function is equivalent to `approve`, and can be used to
704      * e.g. set automatic allowances for certain subsystems, etc.
705      *
706      * Emits an {Approval} event.
707      *
708      * Requirements:
709      *
710      * - `owner` cannot be the zero address.
711      * - `spender` cannot be the zero address.
712      */
713     function _approve(address owner, address spender, uint256 amount) internal virtual {
714         require(owner != address(0), "ERC20: approve from the zero address");
715         require(spender != address(0), "ERC20: approve to the zero address");
716 
717         _allowances[owner][spender] = amount;
718         emit Approval(owner, spender, amount);
719     }
720 
721 
722     /**
723      * @dev Destroys `amount` tokens from the caller.
724      *
725      * See {ERC20-_burn}.
726      */
727     function burn(uint256 amount) public virtual {
728         _burn(_msgSender(), amount);
729     }
730 
731 
732     /**
733      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
734      * allowance.
735      *
736      * See {ERC20-_burn} and {ERC20-allowance}.
737      *
738      * Requirements:
739      *
740      * - the caller must have allowance for ``accounts``'s tokens of at least
741      * `amount`.
742      */
743     function burnFrom(address account, uint256 amount) public virtual {
744         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
745 
746         _approve(account, _msgSender(), decreasedAllowance);
747         _burn(account, amount);
748     }
749 
750 
751 
752     /**
753      * @dev Triggers stopped state.
754      *
755      * Requirements:
756      *
757      * - The contract must not be paused.
758      */
759 
760     function pause() public onlyOwner {
761         _pause();
762     }
763 
764 
765     /**
766      * @dev Returns to normal state.
767      *
768      * Requirements:
769      *
770      * - The contract must be paused.
771      */
772     function unpause() public onlyOwner {
773         _unpause();
774     }
775 
776     /**
777      * @dev Hook that is called before any transfer of tokens. This includes
778      * burning.
779      *
780      * Calling conditions:
781      *
782      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
783      * will be to transferred to `to`.
784      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
785      * - `from` and `to` are never both zero.
786      *
787      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
788      */
789     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
790         require(!paused(), "ERC20Pausable: token transfer while paused");
791     }
792 }