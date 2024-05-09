1 pragma solidity >=0.4.22 <0.6.0;
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
30 contract Ownable {
31     address private _owner;
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33     constructor () internal {
34         _owner = msg.sender;
35         emit OwnershipTransferred(address(0), _owner);
36     }
37     function owner() public view returns (address) {
38         return _owner;
39     }
40     
41     modifier onlyOwner() {
42         require(isOwner());
43         _;
44     }
45     
46     function isOwner() public view returns (bool) {
47         return msg.sender == _owner;
48     }
49     
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54     
55     function transferOwnership(address newOwner) public onlyOwner {
56         _transferOwnership(newOwner);
57     }
58    
59     function _transferOwnership(address newOwner) internal {
60         require(newOwner != address(0));
61         emit OwnershipTransferred(_owner, newOwner);
62         _owner = newOwner;
63     }
64 }
65 
66 
67 /**
68  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
69  * the optional functions; to access them see {ERC20Detailed}.
70  */
71 interface IERC20 {
72     /**
73      * @dev Returns the amount of tokens in existence.
74      */
75     function totalSupply() external view returns (uint256);
76 
77     /**
78      * @dev Returns the amount of tokens owned by `account`.
79      */
80     function balanceOf(address account) external view returns (uint256);
81 
82     /**
83      * @dev Moves `amount` tokens from the caller's account to `recipient`.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transfer(address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Returns the remaining number of tokens that `spender` will be
93      * allowed to spend on behalf of `owner` through {transferFrom}. This is
94      * zero by default.
95      *
96      * This value changes when {approve} or {transferFrom} are called.
97      */
98     function allowance(address owner, address spender) external view returns (uint256);
99 
100     /**
101      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * IMPORTANT: Beware that changing an allowance with this method brings the risk
106      * that someone may use both the old and the new allowance by unfortunate
107      * transaction ordering. One possible solution to mitigate this race
108      * condition is to first reduce the spender's allowance to 0 and set the
109      * desired value afterwards:
110      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address spender, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Moves `amount` tokens from `sender` to `recipient` using the
118      * allowance mechanism. `amount` is then deducted from the caller's
119      * allowance.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 
143 /**
144  * @dev Wrappers over Solidity's arithmetic operations with added overflow
145  * checks.
146  *
147  * Arithmetic operations in Solidity wrap on overflow. This can easily result
148  * in bugs, because programmers usually assume that an overflow raises an
149  * error, which is the standard behavior in high level programming languages.
150  * `SafeMath` restores this intuition by reverting the transaction when an
151  * operation overflows.
152  *
153  * Using this library instead of the unchecked operations eliminates an entire
154  * class of bugs, so it's recommended to use it always.
155  */
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return sub(a, b, "SafeMath: subtraction overflow");
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      * - Subtraction cannot overflow.
194      *
195      * _Available since v2.4.0._
196      */
197     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b <= a, errorMessage);
199         uint256 c = a - b;
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `*` operator.
209      *
210      * Requirements:
211      * - Multiplication cannot overflow.
212      */
213     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
215         // benefit is lost if 'b' is also tested.
216         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
217         if (a == 0) {
218             return 0;
219         }
220 
221         uint256 c = a * b;
222         require(c / a == b, "SafeMath: multiplication overflow");
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         return div(a, b, "SafeMath: division by zero");
240     }
241 
242     /**
243      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
244      * division by zero. The result is rounded towards zero.
245      *
246      * Counterpart to Solidity's `/` operator. Note: this function uses a
247      * `revert` opcode (which leaves remaining gas untouched) while Solidity
248      * uses an invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      *
253      * _Available since v2.4.0._
254      */
255     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         // Solidity only automatically asserts when dividing by 0
257         require(b > 0, errorMessage);
258         uint256 c = a / b;
259         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276         return mod(a, b, "SafeMath: modulo by zero");
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * Reverts with custom message when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      * - The divisor cannot be zero.
289      *
290      * _Available since v2.4.0._
291      */
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b != 0, errorMessage);
294         return a % b;
295     }
296 }
297 
298 
299 /**
300  * @dev Implementation of the {IERC20} interface.
301  *
302  * This implementation is agnostic to the way tokens are created. This means
303  * that a supply mechanism has to be added in a derived contract using {_mint}.
304  * For a generic mechanism see {ERC20Mintable}.
305  *
306  * TIP: For a detailed writeup see our guide
307  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
308  * to implement supply mechanisms].
309  *
310  * We have followed general OpenZeppelin guidelines: functions revert instead
311  * of returning `false` on failure. This behavior is nonetheless conventional
312  * and does not conflict with the expectations of ERC20 applications.
313  *
314  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
315  * This allows applications to reconstruct the allowance for all accounts just
316  * by listening to said events. Other implementations of the EIP may not emit
317  * these events, as it isn't required by the specification.
318  *
319  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
320  * functions have been added to mitigate the well-known issues around setting
321  * allowances. See {IERC20-approve}.
322  */
323 
324 contract ERC20 is Context, IERC20, Ownable{
325     using SafeMath for uint256;
326 
327     mapping (address => uint256) private _balances;
328 
329     mapping (address => mapping (address => uint256)) private _allowances;
330 
331     uint256 private _totalSupply;
332 
333     /**
334      * @dev See {IERC20-totalSupply}.
335      */
336     function totalSupply() public view returns (uint256) {
337         return _totalSupply;
338     }
339 
340     /**
341      * @dev See {IERC20-balanceOf}.
342      */
343     function balanceOf(address account) public view returns (uint256) {
344         return _balances[account];
345     }
346 
347     /**
348      * @dev See {IERC20-transfer}.
349      *
350      * Requirements:
351      *
352      * - `recipient` cannot be the zero address.
353      * - the caller must have a balance of at least `amount`.
354      */
355     function transfer(address recipient, uint256 amount) public returns (bool) {
356         _transfer(_msgSender(), recipient, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-allowance}.
362      */
363     function allowance(address owner, address spender) public view returns (uint256) {
364         return _allowances[owner][spender];
365     }
366 
367     /**
368      * @dev See {IERC20-approve}.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function approve(address spender, uint256 amount) public returns (bool) {
375         _approve(_msgSender(), spender, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-transferFrom}.
381      *
382      * Emits an {Approval} event indicating the updated allowance. This is not
383      * required by the EIP. See the note at the beginning of {ERC20};
384      *
385      * Requirements:
386      * - `sender` and `recipient` cannot be the zero address.
387      * - `sender` must have a balance of at least `amount`.
388      * - the caller must have allowance for `sender`'s tokens of at least
389      * `amount`.
390      */
391     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
392         _transfer(sender, recipient, amount);
393         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
410         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
430         return true;
431     }
432 
433     /**
434      * @dev Moves tokens `amount` from `sender` to `recipient`.
435      *
436      * This is internal function is equivalent to {transfer}, and can be used to
437      * e.g. implement automatic token fees, slashing mechanisms, etc.
438      *
439      * Emits a {Transfer} event.
440      *
441      * Requirements:
442      *
443      * - `sender` cannot be the zero address.
444      * - `recipient` cannot be the zero address.
445      * - `sender` must have a balance of at least `amount`.
446      */
447     function _transfer(address sender, address recipient, uint256 amount) internal {
448         require(sender != address(0), "ERC20: transfer from the zero address");
449         require(recipient != address(0), "ERC20: transfer to the zero address");
450 
451         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
452         _balances[recipient] = _balances[recipient].add(amount);
453         emit Transfer(sender, recipient, amount);
454     }
455 
456     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
457      * the total supply.
458      *
459      * Emits a {Transfer} event with `from` set to the zero address.
460      *
461      * Requirements
462      *
463      * - `to` cannot be the zero address.
464      */
465     function _mint(address account, uint256 amount) internal {
466         require(account != address(0), "ERC20: mint to the zero address");
467 
468         _totalSupply = _totalSupply.add(amount);
469         _balances[account] = _balances[account].add(amount);
470         emit Transfer(address(0), account, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`, reducing the
475      * total supply.
476      *
477      * Emits a {Transfer} event with `to` set to the zero address.
478      *
479      * Requirements
480      *
481      * - `account` cannot be the zero address.
482      * - `account` must have at least `amount` tokens.
483      */
484     function _burn(address account, uint256 amount) internal {
485         require(account != address(0), "ERC20: burn from the zero address");
486 
487         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
488         _totalSupply = _totalSupply.sub(amount);
489         emit Transfer(account, address(0), amount);
490     }
491 
492     /**
493      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
494      *
495      * This is internal function is equivalent to `approve`, and can be used to
496      * e.g. set automatic allowances for certain subsystems, etc.
497      *
498      * Emits an {Approval} event.
499      *
500      * Requirements:
501      *
502      * - `owner` cannot be the zero address.
503      * - `spender` cannot be the zero address.
504      */
505     function _approve(address owner, address spender, uint256 amount) internal {
506         require(owner != address(0), "ERC20: approve from the zero address");
507         require(spender != address(0), "ERC20: approve to the zero address");
508 
509         _allowances[owner][spender] = amount;
510         emit Approval(owner, spender, amount);
511     }
512 
513     /**
514      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
515      * from the caller's allowance.
516      *
517      * See {_burn} and {_approve}.
518      */
519     function _burnFrom(address account, uint256 amount) internal {
520         _burn(account, amount);
521         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
522     }
523 }
524 
525 /**
526  * @dev Optional functions from the ERC20 standard.
527  */
528 
529 contract ERC20Detailed is IERC20 {
530     string private _name;
531     string private _symbol;
532     uint8 private _decimals;
533 
534     /**
535      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
536      * these values are immutable: they can only be set once during
537      * construction.
538      */
539     constructor (string memory name, string memory symbol, uint8 decimals) public {
540         _name = name;
541         _symbol = symbol;
542         _decimals = decimals;
543     }
544 
545     /**
546      * @dev Returns the name of the token.
547      */
548     function name() public view returns (string memory) {
549         return _name;
550     }
551 
552     /**
553      * @dev Returns the symbol of the token, usually a shorter version of the
554      * name.
555      */
556     function symbol() public view returns (string memory) {
557         return _symbol;
558     }
559 
560     /**
561      * @dev Returns the number of decimals used to get its user representation.
562      * For example, if `decimals` equals `2`, a balance of `505` tokens should
563      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
564      *
565      * Tokens usually opt for a value of 18, imitating the relationship between
566      * Ether and Wei.
567      *
568      * NOTE: This information is only used for _display_ purposes: it in
569      * no way affects any of the arithmetic of the contract, including
570      * {IERC20-balanceOf} and {IERC20-transfer}.
571      */
572     function decimals() public view returns (uint8) {
573         return _decimals;
574     }
575 }
576 
577 /**
578  * @title Roles
579  * @dev Library for managing addresses assigned to a Role.
580  */
581 library Roles {
582     struct Role {
583         mapping (address => bool) bearer;
584     }
585 
586     /**
587      * @dev Give an account access to this role.
588      */
589     function add(Role storage role, address account) internal {
590         require(!has(role, account), "Roles: account already has role");
591         role.bearer[account] = true;
592     }
593 
594     /**
595      * @dev Remove an account's access to this role.
596      */
597     function remove(Role storage role, address account) internal {
598         require(has(role, account), "Roles: account does not have role");
599         role.bearer[account] = false;
600     }
601 
602     /**
603      * @dev Check if an account has this role.
604      * @return bool
605      */
606     function has(Role storage role, address account) internal view returns (bool) {
607         require(account != address(0), "Roles: account is the zero address");
608         return role.bearer[account];
609     }
610 }
611 
612 contract PauserRole is Context {
613     using Roles for Roles.Role;
614 
615     event PauserAdded(address indexed account);
616     event PauserRemoved(address indexed account);
617 
618     Roles.Role private _pausers;
619 
620     constructor () internal {
621         _addPauser(_msgSender());
622     }
623 
624     modifier onlyPauser() {
625         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
626         _;
627     }
628 
629     function isPauser(address account) public view returns (bool) {
630         return _pausers.has(account);
631     }
632 
633     function addPauser(address account) public onlyPauser {
634         _addPauser(account);
635     }
636 
637     function renouncePauser() public {
638         _removePauser(_msgSender());
639     }
640 
641     function _addPauser(address account) internal {
642         _pausers.add(account);
643         emit PauserAdded(account);
644     }
645 
646     function _removePauser(address account) internal {
647         _pausers.remove(account);
648         emit PauserRemoved(account);
649     }
650 }
651 
652 /**
653  * @dev Contract module which allows children to implement an emergency stop
654  * mechanism that can be triggered by an authorized account.
655  *
656  * This module is used through inheritance. It will make available the
657  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
658  * the functions of your contract. Note that they will not be pausable by
659  * simply including this module, only once the modifiers are put in place.
660  */
661 contract Pausable is Context, PauserRole {
662     /**
663      * @dev Emitted when the pause is triggered by a pauser (`account`).
664      */
665     event Paused(address account);
666 
667     /**
668      * @dev Emitted when the pause is lifted by a pauser (`account`).
669      */
670     event Unpaused(address account);
671 
672     bool private _paused;
673 
674     /**
675      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
676      * to the deployer.
677      */
678     constructor () internal {
679         _paused = false;
680     }
681 
682     /**
683      * @dev Returns true if the contract is paused, and false otherwise.
684      */
685     function paused() public view returns (bool) {
686         return _paused;
687     }
688 
689     /**
690      * @dev Modifier to make a function callable only when the contract is not paused.
691      */
692     modifier whenNotPaused() {
693         require(!_paused, "Pausable: paused");
694         _;
695     }
696 
697     /**
698      * @dev Modifier to make a function callable only when the contract is paused.
699      */
700     modifier whenPaused() {
701         require(_paused, "Pausable: not paused");
702         _;
703     }
704 
705     /**
706      * @dev Called by a pauser to pause, triggers stopped state.
707      */
708     function pause() public onlyPauser whenNotPaused {
709         _paused = true;
710         emit Paused(_msgSender());
711     }
712 
713     /**
714      * @dev Called by a pauser to unpause, returns to normal state.
715      */
716     function unpause() public onlyPauser whenPaused {
717         _paused = false;
718         emit Unpaused(_msgSender());
719     }
720 }
721 
722 /**
723  * @title Pausable token
724  * @dev ERC20 with pausable transfers and allowances.
725  *
726  * Useful if you want to stop trades until the end of a crowdsale, or have
727  * an emergency switch for freezing all token transfers in the event of a large
728  * bug.
729  */
730 contract ERC20Pausable is ERC20, Pausable {
731     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
732         return super.transfer(to, value);
733     }
734 
735     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
736         return super.transferFrom(from, to, value);
737     }
738 
739     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
740         return super.approve(spender, value);
741     }
742 
743     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
744         return super.increaseAllowance(spender, addedValue);
745     }
746 
747     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
748         return super.decreaseAllowance(spender, subtractedValue);
749     }
750 }
751 
752 /**
753  * @title SimpleToken
754  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
755  * Note they can later distribute these tokens as they wish using `transfer` and other
756  * `ERC20` functions.
757  */
758 contract IssToken is Context, ERC20, ERC20Detailed, ERC20Pausable {
759 
760     /**
761      * @dev Constructor that gives _msgSender() all of existing tokens.
762      */
763     constructor () public ERC20Detailed("IssToken", "ISS", 18) {
764         _mint(_msgSender(), 1000000000 * (10 ** uint256(decimals())));
765     }
766 }