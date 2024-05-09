1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: @openzeppelin/contracts/access/Roles.sol
502 
503 pragma solidity ^0.5.0;
504 
505 /**
506  * @title Roles
507  * @dev Library for managing addresses assigned to a Role.
508  */
509 library Roles {
510     struct Role {
511         mapping (address => bool) bearer;
512     }
513 
514     /**
515      * @dev Give an account access to this role.
516      */
517     function add(Role storage role, address account) internal {
518         require(!has(role, account), "Roles: account already has role");
519         role.bearer[account] = true;
520     }
521 
522     /**
523      * @dev Remove an account's access to this role.
524      */
525     function remove(Role storage role, address account) internal {
526         require(has(role, account), "Roles: account does not have role");
527         role.bearer[account] = false;
528     }
529 
530     /**
531      * @dev Check if an account has this role.
532      * @return bool
533      */
534     function has(Role storage role, address account) internal view returns (bool) {
535         require(account != address(0), "Roles: account is the zero address");
536         return role.bearer[account];
537     }
538 }
539 
540 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
541 
542 pragma solidity ^0.5.0;
543 
544 
545 
546 contract MinterRole is Context {
547     using Roles for Roles.Role;
548 
549     event MinterAdded(address indexed account);
550     event MinterRemoved(address indexed account);
551 
552     Roles.Role private _minters;
553 
554     constructor () internal {
555         _addMinter(_msgSender());
556     }
557 
558     modifier onlyMinter() {
559         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
560         _;
561     }
562 
563     function isMinter(address account) public view returns (bool) {
564         return _minters.has(account);
565     }
566 
567     function addMinter(address account) public onlyMinter {
568         _addMinter(account);
569     }
570 
571     function renounceMinter() public {
572         _removeMinter(_msgSender());
573     }
574 
575     function _addMinter(address account) internal {
576         _minters.add(account);
577         emit MinterAdded(account);
578     }
579 
580     function _removeMinter(address account) internal {
581         _minters.remove(account);
582         emit MinterRemoved(account);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 
592 /**
593  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
594  * which have permission to mint (create) new tokens as they see fit.
595  *
596  * At construction, the deployer of the contract is the only minter.
597  */
598 contract ERC20Mintable is ERC20, MinterRole {
599     /**
600      * @dev See {ERC20-_mint}.
601      *
602      * Requirements:
603      *
604      * - the caller must have the {MinterRole}.
605      */
606     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
607         _mint(account, amount);
608         return true;
609     }
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
613 
614 pragma solidity ^0.5.0;
615 
616 
617 /**
618  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
619  */
620 contract ERC20Capped is ERC20Mintable {
621     uint256 private _cap;
622 
623     /**
624      * @dev Sets the value of the `cap`. This value is immutable, it can only be
625      * set once during construction.
626      */
627     constructor (uint256 cap) public {
628         require(cap > 0, "ERC20Capped: cap is 0");
629         _cap = cap;
630     }
631 
632     /**
633      * @dev Returns the cap on the token's total supply.
634      */
635     function cap() public view returns (uint256) {
636         return _cap;
637     }
638 
639     /**
640      * @dev See {ERC20Mintable-mint}.
641      *
642      * Requirements:
643      *
644      * - `value` must not cause the total supply to go over the cap.
645      */
646     function _mint(address account, uint256 value) internal {
647         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
648         super._mint(account, value);
649     }
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
653 
654 pragma solidity ^0.5.0;
655 
656 
657 /**
658  * @dev Optional functions from the ERC20 standard.
659  */
660 contract ERC20Detailed is IERC20 {
661     string private _name;
662     string private _symbol;
663     uint8 private _decimals;
664 
665     /**
666      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
667      * these values are immutable: they can only be set once during
668      * construction.
669      */
670     constructor (string memory name, string memory symbol, uint8 decimals) public {
671         _name = name;
672         _symbol = symbol;
673         _decimals = decimals;
674     }
675 
676     /**
677      * @dev Returns the name of the token.
678      */
679     function name() public view returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev Returns the symbol of the token, usually a shorter version of the
685      * name.
686      */
687     function symbol() public view returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev Returns the number of decimals used to get its user representation.
693      * For example, if `decimals` equals `2`, a balance of `505` tokens should
694      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
695      *
696      * Tokens usually opt for a value of 18, imitating the relationship between
697      * Ether and Wei.
698      *
699      * NOTE: This information is only used for _display_ purposes: it in
700      * no way affects any of the arithmetic of the contract, including
701      * {IERC20-balanceOf} and {IERC20-transfer}.
702      */
703     function decimals() public view returns (uint8) {
704         return _decimals;
705     }
706 }
707 
708 // File: contracts/MciCoin.sol
709 
710 pragma solidity >=0.5.0;
711 
712 
713 
714 /**
715  * @title MciCoin contract 
716  */
717 contract MciCoin is ERC20Capped, ERC20Detailed {
718     uint noOfTokens = 3300000000; // 3,300,000,000(3.3B)
719 
720     // Address of mci coin vault
721     // The vault will have all the mci coin issued.
722     address internal vault;
723 
724     // Address of mci coin owner
725     // The owner can change admin and vault address.
726     address internal owner;
727 
728     // Address of mci coin admin
729     // The admin can change reserve. The reserve is the amount of token
730     // assigned to some address but not permitted to use.
731     address internal admin;
732 
733     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
734     event VaultChanged(address indexed previousVault, address indexed newVault);
735     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
736     event ReserveChanged(address indexed _address, uint amount);
737 
738     /**
739      * @dev reserved number of tokens per each address
740      *
741      * To limit token transaction for some period by the admin,
742      * each address' balance cannot become lower than this amount
743      *
744      */
745     mapping(address => uint) public reserves;
746 
747     /**
748        * @dev modifier to limit access to the owner only
749        */
750     modifier onlyOwner() {
751         require(msg.sender == owner);
752         _;
753     }
754 
755     /**
756        * @dev limit access to the vault only
757        */
758     modifier onlyVault() {
759         require(msg.sender == vault);
760         _;
761     }
762 
763     /**
764        * @dev limit access to the admin only
765        */
766     modifier onlyAdmin() {
767         require(msg.sender == admin);
768         _;
769     }
770 
771     /**
772        * @dev limit access to owner or vault
773        */
774     modifier onlyOwnerOrVault() {
775         require(msg.sender == owner || msg.sender == vault);
776         _;
777     }
778 
779     /**
780      * @dev initialize QRC20(ERC20)
781      *
782      * all token will deposit into the vault
783      * later, the vault, owner will be multi sign contract to protect privileged operations
784      *
785      * @param _symbol token symbol
786      * @param _name   token name
787      * @param _owner  owner address
788      * @param _admin  admin address
789      * @param _vault  vault address
790      *
791      * Cap the mintable amount to 88.8B(88,800,000,000)
792      *
793      */
794     constructor (string memory _symbol, string memory _name, address _owner,
795         address _admin, address _vault) ERC20Detailed(_name, _symbol, 9) ERC20Capped(88800000000000000000)
796     public {
797         require(bytes(_symbol).length > 0);
798         require(bytes(_name).length > 0);
799 
800         owner = _owner;
801         admin = _admin;
802         vault = _vault;
803 
804         // mint coins to the vault
805         _mint(vault, noOfTokens * (10 ** uint(decimals())));
806     }
807 
808     /**
809      * @dev change the amount of reserved token
810      *
811      * @param _address the target address whose token will be frozen for future use
812      * @param _reserve  the amount of reserved token
813      *
814      */
815     function setReserve(address _address, uint _reserve) public onlyAdmin {
816         require(_reserve <= totalSupply());
817         require(_address != address(0));
818 
819         reserves[_address] = _reserve;
820         emit ReserveChanged(_address, _reserve);
821     }
822 
823     /**
824      * @dev transfer token from sender to other
825      *         the result balance should be greater than or equal to the reserved token amount
826      */
827     function transfer(address _to, uint256 _value) public returns (bool) {
828         // check the reserve
829         require(balanceOf(msg.sender).sub(_value) >= reserveOf(msg.sender));
830         return super.transfer(_to, _value);
831     }
832 
833     /**
834      * @dev change vault address
835      *
836      * @param _newVault new vault address
837      */
838     function setVault(address _newVault) public onlyOwner {
839         require(_newVault != address(0));
840         require(_newVault != vault);
841 
842         address _oldVault = vault;
843 
844         // change vault address
845         vault = _newVault;
846         emit VaultChanged(_oldVault, _newVault);
847     }
848 
849     /**
850      * @dev change owner address
851      * @param _newOwner new owner address
852      */
853     function setOwner(address _newOwner) public onlyVault {
854         require(_newOwner != address(0));
855         require(_newOwner != owner);
856 
857         emit OwnerChanged(owner, _newOwner);
858         owner = _newOwner;
859     }
860 
861     /**
862      * @dev change admin address
863      * @param _newAdmin new admin address
864      */
865     function setAdmin(address _newAdmin) public onlyOwnerOrVault {
866         require(_newAdmin != address(0));
867         require(_newAdmin != admin);
868 
869         emit AdminChanged(admin, _newAdmin);
870         admin = _newAdmin;
871     }
872 
873     /**
874      * @dev Transfer tokens from one address to another
875      *
876      * The _from's mci balance should be larger than the reserved amount(reserves[_from]) plus _value.
877      *
878      *   NOTE: no one can tranfer from vault
879      *
880      */
881     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
882         require(_from != vault);
883         require(_value <= balanceOf(_from).sub(reserves[_from]));
884         return super.transferFrom(_from, _to, _value);
885     }
886 
887     function getOwner() public view returns (address) {
888         return owner;
889     }
890 
891     function getVault() public view returns (address) {
892         return vault;
893     }
894 
895     function getAdmin() public view returns (address) {
896         return admin;
897     }
898 
899     function getOneMciCoin() public view returns (uint) {
900         return (10 ** uint(decimals()));
901     }
902 
903     /**
904      * @dev get the amount of reserved token
905      */
906     function reserveOf(address _address) public view returns (uint _reserve) {
907         return reserves[_address];
908     }
909 
910     /**
911      * @dev get the amount reserved token of the sender
912      */
913     function reserve() public view returns (uint _reserve) {
914         return reserves[msg.sender];
915     }
916 }