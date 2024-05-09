1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount)
28         external
29         returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender)
39         external
40         view
41         returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(
87         address indexed owner,
88         address indexed spender,
89         uint256 value
90     );
91 }
92 
93 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
94 
95 pragma solidity ^0.5.0;
96 
97 /**
98  * @dev Optional functions from the ERC20 standard.
99  */
100 contract ERC20Detailed is IERC20 {
101     string private _name;
102     string private _symbol;
103     uint8 private _decimals;
104 
105     /**
106      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
107      * these values are immutable: they can only be set once during
108      * construction.
109      */
110     constructor(
111         string memory name,
112         string memory symbol,
113         uint8 decimals
114     ) public {
115         _name = name;
116         _symbol = symbol;
117         _decimals = decimals;
118     }
119 
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() public view returns (string memory) {
124         return _name;
125     }
126 
127     /**
128      * @dev Returns the symbol of the token, usually a shorter version of the
129      * name.
130      */
131     function symbol() public view returns (string memory) {
132         return _symbol;
133     }
134 
135     /**
136      * @dev Returns the number of decimals used to get its user representation.
137      * For example, if `decimals` equals `2`, a balance of `505` tokens should
138      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
139      *
140      * Tokens usually opt for a value of 18, imitating the relationship between
141      * Ether and Wei.
142      *
143      * NOTE: This information is only used for _display_ purposes: it in
144      * no way affects any of the arithmetic of the contract, including
145      * {IERC20-balanceOf} and {IERC20-transfer}.
146      */
147     function decimals() public view returns (uint8) {
148         return _decimals;
149     }
150 }
151 
152 // File: @openzeppelin/contracts/GSN/Context.sol
153 
154 pragma solidity ^0.5.0;
155 
156 /*
157  * @dev Provides information about the current execution context, including the
158  * sender of the transaction and its data. While these are generally available
159  * via msg.sender and msg.data, they should not be accessed in such a direct
160  * manner, since when dealing with GSN meta-transactions the account sending and
161  * paying for execution may not be the actual sender (as far as an application
162  * is concerned).
163  *
164  * This contract is only required for intermediate, library-like contracts.
165  */
166 contract Context {
167     // Empty internal constructor, to prevent people from mistakenly deploying
168     // an instance of this contract, which should be used via inheritance.
169     constructor() internal {}
170 
171     // solhint-disable-previous-line no-empty-blocks
172 
173     function _msgSender() internal view returns (address payable) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view returns (bytes memory) {
178         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
179         return msg.data;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/math/SafeMath.sol
184 
185 pragma solidity ^0.5.0;
186 
187 /**
188  * @dev Wrappers over Solidity's arithmetic operations with added overflow
189  * checks.
190  *
191  * Arithmetic operations in Solidity wrap on overflow. This can easily result
192  * in bugs, because programmers usually assume that an overflow raises an
193  * error, which is the standard behavior in high level programming languages.
194  * `SafeMath` restores this intuition by reverting the transaction when an
195  * operation overflows.
196  *
197  * Using this library instead of the unchecked operations eliminates an entire
198  * class of bugs, so it's recommended to use it always.
199  */
200 library SafeMath {
201     /**
202      * @dev Returns the addition of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `+` operator.
206      *
207      * Requirements:
208      * - Addition cannot overflow.
209      */
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         require(c >= a, "SafeMath: addition overflow");
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      * - Subtraction cannot overflow.
225      */
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         return sub(a, b, "SafeMath: subtraction overflow");
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232      * overflow (when the result is negative).
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      * - Subtraction cannot overflow.
238      *
239      * _Available since v2.4.0._
240      */
241     function sub(
242         uint256 a,
243         uint256 b,
244         string memory errorMessage
245     ) internal pure returns (uint256) {
246         require(b <= a, errorMessage);
247         uint256 c = a - b;
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the multiplication of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `*` operator.
257      *
258      * Requirements:
259      * - Multiplication cannot overflow.
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         return div(a, b, "SafeMath: division by zero");
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
292      * division by zero. The result is rounded towards zero.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      * - The divisor cannot be zero.
300      *
301      * _Available since v2.4.0._
302      */
303     function div(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         // Solidity only automatically asserts when dividing by 0
309         require(b > 0, errorMessage);
310         uint256 c = a / b;
311         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return mod(a, b, "SafeMath: modulo by zero");
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * Reverts with custom message when dividing by zero.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      * - The divisor cannot be zero.
341      *
342      * _Available since v2.4.0._
343      */
344     function mod(
345         uint256 a,
346         uint256 b,
347         string memory errorMessage
348     ) internal pure returns (uint256) {
349         require(b != 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
355 
356 pragma solidity ^0.5.0;
357 
358 /**
359  * @dev Implementation of the {IERC20} interface.
360  *
361  * This implementation is agnostic to the way tokens are created. This means
362  * that a supply mechanism has to be added in a derived contract using {_mint}.
363  * For a generic mechanism see {ERC20Mintable}.
364  *
365  * TIP: For a detailed writeup see our guide
366  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
367  * to implement supply mechanisms].
368  *
369  * We have followed general OpenZeppelin guidelines: functions revert instead
370  * of returning `false` on failure. This behavior is nonetheless conventional
371  * and does not conflict with the expectations of ERC20 applications.
372  *
373  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
374  * This allows applications to reconstruct the allowance for all accounts just
375  * by listening to said events. Other implementations of the EIP may not emit
376  * these events, as it isn't required by the specification.
377  *
378  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
379  * functions have been added to mitigate the well-known issues around setting
380  * allowances. See {IERC20-approve}.
381  */
382 contract ERC20 is Context, IERC20 {
383     using SafeMath for uint256;
384 
385     mapping(address => uint256) private _balances;
386 
387     mapping(address => mapping(address => uint256)) private _allowances;
388 
389     uint256 private _totalSupply;
390 
391     /**
392      * @dev See {IERC20-totalSupply}.
393      */
394     function totalSupply() public view returns (uint256) {
395         return _totalSupply;
396     }
397 
398     /**
399      * @dev See {IERC20-balanceOf}.
400      */
401     function balanceOf(address account) public view returns (uint256) {
402         return _balances[account];
403     }
404 
405     /**
406      * @dev See {IERC20-transfer}.
407      *
408      * Requirements:
409      *
410      * - `recipient` cannot be the zero address.
411      * - the caller must have a balance of at least `amount`.
412      */
413     function transfer(address recipient, uint256 amount) public returns (bool) {
414         _transfer(_msgSender(), recipient, amount);
415         return true;
416     }
417 
418     /**
419      * @dev See {IERC20-allowance}.
420      */
421     function allowance(address owner, address spender)
422         public
423         view
424         returns (uint256)
425     {
426         return _allowances[owner][spender];
427     }
428 
429     /**
430      * @dev See {IERC20-approve}.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount) public returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-transferFrom}.
443      *
444      * Emits an {Approval} event indicating the updated allowance. This is not
445      * required by the EIP. See the note at the beginning of {ERC20};
446      *
447      * Requirements:
448      * - `sender` and `recipient` cannot be the zero address.
449      * - `sender` must have a balance of at least `amount`.
450      * - the caller must have allowance for `sender`'s tokens of at least
451      * `amount`.
452      */
453     function transferFrom(
454         address sender,
455         address recipient,
456         uint256 amount
457     ) public returns (bool) {
458         _transfer(sender, recipient, amount);
459         _approve(
460             sender,
461             _msgSender(),
462             _allowances[sender][_msgSender()].sub(
463                 amount,
464                 "ERC20: transfer amount exceeds allowance"
465             )
466         );
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue)
483         public
484         returns (bool)
485     {
486         _approve(
487             _msgSender(),
488             spender,
489             _allowances[_msgSender()][spender].add(addedValue)
490         );
491         return true;
492     }
493 
494     /**
495      * @dev Atomically decreases the allowance granted to `spender` by the caller.
496      *
497      * This is an alternative to {approve} that can be used as a mitigation for
498      * problems described in {IERC20-approve}.
499      *
500      * Emits an {Approval} event indicating the updated allowance.
501      *
502      * Requirements:
503      *
504      * - `spender` cannot be the zero address.
505      * - `spender` must have allowance for the caller of at least
506      * `subtractedValue`.
507      */
508     function decreaseAllowance(address spender, uint256 subtractedValue)
509         public
510         returns (bool)
511     {
512         _approve(
513             _msgSender(),
514             spender,
515             _allowances[_msgSender()][spender].sub(
516                 subtractedValue,
517                 "ERC20: decreased allowance below zero"
518             )
519         );
520         return true;
521     }
522 
523     /**
524      * @dev Moves tokens `amount` from `sender` to `recipient`.
525      *
526      * This is internal function is equivalent to {transfer}, and can be used to
527      * e.g. implement automatic token fees, slashing mechanisms, etc.
528      *
529      * Emits a {Transfer} event.
530      *
531      * Requirements:
532      *
533      * - `sender` cannot be the zero address.
534      * - `recipient` cannot be the zero address.
535      * - `sender` must have a balance of at least `amount`.
536      */
537     function _transfer(
538         address sender,
539         address recipient,
540         uint256 amount
541     ) internal {
542         require(sender != address(0), "ERC20: transfer from the zero address");
543         require(recipient != address(0), "ERC20: transfer to the zero address");
544 
545         _balances[sender] = _balances[sender].sub(
546             amount,
547             "ERC20: transfer amount exceeds balance"
548         );
549         _balances[recipient] = _balances[recipient].add(amount);
550         emit Transfer(sender, recipient, amount);
551     }
552 
553     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
554      * the total supply.
555      *
556      * Emits a {Transfer} event with `from` set to the zero address.
557      *
558      * Requirements
559      *
560      * - `to` cannot be the zero address.
561      */
562     function _mint(address account, uint256 amount) internal {
563         require(account != address(0), "ERC20: mint to the zero address");
564 
565         _totalSupply = _totalSupply.add(amount);
566         _balances[account] = _balances[account].add(amount);
567         emit Transfer(address(0), account, amount);
568     }
569 
570     /**
571      * @dev Destroys `amount` tokens from `account`, reducing the
572      * total supply.
573      *
574      * Emits a {Transfer} event with `to` set to the zero address.
575      *
576      * Requirements
577      *
578      * - `account` cannot be the zero address.
579      * - `account` must have at least `amount` tokens.
580      */
581     function _burn(address account, uint256 amount) internal {
582         require(account != address(0), "ERC20: burn from the zero address");
583 
584         _balances[account] = _balances[account].sub(
585             amount,
586             "ERC20: burn amount exceeds balance"
587         );
588         _totalSupply = _totalSupply.sub(amount);
589         emit Transfer(account, address(0), amount);
590     }
591 
592     /**
593      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
594      *
595      * This is internal function is equivalent to `approve`, and can be used to
596      * e.g. set automatic allowances for certain subsystems, etc.
597      *
598      * Emits an {Approval} event.
599      *
600      * Requirements:
601      *
602      * - `owner` cannot be the zero address.
603      * - `spender` cannot be the zero address.
604      */
605     function _approve(
606         address owner,
607         address spender,
608         uint256 amount
609     ) internal {
610         require(owner != address(0), "ERC20: approve from the zero address");
611         require(spender != address(0), "ERC20: approve to the zero address");
612 
613         _allowances[owner][spender] = amount;
614         emit Approval(owner, spender, amount);
615     }
616 
617     /**
618      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
619      * from the caller's allowance.
620      *
621      * See {_burn} and {_approve}.
622      */
623     function _burnFrom(address account, uint256 amount) internal {
624         _burn(account, amount);
625         _approve(
626             account,
627             _msgSender(),
628             _allowances[account][_msgSender()].sub(
629                 amount,
630                 "ERC20: burn amount exceeds allowance"
631             )
632         );
633     }
634 }
635 
636 // File: @openzeppelin/contracts/access/Roles.sol
637 
638 pragma solidity ^0.5.0;
639 
640 /**
641  * @title Roles
642  * @dev Library for managing addresses assigned to a Role.
643  */
644 library Roles {
645     struct Role {
646         mapping(address => bool) bearer;
647     }
648 
649     /**
650      * @dev Give an account access to this role.
651      */
652     function add(Role storage role, address account) internal {
653         require(!has(role, account), "Roles: account already has role");
654         role.bearer[account] = true;
655     }
656 
657     /**
658      * @dev Remove an account's access to this role.
659      */
660     function remove(Role storage role, address account) internal {
661         require(has(role, account), "Roles: account does not have role");
662         role.bearer[account] = false;
663     }
664 
665     /**
666      * @dev Check if an account has this role.
667      * @return bool
668      */
669     function has(Role storage role, address account)
670         internal
671         view
672         returns (bool)
673     {
674         require(account != address(0), "Roles: account is the zero address");
675         return role.bearer[account];
676     }
677 }
678 
679 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
680 
681 pragma solidity ^0.5.0;
682 
683 contract MinterRole is Context {
684     using Roles for Roles.Role;
685 
686     event MinterAdded(address indexed account);
687     event MinterRemoved(address indexed account);
688 
689     Roles.Role private _minters;
690 
691     constructor() internal {
692         _addMinter(_msgSender());
693     }
694 
695     modifier onlyMinter() {
696         require(
697             isMinter(_msgSender()),
698             "MinterRole: caller does not have the Minter role"
699         );
700         _;
701     }
702 
703     function isMinter(address account) public view returns (bool) {
704         return _minters.has(account);
705     }
706 
707     function addMinter(address account) public onlyMinter {
708         _addMinter(account);
709     }
710 
711     function renounceMinter() public {
712         _removeMinter(_msgSender());
713     }
714 
715     function _addMinter(address account) internal {
716         _minters.add(account);
717         emit MinterAdded(account);
718     }
719 
720     function _removeMinter(address account) internal {
721         _minters.remove(account);
722         emit MinterRemoved(account);
723     }
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
727 
728 pragma solidity ^0.5.0;
729 
730 /**
731  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
732  * which have permission to mint (create) new tokens as they see fit.
733  *
734  * At construction, the deployer of the contract is the only minter.
735  */
736 contract ERC20Mintable is ERC20, MinterRole {
737     /**
738      * @dev See {ERC20-_mint}.
739      *
740      * Requirements:
741      *
742      * - the caller must have the {MinterRole}.
743      */
744     function mint(address account, uint256 amount)
745         public
746         onlyMinter
747         returns (bool)
748     {
749         _mint(account, amount);
750         return true;
751     }
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
755 
756 pragma solidity ^0.5.0;
757 
758 /**
759  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
760  */
761 contract ERC20Capped is ERC20Mintable {
762     uint256 private _cap;
763 
764     /**
765      * @dev Sets the value of the `cap`. This value is immutable, it can only be
766      * set once during construction.
767      */
768     constructor(uint256 cap) public {
769         require(cap > 0, "ERC20Capped: cap is 0");
770         _cap = cap;
771     }
772 
773     /**
774      * @dev Returns the cap on the token's total supply.
775      */
776     function cap() public view returns (uint256) {
777         return _cap;
778     }
779 
780     /**
781      * @dev See {ERC20Mintable-mint}.
782      *
783      * Requirements:
784      *
785      * - `value` must not cause the total supply to go over the cap.
786      */
787     function _mint(address account, uint256 value) internal {
788         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
789         super._mint(account, value);
790     }
791 }
792 
793 // File: contracts/VIToken.sol
794 
795 pragma solidity >=0.4.25 <0.7.0;
796 
797 contract VIToken is ERC20Detailed, ERC20Capped {
798     uint8 public constant DECIMALS = 18;
799     uint256 public constant INITIAL_SUPPLY = 888888888 *
800         (10**uint256(DECIMALS));
801 
802     constructor()
803         public
804         ERC20Detailed("VI", "VI", DECIMALS)
805         ERC20Capped(INITIAL_SUPPLY)
806     {
807         _mint(msg.sender, INITIAL_SUPPLY);
808     }
809 }