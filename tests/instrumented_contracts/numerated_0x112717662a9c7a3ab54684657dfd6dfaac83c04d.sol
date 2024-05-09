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
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 pragma solidity ^0.5.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
35  * the optional functions; to access them see {ERC20Detailed}.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 pragma solidity ^0.5.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      * - Subtraction cannot overflow.
163      *
164      * _Available since v2.4.0._
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      *
222      * _Available since v2.4.0._
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         // Solidity only automatically asserts when dividing by 0
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      * - The divisor cannot be zero.
258      *
259      * _Available since v2.4.0._
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
268 
269 pragma solidity ^0.5.0;
270 
271 
272 
273 
274 /**
275  * @dev Implementation of the {IERC20} interface.
276  *
277  * This implementation is agnostic to the way tokens are created. This means
278  * that a supply mechanism has to be added in a derived contract using {_mint}.
279  * For a generic mechanism see {ERC20Mintable}.
280  *
281  * TIP: For a detailed writeup see our guide
282  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
283  * to implement supply mechanisms].
284  *
285  * We have followed general OpenZeppelin guidelines: functions revert instead
286  * of returning `false` on failure. This behavior is nonetheless conventional
287  * and does not conflict with the expectations of ERC20 applications.
288  *
289  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
290  * This allows applications to reconstruct the allowance for all accounts just
291  * by listening to said events. Other implementations of the EIP may not emit
292  * these events, as it isn't required by the specification.
293  *
294  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
295  * functions have been added to mitigate the well-known issues around setting
296  * allowances. See {IERC20-approve}.
297  */
298 contract ERC20 is Context, IERC20 {
299     using SafeMath for uint256;
300 
301     mapping (address => uint256) private _balances;
302 
303     mapping (address => mapping (address => uint256)) private _allowances;
304 
305     uint256 private _totalSupply;
306 
307     /**
308      * @dev See {IERC20-totalSupply}.
309      */
310     function totalSupply() public view returns (uint256) {
311         return _totalSupply;
312     }
313 
314     /**
315      * @dev See {IERC20-balanceOf}.
316      */
317     function balanceOf(address account) public view returns (uint256) {
318         return _balances[account];
319     }
320 
321     /**
322      * @dev See {IERC20-transfer}.
323      *
324      * Requirements:
325      *
326      * - `recipient` cannot be the zero address.
327      * - the caller must have a balance of at least `amount`.
328      */
329     function transfer(address recipient, uint256 amount) public returns (bool) {
330         _transfer(_msgSender(), recipient, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-allowance}.
336      */
337     function allowance(address owner, address spender) public view returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See {IERC20-approve}.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 amount) public returns (bool) {
349         _approve(_msgSender(), spender, amount);
350         return true;
351     }
352 
353     /**
354      * @dev See {IERC20-transferFrom}.
355      *
356      * Emits an {Approval} event indicating the updated allowance. This is not
357      * required by the EIP. See the note at the beginning of {ERC20};
358      *
359      * Requirements:
360      * - `sender` and `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      * - the caller must have allowance for `sender`'s tokens of at least
363      * `amount`.
364      */
365     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
366         _transfer(sender, recipient, amount);
367         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
368         return true;
369     }
370 
371     /**
372      * @dev Atomically increases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
384         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
385         return true;
386     }
387 
388     /**
389      * @dev Atomically decreases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      * - `spender` must have allowance for the caller of at least
400      * `subtractedValue`.
401      */
402     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
403         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
404         return true;
405     }
406 
407     /**
408      * @dev Moves tokens `amount` from `sender` to `recipient`.
409      *
410      * This is internal function is equivalent to {transfer}, and can be used to
411      * e.g. implement automatic token fees, slashing mechanisms, etc.
412      *
413      * Emits a {Transfer} event.
414      *
415      * Requirements:
416      *
417      * - `sender` cannot be the zero address.
418      * - `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `amount`.
420      */
421     function _transfer(address sender, address recipient, uint256 amount) internal {
422         require(sender != address(0), "ERC20: transfer from the zero address");
423         require(recipient != address(0), "ERC20: transfer to the zero address");
424 
425         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
426         _balances[recipient] = _balances[recipient].add(amount);
427         emit Transfer(sender, recipient, amount);
428     }
429 
430     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
431      * the total supply.
432      *
433      * Emits a {Transfer} event with `from` set to the zero address.
434      *
435      * Requirements
436      *
437      * - `to` cannot be the zero address.
438      */
439     function _mint(address account, uint256 amount) internal {
440         require(account != address(0), "ERC20: mint to the zero address");
441 
442         _totalSupply = _totalSupply.add(amount);
443         _balances[account] = _balances[account].add(amount);
444         emit Transfer(address(0), account, amount);
445     }
446 
447     /**
448      * @dev Destroys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a {Transfer} event with `to` set to the zero address.
452      *
453      * Requirements
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 amount) internal {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
462         _totalSupply = _totalSupply.sub(amount);
463         emit Transfer(account, address(0), amount);
464     }
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
468      *
469      * This is internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an {Approval} event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(address owner, address spender, uint256 amount) internal {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = amount;
484         emit Approval(owner, spender, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
489      * from the caller's allowance.
490      *
491      * See {_burn} and {_approve}.
492      */
493     function _burnFrom(address account, uint256 amount) internal {
494         _burn(account, amount);
495         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
496     }
497 }
498 
499 // File: @openzeppelin/contracts/access/Roles.sol
500 
501 pragma solidity ^0.5.0;
502 
503 /**
504  * @title Roles
505  * @dev Library for managing addresses assigned to a Role.
506  */
507 library Roles {
508     struct Role {
509         mapping (address => bool) bearer;
510     }
511 
512     /**
513      * @dev Give an account access to this role.
514      */
515     function add(Role storage role, address account) internal {
516         require(!has(role, account), "Roles: account already has role");
517         role.bearer[account] = true;
518     }
519 
520     /**
521      * @dev Remove an account's access to this role.
522      */
523     function remove(Role storage role, address account) internal {
524         require(has(role, account), "Roles: account does not have role");
525         role.bearer[account] = false;
526     }
527 
528     /**
529      * @dev Check if an account has this role.
530      * @return bool
531      */
532     function has(Role storage role, address account) internal view returns (bool) {
533         require(account != address(0), "Roles: account is the zero address");
534         return role.bearer[account];
535     }
536 }
537 
538 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
539 
540 pragma solidity ^0.5.0;
541 
542 
543 
544 contract MinterRole is Context {
545     using Roles for Roles.Role;
546 
547     event MinterAdded(address indexed account);
548     event MinterRemoved(address indexed account);
549 
550     Roles.Role private _minters;
551 
552     constructor () internal {
553         _addMinter(_msgSender());
554     }
555 
556     modifier onlyMinter() {
557         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
558         _;
559     }
560 
561     function isMinter(address account) public view returns (bool) {
562         return _minters.has(account);
563     }
564 
565     function addMinter(address account) public onlyMinter {
566         _addMinter(account);
567     }
568 
569     function renounceMinter() public {
570         _removeMinter(_msgSender());
571     }
572 
573     function _addMinter(address account) internal {
574         _minters.add(account);
575         emit MinterAdded(account);
576     }
577 
578     function _removeMinter(address account) internal {
579         _minters.remove(account);
580         emit MinterRemoved(account);
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
585 
586 pragma solidity ^0.5.0;
587 
588 
589 
590 /**
591  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
592  * which have permission to mint (create) new tokens as they see fit.
593  *
594  * At construction, the deployer of the contract is the only minter.
595  */
596 contract ERC20Mintable is ERC20, MinterRole {
597     /**
598      * @dev See {ERC20-_mint}.
599      *
600      * Requirements:
601      *
602      * - the caller must have the {MinterRole}.
603      */
604     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
605         _mint(account, amount);
606         return true;
607     }
608 }
609 
610 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
611 
612 pragma solidity ^0.5.0;
613 
614 
615 /**
616  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
617  */
618 contract ERC20Capped is ERC20Mintable {
619     uint256 private _cap;
620 
621     /**
622      * @dev Sets the value of the `cap`. This value is immutable, it can only be
623      * set once during construction.
624      */
625     constructor (uint256 cap) public {
626         require(cap > 0, "ERC20Capped: cap is 0");
627         _cap = cap;
628     }
629 
630     /**
631      * @dev Returns the cap on the token's total supply.
632      */
633     function cap() public view returns (uint256) {
634         return _cap;
635     }
636 
637     /**
638      * @dev See {ERC20Mintable-mint}.
639      *
640      * Requirements:
641      *
642      * - `value` must not cause the total supply to go over the cap.
643      */
644     function _mint(address account, uint256 value) internal {
645         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
646         super._mint(account, value);
647     }
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
651 
652 pragma solidity ^0.5.0;
653 
654 
655 /**
656  * @dev Optional functions from the ERC20 standard.
657  */
658 contract ERC20Detailed is IERC20 {
659     string private _name;
660     string private _symbol;
661     uint8 private _decimals;
662 
663     /**
664      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
665      * these values are immutable: they can only be set once during
666      * construction.
667      */
668     constructor (string memory name, string memory symbol, uint8 decimals) public {
669         _name = name;
670         _symbol = symbol;
671         _decimals = decimals;
672     }
673 
674     /**
675      * @dev Returns the name of the token.
676      */
677     function name() public view returns (string memory) {
678         return _name;
679     }
680 
681     /**
682      * @dev Returns the symbol of the token, usually a shorter version of the
683      * name.
684      */
685     function symbol() public view returns (string memory) {
686         return _symbol;
687     }
688 
689     /**
690      * @dev Returns the number of decimals used to get its user representation.
691      * For example, if `decimals` equals `2`, a balance of `505` tokens should
692      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
693      *
694      * Tokens usually opt for a value of 18, imitating the relationship between
695      * Ether and Wei.
696      *
697      * NOTE: This information is only used for _display_ purposes: it in
698      * no way affects any of the arithmetic of the contract, including
699      * {IERC20-balanceOf} and {IERC20-transfer}.
700      */
701     function decimals() public view returns (uint8) {
702         return _decimals;
703     }
704 }
705 
706 // File: contracts/MegaCoin.sol
707 
708 pragma solidity >=0.5.0;
709 
710 
711 
712 /**
713  * @title MegaCoin contract 
714  */
715 contract MegaCoin is ERC20Capped, ERC20Detailed {
716     uint noOfTokens = 3_000_000_000; // 3.0B
717 
718     // Address of mega coin vault
719     // The vault will have all the mega coin issued.
720     address internal vault;
721 
722     // Address of mega coin owner
723     // The owner can change admin and vault address.
724     address internal owner;
725 
726     // Address of mega coin admin
727     // The admin can change reserve. The reserve is the amount of token
728     // assigned to some address but not permitted to use.
729     address internal admin;
730 
731     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
732     event VaultChanged(address indexed previousVault, address indexed newVault);
733     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
734     event ReserveChanged(address indexed _address, uint amount);
735 
736     /**
737      * @dev reserved number of tokens per each address
738      *
739      * To limit token transaction for some period by the admin,
740      * each address' balance cannot become lower than this amount
741      *
742      */
743     mapping(address => uint) public reserves;
744 
745     /**
746        * @dev modifier to limit access to the owner only
747        */
748     modifier onlyOwner() {
749         require(msg.sender == owner);
750         _;
751     }
752 
753     /**
754        * @dev limit access to the vault only
755        */
756     modifier onlyVault() {
757         require(msg.sender == vault);
758         _;
759     }
760 
761     /**
762        * @dev limit access to the admin only
763        */
764     modifier onlyAdmin() {
765         require(msg.sender == admin);
766         _;
767     }
768 
769     /**
770        * @dev limit access to owner or vault
771        */
772     modifier onlyOwnerOrVault() {
773         require(msg.sender == owner || msg.sender == vault);
774         _;
775     }
776 
777     /**
778      * @dev initialize QRC20(ERC20)
779      *
780      * all token will deposit into the vault
781      * later, the vault, owner will be multi sign contract to protect privileged operations
782      *
783      * @param _symbol token symbol
784      * @param _name   token name
785      * @param _owner  owner address
786      * @param _admin  admin address
787      * @param _vault  vault address
788      *
789      * Cap the mintable amount to 77.7B(77,700,000,000)
790      *
791      */
792     constructor (string memory _symbol, string memory _name, address _owner,
793         address _admin, address _vault) ERC20Detailed(_name, _symbol, 18) ERC20Capped(77_700_000_000_000_000_000_000_000_000)
794     public {
795         require(bytes(_symbol).length > 0);
796         require(bytes(_name).length > 0);
797 
798         owner = _owner;
799         admin = _admin;
800         vault = _vault;
801 
802         // mint coins to the vault
803         _mint(vault, noOfTokens * (10 ** uint(decimals())));
804     }
805 
806     /**
807      * @dev change the amount of reserved token
808      *
809      * @param _address the target address whose token will be frozen for future use
810      * @param _reserve  the amount of reserved token
811      *
812      */
813     function setReserve(address _address, uint _reserve) public onlyAdmin {
814         require(_reserve <= totalSupply());
815         require(_address != address(0));
816 
817         reserves[_address] = _reserve;
818         emit ReserveChanged(_address, _reserve);
819     }
820 
821     /**
822      * @dev transfer token from sender to other
823      *         the result balance should be greater than or equal to the reserved token amount
824      */
825     function transfer(address _to, uint256 _value) public returns (bool) {
826         // check the reserve
827         require(balanceOf(msg.sender).sub(_value) >= reserveOf(msg.sender));
828         return super.transfer(_to, _value);
829     }
830 
831     /**
832      * @dev change vault address
833      *
834      * @param _newVault new vault address
835      */
836     function setVault(address _newVault) public onlyOwner {
837         require(_newVault != address(0));
838         require(_newVault != vault);
839 
840         address _oldVault = vault;
841 
842         // change vault address
843         vault = _newVault;
844         emit VaultChanged(_oldVault, _newVault);
845     }
846 
847     /**
848      * @dev change owner address
849      * @param _newOwner new owner address
850      */
851     function setOwner(address _newOwner) public onlyVault {
852         require(_newOwner != address(0));
853         require(_newOwner != owner);
854 
855         emit OwnerChanged(owner, _newOwner);
856         owner = _newOwner;
857     }
858 
859     /**
860      * @dev change admin address
861      * @param _newAdmin new admin address
862      */
863     function setAdmin(address _newAdmin) public onlyOwnerOrVault {
864         require(_newAdmin != address(0));
865         require(_newAdmin != admin);
866 
867         emit AdminChanged(admin, _newAdmin);
868         admin = _newAdmin;
869     }
870 
871     /**
872      * @dev Transfer tokens from one address to another
873      *
874      * The _from's mega balance should be larger than the reserved amount(reserves[_from]) plus _value.
875      *
876      *   NOTE: no one can tranfer from vault
877      *
878      */
879     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
880         require(_from != vault);
881         require(_value <= balanceOf(_from).sub(reserves[_from]));
882         return super.transferFrom(_from, _to, _value);
883     }
884 
885     function getOwner() public view returns (address) {
886         return owner;
887     }
888 
889     function getVault() public view returns (address) {
890         return vault;
891     }
892 
893     function getAdmin() public view returns (address) {
894         return admin;
895     }
896 
897     function getOneMegaCoin() public view returns (uint) {
898         return (10 ** uint(decimals()));
899     }
900 
901     /**
902      * @dev get the amount of reserved token
903      */
904     function reserveOf(address _address) public view returns (uint _reserve) {
905         return reserves[_address];
906     }
907 
908     /**
909      * @dev get the amount reserved token of the sender
910      */
911     function reserve() public view returns (uint _reserve) {
912         return reserves[msg.sender];
913     }
914 }