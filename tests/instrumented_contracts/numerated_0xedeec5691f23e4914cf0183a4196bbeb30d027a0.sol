1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-15
3 */
4 
5 // File: ..\common.5\openzeppelin\token\ERC20\IERC20.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
11  * the optional functions; to access them see {ERC20Detailed}.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: ..\common.5\openzeppelin\token\ERC20\ERC20Detailed.sol
85 
86 pragma solidity ^0.5.0;
87 
88 
89 /**
90  * @dev Optional functions from the ERC20 standard.
91  */
92 contract ERC20Detailed is IERC20 {
93     string private _name;
94     string private _symbol;
95     uint8 private _decimals;
96 
97     /**
98      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
99      * these values are immutable: they can only be set once during
100      * construction.
101      */
102     constructor (string memory name, string memory symbol, uint8 decimals) public {
103         _name = name;
104         _symbol = symbol;
105         _decimals = decimals;
106     }
107 
108     /**
109      * @dev Returns the name of the token.
110      */
111     function name() public view returns (string memory) {
112         return _name;
113     }
114 
115     /**
116      * @dev Returns the symbol of the token, usually a shorter version of the
117      * name.
118      */
119     function symbol() public view returns (string memory) {
120         return _symbol;
121     }
122 
123     /**
124      * @dev Returns the number of decimals used to get its user representation.
125      * For example, if `decimals` equals `2`, a balance of `505` tokens should
126      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
127      *
128      * Tokens usually opt for a value of 18, imitating the relationship between
129      * Ether and Wei.
130      *
131      * NOTE: This information is only used for _display_ purposes: it in
132      * no way affects any of the arithmetic of the contract, including
133      * {IERC20-balanceOf} and {IERC20-transfer}.
134      */
135     function decimals() public view returns (uint8) {
136         return _decimals;
137     }
138 }
139 
140 // File: ..\common.5\openzeppelin\GSN\Context.sol
141 
142 pragma solidity ^0.5.0;
143 
144 /*
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with GSN meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 contract Context {
155     // Empty internal constructor, to prevent people from mistakenly deploying
156     // an instance of this contract, which should be used via inheritance.
157     constructor () internal { }
158     // solhint-disable-previous-line no-empty-blocks
159 
160     function _msgSender() internal view returns (address payable) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view returns (bytes memory) {
165         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
166         return msg.data;
167     }
168 }
169 
170 // File: ..\common.5\openzeppelin\math\SafeMath.sol
171 
172 pragma solidity ^0.5.0;
173 
174 /**
175  * @dev Wrappers over Solidity's arithmetic operations with added overflow
176  * checks.
177  *
178  * Arithmetic operations in Solidity wrap on overflow. This can easily result
179  * in bugs, because programmers usually assume that an overflow raises an
180  * error, which is the standard behavior in high level programming languages.
181  * `SafeMath` restores this intuition by reverting the transaction when an
182  * operation overflows.
183  *
184  * Using this library instead of the unchecked operations eliminates an entire
185  * class of bugs, so it's recommended to use it always.
186  */
187 library SafeMath {
188     /**
189      * @dev Returns the addition of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `+` operator.
193      *
194      * Requirements:
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         require(c >= a, "SafeMath: addition overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         return sub(a, b, "SafeMath: subtraction overflow");
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      * - Subtraction cannot overflow.
225      *
226      * _Available since v2.4.0._
227      */
228     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b <= a, errorMessage);
230         uint256 c = a - b;
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the multiplication of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `*` operator.
240      *
241      * Requirements:
242      * - Multiplication cannot overflow.
243      */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246         // benefit is lost if 'b' is also tested.
247         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
248         if (a == 0) {
249             return 0;
250         }
251 
252         uint256 c = a * b;
253         require(c / a == b, "SafeMath: multiplication overflow");
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers. Reverts on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      * - The divisor cannot be zero.
268      */
269     function div(uint256 a, uint256 b) internal pure returns (uint256) {
270         return div(a, b, "SafeMath: division by zero");
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
275      * division by zero. The result is rounded towards zero.
276      *
277      * Counterpart to Solidity's `/` operator. Note: this function uses a
278      * `revert` opcode (which leaves remaining gas untouched) while Solidity
279      * uses an invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      * - The divisor cannot be zero.
283      *
284      * _Available since v2.4.0._
285      */
286     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         // Solidity only automatically asserts when dividing by 0
288         require(b > 0, errorMessage);
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      * - The divisor cannot be zero.
305      */
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         return mod(a, b, "SafeMath: modulo by zero");
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts with custom message when dividing by zero.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      * - The divisor cannot be zero.
320      *
321      * _Available since v2.4.0._
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b != 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 // File: ..\common.5\openzeppelin\token\ERC20\ERC20.sol
330 
331 pragma solidity ^0.5.0;
332 
333 
334 
335 
336 /**
337  * @dev Implementation of the {IERC20} interface.
338  *
339  * This implementation is agnostic to the way tokens are created. This means
340  * that a supply mechanism has to be added in a derived contract using {_mint}.
341  * For a generic mechanism see {ERC20Mintable}.
342  *
343  * TIP: For a detailed writeup see our guide
344  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
345  * to implement supply mechanisms].
346  *
347  * We have followed general OpenZeppelin guidelines: functions revert instead
348  * of returning `false` on failure. This behavior is nonetheless conventional
349  * and does not conflict with the expectations of ERC20 applications.
350  *
351  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
352  * This allows applications to reconstruct the allowance for all accounts just
353  * by listening to said events. Other implementations of the EIP may not emit
354  * these events, as it isn't required by the specification.
355  *
356  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
357  * functions have been added to mitigate the well-known issues around setting
358  * allowances. See {IERC20-approve}.
359  */
360 contract ERC20 is Context, IERC20 {
361     using SafeMath for uint256;
362 
363     mapping (address => uint256) private _balances;
364 
365     mapping (address => mapping (address => uint256)) private _allowances;
366 
367     uint256 private _totalSupply;
368 
369     /**
370      * @dev See {IERC20-totalSupply}.
371      */
372     function totalSupply() public view returns (uint256) {
373         return _totalSupply;
374     }
375 
376     /**
377      * @dev See {IERC20-balanceOf}.
378      */
379     function balanceOf(address account) public view returns (uint256) {
380         return _balances[account];
381     }
382 
383     /**
384      * @dev See {IERC20-transfer}.
385      *
386      * Requirements:
387      *
388      * - `recipient` cannot be the zero address.
389      * - the caller must have a balance of at least `amount`.
390      */
391     function transfer(address recipient, uint256 amount) public returns (bool) {
392         _transfer(_msgSender(), recipient, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-allowance}.
398      */
399     function allowance(address owner, address spender) public view returns (uint256) {
400         return _allowances[owner][spender];
401     }
402 
403     /**
404      * @dev See {IERC20-approve}.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function approve(address spender, uint256 amount) public returns (bool) {
411         _approve(_msgSender(), spender, amount);
412         return true;
413     }
414 
415     /**
416      * @dev See {IERC20-transferFrom}.
417      *
418      * Emits an {Approval} event indicating the updated allowance. This is not
419      * required by the EIP. See the note at the beginning of {ERC20};
420      *
421      * Requirements:
422      * - `sender` and `recipient` cannot be the zero address.
423      * - `sender` must have a balance of at least `amount`.
424      * - the caller must have allowance for `sender`'s tokens of at least
425      * `amount`.
426      */
427     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
428         _transfer(sender, recipient, amount);
429         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
430         return true;
431     }
432 
433     /**
434      * @dev Atomically increases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
446         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
447         return true;
448     }
449 
450     /**
451      * @dev Atomically decreases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      *
456      * Emits an {Approval} event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      * - `spender` must have allowance for the caller of at least
462      * `subtractedValue`.
463      */
464     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
466         return true;
467     }
468 
469     /**
470      * @dev Moves tokens `amount` from `sender` to `recipient`.
471      *
472      * This is internal function is equivalent to {transfer}, and can be used to
473      * e.g. implement automatic token fees, slashing mechanisms, etc.
474      *
475      * Emits a {Transfer} event.
476      *
477      * Requirements:
478      *
479      * - `sender` cannot be the zero address.
480      * - `recipient` cannot be the zero address.
481      * - `sender` must have a balance of at least `amount`.
482      */
483     function _transfer(address sender, address recipient, uint256 amount) internal {
484         require(sender != address(0), "ERC20: transfer from the zero address");
485         require(recipient != address(0), "ERC20: transfer to the zero address");
486 
487         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
488         _balances[recipient] = _balances[recipient].add(amount);
489         emit Transfer(sender, recipient, amount);
490     }
491 
492     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
493      * the total supply.
494      *
495      * Emits a {Transfer} event with `from` set to the zero address.
496      *
497      * Requirements
498      *
499      * - `to` cannot be the zero address.
500      */
501     function _mint(address account, uint256 amount) internal {
502         require(account != address(0), "ERC20: mint to the zero address");
503 
504         _totalSupply = _totalSupply.add(amount);
505         _balances[account] = _balances[account].add(amount);
506         emit Transfer(address(0), account, amount);
507     }
508 
509     /**
510      * @dev Destroys `amount` tokens from `account`, reducing the
511      * total supply.
512      *
513      * Emits a {Transfer} event with `to` set to the zero address.
514      *
515      * Requirements
516      *
517      * - `account` cannot be the zero address.
518      * - `account` must have at least `amount` tokens.
519      */
520     function _burn(address account, uint256 amount) internal {
521         require(account != address(0), "ERC20: burn from the zero address");
522 
523         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
524         _totalSupply = _totalSupply.sub(amount);
525         emit Transfer(account, address(0), amount);
526     }
527 
528     /**
529      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
530      *
531      * This is internal function is equivalent to `approve`, and can be used to
532      * e.g. set automatic allowances for certain subsystems, etc.
533      *
534      * Emits an {Approval} event.
535      *
536      * Requirements:
537      *
538      * - `owner` cannot be the zero address.
539      * - `spender` cannot be the zero address.
540      */
541     function _approve(address owner, address spender, uint256 amount) internal {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = amount;
546         emit Approval(owner, spender, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
551      * from the caller's allowance.
552      *
553      * See {_burn} and {_approve}.
554      */
555     function _burnFrom(address account, uint256 amount) internal {
556         _burn(account, amount);
557         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
558     }
559 }
560 
561 // File: ..\common.5\openzeppelin\access\Roles.sol
562 
563 pragma solidity ^0.5.0;
564 
565 /**
566  * @title Roles
567  * @dev Library for managing addresses assigned to a Role.
568  */
569 library Roles {
570     struct Role {
571         mapping (address => bool) bearer;
572     }
573 
574     /**
575      * @dev Give an account access to this role.
576      */
577     function add(Role storage role, address account) internal {
578         require(!has(role, account), "Roles: account already has role");
579         role.bearer[account] = true;
580     }
581 
582     /**
583      * @dev Remove an account's access to this role.
584      */
585     function remove(Role storage role, address account) internal {
586         require(has(role, account), "Roles: account does not have role");
587         role.bearer[account] = false;
588     }
589 
590     /**
591      * @dev Check if an account has this role.
592      * @return bool
593      */
594     function has(Role storage role, address account) internal view returns (bool) {
595         require(account != address(0), "Roles: account is the zero address");
596         return role.bearer[account];
597     }
598 }
599 
600 // File: ..\common.5\openzeppelin\access\roles\MinterRole.sol
601 
602 pragma solidity ^0.5.0;
603 
604 
605 
606 contract MinterRole is Context {
607     using Roles for Roles.Role;
608 
609     event MinterAdded(address indexed account);
610     event MinterRemoved(address indexed account);
611 
612     Roles.Role private _minters;
613 
614     constructor () internal {
615         _addMinter(_msgSender());
616     }
617 
618     modifier onlyMinter() {
619         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
620         _;
621     }
622 
623     function isMinter(address account) public view returns (bool) {
624         return _minters.has(account);
625     }
626 
627     function addMinter(address account) public onlyMinter {
628         _addMinter(account);
629     }
630 
631     function renounceMinter() public {
632         _removeMinter(_msgSender());
633     }
634 
635     function _addMinter(address account) internal {
636         _minters.add(account);
637         emit MinterAdded(account);
638     }
639 
640     function _removeMinter(address account) internal {
641         _minters.remove(account);
642         emit MinterRemoved(account);
643     }
644 }
645 
646 // File: ..\common.5\openzeppelin\token\ERC20\ERC20Mintable.sol
647 
648 pragma solidity ^0.5.0;
649 
650 
651 
652 /**
653  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
654  * which have permission to mint (create) new tokens as they see fit.
655  *
656  * At construction, the deployer of the contract is the only minter.
657  */
658 contract ERC20Mintable is ERC20, MinterRole {
659     /**
660      * @dev See {ERC20-_mint}.
661      *
662      * Requirements:
663      *
664      * - the caller must have the {MinterRole}.
665      */
666     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
667         _mint(account, amount);
668         return true;
669     }
670 }
671 
672 // File: ..\common.5\openzeppelin\token\ERC20\ERC20Burnable.sol
673 
674 pragma solidity ^0.5.0;
675 
676 
677 
678 /**
679  * @dev Extension of {ERC20} that allows token holders to destroy both their own
680  * tokens and those that they have an allowance for, in a way that can be
681  * recognized off-chain (via event analysis).
682  */
683 contract ERC20Burnable is Context, ERC20 {
684     /**
685      * @dev Destroys `amount` tokens from the caller.
686      *
687      * See {ERC20-_burn}.
688      */
689     function burn(uint256 amount) public {
690         _burn(_msgSender(), amount);
691     }
692 
693     /**
694      * @dev See {ERC20-_burnFrom}.
695      */
696     function burnFrom(address account, uint256 amount) public {
697         _burnFrom(account, amount);
698     }
699 }
700 
701 // File: contracts\WSTA.sol
702 
703 pragma solidity ^0.5.17;
704 
705 
706 
707 
708 
709 contract WSTA is Context, ERC20Detailed, ERC20Mintable, ERC20Burnable
710 {
711     using SafeMath for uint;
712 
713     ERC20 public STA;
714     
715     constructor()
716         public
717         ERC20Detailed("Wrapped STA", "WSTA", 18)
718     { 
719         STA = ERC20Mintable(0xa7DE087329BFcda5639247F96140f9DAbe3DeED1);
720         _removeMinter(msg.sender);
721     }
722 
723     event Wrapped(address _wrapper, uint _amountIn, uint _amountWrapped);
724     function wrap(uint _amount)
725         public
726     {
727         uint balanceBefore = STA.balanceOf(address(this));
728         STA.transferFrom(msg.sender, address(this), _amount);
729         uint realAmount = STA.balanceOf(address(this)).sub(balanceBefore);
730         _mint(msg.sender, realAmount);
731         emit Wrapped(msg.sender, _amount, realAmount);
732     }
733 
734     event Unwrapped(address _unwrapper, uint _amountUnwrapped, uint _amountOut);
735     function unwrap(uint _amount)
736         public
737     {
738         uint balanceBefore = STA.balanceOf(msg.sender);
739         STA.transfer(msg.sender, _amount);
740         uint realAmount = STA.balanceOf(msg.sender).sub(balanceBefore);
741         _burn(msg.sender, _amount);
742         emit Unwrapped(msg.sender, _amount, realAmount);
743     }
744 }