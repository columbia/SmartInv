1 pragma solidity ^0.5.0;
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
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 /**
31  * @dev Wrappers over Solidity's arithmetic operations with added overflow
32  * checks.
33  *
34  * Arithmetic operations in Solidity wrap on overflow. This can easily result
35  * in bugs, because programmers usually assume that an overflow raises an
36  * error, which is the standard behavior in high level programming languages.
37  * `SafeMath` restores this intuition by reverting the transaction when an
38  * operation overflows.
39  *
40  * Using this library instead of the unchecked operations eliminates an entire
41  * class of bugs, so it's recommended to use it always.
42  */
43 library SafeMath {
44     /**
45      * @dev Returns the addition of two unsigned integers, reverting on
46      * overflow.
47      *
48      * Counterpart to Solidity's `+` operator.
49      *
50      * Requirements:
51      * - Addition cannot overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      * - Subtraction cannot overflow.
81      *
82      * _Available since v2.4.0._
83      */
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `*` operator.
96      *
97      * Requirements:
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      *
140      * _Available since v2.4.0._
141      */
142     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         // Solidity only automatically asserts when dividing by 0
144         require(b > 0, errorMessage);
145         uint256 c = a / b;
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return mod(a, b, "SafeMath: modulo by zero");
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts with custom message when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      *
177      * _Available since v2.4.0._
178      */
179     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b != 0, errorMessage);
181         return a % b;
182     }
183 }
184 
185 
186 /**
187  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
188  * the optional functions; to access them see {ERC20Detailed}.
189  */
190 interface IERC20 {
191     /**
192      * @dev Returns the amount of tokens in existence.
193      */
194     function totalSupply() external view returns (uint256);
195 
196     /**
197      * @dev Returns the amount of tokens owned by `account`.
198      */
199     function balanceOf(address account) external view returns (uint256);
200 
201     /**
202      * @dev Moves `amount` tokens from the caller's account to `recipient`.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transfer(address recipient, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Returns the remaining number of tokens that `spender` will be
212      * allowed to spend on behalf of `owner` through {transferFrom}. This is
213      * zero by default.
214      *
215      * This value changes when {approve} or {transferFrom} are called.
216      */
217     function allowance(address owner, address spender) external view returns (uint256);
218 
219     /**
220      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * IMPORTANT: Beware that changing an allowance with this method brings the risk
225      * that someone may use both the old and the new allowance by unfortunate
226      * transaction ordering. One possible solution to mitigate this race
227      * condition is to first reduce the spender's allowance to 0 and set the
228      * desired value afterwards:
229      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230      *
231      * Emits an {Approval} event.
232      */
233     function approve(address spender, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Moves `amount` tokens from `sender` to `recipient` using the
237      * allowance mechanism. `amount` is then deducted from the caller's
238      * allowance.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Emitted when `value` tokens are moved from one account (`from`) to
248      * another (`to`).
249      *
250      * Note that `value` may be zero.
251      */
252     event Transfer(address indexed from, address indexed to, uint256 value);
253 
254     /**
255      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
256      * a call to {approve}. `value` is the new allowance.
257      */
258     event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 
262 
263 
264 
265 
266 
267 
268 /**
269  * @dev Implementation of the {IERC20} interface.
270  *
271  * This implementation is agnostic to the way tokens are created. This means
272  * that a supply mechanism has to be added in a derived contract using {_mint}.
273  * For a generic mechanism see {ERC20Mintable}.
274  *
275  * TIP: For a detailed writeup see our guide
276  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
277  * to implement supply mechanisms].
278  *
279  * We have followed general OpenZeppelin guidelines: functions revert instead
280  * of returning `false` on failure. This behavior is nonetheless conventional
281  * and does not conflict with the expectations of ERC20 applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20 {
293     using SafeMath for uint256;
294 
295     mapping (address => uint256) private _balances;
296 
297     mapping (address => mapping (address => uint256)) private _allowances;
298 
299     uint256 private _totalSupply;
300 
301     /**
302      * @dev See {IERC20-totalSupply}.
303      */
304     function totalSupply() public view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     /**
309      * @dev See {IERC20-balanceOf}.
310      */
311     function balanceOf(address account) public view returns (uint256) {
312         return _balances[account];
313     }
314 
315     /**
316      * @dev See {IERC20-transfer}.
317      *
318      * Requirements:
319      *
320      * - `recipient` cannot be the zero address.
321      * - the caller must have a balance of at least `amount`.
322      */
323     function transfer(address recipient, uint256 amount) public returns (bool) {
324         _transfer(_msgSender(), recipient, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {IERC20-approve}.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      */
342     function approve(address spender, uint256 amount) public returns (bool) {
343         _approve(_msgSender(), spender, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-transferFrom}.
349      *
350      * Emits an {Approval} event indicating the updated allowance. This is not
351      * required by the EIP. See the note at the beginning of {ERC20};
352      *
353      * Requirements:
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for `sender`'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
360         _transfer(sender, recipient, amount);
361         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {IERC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
379         return true;
380     }
381 
382     /**
383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      * - `spender` must have allowance for the caller of at least
394      * `subtractedValue`.
395      */
396     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
397         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
398         return true;
399     }
400 
401     /**
402      * @dev Moves tokens `amount` from `sender` to `recipient`.
403      *
404      * This is internal function is equivalent to {transfer}, and can be used to
405      * e.g. implement automatic token fees, slashing mechanisms, etc.
406      *
407      * Emits a {Transfer} event.
408      *
409      * Requirements:
410      *
411      * - `sender` cannot be the zero address.
412      * - `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      */
415     function _transfer(address sender, address recipient, uint256 amount) internal {
416         require(sender != address(0), "ERC20: transfer from the zero address");
417         require(recipient != address(0), "ERC20: transfer to the zero address");
418 
419         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422     }
423 
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a {Transfer} event with `from` set to the zero address.
428      *
429      * Requirements
430      *
431      * - `to` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal {
434         require(account != address(0), "ERC20: mint to the zero address");
435 
436         _totalSupply = _totalSupply.add(amount);
437         _balances[account] = _balances[account].add(amount);
438         emit Transfer(address(0), account, amount);
439     }
440 
441     /**
442      * @dev Destroys `amount` tokens from `account`, reducing the
443      * total supply.
444      *
445      * Emits a {Transfer} event with `to` set to the zero address.
446      *
447      * Requirements
448      *
449      * - `account` cannot be the zero address.
450      * - `account` must have at least `amount` tokens.
451      */
452     function _burn(address account, uint256 amount) internal {
453         require(account != address(0), "ERC20: burn from the zero address");
454 
455         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
456         _totalSupply = _totalSupply.sub(amount);
457         emit Transfer(account, address(0), amount);
458     }
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
462      *
463      * This is internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an {Approval} event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(address owner, address spender, uint256 amount) internal {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = amount;
478         emit Approval(owner, spender, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
483      * from the caller's allowance.
484      *
485      * See {_burn} and {_approve}.
486      */
487     function _burnFrom(address account, uint256 amount) internal {
488         _burn(account, amount);
489         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
490     }
491 }
492 
493 
494 
495 
496 
497 /**
498  * @dev Optional functions from the ERC20 standard.
499  */
500 contract ERC20Detailed is IERC20 {
501     string private _name;
502     string private _symbol;
503     uint8 private _decimals;
504 
505     /**
506      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
507      * these values are immutable: they can only be set once during
508      * construction.
509      */
510     constructor (string memory name, string memory symbol, uint8 decimals) public {
511         _name = name;
512         _symbol = symbol;
513         _decimals = decimals;
514     }
515 
516     /**
517      * @dev Returns the name of the token.
518      */
519     function name() public view returns (string memory) {
520         return _name;
521     }
522 
523     /**
524      * @dev Returns the symbol of the token, usually a shorter version of the
525      * name.
526      */
527     function symbol() public view returns (string memory) {
528         return _symbol;
529     }
530 
531     /**
532      * @dev Returns the number of decimals used to get its user representation.
533      * For example, if `decimals` equals `2`, a balance of `505` tokens should
534      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
535      *
536      * Tokens usually opt for a value of 18, imitating the relationship between
537      * Ether and Wei.
538      *
539      * NOTE: This information is only used for _display_ purposes: it in
540      * no way affects any of the arithmetic of the contract, including
541      * {IERC20-balanceOf} and {IERC20-transfer}.
542      */
543     function decimals() public view returns (uint8) {
544         return _decimals;
545     }
546 }
547 
548 
549 
550 
551 
552 
553 
554 
555 
556 
557 
558 
559 contract PauserRole is Context {
560     using Roles for Roles.Role;
561 
562     event PauserAdded(address indexed account);
563     event PauserRemoved(address indexed account);
564 
565     Roles.Role private _pausers;
566 
567     constructor () internal {
568         _addPauser(_msgSender());
569     }
570 
571     modifier onlyPauser() {
572         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
573         _;
574     }
575 
576     function isPauser(address account) public view returns (bool) {
577         return _pausers.has(account);
578     }
579 
580     function addPauser(address account) public onlyPauser {
581         _addPauser(account);
582     }
583 
584     function renouncePauser() public {
585         _removePauser(_msgSender());
586     }
587 
588     function _addPauser(address account) internal {
589         _pausers.add(account);
590         emit PauserAdded(account);
591     }
592 
593     function _removePauser(address account) internal {
594         _pausers.remove(account);
595         emit PauserRemoved(account);
596     }
597 }
598 
599 
600 /**
601  * @dev Contract module which allows children to implement an emergency stop
602  * mechanism that can be triggered by an authorized account.
603  *
604  * This module is used through inheritance. It will make available the
605  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
606  * the functions of your contract. Note that they will not be pausable by
607  * simply including this module, only once the modifiers are put in place.
608  */
609 contract Pausable is Context, PauserRole {
610     /**
611      * @dev Emitted when the pause is triggered by a pauser (`account`).
612      */
613     event Paused(address account);
614 
615     /**
616      * @dev Emitted when the pause is lifted by a pauser (`account`).
617      */
618     event Unpaused(address account);
619 
620     bool private _paused;
621 
622     /**
623      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
624      * to the deployer.
625      */
626     constructor () internal {
627         _paused = false;
628     }
629 
630     /**
631      * @dev Returns true if the contract is paused, and false otherwise.
632      */
633     function paused() public view returns (bool) {
634         return _paused;
635     }
636 
637     /**
638      * @dev Modifier to make a function callable only when the contract is not paused.
639      */
640     modifier whenNotPaused() {
641         require(!_paused, "Pausable: paused");
642         _;
643     }
644 
645     /**
646      * @dev Modifier to make a function callable only when the contract is paused.
647      */
648     modifier whenPaused() {
649         require(_paused, "Pausable: not paused");
650         _;
651     }
652 
653     /**
654      * @dev Called by a pauser to pause, triggers stopped state.
655      */
656     function pause() public onlyPauser whenNotPaused {
657         _paused = true;
658         emit Paused(_msgSender());
659     }
660 
661     /**
662      * @dev Called by a pauser to unpause, returns to normal state.
663      */
664     function unpause() public onlyPauser whenPaused {
665         _paused = false;
666         emit Unpaused(_msgSender());
667     }
668 }
669 
670 
671 /**
672  * @title Pausable token
673  * @dev ERC20 with pausable transfers and allowances.
674  *
675  * Useful if you want to stop trades until the end of a crowdsale, or have
676  * an emergency switch for freezing all token transfers in the event of a large
677  * bug.
678  */
679 contract ERC20Pausable is ERC20, Pausable {
680     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
681         return super.transfer(to, value);
682     }
683 
684     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
685         return super.transferFrom(from, to, value);
686     }
687 
688     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
689         return super.approve(spender, value);
690     }
691 
692     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
693         return super.increaseAllowance(spender, addedValue);
694     }
695 
696     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
697         return super.decreaseAllowance(spender, subtractedValue);
698     }
699 }
700 
701 
702 
703 
704 
705 
706 
707 /**
708  * @dev Collection of functions related to the address type
709  */
710 library Address {
711     /**
712      * @dev Returns true if `account` is a contract.
713      *
714      * [IMPORTANT]
715      * ====
716      * It is unsafe to assume that an address for which this function returns
717      * false is an externally-owned account (EOA) and not a contract.
718      *
719      * Among others, `isContract` will return false for the following 
720      * types of addresses:
721      *
722      *  - an externally-owned account
723      *  - a contract in construction
724      *  - an address where a contract will be created
725      *  - an address where a contract lived, but was destroyed
726      * ====
727      */
728     function isContract(address account) internal view returns (bool) {
729         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
730         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
731         // for accounts without code, i.e. `keccak256('')`
732         bytes32 codehash;
733         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
734         // solhint-disable-next-line no-inline-assembly
735         assembly { codehash := extcodehash(account) }
736         return (codehash != accountHash && codehash != 0x0);
737     }
738 
739     /**
740      * @dev Converts an `address` into `address payable`. Note that this is
741      * simply a type cast: the actual underlying value is not changed.
742      *
743      * _Available since v2.4.0._
744      */
745     function toPayable(address account) internal pure returns (address payable) {
746         return address(uint160(account));
747     }
748 
749     /**
750      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
751      * `recipient`, forwarding all available gas and reverting on errors.
752      *
753      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
754      * of certain opcodes, possibly making contracts go over the 2300 gas limit
755      * imposed by `transfer`, making them unable to receive funds via
756      * `transfer`. {sendValue} removes this limitation.
757      *
758      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
759      *
760      * IMPORTANT: because control is transferred to `recipient`, care must be
761      * taken to not create reentrancy vulnerabilities. Consider using
762      * {ReentrancyGuard} or the
763      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
764      *
765      * _Available since v2.4.0._
766      */
767     function sendValue(address payable recipient, uint256 amount) internal {
768         require(address(this).balance >= amount, "Address: insufficient balance");
769 
770         // solhint-disable-next-line avoid-call-value
771         (bool success, ) = recipient.call.value(amount)("");
772         require(success, "Address: unable to send value, recipient may have reverted");
773     }
774 }
775 
776 
777 /**
778  * @title SafeERC20
779  * @dev Wrappers around ERC20 operations that throw on failure (when the token
780  * contract returns false). Tokens that return no value (and instead revert or
781  * throw on failure) are also supported, non-reverting calls are assumed to be
782  * successful.
783  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
784  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
785  */
786 library SafeERC20 {
787     using SafeMath for uint256;
788     using Address for address;
789 
790     function safeTransfer(IERC20 token, address to, uint256 value) internal {
791         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
792     }
793 
794     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
795         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
796     }
797 
798     function safeApprove(IERC20 token, address spender, uint256 value) internal {
799         // safeApprove should only be called when setting an initial allowance,
800         // or when resetting it to zero. To increase and decrease it, use
801         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
802         // solhint-disable-next-line max-line-length
803         require((value == 0) || (token.allowance(address(this), spender) == 0),
804             "SafeERC20: approve from non-zero to non-zero allowance"
805         );
806         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
807     }
808 
809     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
810         uint256 newAllowance = token.allowance(address(this), spender).add(value);
811         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
812     }
813 
814     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
815         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
816         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
817     }
818 
819     /**
820      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
821      * on the return value: the return value is optional (but if data is returned, it must not be false).
822      * @param token The token targeted by the call.
823      * @param data The call data (encoded using abi.encode or one of its variants).
824      */
825     function callOptionalReturn(IERC20 token, bytes memory data) private {
826         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
827         // we're implementing it ourselves.
828 
829         // A Solidity high level call has three parts:
830         //  1. The target address is checked to verify it contains contract code
831         //  2. The call itself is made, and success asserted
832         //  3. The return value is decoded, which in turn checks the size of the returned data.
833         // solhint-disable-next-line max-line-length
834         require(address(token).isContract(), "SafeERC20: call to non-contract");
835 
836         // solhint-disable-next-line avoid-low-level-calls
837         (bool success, bytes memory returndata) = address(token).call(data);
838         require(success, "SafeERC20: low-level call failed");
839 
840         if (returndata.length > 0) { // Return data is optional
841             // solhint-disable-next-line max-line-length
842             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
843         }
844     }
845 }
846 
847 
848 
849 
850 
851 
852 /**
853  * @title Roles
854  * @dev Library for managing addresses assigned to a Role.
855  */
856 library Roles {
857     struct Role {
858         mapping (address => bool) bearer;
859     }
860 
861     /**
862      * @dev Give an account access to this role.
863      */
864     function add(Role storage role, address account) internal {
865         require(!has(role, account), "Roles: account already has role");
866         role.bearer[account] = true;
867     }
868 
869     /**
870      * @dev Remove an account's access to this role.
871      */
872     function remove(Role storage role, address account) internal {
873         require(has(role, account), "Roles: account does not have role");
874         role.bearer[account] = false;
875     }
876 
877     /**
878      * @dev Check if an account has this role.
879      * @return bool
880      */
881     function has(Role storage role, address account) internal view returns (bool) {
882         require(account != address(0), "Roles: account is the zero address");
883         return role.bearer[account];
884     }
885 }
886 
887 
888 contract MinterRole is Context {
889     using Roles for Roles.Role;
890 
891     event MinterAdded(address indexed account);
892     event MinterRemoved(address indexed account);
893 
894     Roles.Role private _minters;
895 
896     constructor () internal {
897         _addMinter(_msgSender());
898     }
899 
900     modifier onlyMinter() {
901         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
902         _;
903     }
904 
905     function isMinter(address account) public view returns (bool) {
906         return _minters.has(account);
907     }
908 
909     function addMinter(address account) public onlyMinter {
910         _addMinter(account);
911     }
912 
913     function renounceMinter() public {
914         _removeMinter(_msgSender());
915     }
916 
917     function _addMinter(address account) internal {
918         _minters.add(account);
919         emit MinterAdded(account);
920     }
921 
922     function _removeMinter(address account) internal {
923         _minters.remove(account);
924         emit MinterRemoved(account);
925     }
926 }
927 
928 
929 
930 
931 
932 
933 contract OwnerRole is Context {
934     using Roles for Roles.Role;
935 
936     event OwnerAdded(address indexed account);
937     event OwnerRemoved(address indexed account);
938 
939     Roles.Role private _owners;
940 
941     constructor () internal {
942         _addOwner(_msgSender());
943     }
944 
945     modifier onlyOwner() {
946         require(isOwner(_msgSender()), "OwnerRole: caller does not have the Owner role");
947         _;
948     }
949 
950     function isOwner(address account) public view returns (bool) {
951         return _owners.has(account);
952     }
953 
954     function addOwner(address account) public onlyOwner {
955         _addOwner(account);
956     }
957 
958     function renounceOwner() public {
959         _removeOwner(_msgSender());
960     }
961 
962     function _addOwner(address account) internal {
963         _owners.add(account);
964         emit OwnerAdded(account);
965     }
966 
967     function _removeOwner(address account) internal {
968         _owners.remove(account);
969         emit OwnerRemoved(account);
970     }
971 }
972 
973 
974 contract WrappedADS is ERC20, ERC20Detailed, ERC20Pausable, OwnerRole, MinterRole {
975     using SafeMath for uint256;
976     using SafeERC20 for IERC20;
977 
978     mapping (address => uint256) private _minterAllowances;
979 
980     constructor () public ERC20Detailed("Adshares", "ADS", 11) {
981 
982     }
983 
984     /**
985      *  Wraps received native ADS tokens and mint wrapped tokens. Logs native tx sender and id.
986      */
987     function wrapTo(address account, uint256 amount, uint64 from, uint64 txid) public onlyMinter whenNotPaused returns (bool) {
988         _checksumCheck(from);
989         emit Wrap(account, from, txid, amount);
990         _mint(account, amount);
991         _minterApprove(_msgSender(), _minterAllowances[_msgSender()].sub(amount, "WrappedADS: minted amount exceeds minterAllowance"));
992         return true;
993     }
994 
995     /**
996      * Unwrap and destroy `amount` tokens from the caller. Logs native ADS address to receive unwrapped tokens.
997      *
998      */
999     function unwrap(uint256 amount, uint64 to) public whenNotPaused {
1000         _unwrap(amount, to, 0);
1001     }
1002 
1003     /**
1004      * Unwrap and destroy `amount` tokens from the caller. Logs native ADS address to receive unwrapped tokens.
1005      *
1006      */
1007     function unwrapMessage(uint256 amount, uint64 to, uint128 message) public whenNotPaused {
1008         _unwrap(amount, to, message);
1009     }
1010 
1011     function _unwrap(uint256 amount, uint64 to, uint128 message) internal {
1012         _checksumCheck(to);
1013         emit Unwrap(_msgSender(), to, amount, message);
1014         _burn(_msgSender(), amount);
1015     }
1016 
1017     /**
1018      * Unwraps and destroys `amount` tokens from `account`.`amount` is then deducted
1019      * from the caller's allowance.
1020      * Logs native ADS address to receive unwrapped tokens.
1021      */
1022     function unwrapFrom(address account, uint256 amount, uint64 to, uint128 message) public whenNotPaused {
1023         _checksumCheck(to);
1024         emit Unwrap(account, to, amount, message);
1025         _burnFrom(account, amount);
1026     }
1027 
1028     function minterAllowance(address minter) public view returns (uint256) {
1029         return _minterAllowances[minter];
1030     }
1031 
1032     /**
1033      * Set the minterAllowance granted to `minter`.
1034      *
1035      */
1036     function minterApprove(address minter, uint256 amount) public onlyOwner returns (bool) {
1037         _minterApprove(minter, amount);
1038         return true;
1039     }
1040 
1041     /**
1042      * Atomically increases the minterAllowance granted to `minter`.
1043      *
1044      */
1045     function increaseMinterAllowance(address minter, uint256 addedValue) public onlyOwner returns (bool) {
1046         _minterApprove(minter, _minterAllowances[minter].add(addedValue));
1047         return true;
1048     }
1049 
1050     /**
1051      * Atomically decreases the minterAllowance granted to `minter`
1052      *
1053      */
1054     function decreaseMinterAllowance(address minter, uint256 subtractedValue) public onlyOwner returns (bool) {
1055         _minterApprove(minter, _minterAllowances[minter].sub(subtractedValue, "WrappedADS: decreased minterAllowance below zero"));
1056         return true;
1057     }
1058 
1059     function _minterApprove(address minter, uint256 amount) internal {
1060         require(isMinter(minter), "WrappedADS: minter approve for non-minting address");
1061 
1062         _minterAllowances[minter] = amount;
1063         emit MinterApproval(minter, amount);
1064     }
1065 
1066     function isMinter(address account) public view returns (bool) {
1067         return MinterRole.isMinter(account) || isOwner(account);
1068     }
1069 
1070     function removeMinter(address account) public onlyOwner {
1071         _minterApprove(account, 0);
1072         _removeMinter(account);
1073     }
1074 
1075     function isPauser(address account) public view returns (bool) {
1076         return PauserRole.isPauser(account) || isOwner(account);
1077     }
1078 
1079     function removePauser(address account) public onlyOwner {
1080         _removePauser(account);
1081     }
1082 
1083     /**
1084      * Transfer all Ether held by the contract to the owner.
1085      */
1086     function reclaimEther() external onlyOwner {
1087         _msgSender().transfer(address(this).balance);
1088     }
1089 
1090     /**
1091      * Reclaim all ERC20 compatible tokenst
1092      */
1093     function reclaimToken(IERC20 _token) external onlyOwner {
1094         uint256 balance = _token.balanceOf(address(this));
1095         _token.safeTransfer(_msgSender(), balance);
1096     }
1097 
1098     /**
1099      * Verify checksum for ADS address.
1100      */
1101     function _checksumCheck(uint64 adsAddress) pure internal {
1102         uint8 x;
1103         uint16 crc = 0x1D0F;
1104 
1105         for(uint8 i=7;i>=2;i--) {
1106             x = (uint8)(crc >> 8) ^ ((uint8)(adsAddress >> i*8));
1107             x ^= x>>4;
1108             crc = (crc << 8) ^ ((uint16)(x) << 12) ^ ((uint16)(x) <<5) ^ ((uint16)(x));
1109         }
1110 
1111         require(crc == (adsAddress & 0xFFFF), "WrappedADS: invalid ADS address");
1112     }
1113 
1114     event Wrap(address indexed to, uint64 indexed from, uint64 txid, uint256 amount);
1115     event Unwrap(address indexed from, uint64 indexed to, uint256 amount, uint128 message);
1116     event MinterApproval(address indexed minter, uint256 amount);
1117 }