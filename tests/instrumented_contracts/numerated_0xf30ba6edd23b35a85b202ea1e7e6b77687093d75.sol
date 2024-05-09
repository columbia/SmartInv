1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-12-15
7 */
8 
9 // File: ..\common.5\openzeppelin\token\ERC20\IERC20.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
15  * the optional functions; to access them see {ERC20Detailed}.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // File: ..\common.5\openzeppelin\token\ERC20\ERC20Detailed.sol
89 
90 pragma solidity ^0.5.0;
91 
92 
93 /**
94  * @dev Optional functions from the ERC20 standard.
95  */
96 contract ERC20Detailed is IERC20 {
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 
101     /**
102      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
103      * these values are immutable: they can only be set once during
104      * construction.
105      */
106     constructor (string memory name, string memory symbol, uint8 decimals) public {
107         _name = name;
108         _symbol = symbol;
109         _decimals = decimals;
110     }
111 
112     /**
113      * @dev Returns the name of the token.
114      */
115     function name() public view returns (string memory) {
116         return _name;
117     }
118 
119     /**
120      * @dev Returns the symbol of the token, usually a shorter version of the
121      * name.
122      */
123     function symbol() public view returns (string memory) {
124         return _symbol;
125     }
126 
127     /**
128      * @dev Returns the number of decimals used to get its user representation.
129      * For example, if `decimals` equals `2`, a balance of `505` tokens should
130      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
131      *
132      * Tokens usually opt for a value of 18, imitating the relationship between
133      * Ether and Wei.
134      *
135      * NOTE: This information is only used for _display_ purposes: it in
136      * no way affects any of the arithmetic of the contract, including
137      * {IERC20-balanceOf} and {IERC20-transfer}.
138      */
139     function decimals() public view returns (uint8) {
140         return _decimals;
141     }
142 }
143 
144 // File: ..\common.5\openzeppelin\GSN\Context.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /*
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with GSN meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 contract Context {
159     // Empty internal constructor, to prevent people from mistakenly deploying
160     // an instance of this contract, which should be used via inheritance.
161     constructor () internal { }
162     // solhint-disable-previous-line no-empty-blocks
163 
164     function _msgSender() internal view returns (address payable) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view returns (bytes memory) {
169         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
170         return msg.data;
171     }
172 }
173 
174 // File: ..\common.5\openzeppelin\math\SafeMath.sol
175 
176 pragma solidity ^0.5.0;
177 
178 /**
179  * @dev Wrappers over Solidity's arithmetic operations with added overflow
180  * checks.
181  *
182  * Arithmetic operations in Solidity wrap on overflow. This can easily result
183  * in bugs, because programmers usually assume that an overflow raises an
184  * error, which is the standard behavior in high level programming languages.
185  * `SafeMath` restores this intuition by reverting the transaction when an
186  * operation overflows.
187  *
188  * Using this library instead of the unchecked operations eliminates an entire
189  * class of bugs, so it's recommended to use it always.
190  */
191 library SafeMath {
192     /**
193      * @dev Returns the addition of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `+` operator.
197      *
198      * Requirements:
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         return sub(a, b, "SafeMath: subtraction overflow");
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      * - Subtraction cannot overflow.
229      *
230      * _Available since v2.4.0._
231      */
232     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         uint256 c = a - b;
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      * - Multiplication cannot overflow.
247      */
248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
250         // benefit is lost if 'b' is also tested.
251         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
252         if (a == 0) {
253             return 0;
254         }
255 
256         uint256 c = a * b;
257         require(c / a == b, "SafeMath: multiplication overflow");
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers. Reverts on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b) internal pure returns (uint256) {
274         return div(a, b, "SafeMath: division by zero");
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      *
288      * _Available since v2.4.0._
289      */
290     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         // Solidity only automatically asserts when dividing by 0
292         require(b > 0, errorMessage);
293         uint256 c = a / b;
294         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * Reverts when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      * - The divisor cannot be zero.
309      */
310     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
311         return mod(a, b, "SafeMath: modulo by zero");
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts with custom message when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      * - The divisor cannot be zero.
324      *
325      * _Available since v2.4.0._
326      */
327     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b != 0, errorMessage);
329         return a % b;
330     }
331 }
332 
333 // File: ..\common.5\openzeppelin\token\ERC20\ERC20.sol
334 
335 pragma solidity ^0.5.0;
336 
337 
338 
339 
340 /**
341  * @dev Implementation of the {IERC20} interface.
342  *
343  * This implementation is agnostic to the way tokens are created. This means
344  * that a supply mechanism has to be added in a derived contract using {_mint}.
345  * For a generic mechanism see {ERC20Mintable}.
346  *
347  * TIP: For a detailed writeup see our guide
348  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
349  * to implement supply mechanisms].
350  *
351  * We have followed general OpenZeppelin guidelines: functions revert instead
352  * of returning `false` on failure. This behavior is nonetheless conventional
353  * and does not conflict with the expectations of ERC20 applications.
354  *
355  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
356  * This allows applications to reconstruct the allowance for all accounts just
357  * by listening to said events. Other implementations of the EIP may not emit
358  * these events, as it isn't required by the specification.
359  *
360  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
361  * functions have been added to mitigate the well-known issues around setting
362  * allowances. See {IERC20-approve}.
363  */
364 contract ERC20 is Context, IERC20 {
365     using SafeMath for uint256;
366 
367     mapping (address => uint256) private _balances;
368 
369     mapping (address => mapping (address => uint256)) private _allowances;
370 
371     uint256 private _totalSupply;
372 
373     /**
374      * @dev See {IERC20-totalSupply}.
375      */
376     function totalSupply() public view returns (uint256) {
377         return _totalSupply;
378     }
379 
380     /**
381      * @dev See {IERC20-balanceOf}.
382      */
383     function balanceOf(address account) public view returns (uint256) {
384         return _balances[account];
385     }
386 
387     /**
388      * @dev See {IERC20-transfer}.
389      *
390      * Requirements:
391      *
392      * - `recipient` cannot be the zero address.
393      * - the caller must have a balance of at least `amount`.
394      */
395     function transfer(address recipient, uint256 amount) public returns (bool) {
396         _transfer(_msgSender(), recipient, amount);
397         return true;
398     }
399 
400     /**
401      * @dev See {IERC20-allowance}.
402      */
403     function allowance(address owner, address spender) public view returns (uint256) {
404         return _allowances[owner][spender];
405     }
406 
407     /**
408      * @dev See {IERC20-approve}.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      */
414     function approve(address spender, uint256 amount) public returns (bool) {
415         _approve(_msgSender(), spender, amount);
416         return true;
417     }
418 
419     /**
420      * @dev See {IERC20-transferFrom}.
421      *
422      * Emits an {Approval} event indicating the updated allowance. This is not
423      * required by the EIP. See the note at the beginning of {ERC20};
424      *
425      * Requirements:
426      * - `sender` and `recipient` cannot be the zero address.
427      * - `sender` must have a balance of at least `amount`.
428      * - the caller must have allowance for `sender`'s tokens of at least
429      * `amount`.
430      */
431     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
432         _transfer(sender, recipient, amount);
433         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
434         return true;
435     }
436 
437     /**
438      * @dev Atomically increases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      */
449     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
450         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
451         return true;
452     }
453 
454     /**
455      * @dev Atomically decreases the allowance granted to `spender` by the caller.
456      *
457      * This is an alternative to {approve} that can be used as a mitigation for
458      * problems described in {IERC20-approve}.
459      *
460      * Emits an {Approval} event indicating the updated allowance.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      * - `spender` must have allowance for the caller of at least
466      * `subtractedValue`.
467      */
468     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
469         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
470         return true;
471     }
472 
473     /**
474      * @dev Moves tokens `amount` from `sender` to `recipient`.
475      *
476      * This is internal function is equivalent to {transfer}, and can be used to
477      * e.g. implement automatic token fees, slashing mechanisms, etc.
478      *
479      * Emits a {Transfer} event.
480      *
481      * Requirements:
482      *
483      * - `sender` cannot be the zero address.
484      * - `recipient` cannot be the zero address.
485      * - `sender` must have a balance of at least `amount`.
486      */
487     function _transfer(address sender, address recipient, uint256 amount) internal {
488         require(sender != address(0), "ERC20: transfer from the zero address");
489         require(recipient != address(0), "ERC20: transfer to the zero address");
490 
491         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
492         _balances[recipient] = _balances[recipient].add(amount);
493         emit Transfer(sender, recipient, amount);
494     }
495 
496     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
497      * the total supply.
498      *
499      * Emits a {Transfer} event with `from` set to the zero address.
500      *
501      * Requirements
502      *
503      * - `to` cannot be the zero address.
504      */
505     function _mint(address account, uint256 amount) internal {
506         require(account != address(0), "ERC20: mint to the zero address");
507 
508         _totalSupply = _totalSupply.add(amount);
509         _balances[account] = _balances[account].add(amount);
510         emit Transfer(address(0), account, amount);
511     }
512 
513     /**
514      * @dev Destroys `amount` tokens from `account`, reducing the
515      * total supply.
516      *
517      * Emits a {Transfer} event with `to` set to the zero address.
518      *
519      * Requirements
520      *
521      * - `account` cannot be the zero address.
522      * - `account` must have at least `amount` tokens.
523      */
524     function _burn(address account, uint256 amount) internal {
525         require(account != address(0), "ERC20: burn from the zero address");
526 
527         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
528         _totalSupply = _totalSupply.sub(amount);
529         emit Transfer(account, address(0), amount);
530     }
531 
532     /**
533      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
534      *
535      * This is internal function is equivalent to `approve`, and can be used to
536      * e.g. set automatic allowances for certain subsystems, etc.
537      *
538      * Emits an {Approval} event.
539      *
540      * Requirements:
541      *
542      * - `owner` cannot be the zero address.
543      * - `spender` cannot be the zero address.
544      */
545     function _approve(address owner, address spender, uint256 amount) internal {
546         require(owner != address(0), "ERC20: approve from the zero address");
547         require(spender != address(0), "ERC20: approve to the zero address");
548 
549         _allowances[owner][spender] = amount;
550         emit Approval(owner, spender, amount);
551     }
552 
553     /**
554      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
555      * from the caller's allowance.
556      *
557      * See {_burn} and {_approve}.
558      */
559     function _burnFrom(address account, uint256 amount) internal {
560         _burn(account, amount);
561         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
562     }
563 }
564 
565 // File: ..\common.5\openzeppelin\access\Roles.sol
566 
567 pragma solidity ^0.5.0;
568 
569 /**
570  * @title Roles
571  * @dev Library for managing addresses assigned to a Role.
572  */
573 library Roles {
574     struct Role {
575         mapping (address => bool) bearer;
576     }
577 
578     /**
579      * @dev Give an account access to this role.
580      */
581     function add(Role storage role, address account) internal {
582         require(!has(role, account), "Roles: account already has role");
583         role.bearer[account] = true;
584     }
585 
586     /**
587      * @dev Remove an account's access to this role.
588      */
589     function remove(Role storage role, address account) internal {
590         require(has(role, account), "Roles: account does not have role");
591         role.bearer[account] = false;
592     }
593 
594     /**
595      * @dev Check if an account has this role.
596      * @return bool
597      */
598     function has(Role storage role, address account) internal view returns (bool) {
599         require(account != address(0), "Roles: account is the zero address");
600         return role.bearer[account];
601     }
602 }
603 
604 // File: ..\common.5\openzeppelin\access\roles\MinterRole.sol
605 
606 pragma solidity ^0.5.0;
607 
608 
609 
610 contract MinterRole is Context {
611     using Roles for Roles.Role;
612 
613     event MinterAdded(address indexed account);
614     event MinterRemoved(address indexed account);
615 
616     Roles.Role private _minters;
617 
618     constructor () internal {
619         _addMinter(_msgSender());
620     }
621 
622     modifier onlyMinter() {
623         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
624         _;
625     }
626 
627     function isMinter(address account) public view returns (bool) {
628         return _minters.has(account);
629     }
630 
631     function addMinter(address account) public onlyMinter {
632         _addMinter(account);
633     }
634 
635     function renounceMinter() public {
636         _removeMinter(_msgSender());
637     }
638 
639     function _addMinter(address account) internal {
640         _minters.add(account);
641         emit MinterAdded(account);
642     }
643 
644     function _removeMinter(address account) internal {
645         _minters.remove(account);
646         emit MinterRemoved(account);
647     }
648 }
649 
650 // File: ..\common.5\openzeppelin\token\ERC20\ERC20Mintable.sol
651 
652 pragma solidity ^0.5.0;
653 
654 
655 
656 /**
657  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
658  * which have permission to mint (create) new tokens as they see fit.
659  *
660  * At construction, the deployer of the contract is the only minter.
661  */
662 contract ERC20Mintable is ERC20, MinterRole {
663     /**
664      * @dev See {ERC20-_mint}.
665      *
666      * Requirements:
667      *
668      * - the caller must have the {MinterRole}.
669      */
670     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
671         _mint(account, amount);
672         return true;
673     }
674 }
675 
676 // File: ..\common.5\openzeppelin\token\ERC20\ERC20Burnable.sol
677 
678 pragma solidity ^0.5.0;
679 
680 
681 
682 /**
683  * @dev Extension of {ERC20} that allows token holders to destroy both their own
684  * tokens and those that they have an allowance for, in a way that can be
685  * recognized off-chain (via event analysis).
686  */
687 contract ERC20Burnable is Context, ERC20 {
688     /**
689      * @dev Destroys `amount` tokens from the caller.
690      *
691      * See {ERC20-_burn}.
692      */
693     function burn(uint256 amount) public {
694         _burn(_msgSender(), amount);
695     }
696 
697     /**
698      * @dev See {ERC20-_burnFrom}.
699      */
700     function burnFrom(address account, uint256 amount) public {
701         _burnFrom(account, amount);
702     }
703 }
704 
705 // File: contracts\WBUNNY.sol
706 
707 pragma solidity ^0.5.17;
708 
709 
710 
711 
712 
713 contract WBUNNY is Context, ERC20Detailed, ERC20Mintable, ERC20Burnable
714 {
715     using SafeMath for uint;
716 
717     ERC20 public BUNNY;
718     
719     constructor()
720         public
721         ERC20Detailed("Wrapped Rocket Bunny", "WBUNNY", 9)
722     { 
723         BUNNY = ERC20Mintable(0x3Ea50B7Ef6a7eaf7E966E2cb72b519C16557497c);
724         _removeMinter(msg.sender);
725     }
726 
727     event Wrapped(address _wrapper, uint _amountIn, uint _amountWrapped);
728 
729     function wrap(uint _amount) public {
730 
731         uint balanceBefore = BUNNY.balanceOf(address(this));
732         BUNNY.transferFrom(msg.sender, address(this), _amount);
733         uint realAmount = BUNNY.balanceOf(address(this)).sub(balanceBefore);
734         
735         _mint(msg.sender, realAmount);
736         emit Wrapped(msg.sender, _amount, realAmount);
737     }
738 
739     event Unwrapped(address _unwrapper, uint _amountUnwrapped, uint _amountOut);
740 
741     function unwrap(uint _amount) public {
742 
743         uint256 bunnyBalance = BUNNY.balanceOf(address(this));
744         uint256 totalYield = bunnyBalance.sub(totalSupply());
745 
746         uint256 bonusYield;
747         
748 
749         // add percent of total current yield held based on unwrap amount
750         bonusYield = bonusYield.add(_amount.mul(totalYield).div(totalSupply()));
751 
752         uint balanceBefore = BUNNY.balanceOf(msg.sender);
753         BUNNY.transfer(msg.sender, _amount.add(bonusYield));
754         uint realAmount = BUNNY.balanceOf(msg.sender).sub(balanceBefore).sub(bonusYield);
755 
756         _burn(msg.sender, _amount);
757         
758         //BUNNY.transfer(msg.sender, bonusYield);
759         
760         emit Unwrapped(msg.sender, _amount, realAmount);
761     }
762     
763     function totalYieldView() public view returns(uint256) {
764         uint256 bunnyBalance = BUNNY.balanceOf(address(this));
765         uint256 totalYield = bunnyBalance.sub(totalSupply());
766         return totalYield;
767     }
768 }