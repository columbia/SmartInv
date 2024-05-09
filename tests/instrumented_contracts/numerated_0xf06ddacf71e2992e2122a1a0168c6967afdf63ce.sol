1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
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
19 
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
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
110 pragma solidity ^0.6.0;
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
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 pragma solidity ^0.6.2;
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 }
321 
322 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
323 
324 pragma solidity ^0.6.0;
325 
326 
327 
328 
329 
330 /**
331  * @dev Implementation of the {IERC20} interface.
332  *
333  * This implementation is agnostic to the way tokens are created. This means
334  * that a supply mechanism has to be added in a derived contract using {_mint}.
335  * For a generic mechanism see {ERC20MinterPauser}.
336  *
337  * TIP: For a detailed writeup see our guide
338  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
339  * to implement supply mechanisms].
340  *
341  * We have followed general OpenZeppelin guidelines: functions revert instead
342  * of returning `false` on failure. This behavior is nonetheless conventional
343  * and does not conflict with the expectations of ERC20 applications.
344  *
345  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
346  * This allows applications to reconstruct the allowance for all accounts just
347  * by listening to said events. Other implementations of the EIP may not emit
348  * these events, as it isn't required by the specification.
349  *
350  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
351  * functions have been added to mitigate the well-known issues around setting
352  * allowances. See {IERC20-approve}.
353  */
354 contract ERC20 is Context, IERC20 {
355     using SafeMath for uint256;
356     using Address for address;
357 
358     mapping (address => uint256) private _balances;
359 
360     mapping (address => mapping (address => uint256)) private _allowances;
361 
362     uint256 private _totalSupply;
363 
364     string private _name;
365     string private _symbol;
366     uint8 private _decimals;
367 
368     /**
369      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
370      * a default value of 18.
371      *
372      * To select a different value for {decimals}, use {_setupDecimals}.
373      *
374      * All three of these values are immutable: they can only be set once during
375      * construction.
376      */
377     constructor (string memory name, string memory symbol) public {
378         _name = name;
379         _symbol = symbol;
380         _decimals = 18;
381     }
382 
383     /**
384      * @dev Returns the name of the token.
385      */
386     function name() public view returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @dev Returns the symbol of the token, usually a shorter version of the
392      * name.
393      */
394     function symbol() public view returns (string memory) {
395         return _symbol;
396     }
397 
398     /**
399      * @dev Returns the number of decimals used to get its user representation.
400      * For example, if `decimals` equals `2`, a balance of `505` tokens should
401      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
402      *
403      * Tokens usually opt for a value of 18, imitating the relationship between
404      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
405      * called.
406      *
407      * NOTE: This information is only used for _display_ purposes: it in
408      * no way affects any of the arithmetic of the contract, including
409      * {IERC20-balanceOf} and {IERC20-transfer}.
410      */
411     function decimals() public view returns (uint8) {
412         return _decimals;
413     }
414 
415     /**
416      * @dev See {IERC20-totalSupply}.
417      */
418     function totalSupply() public view override returns (uint256) {
419         return _totalSupply;
420     }
421 
422     /**
423      * @dev See {IERC20-balanceOf}.
424      */
425     function balanceOf(address account) public view override returns (uint256) {
426         return _balances[account];
427     }
428 
429     /**
430      * @dev See {IERC20-transfer}.
431      *
432      * Requirements:
433      *
434      * - `recipient` cannot be the zero address.
435      * - the caller must have a balance of at least `amount`.
436      */
437     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
438         _transfer(_msgSender(), recipient, amount);
439         return true;
440     }
441 
442     /**
443      * @dev See {IERC20-allowance}.
444      */
445     function allowance(address owner, address spender) public view virtual override returns (uint256) {
446         return _allowances[owner][spender];
447     }
448 
449     /**
450      * @dev See {IERC20-approve}.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      */
456     function approve(address spender, uint256 amount) public virtual override returns (bool) {
457         _approve(_msgSender(), spender, amount);
458         return true;
459     }
460 
461     /**
462      * @dev See {IERC20-transferFrom}.
463      *
464      * Emits an {Approval} event indicating the updated allowance. This is not
465      * required by the EIP. See the note at the beginning of {ERC20};
466      *
467      * Requirements:
468      * - `sender` and `recipient` cannot be the zero address.
469      * - `sender` must have a balance of at least `amount`.
470      * - the caller must have allowance for ``sender``'s tokens of at least
471      * `amount`.
472      */
473     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
474         _transfer(sender, recipient, amount);
475         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
476         return true;
477     }
478 
479     /**
480      * @dev Atomically increases the allowance granted to `spender` by the caller.
481      *
482      * This is an alternative to {approve} that can be used as a mitigation for
483      * problems described in {IERC20-approve}.
484      *
485      * Emits an {Approval} event indicating the updated allowance.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      */
491     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
493         return true;
494     }
495 
496     /**
497      * @dev Atomically decreases the allowance granted to `spender` by the caller.
498      *
499      * This is an alternative to {approve} that can be used as a mitigation for
500      * problems described in {IERC20-approve}.
501      *
502      * Emits an {Approval} event indicating the updated allowance.
503      *
504      * Requirements:
505      *
506      * - `spender` cannot be the zero address.
507      * - `spender` must have allowance for the caller of at least
508      * `subtractedValue`.
509      */
510     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
512         return true;
513     }
514 
515     /**
516      * @dev Moves tokens `amount` from `sender` to `recipient`.
517      *
518      * This is internal function is equivalent to {transfer}, and can be used to
519      * e.g. implement automatic token fees, slashing mechanisms, etc.
520      *
521      * Emits a {Transfer} event.
522      *
523      * Requirements:
524      *
525      * - `sender` cannot be the zero address.
526      * - `recipient` cannot be the zero address.
527      * - `sender` must have a balance of at least `amount`.
528      */
529     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
530         require(sender != address(0), "ERC20: transfer from the zero address");
531         require(recipient != address(0), "ERC20: transfer to the zero address");
532 
533         _beforeTokenTransfer(sender, recipient, amount);
534 
535         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
536         _balances[recipient] = _balances[recipient].add(amount);
537         emit Transfer(sender, recipient, amount);
538     }
539 
540     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
541      * the total supply.
542      *
543      * Emits a {Transfer} event with `from` set to the zero address.
544      *
545      * Requirements
546      *
547      * - `to` cannot be the zero address.
548      */
549     function _mint(address account, uint256 amount) internal virtual {
550         require(account != address(0), "ERC20: mint to the zero address");
551 
552         _beforeTokenTransfer(address(0), account, amount);
553 
554         _totalSupply = _totalSupply.add(amount);
555         _balances[account] = _balances[account].add(amount);
556         emit Transfer(address(0), account, amount);
557     }
558 
559     /**
560      * @dev Destroys `amount` tokens from `account`, reducing the
561      * total supply.
562      *
563      * Emits a {Transfer} event with `to` set to the zero address.
564      *
565      * Requirements
566      *
567      * - `account` cannot be the zero address.
568      * - `account` must have at least `amount` tokens.
569      */
570     function _burn(address account, uint256 amount) internal virtual {
571         require(account != address(0), "ERC20: burn from the zero address");
572 
573         _beforeTokenTransfer(account, address(0), amount);
574 
575         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
576         _totalSupply = _totalSupply.sub(amount);
577         emit Transfer(account, address(0), amount);
578     }
579 
580     /**
581      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
582      *
583      * This is internal function is equivalent to `approve`, and can be used to
584      * e.g. set automatic allowances for certain subsystems, etc.
585      *
586      * Emits an {Approval} event.
587      *
588      * Requirements:
589      *
590      * - `owner` cannot be the zero address.
591      * - `spender` cannot be the zero address.
592      */
593     function _approve(address owner, address spender, uint256 amount) internal virtual {
594         require(owner != address(0), "ERC20: approve from the zero address");
595         require(spender != address(0), "ERC20: approve to the zero address");
596 
597         _allowances[owner][spender] = amount;
598         emit Approval(owner, spender, amount);
599     }
600 
601     /**
602      * @dev Sets {decimals} to a value other than the default one of 18.
603      *
604      * WARNING: This function should only be called from the constructor. Most
605      * applications that interact with token contracts will not expect
606      * {decimals} to ever change, and may work incorrectly if it does.
607      */
608     function _setupDecimals(uint8 decimals_) internal {
609         _decimals = decimals_;
610     }
611 
612     /**
613      * @dev Hook that is called before any transfer of tokens. This includes
614      * minting and burning.
615      *
616      * Calling conditions:
617      *
618      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
619      * will be to transferred to `to`.
620      * - when `from` is zero, `amount` tokens will be minted for `to`.
621      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
622      * - `from` and `to` are never both zero.
623      *
624      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
625      */
626     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
627 }
628 
629 // File: contracts/common/implementation/MultiRole.sol
630 
631 pragma solidity ^0.6.0;
632 
633 
634 library Exclusive {
635     struct RoleMembership {
636         address member;
637     }
638 
639     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
640         return roleMembership.member == memberToCheck;
641     }
642 
643     function resetMember(RoleMembership storage roleMembership, address newMember) internal {
644         require(newMember != address(0x0), "Cannot set an exclusive role to 0x0");
645         roleMembership.member = newMember;
646     }
647 
648     function getMember(RoleMembership storage roleMembership) internal view returns (address) {
649         return roleMembership.member;
650     }
651 
652     function init(RoleMembership storage roleMembership, address initialMember) internal {
653         resetMember(roleMembership, initialMember);
654     }
655 }
656 
657 
658 library Shared {
659     struct RoleMembership {
660         mapping(address => bool) members;
661     }
662 
663     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
664         return roleMembership.members[memberToCheck];
665     }
666 
667     function addMember(RoleMembership storage roleMembership, address memberToAdd) internal {
668         require(memberToAdd != address(0x0), "Cannot add 0x0 to a shared role");
669         roleMembership.members[memberToAdd] = true;
670     }
671 
672     function removeMember(RoleMembership storage roleMembership, address memberToRemove) internal {
673         roleMembership.members[memberToRemove] = false;
674     }
675 
676     function init(RoleMembership storage roleMembership, address[] memory initialMembers) internal {
677         for (uint256 i = 0; i < initialMembers.length; i++) {
678             addMember(roleMembership, initialMembers[i]);
679         }
680     }
681 }
682 
683 
684 /**
685  * @title Base class to manage permissions for the derived class.
686  */
687 abstract contract MultiRole {
688     using Exclusive for Exclusive.RoleMembership;
689     using Shared for Shared.RoleMembership;
690 
691     enum RoleType { Invalid, Exclusive, Shared }
692 
693     struct Role {
694         uint256 managingRole;
695         RoleType roleType;
696         Exclusive.RoleMembership exclusiveRoleMembership;
697         Shared.RoleMembership sharedRoleMembership;
698     }
699 
700     mapping(uint256 => Role) private roles;
701 
702     event ResetExclusiveMember(uint256 indexed roleId, address indexed newMember, address indexed manager);
703     event AddedSharedMember(uint256 indexed roleId, address indexed newMember, address indexed manager);
704     event RemovedSharedMember(uint256 indexed roleId, address indexed oldMember, address indexed manager);
705 
706     /**
707      * @notice Reverts unless the caller is a member of the specified roleId.
708      */
709     modifier onlyRoleHolder(uint256 roleId) {
710         require(holdsRole(roleId, msg.sender), "Sender does not hold required role");
711         _;
712     }
713 
714     /**
715      * @notice Reverts unless the caller is a member of the manager role for the specified roleId.
716      */
717     modifier onlyRoleManager(uint256 roleId) {
718         require(holdsRole(roles[roleId].managingRole, msg.sender), "Can only be called by a role manager");
719         _;
720     }
721 
722     /**
723      * @notice Reverts unless the roleId represents an initialized, exclusive roleId.
724      */
725     modifier onlyExclusive(uint256 roleId) {
726         require(roles[roleId].roleType == RoleType.Exclusive, "Must be called on an initialized Exclusive role");
727         _;
728     }
729 
730     /**
731      * @notice Reverts unless the roleId represents an initialized, shared roleId.
732      */
733     modifier onlyShared(uint256 roleId) {
734         require(roles[roleId].roleType == RoleType.Shared, "Must be called on an initialized Shared role");
735         _;
736     }
737 
738     /**
739      * @notice Whether `memberToCheck` is a member of roleId.
740      * @dev Reverts if roleId does not correspond to an initialized role.
741      * @param roleId the Role to check.
742      * @param memberToCheck the address to check.
743      * @return True if `memberToCheck` is a member of `roleId`.
744      */
745     function holdsRole(uint256 roleId, address memberToCheck) public view returns (bool) {
746         Role storage role = roles[roleId];
747         if (role.roleType == RoleType.Exclusive) {
748             return role.exclusiveRoleMembership.isMember(memberToCheck);
749         } else if (role.roleType == RoleType.Shared) {
750             return role.sharedRoleMembership.isMember(memberToCheck);
751         }
752         revert("Invalid roleId");
753     }
754 
755     /**
756      * @notice Changes the exclusive role holder of `roleId` to `newMember`.
757      * @dev Reverts if the caller is not a member of the managing role for `roleId` or if `roleId` is not an
758      * initialized, ExclusiveRole.
759      * @param roleId the ExclusiveRole membership to modify.
760      * @param newMember the new ExclusiveRole member.
761      */
762     function resetMember(uint256 roleId, address newMember) public onlyExclusive(roleId) onlyRoleManager(roleId) {
763         roles[roleId].exclusiveRoleMembership.resetMember(newMember);
764         emit ResetExclusiveMember(roleId, newMember, msg.sender);
765     }
766 
767     /**
768      * @notice Gets the current holder of the exclusive role, `roleId`.
769      * @dev Reverts if `roleId` does not represent an initialized, exclusive role.
770      * @param roleId the ExclusiveRole membership to check.
771      * @return the address of the current ExclusiveRole member.
772      */
773     function getMember(uint256 roleId) public view onlyExclusive(roleId) returns (address) {
774         return roles[roleId].exclusiveRoleMembership.getMember();
775     }
776 
777     /**
778      * @notice Adds `newMember` to the shared role, `roleId`.
779      * @dev Reverts if `roleId` does not represent an initialized, SharedRole or if the caller is not a member of the
780      * managing role for `roleId`.
781      * @param roleId the SharedRole membership to modify.
782      * @param newMember the new SharedRole member.
783      */
784     function addMember(uint256 roleId, address newMember) public onlyShared(roleId) onlyRoleManager(roleId) {
785         roles[roleId].sharedRoleMembership.addMember(newMember);
786         emit AddedSharedMember(roleId, newMember, msg.sender);
787     }
788 
789     /**
790      * @notice Removes `memberToRemove` from the shared role, `roleId`.
791      * @dev Reverts if `roleId` does not represent an initialized, SharedRole or if the caller is not a member of the
792      * managing role for `roleId`.
793      * @param roleId the SharedRole membership to modify.
794      * @param memberToRemove the current SharedRole member to remove.
795      */
796     function removeMember(uint256 roleId, address memberToRemove) public onlyShared(roleId) onlyRoleManager(roleId) {
797         roles[roleId].sharedRoleMembership.removeMember(memberToRemove);
798         emit RemovedSharedMember(roleId, memberToRemove, msg.sender);
799     }
800 
801     /**
802      * @notice Removes caller from the role, `roleId`.
803      * @dev Reverts if the caller is not a member of the role for `roleId` or if `roleId` is not an
804      * initialized, SharedRole.
805      * @param roleId the SharedRole membership to modify.
806      */
807     function renounceMembership(uint256 roleId) public onlyShared(roleId) onlyRoleHolder(roleId) {
808         roles[roleId].sharedRoleMembership.removeMember(msg.sender);
809         emit RemovedSharedMember(roleId, msg.sender, msg.sender);
810     }
811 
812     /**
813      * @notice Reverts if `roleId` is not initialized.
814      */
815     modifier onlyValidRole(uint256 roleId) {
816         require(roles[roleId].roleType != RoleType.Invalid, "Attempted to use an invalid roleId");
817         _;
818     }
819 
820     /**
821      * @notice Reverts if `roleId` is initialized.
822      */
823     modifier onlyInvalidRole(uint256 roleId) {
824         require(roles[roleId].roleType == RoleType.Invalid, "Cannot use a pre-existing role");
825         _;
826     }
827 
828     /**
829      * @notice Internal method to initialize a shared role, `roleId`, which will be managed by `managingRoleId`.
830      * `initialMembers` will be immediately added to the role.
831      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
832      * initialized.
833      */
834     function _createSharedRole(
835         uint256 roleId,
836         uint256 managingRoleId,
837         address[] memory initialMembers
838     ) internal onlyInvalidRole(roleId) {
839         Role storage role = roles[roleId];
840         role.roleType = RoleType.Shared;
841         role.managingRole = managingRoleId;
842         role.sharedRoleMembership.init(initialMembers);
843         require(
844             roles[managingRoleId].roleType != RoleType.Invalid,
845             "Attempted to use an invalid role to manage a shared role"
846         );
847     }
848 
849     /**
850      * @notice Internal method to initialize an exclusive role, `roleId`, which will be managed by `managingRoleId`.
851      * `initialMember` will be immediately added to the role.
852      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
853      * initialized.
854      */
855     function _createExclusiveRole(
856         uint256 roleId,
857         uint256 managingRoleId,
858         address initialMember
859     ) internal onlyInvalidRole(roleId) {
860         Role storage role = roles[roleId];
861         role.roleType = RoleType.Exclusive;
862         role.managingRole = managingRoleId;
863         role.exclusiveRoleMembership.init(initialMember);
864         require(
865             roles[managingRoleId].roleType != RoleType.Invalid,
866             "Attempted to use an invalid role to manage an exclusive role"
867         );
868     }
869 }
870 
871 // File: contracts/common/interfaces/ExpandedIERC20.sol
872 
873 pragma solidity ^0.6.0;
874 
875 
876 
877 /**
878  * @title ERC20 interface that includes burn and mint methods.
879  */
880 abstract contract ExpandedIERC20 is IERC20 {
881     /**
882      * @notice Burns a specific amount of the caller's tokens.
883      * @dev Only burns the caller's tokens, so it is safe to leave this method permissionless.
884      */
885     function burn(uint256 value) external virtual;
886 
887     /**
888      * @notice Mints tokens and adds them to the balance of the `to` address.
889      * @dev This method should be permissioned to only allow designated parties to mint tokens.
890      */
891     function mint(address to, uint256 value) external virtual returns (bool);
892 }
893 
894 // File: contracts/common/implementation/ExpandedERC20.sol
895 
896 pragma solidity ^0.6.0;
897 
898 
899 
900 
901 
902 /**
903  * @title An ERC20 with permissioned burning and minting. The contract deployer will initially
904  * be the owner who is capable of adding new roles.
905  */
906 contract ExpandedERC20 is ExpandedIERC20, ERC20, MultiRole {
907     enum Roles {
908         // Can set the minter and burner.
909         Owner,
910         // Addresses that can mint new tokens.
911         Minter,
912         // Addresses that can burn tokens that address owns.
913         Burner
914     }
915 
916     /**
917      * @notice Constructs the ExpandedERC20.
918      * @param _tokenName The name which describes the new token.
919      * @param _tokenSymbol The ticker abbreviation of the name. Ideally < 5 chars.
920      * @param _tokenDecimals The number of decimals to define token precision.
921      */
922     constructor(
923         string memory _tokenName,
924         string memory _tokenSymbol,
925         uint8 _tokenDecimals
926     ) public ERC20(_tokenName, _tokenSymbol) {
927         _setupDecimals(_tokenDecimals);
928         _createExclusiveRole(uint256(Roles.Owner), uint256(Roles.Owner), msg.sender);
929         _createSharedRole(uint256(Roles.Minter), uint256(Roles.Owner), new address[](0));
930         _createSharedRole(uint256(Roles.Burner), uint256(Roles.Owner), new address[](0));
931     }
932 
933     /**
934      * @dev Mints `value` tokens to `recipient`, returning true on success.
935      * @param recipient address to mint to.
936      * @param value amount of tokens to mint.
937      * @return True if the mint succeeded, or False.
938      */
939     function mint(address recipient, uint256 value)
940         external
941         override
942         onlyRoleHolder(uint256(Roles.Minter))
943         returns (bool)
944     {
945         _mint(recipient, value);
946         return true;
947     }
948 
949     /**
950      * @dev Burns `value` tokens owned by `msg.sender`.
951      * @param value amount of tokens to burn.
952      */
953     function burn(uint256 value) external override onlyRoleHolder(uint256(Roles.Burner)) {
954         _burn(msg.sender, value);
955     }
956 }
957 
958 // File: contracts/common/implementation/Lockable.sol
959 
960 pragma solidity ^0.6.0;
961 
962 
963 /**
964  * @title A contract that provides modifiers to prevent reentrancy to state-changing and view-only methods. This contract
965  * is inspired by https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
966  * and https://github.com/balancer-labs/balancer-core/blob/master/contracts/BPool.sol.
967  */
968 contract Lockable {
969     bool private _notEntered;
970 
971     constructor() internal {
972         // Storing an initial non-zero value makes deployment a bit more
973         // expensive, but in exchange the refund on every call to nonReentrant
974         // will be lower in amount. Since refunds are capped to a percetange of
975         // the total transaction's gas, it is best to keep them low in cases
976         // like this one, to increase the likelihood of the full refund coming
977         // into effect.
978         _notEntered = true;
979     }
980 
981     /**
982      * @dev Prevents a contract from calling itself, directly or indirectly.
983      * Calling a `nonReentrant` function from another `nonReentrant`
984      * function is not supported. It is possible to prevent this from happening
985      * by making the `nonReentrant` function external, and make it call a
986      * `private` function that does the actual work.
987      */
988     modifier nonReentrant() {
989         _preEntranceCheck();
990         _preEntranceSet();
991         _;
992         _postEntranceReset();
993     }
994 
995     /**
996      * @dev Designed to prevent a view-only method from being re-entered during a call to a `nonReentrant()` state-changing method.
997      */
998     modifier nonReentrantView() {
999         _preEntranceCheck();
1000         _;
1001     }
1002 
1003     // Internal methods are used to avoid copying the require statement's bytecode to every `nonReentrant()` method.
1004     // On entry into a function, `_preEntranceCheck()` should always be called to check if the function is being re-entered.
1005     // Then, if the function modifies state, it should call `_postEntranceSet()`, perform its logic, and then call `_postEntranceReset()`.
1006     // View-only methods can simply call `_preEntranceCheck()` to make sure that it is not being re-entered.
1007     function _preEntranceCheck() internal view {
1008         // On the first call to nonReentrant, _notEntered will be true
1009         require(_notEntered, "ReentrancyGuard: reentrant call");
1010     }
1011 
1012     function _preEntranceSet() internal {
1013         // Any calls to nonReentrant after this point will fail
1014         _notEntered = false;
1015     }
1016 
1017     function _postEntranceReset() internal {
1018         // By storing the original value once again, a refund is triggered (see
1019         // https://eips.ethereum.org/EIPS/eip-2200)
1020         _notEntered = true;
1021     }
1022 }
1023 
1024 // File: contracts/financial-templates/common/SyntheticToken.sol
1025 
1026 pragma solidity ^0.6.0;
1027 
1028 
1029 
1030 
1031 /**
1032  * @title Burnable and mintable ERC20.
1033  * @dev The contract deployer will initially be the only minter, burner and owner capable of adding new roles.
1034  */
1035 
1036 contract SyntheticToken is ExpandedERC20, Lockable {
1037     /**
1038      * @notice Constructs the SyntheticToken.
1039      * @param tokenName The name which describes the new token.
1040      * @param tokenSymbol The ticker abbreviation of the name. Ideally < 5 chars.
1041      * @param tokenDecimals The number of decimals to define token precision.
1042      */
1043     constructor(
1044         string memory tokenName,
1045         string memory tokenSymbol,
1046         uint8 tokenDecimals
1047     ) public ExpandedERC20(tokenName, tokenSymbol, tokenDecimals) nonReentrant() {}
1048 
1049     /**
1050      * @notice Add Minter role to account.
1051      * @dev The caller must have the Owner role.
1052      * @param account The address to which the Minter role is added.
1053      */
1054     function addMinter(address account) external nonReentrant() {
1055         addMember(uint256(Roles.Minter), account);
1056     }
1057 
1058     /**
1059      * @notice Remove Minter role from account.
1060      * @dev The caller must have the Owner role.
1061      * @param account The address from which the Minter role is removed.
1062      */
1063     function removeMinter(address account) external nonReentrant() {
1064         removeMember(uint256(Roles.Minter), account);
1065     }
1066 
1067     /**
1068      * @notice Add Burner role to account.
1069      * @dev The caller must have the Owner role.
1070      * @param account The address to which the Burner role is added.
1071      */
1072     function addBurner(address account) external nonReentrant() {
1073         addMember(uint256(Roles.Burner), account);
1074     }
1075 
1076     /**
1077      * @notice Removes Burner role from account.
1078      * @dev The caller must have the Owner role.
1079      * @param account The address from which the Burner role is removed.
1080      */
1081     function removeBurner(address account) external nonReentrant() {
1082         removeMember(uint256(Roles.Burner), account);
1083     }
1084 
1085     /**
1086      * @notice Reset Owner role to account.
1087      * @dev The caller must have the Owner role.
1088      * @param account The new holder of the Owner role.
1089      */
1090     function resetOwner(address account) external nonReentrant() {
1091         resetMember(uint256(Roles.Owner), account);
1092     }
1093 
1094     /**
1095      * @notice Checks if a given account holds the Minter role.
1096      * @param account The address which is checked for the Minter role.
1097      * @return bool True if the provided account is a Minter.
1098      */
1099     function isMinter(address account) public view nonReentrantView() returns (bool) {
1100         return holdsRole(uint256(Roles.Minter), account);
1101     }
1102 
1103     /**
1104      * @notice Checks if a given account holds the Burner role.
1105      * @param account The address which is checked for the Burner role.
1106      * @return bool True if the provided account is a Burner.
1107      */
1108     function isBurner(address account) public view nonReentrantView() returns (bool) {
1109         return holdsRole(uint256(Roles.Burner), account);
1110     }
1111 }