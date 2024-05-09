1 pragma solidity 0.5.16;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev Give an account access to this role.
14      */
15     function add(Role storage role, address account) internal {
16         require(!has(role, account), "Roles: account already has role");
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev Remove an account's access to this role.
22      */
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "Roles: account does not have role");
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev Check if an account has this role.
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0), "Roles: account is the zero address");
34         return role.bearer[account];
35     }
36 }
37 
38 /**
39  * @dev Wrappers over Solidity's arithmetic operations with added overflow
40  * checks.
41  *
42  * Arithmetic operations in Solidity wrap on overflow. This can easily result
43  * in bugs, because programmers usually assume that an overflow raises an
44  * error, which is the standard behavior in high level programming languages.
45  * `SafeMath` restores this intuition by reverting the transaction when an
46  * operation overflows.
47  *
48  * Using this library instead of the unchecked operations eliminates an entire
49  * class of bugs, so it's recommended to use it always.
50  */
51 library SafeMath {
52     /**
53      * @dev Returns the addition of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `+` operator.
57      *
58      * Requirements:
59      * - Addition cannot overflow.
60      */
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the subtraction of two unsigned integers, reverting on
70      * overflow (when the result is negative).
71      *
72      * Counterpart to Solidity's `-` operator.
73      *
74      * Requirements:
75      * - Subtraction cannot overflow.
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     /**
82      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
83      * overflow (when the result is negative).
84      *
85      * Counterpart to Solidity's `-` operator.
86      *
87      * Requirements:
88      * - Subtraction cannot overflow.
89      *
90      * _Available since v2.4.0._
91      */
92     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      *
148      * _Available since v2.4.0._
149      */
150     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         // Solidity only automatically asserts when dividing by 0
152         require(b > 0, errorMessage);
153         uint256 c = a / b;
154         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * Reverts when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
176      * Reverts with custom message when dividing by zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      * - The divisor cannot be zero.
184      *
185      * _Available since v2.4.0._
186      */
187     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b != 0, errorMessage);
189         return a % b;
190     }
191 }
192 
193 
194 /*
195  * @dev Provides information about the current execution context, including the
196  * sender of the transaction and its data. While these are generally available
197  * via msg.sender and msg.data, they should not be accessed in such a direct
198  * manner, since when dealing with GSN meta-transactions the account sending and
199  * paying for execution may not be the actual sender (as far as an application
200  * is concerned).
201  *
202  * This contract is only required for intermediate, library-like contracts.
203  */
204 contract Context {
205     // Empty internal constructor, to prevent people from mistakenly deploying
206     // an instance of this contract, which should be used via inheritance.
207     constructor () internal { }
208     // solhint-disable-previous-line no-empty-blocks
209 
210     function _msgSender() internal view returns (address payable) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view returns (bytes memory) {
215         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
216         return msg.data;
217     }
218 }
219 
220 /**
221  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
222  * the optional functions; to access them see {ERC20Detailed}.
223  */
224 interface IERC20 {
225     /**
226      * @dev Returns the amount of tokens in existence.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     /**
231      * @dev Returns the amount of tokens owned by `account`.
232      */
233     function balanceOf(address account) external view returns (uint256);
234 
235     /**
236      * @dev Moves `amount` tokens from the caller's account to `recipient`.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transfer(address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Returns the remaining number of tokens that `spender` will be
246      * allowed to spend on behalf of `owner` through {transferFrom}. This is
247      * zero by default.
248      *
249      * This value changes when {approve} or {transferFrom} are called.
250      */
251     function allowance(address owner, address spender) external view returns (uint256);
252 
253     /**
254      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * IMPORTANT: Beware that changing an allowance with this method brings the risk
259      * that someone may use both the old and the new allowance by unfortunate
260      * transaction ordering. One possible solution to mitigate this race
261      * condition is to first reduce the spender's allowance to 0 and set the
262      * desired value afterwards:
263      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264      *
265      * Emits an {Approval} event.
266      */
267     function approve(address spender, uint256 amount) external returns (bool);
268 
269     /**
270      * @dev Moves `amount` tokens from `sender` to `recipient` using the
271      * allowance mechanism. `amount` is then deducted from the caller's
272      * allowance.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * Emits a {Transfer} event.
277      */
278     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
279 
280     /**
281      * @dev Emitted when `value` tokens are moved from one account (`from`) to
282      * another (`to`).
283      *
284      * Note that `value` may be zero.
285      */
286     event Transfer(address indexed from, address indexed to, uint256 value);
287 
288     /**
289      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
290      * a call to {approve}. `value` is the new allowance.
291      */
292     event Approval(address indexed owner, address indexed spender, uint256 value);
293 }
294 
295 
296 /**
297  * @dev Implementation of the {IERC20} interface.
298  *
299  * This implementation is agnostic to the way tokens are created. This means
300  * that a supply mechanism has to be added in a derived contract using {_mint}.
301  * For a generic mechanism see {ERC20Mintable}.
302  *
303  * TIP: For a detailed writeup see our guide
304  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
305  * to implement supply mechanisms].
306  *
307  * We have followed general OpenZeppelin guidelines: functions revert instead
308  * of returning `false` on failure. This behavior is nonetheless conventional
309  * and does not conflict with the expectations of ERC20 applications.
310  *
311  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
312  * This allows applications to reconstruct the allowance for all accounts just
313  * by listening to said events. Other implementations of the EIP may not emit
314  * these events, as it isn't required by the specification.
315  *
316  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
317  * functions have been added to mitigate the well-known issues around setting
318  * allowances. See {IERC20-approve}.
319  */
320 contract ERC20 is Context, IERC20 {
321     using SafeMath for uint256;
322 
323     mapping (address => uint256) private _balances;
324 
325     mapping (address => mapping (address => uint256)) private _allowances;
326 
327     uint256 private _totalSupply;
328 
329     /**
330      * @dev See {IERC20-totalSupply}.
331      */
332     function totalSupply() public view returns (uint256) {
333         return _totalSupply;
334     }
335 
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account) public view returns (uint256) {
340         return _balances[account];
341     }
342 
343     /**
344      * @dev See {IERC20-transfer}.
345      *
346      * Requirements:
347      *
348      * - `recipient` cannot be the zero address.
349      * - the caller must have a balance of at least `amount`.
350      */
351     function transfer(address recipient, uint256 amount) public returns (bool) {
352         _transfer(_msgSender(), recipient, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-allowance}.
358      */
359     function allowance(address owner, address spender) public view returns (uint256) {
360         return _allowances[owner][spender];
361     }
362 
363     /**
364      * @dev See {IERC20-approve}.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function approve(address spender, uint256 amount) public returns (bool) {
371         _approve(_msgSender(), spender, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-transferFrom}.
377      *
378      * Emits an {Approval} event indicating the updated allowance. This is not
379      * required by the EIP. See the note at the beginning of {ERC20};
380      *
381      * Requirements:
382      * - `sender` and `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      * - the caller must have allowance for `sender`'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
388         _transfer(sender, recipient, amount);
389         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
407         return true;
408     }
409 
410     /**
411      * @dev Atomically decreases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      * - `spender` must have allowance for the caller of at least
422      * `subtractedValue`.
423      */
424     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
425         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
426         return true;
427     }
428 
429     /**
430      * @dev Moves tokens `amount` from `sender` to `recipient`.
431      *
432      * This is internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `sender` cannot be the zero address.
440      * - `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      */
443     function _transfer(address sender, address recipient, uint256 amount) internal {
444         require(sender != address(0), "ERC20: transfer from the zero address");
445         require(recipient != address(0), "ERC20: transfer to the zero address");
446 
447         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
448         _balances[recipient] = _balances[recipient].add(amount);
449         emit Transfer(sender, recipient, amount);
450     }
451 
452     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
453      * the total supply.
454      *
455      * Emits a {Transfer} event with `from` set to the zero address.
456      *
457      * Requirements
458      *
459      * - `to` cannot be the zero address.
460      */
461     function _mint(address account, uint256 amount) internal {
462         require(account != address(0), "ERC20: mint to the zero address");
463 
464         _totalSupply = _totalSupply.add(amount);
465         _balances[account] = _balances[account].add(amount);
466         emit Transfer(address(0), account, amount);
467     }
468 
469      /**
470      * @dev Destroys `amount` tokens from `account`, reducing the
471      * total supply.
472      *
473      * Emits a {Transfer} event with `to` set to the zero address.
474      *
475      * Requirements
476      *
477      * - `account` cannot be the zero address.
478      * - `account` must have at least `amount` tokens.
479      */
480     function _burn(address account, uint256 amount) internal {
481         require(account != address(0), "ERC20: burn from the zero address");
482 
483         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
484         _totalSupply = _totalSupply.sub(amount);
485         emit Transfer(account, address(0), amount);
486     }
487 
488     /**
489      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
490      *
491      * This is internal function is equivalent to `approve`, and can be used to
492      * e.g. set automatic allowances for certain subsystems, etc.
493      *
494      * Emits an {Approval} event.
495      *
496      * Requirements:
497      *
498      * - `owner` cannot be the zero address.
499      * - `spender` cannot be the zero address.
500      */
501     function _approve(address owner, address spender, uint256 amount) internal {
502         require(owner != address(0), "ERC20: approve from the zero address");
503         require(spender != address(0), "ERC20: approve to the zero address");
504 
505         _allowances[owner][spender] = amount;
506         emit Approval(owner, spender, amount);
507     }
508 
509     /**
510      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
511      * from the caller's allowance.
512      *
513      * See {_burn} and {_approve}.
514      */
515     function _burnFrom(address account, uint256 amount) internal {
516         _burn(account, amount);
517         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
518     }
519 }
520 
521 
522 /**
523  * @dev Optional functions from the ERC20 standard.
524  */
525 contract ERC20Detailed is IERC20 {
526     string private _name;
527     string private _symbol;
528     uint8 private _decimals;
529 
530     /**
531      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
532      * these values are immutable: they can only be set once during
533      * construction.
534      */
535     constructor (string memory name, string memory symbol, uint8 decimals) public {
536         _name = name;
537         _symbol = symbol;
538         _decimals = decimals;
539     }
540 
541     /**
542      * @dev Returns the name of the token.
543      */
544     function name() public view returns (string memory) {
545         return _name;
546     }
547 
548     /**
549      * @dev Returns the symbol of the token, usually a shorter version of the
550      * name.
551      */
552     function symbol() public view returns (string memory) {
553         return _symbol;
554     }
555 
556     /**
557      * @dev Returns the number of decimals used to get its user representation.
558      * For example, if `decimals` equals `2`, a balance of `505` tokens should
559      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
560      *
561      * Tokens usually opt for a value of 18, imitating the relationship between
562      * Ether and Wei.
563      *
564      * NOTE: This information is only used for _display_ purposes: it in
565      * no way affects any of the arithmetic of the contract, including
566      * {IERC20-balanceOf} and {IERC20-transfer}.
567      */
568     function decimals() public view returns (uint8) {
569         return _decimals;
570     }
571 }
572 
573 
574 /// @author BlockBen
575 /// @title BNOXToken Adminrole
576 /// @notice BNOXToken Adminrole implementation
577 contract BNOXAdminRole is Context {
578     using Roles for Roles.Role;
579 
580     /// @notice superadmin on paper wallet for worst case key compromise
581     address _superadmin;
582 
583     /// @notice list (mapping) of BNOX admins
584     Roles.Role _BNOXAdmins;
585 
586     /// @notice list (mapping) of Treasury admins can only mint or burn
587     Roles.Role _TreasuryAdmins;
588 
589     /// @notice list (mapping) of KYC admins can only whitelist and blacklist addresses
590     Roles.Role _KYCAdmins;
591 
592     /// @notice Event for Admin addedd
593     event BNOXAdminAdded(address indexed account);
594     /// @notice Event for Admin removed
595     event BNOXAdminRemoved(address indexed account);
596     /// @notice Event for adding treasury admin
597     event BNOXTreasuryAdminAdded(address indexed account);
598     /// @notice Event for rmoving treasury admin
599     event BNOXTreasuryAdminRemoved(address indexed account);
600     /// @notice Event for adding KYC admin
601     event BNOXKYCAdminAdded(address indexed account);
602     /// @notice Event for rmoving KYC admin
603     event BNOXKYCAdminRemoved(address indexed account);
604 
605     // constructor setting the superadmin and adding deployer as admin
606     constructor (address superadmin) internal {
607         _superadmin = superadmin;
608         _BNOXAdmins.add(_msgSender());
609         emit BNOXAdminAdded(_msgSender());
610     }
611 
612     /// @notice Modifyer checking if the caller is a BNOX admin
613     modifier onlyBNOXAdmin() {
614         require((isBNOXAdmin(_msgSender()) || (_msgSender() == _superadmin)), "BNOXAdmin: caller does not have the BNOXAdmin role");
615         _;
616     }
617 
618     /// @notice Modifyer checking if the caller is a Treasury admin
619     modifier onlyTreasuryAdmin() {
620         require(isTreasuryAdmin(_msgSender()), "Treasury admin: caller does not have the TreasuryAdmin role");
621         _;
622     }
623 
624     /// @notice Modifyer checking if the caller is a KYC admin
625     modifier onlyKYCAdmin() {
626         require(isKYCAdmin(_msgSender()), "KYC admin: caller does not have the KYCAdmin role");
627         _;
628     }
629 
630     /// @notice Checking if the address is a KYC admin
631     /// @dev ...
632     /// @param account The address of the account to be checked
633     /// @return true if the account is a KYC admin
634     function isKYCAdmin(address account) public view returns (bool) {
635         return _KYCAdmins.has(account);
636     }
637 
638     /// @notice Checking if the address is a Treasury admin
639     /// @dev ...
640     /// @param account The address of the account to be checked
641     /// @return true if the account is a treasury admin
642     function isTreasuryAdmin(address account) public view returns (bool) {
643         return _TreasuryAdmins.has(account);
644     }
645 
646     /// @notice Checking if the address is a BNOX admin
647     /// @dev ...
648     /// @param account The address of the account to be checked
649     /// @return true if the account is an admin
650     function isBNOXAdmin(address account) public view returns (bool) {
651         return _BNOXAdmins.has(account);
652     }
653 
654     /// @notice Adding an account as a BNOX admin
655     /// @dev ...
656     /// @param account The address of the account to be added
657     function addBNOXAdmin(address account) external onlyBNOXAdmin {
658         _BNOXAdmins.add(account);
659         emit BNOXAdminAdded(account);
660     }
661 
662     /// @notice Removing an account as a BNOX admin
663     /// @dev ...
664     /// @param account The address of the account to be added
665     function removeBNOXAdmin(address account) external onlyBNOXAdmin {
666         _BNOXAdmins.remove(account);
667         emit BNOXAdminRemoved(account);
668     }
669 
670     /// @notice Adding an account as a Treasury admin
671     /// @dev ...
672     /// @param account The address of the account to be added
673     function addTreasuryAdmin(address account) external onlyBNOXAdmin {
674         _TreasuryAdmins.add(account);
675         emit BNOXTreasuryAdminAdded(account);
676     }
677 
678     /// @notice Removing an account as a Treasury admin
679     /// @dev ...
680     /// @param account The address of the account to be removed
681     function removeTreasuryAdmin(address account) external onlyBNOXAdmin {
682         _TreasuryAdmins.remove(account);
683         emit BNOXTreasuryAdminRemoved(account);
684     }
685 
686     /// @notice Adding an account as a KYC admin
687     /// @dev ...
688     /// @param account The address of the account to be added
689     function addKYCAdmin(address account) external onlyBNOXAdmin {
690         _KYCAdmins.add(account);
691         emit BNOXKYCAdminAdded(account);
692     }
693 
694     /// @notice Removing an account as a KYC admin
695     /// @dev ...
696     /// @param account The address of the account to be removed
697     function removeKYCAdmin(address account) external onlyBNOXAdmin {
698         _KYCAdmins.remove(account);
699         emit BNOXKYCAdminRemoved(account);
700     }
701 
702 }
703 
704 
705 
706 /// @author Blockben
707 /// @title BNOXToken KYC specific extentions of the token functionalities
708 /// @notice BNOXToken extentions for handling source and destination KYC
709 contract BNOXAdminExt is BNOXAdminRole {
710 
711     /// @notice administrating locks for the source contracts
712     mapping(address => bool) _sourceAccountWL;
713 
714     /// @notice administrating locks for the destination contracts
715     mapping(address => bool) _destinationAccountWL;
716 
717     /// @notice url for external verification
718     string public url;
719 
720     /// @notice addres for collecting and burning tokens
721     address public treasuryAddress;
722 
723     /// @notice addres for fee
724     address public feeAddress;
725 
726     /// @notice addres for bsopool
727     address public bsopoolAddress;
728 
729     /// @notice general transaction fee
730     uint16 public generalFee;
731 
732     /// @notice bso transaction fee
733     uint16 public bsoFee;
734 
735     /// @notice basic functionality can be paused
736     bool public paused;
737 
738     /// @notice Event for locking or unlocking a source account
739     event BNOXSourceAccountWL(address indexed account, bool lockValue);
740     /// @notice Event for locking or unlocking a destination account
741     event BNOXDestinationAccountWL(address indexed account, bool lockValue);
742     /// @notice Event for locking or unlocking a destination account
743     event BNOXUrlSet(string ulr);
744     /// @notice Event for changing the terasury address
745     event BNOXTreasuryAddressChange(address newAddress);
746     /// @notice Event for changing the fee address
747     event BNOXFeeAddressChange(address newAddress);
748     /// @notice Event for changing the bsopool address
749     event BNOXBSOPOOLAddressChange(address newAddress);
750     /// @notice Event for changing the general fee
751     event BNOXGeneralFeeChange(uint256 newFee);
752     /// @notice Event for changing the bso fee
753     event BNOXBSOFeeChange(uint256 newFee);
754     /// @notice Token is paused by the account
755     event BNOXPaused(address account);
756     /// @notice Token is un-paused by the account
757     event BNOXUnpaused(address account);
758 
759     // constructor setting the contract unpaused and delegating the superadmin
760     constructor (address superadmin) BNOXAdminRole(superadmin) internal {
761         paused = false;
762     }
763 
764     /// @notice Modifier only if not paused
765     modifier whenNotPaused() {
766         require(!paused, "The token is paused!");
767         _;
768     }
769 
770     /// @notice getting if an address is locked as a source address
771     /// @dev ...
772     /// @param sourceAddress The address of the account to be checked
773     function getSourceAccountWL(address sourceAddress) public view returns (bool) {
774         return _sourceAccountWL[sourceAddress];
775     }
776 
777     /// @notice getting if an address is locked as a destinationAddress
778     /// @dev ...
779     /// @param destinationAddress The address of the account to be checked
780     function getDestinationAccountWL(address destinationAddress) public view returns (bool) {
781         return _destinationAccountWL[destinationAddress];
782     }
783 
784     /// @notice setting if an address is locked as a source address
785     /// @dev ...
786     /// @param sourceAddress The address of the account to be checked
787     function setSourceAccountWL(address sourceAddress, bool lockValue) external onlyKYCAdmin {
788         _sourceAccountWL[sourceAddress] = lockValue;
789         emit BNOXSourceAccountWL(sourceAddress, lockValue);
790     }
791 
792     /// @notice setting if an address is locked as a destination address
793     /// @dev ...
794     /// @param destinationAddress The address of the account to be checked
795     function setDestinationAccountWL(address destinationAddress, bool lockValue) external onlyKYCAdmin {
796         _destinationAccountWL[destinationAddress] = lockValue;
797         emit BNOXDestinationAccountWL(destinationAddress, lockValue);
798     }
799 
800     /// @notice setting the url referring to the documentation
801     /// @dev ...
802     /// @param newUrl The new url
803     function setUrl(string calldata newUrl) external onlyBNOXAdmin {
804         url = newUrl;
805         emit BNOXUrlSet(newUrl);
806     }
807 
808     /// @notice setting a new address for treasuryAddress
809     /// @dev ...
810     /// @param newAddress The new address to set
811     function setTreasuryAddress(address newAddress) external onlyBNOXAdmin {
812         treasuryAddress = newAddress;
813         emit BNOXTreasuryAddressChange(newAddress);
814     }
815 
816     /// @notice setting a new address for feeAddress
817     /// @dev ...
818     /// @param newAddress The new address to set
819     function setFeeAddress(address newAddress) external onlyBNOXAdmin {
820         feeAddress = newAddress;
821         emit BNOXFeeAddressChange(newAddress);
822     }
823 
824     /// @notice setting a new address for feeAddress
825     /// @dev ...
826     /// @param newAddress The new address to set
827     function setBsopoolAddress(address newAddress) external onlyBNOXAdmin {
828         bsopoolAddress = newAddress;
829         emit BNOXBSOPOOLAddressChange(newAddress);
830     }
831 
832     /// @notice setting a new general fee
833     /// @dev ...
834     /// @param newFee The new fee to set
835     function setGeneralFee(uint16 newFee) external onlyBNOXAdmin {
836         generalFee = newFee;
837         emit BNOXGeneralFeeChange(newFee);
838     }
839 
840     /// @notice setting a new bsoFee fee
841     /// @dev ...
842     /// @param newFee The new fee to set
843     function setBsoFee(uint16 newFee) external onlyBNOXAdmin {
844         bsoFee = newFee;
845         emit BNOXBSOFeeChange(newFee);
846     }
847 
848     /// @notice pause the contract
849     /// @dev ...
850     function pause() external onlyBNOXAdmin {
851         require(paused == false, "The contract is already paused");
852         paused = true;
853         emit BNOXPaused(_msgSender());
854     }
855 
856     /// @notice un-pause the contract
857     /// @dev ...
858     function unpause() external onlyBNOXAdmin {
859         paused = false;
860         emit BNOXUnpaused(_msgSender());
861     }
862 
863 }
864 
865 /// @author Blockben
866 /// @title BNOXToken standard extentions for the token functionalities
867 /// @notice BNOXToken extentions for mint, burn and kill
868 contract BNOXStandardExt is BNOXAdminExt, ERC20 {
869 
870     // constructor delegating superadmin role to the BNOXAdminRole
871     constructor (address superadmin) BNOXAdminExt(superadmin) internal {
872     }
873 
874     /// @notice transfer BNOX token, only if not paused
875     /// @dev ...
876     /// @param to The address of the account to be transferred
877     /// @param value The amount of token to be transferred
878     /// @return true if everything is cool
879     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
880         _transfer(_msgSender(), to, value);
881         return true;
882     }
883 
884     /// @notice transferFrom BNOX token, only if not paused
885     /// @dev ...
886     /// @param from The address transferred from
887     /// @param to The amount transferred to
888     /// @param value The amount of token to be transferred
889     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
890         return super.transferFrom(from, to, value);
891     }
892 
893     /// @notice approve BNOX token to be moved with tranferFrom, only if not paused
894     /// @dev ...
895     /// @param spender The address to be approved
896     /// @param value The amount of token to be allowed to be transferred
897     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
898         require((value == 0) || (allowance(msg.sender, spender) == 0), "approve must be set to zero first");
899         return super.approve(spender, value);
900     }
901 
902     /// @notice increase approved BNOX token, only if not paused
903     /// @dev ...
904     /// @param spender The address to be approved
905     /// @param addedValue The amount of token to be allowed to be transferred
906     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
907         return super.increaseAllowance(spender, addedValue);
908     }
909 
910     /// @notice decrease approved BNOX token, only if not paused
911     /// @dev ...
912     /// @param spender The address to be approved
913     /// @param subtractedValue The amount of token to be allowed to be transferred
914     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
915         return super.decreaseAllowance(spender, subtractedValue);
916     }
917 
918 
919     /// @notice mint BNOX token, only Treasury admin, only if no paused
920     /// @dev ...
921     /// @param account The address of the account to be minted
922     /// @param amount The amount of token to be minted
923     /// @return true if everything is cool
924     function mint(address account, uint256 amount) external onlyTreasuryAdmin whenNotPaused returns (bool) {
925         _mint(account, amount);
926         return true;
927     }
928 
929     /// @notice burning BNOX token from the treasury account, only if not paused
930     /// @dev ...
931     /// @param amount The amount of token to be burned
932     function burn(uint256 amount) external onlyTreasuryAdmin whenNotPaused {
933         require(getSourceAccountWL(treasuryAddress) == true, "Treasury address is locked by the source account whitelist");
934         _burnFrom(treasuryAddress, amount);
935     }
936 
937     /// @notice killing the contract, only paused contract can be killed by the admin
938     /// @dev ...
939     /// @param toChashOut The address where the ether of the token should be sent
940     function kill(address payable toChashOut) external onlyBNOXAdmin {
941         require (paused == true, "only paused contract can be killed");
942         selfdestruct(toChashOut);
943     }
944 
945     /// @notice mint override to consider address lock for KYC
946     /// @dev ...
947     /// @param account The address where token is mineted
948     /// @param amount The amount to be minted
949     function _mint(address account, uint256 amount) internal {
950         require(getDestinationAccountWL(account) == true, "Target account is locked by the destination account whitelist");
951 
952         super._mint(account, amount);
953     }
954 
955     /// @notice transfer override to consider locks for KYC
956     /// @dev ...
957     /// @param sender The address from where the token sent
958     /// @param recipient Recipient address
959     /// @param amount The amount to be transferred
960     function _transfer(address sender, address recipient, uint256 amount) internal {
961         require(getSourceAccountWL(sender) == true, "Sender account is not unlocked by the source account whitelist");
962         require(getDestinationAccountWL(recipient) == true, "Target account is not unlocked by the destination account whitelist");
963         require(getDestinationAccountWL(feeAddress) == true, "General fee account is not unlocked by the destination account whitelist");
964         require(getDestinationAccountWL(bsopoolAddress) == true, "Bso pool account is not unlocked by the destination account whitelist");
965 
966         // transfer to the trasuryAddress or transfer from the treasuryAddress do not cost transaction fee
967         if((sender == treasuryAddress) || (recipient == treasuryAddress)){
968             super._transfer(sender, recipient, amount);
969         }
970         else {
971 
972             // three decimal in percent
973             // The decimalcorrection is 100.000, but to avoid rounding errors, first use 10.000 and
974             // where we use decimalCorrection the calculation must add 5 and divide 10 at the and
975             uint256 decimalCorrection = 10000;
976 
977             // calculate and transfer fee
978             uint256 generalFee256 = generalFee;
979 
980             uint256 bsoFee256 = bsoFee;
981 
982             uint256 totalFee = generalFee256.add(bsoFee256);
983 
984             // To avoid rounding errors add 5 and then div by 10. Read comment at decimalCorrection
985             uint256 amountTotal = amount.mul(totalFee).div(decimalCorrection).add(5).div(10);
986 
987             // To avoid rounding errors add 5 and then div by 10. Read comment at decimalCorrection
988             uint256 amountBso = amount.mul(bsoFee256).div(decimalCorrection).add(5).div(10);
989 
990             uint256 amountGeneral = amountTotal.sub(amountBso);
991 
992             uint256 amountRest = amount.sub(amountTotal);
993 
994             super._transfer(sender, recipient, amountRest);
995             super._transfer(sender, feeAddress, amountGeneral);
996             super._transfer(sender, bsopoolAddress, amountBso);
997         }
998     }
999 }
1000 
1001 /// @author Blockben
1002 /// @title BNOXToken
1003 /// @notice BNOXToken implementation
1004 contract BNOXToken is BNOXStandardExt, ERC20Detailed {
1005 
1006     /// @notice Constructor: creating initial supply and setting one admin
1007     /// @dev Not working with decimal numbers
1008     /// @param superadmin superadmnin of the token
1009     constructor(address superadmin) BNOXStandardExt(superadmin) ERC20Detailed("BlockNoteX", "BNOX", 2) public {
1010     }
1011 }