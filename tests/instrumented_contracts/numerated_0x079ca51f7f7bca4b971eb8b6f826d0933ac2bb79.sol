1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
80 // File: @openzeppelin/contracts/math/SafeMath.sol
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
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See `IERC20.approve`.
218  */
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     /**
229      * @dev See `IERC20.totalSupply`.
230      */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See `IERC20.balanceOf`.
237      */
238     function balanceOf(address account) public view returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See `IERC20.transfer`.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See `IERC20.allowance`.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See `IERC20.approve`.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.transferFrom`.
276      *
277      * Emits an `Approval` event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of `ERC20`;
279      *
280      * Requirements:
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `value`.
283      * - the caller must have allowance for `sender`'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to `transfer`, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a `Transfer` event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _balances[sender] = _balances[sender].sub(amount);
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a `Transfer` event with `from` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _totalSupply = _totalSupply.add(amount);
364         _balances[account] = _balances[account].add(amount);
365         emit Transfer(address(0), account, amount);
366     }
367 
368      /**
369      * @dev Destoys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a `Transfer` event with `to` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
389      *
390      * This is internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an `Approval` event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
410      * from the caller's allowance.
411      *
412      * See `_burn` and `_approve`.
413      */
414     function _burnFrom(address account, uint256 amount) internal {
415         _burn(account, amount);
416         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
417     }
418 }
419 
420 // File: @openzeppelin/contracts/access/Roles.sol
421 
422 pragma solidity ^0.5.0;
423 
424 /**
425  * @title Roles
426  * @dev Library for managing addresses assigned to a Role.
427  */
428 library Roles {
429     struct Role {
430         mapping (address => bool) bearer;
431     }
432 
433     /**
434      * @dev Give an account access to this role.
435      */
436     function add(Role storage role, address account) internal {
437         require(!has(role, account), "Roles: account already has role");
438         role.bearer[account] = true;
439     }
440 
441     /**
442      * @dev Remove an account's access to this role.
443      */
444     function remove(Role storage role, address account) internal {
445         require(has(role, account), "Roles: account does not have role");
446         role.bearer[account] = false;
447     }
448 
449     /**
450      * @dev Check if an account has this role.
451      * @return bool
452      */
453     function has(Role storage role, address account) internal view returns (bool) {
454         require(account != address(0), "Roles: account is the zero address");
455         return role.bearer[account];
456     }
457 }
458 
459 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
460 
461 pragma solidity ^0.5.0;
462 
463 
464 contract MinterRole {
465     using Roles for Roles.Role;
466 
467     event MinterAdded(address indexed account);
468     event MinterRemoved(address indexed account);
469 
470     Roles.Role private _minters;
471 
472     constructor () internal {
473         _addMinter(msg.sender);
474     }
475 
476     modifier onlyMinter() {
477         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
478         _;
479     }
480 
481     function isMinter(address account) public view returns (bool) {
482         return _minters.has(account);
483     }
484 
485     function addMinter(address account) public onlyMinter {
486         _addMinter(account);
487     }
488 
489     function renounceMinter() public {
490         _removeMinter(msg.sender);
491     }
492 
493     function _addMinter(address account) internal {
494         _minters.add(account);
495         emit MinterAdded(account);
496     }
497 
498     function _removeMinter(address account) internal {
499         _minters.remove(account);
500         emit MinterRemoved(account);
501     }
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
505 
506 pragma solidity ^0.5.0;
507 
508 
509 
510 /**
511  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
512  * which have permission to mint (create) new tokens as they see fit.
513  *
514  * At construction, the deployer of the contract is the only minter.
515  */
516 contract ERC20Mintable is ERC20, MinterRole {
517     /**
518      * @dev See `ERC20._mint`.
519      *
520      * Requirements:
521      *
522      * - the caller must have the `MinterRole`.
523      */
524     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
525         _mint(account, amount);
526         return true;
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
531 
532 pragma solidity ^0.5.0;
533 
534 
535 /**
536  * @dev Optional functions from the ERC20 standard.
537  */
538 contract ERC20Detailed is IERC20 {
539     string private _name;
540     string private _symbol;
541     uint8 private _decimals;
542 
543     /**
544      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
545      * these values are immutable: they can only be set once during
546      * construction.
547      */
548     constructor (string memory name, string memory symbol, uint8 decimals) public {
549         _name = name;
550         _symbol = symbol;
551         _decimals = decimals;
552     }
553 
554     /**
555      * @dev Returns the name of the token.
556      */
557     function name() public view returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev Returns the symbol of the token, usually a shorter version of the
563      * name.
564      */
565     function symbol() public view returns (string memory) {
566         return _symbol;
567     }
568 
569     /**
570      * @dev Returns the number of decimals used to get its user representation.
571      * For example, if `decimals` equals `2`, a balance of `505` tokens should
572      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
573      *
574      * Tokens usually opt for a value of 18, imitating the relationship between
575      * Ether and Wei.
576      *
577      * > Note that this information is only used for _display_ purposes: it in
578      * no way affects any of the arithmetic of the contract, including
579      * `IERC20.balanceOf` and `IERC20.transfer`.
580      */
581     function decimals() public view returns (uint8) {
582         return _decimals;
583     }
584 }
585 
586 // File: contracts/CfoCoin.sol
587 
588 pragma solidity >=0.5.0;
589 
590 
591 
592 /**
593  * @title CfoCoin contract 
594  */
595 contract CfoCoin is ERC20Mintable, ERC20Detailed {
596     uint noOfTokens = 10000000000; // 10,000,000,000 (10B)
597 
598     // Address of cfgcoin vault (a CfoCoinMultiSigWallet contract)
599     // The vault will have all the cfgcoin issued and the operation
600     // on its token will be protected by multi signing.
601     // In addtion, vault can recall(transfer back) the reserved amount
602     // from some address.
603     address internal vault;
604 
605     // Address of cfgcoin owner (a CfoCoinMultiSigWallet contract)
606     // The owner can change admin and vault address, but the change operation
607     // will be protected by multi signing.
608     address internal owner;
609 
610     // Address of cfgcoin admin (a CfoCoinMultiSigWallet contract)
611     // The admin can change reserve. The reserve is the amount of token
612     // assigned to some address but not permitted to use.
613     // Once the signers of the admin agree with removing the reserve,
614     // they can change the reserve to zero to permit the user to use all reserved
615     // amount. So in effect, reservation will postpone the use of some tokens
616     // being used until all stakeholders agree with giving permission to use that
617     // token to the token owner.
618     // All admin operation will be protected by multi signing.
619     address internal admin;
620 
621     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
622     event VaultChanged(address indexed previousVault, address indexed newVault);
623     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
624     event ReserveChanged(address indexed _address, uint amount);
625     event Recalled(address indexed from, uint amount);
626 
627     // for debugging
628     event MsgAndValue(string message, bytes32 value);
629 
630     /**
631      * @dev reserved number of tokens per each address
632      *
633      * To limit token transaction for some period by the admin or owner,
634      * each address' balance cannot become lower than this amount
635      *
636      */
637     mapping(address => uint) public reserves;
638 
639     /**
640        * @dev modifier to limit access to the owner only
641        */
642     modifier onlyOwner() {
643         require(msg.sender == owner);
644         _;
645     }
646 
647     /**
648        * @dev limit access to the vault only
649        */
650     modifier onlyVault() {
651         require(msg.sender == vault);
652         _;
653     }
654 
655     /**
656        * @dev limit access to the admin only
657        */
658     modifier onlyAdmin() {
659         require(msg.sender == admin);
660         _;
661     }
662 
663     /**
664        * @dev limit access to admin or vault
665        */
666     modifier onlyAdminOrVault() {
667         require(msg.sender == vault || msg.sender == admin);
668         _;
669     }
670 
671     /**
672        * @dev limit access to owner or vault
673        */
674     modifier onlyOwnerOrVault() {
675         require(msg.sender == owner || msg.sender == vault);
676         _;
677     }
678 
679     /**
680        * @dev limit access to owner or admin
681        */
682     modifier onlyAdminOrOwner() {
683         require(msg.sender == owner || msg.sender == admin);
684         _;
685     }
686 
687     /**
688        * @dev limit access to owner or admin or vault
689        */
690     modifier onlyAdminOrOwnerOrVault() {
691         require(msg.sender == owner || msg.sender == vault || msg.sender == admin);
692         _;
693     }
694 
695     /**
696      * @dev initialize QRC20(ERC20)
697      *
698      * all token will deposit into the vault
699      * later, the vault, owner will be multi sign contract to protect privileged operations
700      *
701      * @param _symbol token symbol
702      * @param _name   token name
703      * @param _owner  owner address
704      * @param _admin  admin address
705      * @param _vault  vault address
706      */
707     constructor (string memory _symbol, string memory _name, address _owner,
708         address _admin, address _vault) ERC20Detailed(_name, _symbol, 9)
709     public {
710         require(bytes(_symbol).length > 0);
711         require(bytes(_name).length > 0);
712 
713         owner = _owner;
714         admin = _admin;
715         vault = _vault;
716 
717         // mint coins to the vault
718         _mint(vault, noOfTokens * (10 ** uint(decimals())));
719     }
720 
721     /**
722      * @dev change the amount of reserved token
723      *    reserve should be less than or equal to the current token balance
724      *
725      *    Refer to the comment on the admin if you want to know more.
726      *
727      * @param _address the target address whose token will be frozen for future use
728      * @param _reserve  the amount of reserved token
729      *
730      */
731     function setReserve(address _address, uint _reserve) public onlyAdmin {
732         require(_reserve <= totalSupply());
733         require(_address != address(0));
734 
735         reserves[_address] = _reserve;
736         emit ReserveChanged(_address, _reserve);
737     }
738 
739     /**
740      * @dev transfer token from sender to other
741      *         the result balance should be greater than or equal to the reserved token amount
742      */
743     function transfer(address _to, uint256 _value) public returns (bool) {
744         // check the reserve
745         require(balanceOf(msg.sender) - _value >= reserveOf(msg.sender));
746         return super.transfer(_to, _value);
747     }
748 
749     /**
750      * @dev change vault address
751      *    BEWARE! this withdraw all token from old vault and store it to the new vault
752      *            and new vault's allowed, reserve will be set to zero
753      * @param _newVault new vault address
754      */
755     function setVault(address _newVault) public onlyOwner {
756         require(_newVault != address(0));
757         require(_newVault != vault);
758 
759         address _oldVault = vault;
760 
761         // change vault address
762         vault = _newVault;
763         emit VaultChanged(_oldVault, _newVault);
764 
765         // vault cannot have any allowed or reserved amount!!!
766         _approve(_newVault, msg.sender,  0);
767         reserves[_newVault] = 0;
768 
769         // adjust balance
770         uint _value = balanceOf(_oldVault);
771         _transfer(_oldVault, _newVault, _value);
772     }
773 
774     /**
775      * @dev change owner address
776      * @param _newOwner new owner address
777      */
778     function setOwner(address _newOwner) public onlyVault {
779         require(_newOwner != address(0));
780         require(_newOwner != owner);
781 
782         owner = _newOwner;
783         emit OwnerChanged(owner, _newOwner);
784     }
785 
786     /**
787      * @dev change admin address
788      * @param _newAdmin new admin address
789      */
790     function setAdmin(address _newAdmin) public onlyOwnerOrVault {
791         require(_newAdmin != address(0));
792         require(_newAdmin != admin);
793 
794         admin = _newAdmin;
795 
796         emit AdminChanged(admin, _newAdmin);
797     }
798 
799     /**
800      * @dev transfer a part of reserved amount to the vault
801      *
802      *    Refer to the comment on the vault if you want to know more.
803      *
804      * @param _from the address from which the reserved token will be taken
805      * @param _amount the amount of token to be taken
806      */
807     function recall(address _from, uint _amount) public onlyAdmin {
808         require(_from != address(0));
809         require(_amount > 0);
810 
811         uint currentReserve = reserveOf(_from);
812         uint currentBalance = balanceOf(_from);
813 
814         require(currentReserve >= _amount);
815         require(currentBalance >= _amount);
816 
817         uint newReserve = currentReserve - _amount;
818         reserves[_from] = newReserve;
819         emit ReserveChanged(_from, newReserve);
820 
821         // transfer token _from to vault
822         _transfer(_from, vault, _amount);
823         emit Recalled(_from, _amount);
824     }
825 
826     /**
827      * @dev Transfer tokens from one address to another
828      *
829      * The _from's CFO balance should be larger than the reserved amount(reserves[_from]) plus _value.
830      *
831      */
832     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
833         require(_value <= balanceOf(_from).sub(reserves[_from]));
834         return super.transferFrom(_from, _to, _value);
835     }
836 
837     function getOwner() public view onlyAdminOrOwnerOrVault returns (address) {
838         return owner;
839     }
840 
841     function getVault() public view onlyAdminOrOwnerOrVault returns (address) {
842         return vault;
843     }
844 
845     function getAdmin() public view onlyAdminOrOwnerOrVault returns (address) {
846         return admin;
847     }
848 
849     function getOneCfoCoin() public view returns (uint) {
850         return (10 ** uint(decimals()));
851     }
852 
853     /**
854      * @dev get the amount of reserved token
855      */
856     function reserveOf(address _address) public view returns (uint _reserve) {
857         return reserves[_address];
858     }
859 
860     /**
861      * @dev get the amount reserved token of the sender
862      */
863     function reserve() public view returns (uint _reserve) {
864         return reserves[msg.sender];
865     }
866 }