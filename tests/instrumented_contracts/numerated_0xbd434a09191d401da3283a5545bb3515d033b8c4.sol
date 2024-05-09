1 // File: contracts/gix/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
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
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/gix/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         if (a == 0) {
143             return 0;
144         }
145 
146         uint256 c = a * b;
147         require(c / a == b, "SafeMath: multiplication overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the integer division of two unsigned integers. Reverts on
154      * division by zero. The result is rounded towards zero.
155      *
156      * Counterpart to Solidity's `/` operator. Note: this function uses a
157      * `revert` opcode (which leaves remaining gas untouched) while Solidity
158      * uses an invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      * - The divisor cannot be zero.
162      */
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Solidity only automatically asserts when dividing by 0
165         require(b > 0, "SafeMath: division by zero");
166         uint256 c = a / b;
167         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         require(b != 0, "SafeMath: modulo by zero");
185         return a % b;
186     }
187 }
188 
189 // File: contracts/gix/ERC20.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 
195 /**
196  * @dev Implementation of the `IERC20` interface.
197  *
198  * This implementation is agnostic to the way tokens are created. This means
199  * that a supply mechanism has to be added in a derived contract using `_mint`.
200  * For a generic mechanism see `ERC20Mintable`.
201  *
202  * Functions revert instead of returning `false` on failure. This behavior
203  * is nonetheless conventional and does not conflict with the expectations
204  * of ERC20 applications.
205  *
206  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
207  * This allows applications to reconstruct the allowance for all accounts just
208  * by listening to said events. Other implementations of the EIP may not emit
209  * these events, as it isn't required by the specification.
210  *
211  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
212  * functions have been added to mitigate the well-known issues around setting
213  * allowances. See `IERC20.approve`.
214  */
215 contract ERC20 is IERC20 {
216     using SafeMath for uint256;
217 
218     mapping (address => uint256) private _balances;
219 
220     mapping (address => mapping (address => uint256)) private _allowances;
221 
222     uint256 private _totalSupply;
223 
224     /**
225      * @dev See `IERC20.totalSupply`.
226      */
227     function totalSupply() public view returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * @dev See `IERC20.balanceOf`.
233      */
234     function balanceOf(address account) public view returns (uint256) {
235         return _balances[account];
236     }
237 
238     /**
239      * @dev See `IERC20.transfer`.
240      *
241      * Requirements:
242      *
243      * - `recipient` cannot be the zero address.
244      * - the caller must have a balance of at least `amount`.
245      */
246     function transfer(address recipient, uint256 amount) public returns (bool) {
247         _transfer(msg.sender, recipient, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See `IERC20.allowance`.
253      */
254     function allowance(address owner, address spender) public view returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * @dev See `IERC20.approve`.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function approve(address spender, uint256 value) public returns (bool) {
266         _approve(msg.sender, spender, value);
267         return true;
268     }
269 
270     /**
271      * @dev See `IERC20.transferFrom`.
272      *
273      * Emits an `Approval` event indicating the updated allowance. This is not
274      * required by the EIP. See the note at the beginning of `ERC20`;
275      *
276      * Requirements:
277      * - `sender` and `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `value`.
279      * - the caller must have allowance for `sender`'s tokens of at least
280      * `amount`.
281      */
282     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
285         return true;
286     }
287 
288     /**
289      * @dev Atomically increases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to `approve` that can be used as a mitigation for
292      * problems described in `IERC20.approve`.
293      *
294      * Emits an `Approval` event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
301         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
302         return true;
303     }
304 
305     /**
306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to `approve` that can be used as a mitigation for
309      * problems described in `IERC20.approve`.
310      *
311      * Emits an `Approval` event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      * - `spender` must have allowance for the caller of at least
317      * `subtractedValue`.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
320         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
321         return true;
322     }
323 
324     /**
325      * @dev Moves tokens `amount` from `sender` to `recipient`.
326      *
327      * This is internal function is equivalent to `transfer`, and can be used to
328      * e.g. implement automatic token fees, slashing mechanisms, etc.
329      *
330      * Emits a `Transfer` event.
331      *
332      * Requirements:
333      *
334      * - `sender` cannot be the zero address.
335      * - `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      */
338     function _transfer(address sender, address recipient, uint256 amount) internal {
339         require(sender != address(0), "ERC20: transfer from the zero address");
340         require(recipient != address(0), "ERC20: transfer to the zero address");
341 
342         _balances[sender] = _balances[sender].sub(amount);
343         _balances[recipient] = _balances[recipient].add(amount);
344         emit Transfer(sender, recipient, amount);
345     }
346 
347     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
348      * the total supply.
349      *
350      * Emits a `Transfer` event with `from` set to the zero address.
351      *
352      * Requirements
353      *
354      * - `to` cannot be the zero address.
355      */
356     function _mint(address account, uint256 amount) internal {
357         require(account != address(0), "ERC20: mint to the zero address");
358 
359         _totalSupply = _totalSupply.add(amount);
360         _balances[account] = _balances[account].add(amount);
361         emit Transfer(address(0), account, amount);
362     }
363 
364     /**
365     * @dev Destoys `amount` tokens from `account`, reducing the
366     * total supply.
367     *
368     * Emits a `Transfer` event with `to` set to the zero address.
369     *
370     * Requirements
371     *
372     * - `account` cannot be the zero address.
373     * - `account` must have at least `amount` tokens.
374     */
375     function _burn(address account, uint256 value) internal {
376         require(account != address(0), "ERC20: burn from the zero address");
377 
378         _totalSupply = _totalSupply.sub(value);
379         _balances[account] = _balances[account].sub(value);
380         emit Transfer(account, address(0), value);
381     }
382 
383     /**
384      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
385      *
386      * This is internal function is equivalent to `approve`, and can be used to
387      * e.g. set automatic allowances for certain subsystems, etc.
388      *
389      * Emits an `Approval` event.
390      *
391      * Requirements:
392      *
393      * - `owner` cannot be the zero address.
394      * - `spender` cannot be the zero address.
395      */
396     function _approve(address owner, address spender, uint256 value) internal {
397         require(owner != address(0), "ERC20: approve from the zero address");
398         require(spender != address(0), "ERC20: approve to the zero address");
399 
400         _allowances[owner][spender] = value;
401         emit Approval(owner, spender, value);
402     }
403 
404     /**
405      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
406      * from the caller's allowance.
407      *
408      * See `_burn` and `_approve`.
409      */
410     function _burnFrom(address account, uint256 amount) internal {
411         _burn(account, amount);
412         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
413     }
414 }
415 
416 // File: contracts/gix/ERCDetailed.sol
417 
418 pragma solidity ^0.5.0;
419 
420 
421 /**
422  * @dev Optional functions from the ERC20 standard.
423  */
424 contract ERC20Detailed is ERC20 {
425     string private _name;
426     string private _symbol;
427     uint256 private _decimals;
428 
429     /**
430      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
431      * these values are immutable: they can only be set once during
432      * construction.
433      */
434     constructor (string memory name, string memory symbol, uint256 decimals) public {
435         _name = name;
436         _symbol = symbol;
437         _decimals = decimals;
438     }
439 
440     /**
441      * @dev Returns the name of the token.
442      */
443     function name() public view returns (string memory) {
444         return _name;
445     }
446 
447     /**
448      * @dev Returns the symbol of the token, usually a shorter version of the
449      * name.
450      */
451     function symbol() public view returns (string memory) {
452         return _symbol;
453     }
454 
455     /**
456      * @dev Returns the number of decimals used to get its user representation.
457      * For example, if `decimals` equals `2`, a balance of `505` tokens should
458      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
459      *
460      * Tokens usually opt for a value of 18, imitating the relationship between
461      * Ether and Wei.
462      *
463      * > Note that this information is only used for _display_ purposes: it in
464      * no way affects any of the arithmetic of the contract, including
465      * `IERC20.balanceOf` and `IERC20.transfer`.
466      */
467     function decimals() public view returns (uint256) {
468         return _decimals;
469     }
470 }
471 
472 // File: contracts/gix/access/Roles.sol
473 
474 pragma solidity ^0.5.0;
475 
476 /**
477  * @title Roles
478  * @dev Library for managing addresses assigned to a Role.
479  */
480 library Roles {
481     struct Role {
482         mapping (address => bool) bearer;
483     }
484 
485     /**
486      * @dev Give an account access to this role.
487      */
488     function add(Role storage role, address account) internal {
489         require(!has(role, account), "Roles: account already has role");
490         role.bearer[account] = true;
491     }
492 
493     /**
494      * @dev Remove an account's access to this role.
495      */
496     function remove(Role storage role, address account) internal {
497         require(has(role, account), "Roles: account does not have role");
498         role.bearer[account] = false;
499     }
500 
501     /**
502      * @dev Check if an account has this role.
503      * @return bool
504      */
505     function has(Role storage role, address account) internal view returns (bool) {
506         require(account != address(0), "Roles: account is the zero address");
507         return role.bearer[account];
508     }
509 }
510 
511 // File: contracts/gix/access/roles/MinterRole.sol
512 
513 pragma solidity ^0.5.0;
514 
515 
516 contract MinterRole {
517     using Roles for Roles.Role;
518 
519     event MinterAdded(address indexed account);
520     event MinterRemoved(address indexed account);
521     event AccountPaused(address indexed account);
522     event AccountResumed(address indexed account);
523 
524     Roles.Role private _minters;
525     Roles.Role private _pausedAccounts;
526 
527     constructor () internal {
528         _addMinter(msg.sender);
529     }
530 
531     modifier onlyMinter() {
532         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
533         _;
534     }
535 
536     modifier onlyResumed() {
537         require(!isPaused(msg.sender), "MinterRole: caller has his account paused");
538         _;
539     }
540 
541     function isMinter(address account) public view returns (bool) {
542         return _minters.has(account);
543     }
544 
545     function isPaused(address account) public view returns (bool) {
546         return _isPaused(account);
547     }
548 
549     function addMinter(address account) public onlyMinter {
550         _addMinter(account);
551     }
552 
553     function pauseAccount(address account) public onlyMinter {
554         _pauseAccount(account);
555     }
556 
557     function renounceMinter() public {
558         _removeMinter(msg.sender);
559     }
560 
561     function _addMinter(address account) internal {
562         _minters.add(account);
563         emit MinterAdded(account);
564     }
565 
566     function _removeMinter(address account) internal {
567         _minters.remove(account);
568         emit MinterRemoved(account);
569     }
570 
571     function _pauseAccount(address account) internal {
572         _pausedAccounts.add(account);
573         emit AccountPaused(account);
574     }
575 
576     function _resumeAccount(address account) internal {
577         _pausedAccounts.remove(account);
578         emit AccountResumed(account);
579     }
580 
581     function _isPaused(address account) internal view returns (bool) {
582         return _pausedAccounts.has(account);
583     }
584 }
585 
586 // File: contracts/gix/ERC20Mintable.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 
592 /**
593  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
594  * which have permission to mint (create) new tokens as they see fit.
595  *
596  * At construction, the deployer of the contract is the only minter.
597  */
598 contract ERC20Mintable is ERC20, MinterRole {
599     /**
600      * @dev See `ERC20._mint`.
601      *
602      * Requirements:
603      *
604      * - the caller must have the `MinterRole`.
605      */
606     function mint(address account, uint256 amount, bool shouldPause) public onlyMinter returns (bool) {
607         _mint(account, amount);
608 
609         // First time being minted? Then let's ensure
610         // the token will remain paused for now
611         if (shouldPause && !_isPaused(account)) {
612             _pauseAccount(account);
613         }
614 
615         return true;
616     }
617 
618     /**
619      * @dev See `ERC20._mint`.
620      *
621      * Requirements:
622      *
623      * - the caller must have the `MinterRole`.
624      */
625     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
626         return mint(account, amount, true);
627     }
628 }
629 
630 // File: contracts/gix/ERC20Capped.sol
631 
632 pragma solidity ^0.5.0;
633 
634 
635 /**
636  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
637  */
638 contract ERC20Capped is ERC20Mintable {
639     uint256 private _cap;
640 
641     /**
642      * @dev Sets the value of the `cap`. This value is immutable, it can only be
643      * set once during construction.
644      */
645     constructor (uint256 cap) public {
646         require(cap > 0, "ERC20Capped: cap is 0");
647         _cap = cap;
648     }
649 
650     /**
651      * @dev Returns the cap on the token's total supply.
652      */
653     function cap() public view returns (uint256) {
654         return _cap;
655     }
656 
657     /**
658      * @dev See {ERC20Mintable-mint}.
659      *
660      * Requirements:
661      *
662      * - `value` must not cause the total supply to go over the cap.
663      */
664     function _mint(address account, uint256 value) internal {
665         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
666         super._mint(account, value);
667     }
668 }
669 
670 // File: contracts/gix/access/roles/AdminRole.sol
671 
672 pragma solidity ^0.5.0;
673 
674 
675 
676 contract AdminRole is MinterRole {
677     using Roles for Roles.Role;
678 
679     event AdminAdded(address indexed account);
680     event AdminRemoved(address indexed account);
681 
682     Roles.Role private _admins;
683 
684     constructor () internal {
685         _addAdmin(msg.sender);
686     }
687 
688     modifier onlyAdmin() {
689         require(isAdmin(msg.sender), "AdminRole: caller does not have the Admin role");
690         _;
691     }
692 
693     function isAdmin(address account) public view returns (bool) {
694         return _admins.has(account);
695     }
696 
697     function addAdmin(address account) public onlyAdmin {
698         _addAdmin(account);
699     }
700 
701     function renounceAdmin() public {
702         _removeAdmin(msg.sender);
703     }
704 
705     function resumeAccount(address account) public onlyAdmin {
706         _resumeAccount(account);
707     }
708 
709     function _addAdmin(address account) internal {
710         _admins.add(account);
711         emit AdminAdded(account);
712     }
713 
714     function _removeAdmin(address account) internal {
715         _admins.remove(account);
716         emit AdminRemoved(account);
717     }
718 }
719 
720 // File: contracts/gix/ERC20Resumable.sol
721 
722 pragma solidity ^0.5.0;
723 
724 
725 
726 /**
727  * @title Resumable token
728  * @dev ERC20 modified with whitelistable transfers.
729  */
730 contract ERC20Resumable is ERC20, AdminRole {
731     function transfer(address to, uint256 value) public onlyResumed returns (bool) {
732         return super.transfer(to, value);
733     }
734 
735     function transferFrom(address from, address to, uint256 value) public onlyResumed returns (bool) {
736         return super.transferFrom(from, to, value);
737     }
738 
739     function approve(address spender, uint256 value) public onlyResumed returns (bool) {
740         return super.approve(spender, value);
741     }
742 
743     function increaseAllowance(address spender, uint addedValue) public onlyResumed returns (bool) {
744         return super.increaseAllowance(spender, addedValue);
745     }
746 
747     function decreaseAllowance(address spender, uint subtractedValue) public onlyResumed returns (bool) {
748         return super.decreaseAllowance(spender, subtractedValue);
749     }
750 }
751 
752 // File: contracts/gix/ERC20Burnable.sol
753 
754 pragma solidity ^0.5.0;
755 
756 
757 
758 /**
759  * @dev Extension of `ERC20` that allows token holders to destroy both their own
760  * tokens and those that they have an allowance for, in a way that can be
761  * recognized off-chain (via event analysis).
762  */
763 contract ERC20Burnable is ERC20, AdminRole {
764     /**
765      * @dev Destoys `amount` tokens from the caller.
766      *
767      * See `ERC20._burn`.
768      */
769     function burn(uint256 amount) public {
770         _burn(msg.sender, amount);
771     }
772 
773     /**
774      * @dev Destoys `amount` tokens of a given account.
775      *
776      * See `ERC20._burn`.
777      */
778     function burn(address account, uint256 amount) onlyAdmin public {
779         _burn(account, amount);
780     }
781 
782     /**
783      * @dev See `ERC20._burnFrom`.
784      */
785     function burnFrom(address account, uint256 amount) public {
786         _burnFrom(account, amount);
787     }
788 }
789 
790 // File: contracts/gix/GIXToken.sol
791 
792 pragma solidity ^0.5.0;
793 
794 
795 
796 
797 
798 /**
799  * @title GIXToken
800  * @dev The GIX ERC20 Token that can be
801  * minted and is capped to a maximum allocation.
802  */
803 contract GIXToken is ERC20Detailed, ERC20Capped, ERC20Resumable, ERC20Burnable {
804     uint256 private constant DECIMALS = 18;
805     uint256 private constant CAP = 1000000000 * (10**18);
806 
807     constructor () public
808     ERC20Detailed("GIX Coin", "GIX", DECIMALS)
809     ERC20Capped(CAP)
810     {
811 
812     }
813 }