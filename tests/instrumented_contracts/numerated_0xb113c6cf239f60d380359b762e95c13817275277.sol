1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.9;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
30 
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // File: contracts/roles/Roles.sol
103 
104 /**
105  * @title Roles
106  * @dev Library for managing addresses assigned to a Role.
107  */
108 library Roles {
109     struct Role {
110         mapping(address => bool) bearer;
111     }
112 
113     /**
114      * @dev Give an account access to this role.
115      */
116     function add(Role storage role, address account) internal {
117         require(!has(role, account), 'Roles: account already has role');
118         role.bearer[account] = true;
119     }
120 
121     /**
122      * @dev Remove an account's access to this role.
123      */
124     function remove(Role storage role, address account) internal {
125         require(has(role, account), 'Roles: account does not have role');
126         role.bearer[account] = false;
127     }
128 
129     /**
130      * @dev Check if an account has this role.
131      * @return bool
132      */
133     function has(Role storage role, address account) internal view returns (bool) {
134         require(account != address(0), 'Roles: account is the zero address');
135         return role.bearer[account];
136     }
137 }
138 
139 // File: contracts/roles/BlacklistManagerRole.sol
140 // Author : Tokeny Solutions
141 
142 
143 
144 
145 contract BlacklistManagerRole is Ownable {
146     using Roles for Roles.Role;
147 
148     event BlacklistManagerAdded(address indexed _blacklistManager);
149     event BlacklistManagerRemoved(address indexed _blacklistManager);
150 
151     Roles.Role private _blacklistManagers;
152 
153     modifier onlyBlacklistManager() {
154         require(isBlacklistManager(msg.sender), 'BlacklistManagerRole: caller does not have the role');
155         _;
156     }
157 
158     function isBlacklistManager(address _blacklistManager) public view returns (bool) {
159         return _blacklistManagers.has(_blacklistManager);
160     }
161 
162     function addBlacklistManager(address _blacklistManager) public onlyOwner {
163         _blacklistManagers.add(_blacklistManager);
164         emit BlacklistManagerAdded(_blacklistManager);
165     }
166 
167     function removeBlacklistManager(address _blacklistManager) public onlyOwner {
168         _blacklistManagers.remove(_blacklistManager);
169         emit BlacklistManagerRemoved(_blacklistManager);
170     }
171 }
172 
173 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
174 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
175 
176 /**
177  * @dev Interface of the ERC20 standard as defined in the EIP.
178  */
179 interface IERC20 {
180     /**
181      * @dev Returns the amount of tokens in existence.
182      */
183     function totalSupply() external view returns (uint256);
184 
185     /**
186      * @dev Returns the amount of tokens owned by `account`.
187      */
188     function balanceOf(address account) external view returns (uint256);
189 
190     /**
191      * @dev Moves `amount` tokens from the caller's account to `recipient`.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transfer(address recipient, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Returns the remaining number of tokens that `spender` will be
201      * allowed to spend on behalf of `owner` through {transferFrom}. This is
202      * zero by default.
203      *
204      * This value changes when {approve} or {transferFrom} are called.
205      */
206     function allowance(address owner, address spender) external view returns (uint256);
207 
208     /**
209      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * IMPORTANT: Beware that changing an allowance with this method brings the risk
214      * that someone may use both the old and the new allowance by unfortunate
215      * transaction ordering. One possible solution to mitigate this race
216      * condition is to first reduce the spender's allowance to 0 and set the
217      * desired value afterwards:
218      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address spender, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Moves `amount` tokens from `sender` to `recipient` using the
226      * allowance mechanism. `amount` is then deducted from the caller's
227      * allowance.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transferFrom(
234         address sender,
235         address recipient,
236         uint256 amount
237     ) external returns (bool);
238 
239     /**
240      * @dev Emitted when `value` tokens are moved from one account (`from`) to
241      * another (`to`).
242      *
243      * Note that `value` may be zero.
244      */
245     event Transfer(address indexed from, address indexed to, uint256 value);
246 
247     /**
248      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
249      * a call to {approve}. `value` is the new allowance.
250      */
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252 }
253 
254 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
255 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
256 
257 
258 /**
259  * @dev Interface for the optional metadata functions from the ERC20 standard.
260  *
261  * _Available since v4.1._
262  */
263 interface IERC20Metadata is IERC20 {
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() external view returns (string memory);
268 
269     /**
270      * @dev Returns the symbol of the token.
271      */
272     function symbol() external view returns (string memory);
273 
274     /**
275      * @dev Returns the decimals places of the token.
276      */
277     function decimals() external view returns (uint8);
278 }
279 
280 // File: @openzeppelin/contracts/security/Pausable.sol
281 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
282 
283 
284 /**
285  * @dev Contract module which allows children to implement an emergency stop
286  * mechanism that can be triggered by an authorized account.
287  *
288  * This module is used through inheritance. It will make available the
289  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
290  * the functions of your contract. Note that they will not be pausable by
291  * simply including this module, only once the modifiers are put in place.
292  */
293 abstract contract Pausable is Context {
294     /**
295      * @dev Emitted when the pause is triggered by `account`.
296      */
297     event Paused(address account);
298 
299     /**
300      * @dev Emitted when the pause is lifted by `account`.
301      */
302     event Unpaused(address account);
303 
304     bool private _paused;
305 
306     /**
307      * @dev Initializes the contract in unpaused state.
308      */
309     constructor() {
310         _paused = false;
311     }
312 
313     /**
314      * @dev Returns true if the contract is paused, and false otherwise.
315      */
316     function paused() public view virtual returns (bool) {
317         return _paused;
318     }
319 
320     /**
321      * @dev Modifier to make a function callable only when the contract is not paused.
322      *
323      * Requirements:
324      *
325      * - The contract must not be paused.
326      */
327     modifier whenNotPaused() {
328         require(!paused(), "Pausable: paused");
329         _;
330     }
331 
332     /**
333      * @dev Modifier to make a function callable only when the contract is paused.
334      *
335      * Requirements:
336      *
337      * - The contract must be paused.
338      */
339     modifier whenPaused() {
340         require(paused(), "Pausable: not paused");
341         _;
342     }
343 
344     /**
345      * @dev Triggers stopped state.
346      *
347      * Requirements:
348      *
349      * - The contract must not be paused.
350      */
351     function _pause() internal virtual whenNotPaused {
352         _paused = true;
353         emit Paused(_msgSender());
354     }
355 
356     /**
357      * @dev Returns to normal state.
358      *
359      * Requirements:
360      *
361      * - The contract must be paused.
362      */
363     function _unpause() internal virtual whenPaused {
364         _paused = false;
365         emit Unpaused(_msgSender());
366     }
367 }
368 
369 // File: contracts/vesting/IVesting.sol
370 // Author : Tokeny Solutions
371 
372 interface IVesting {
373 
374     // events
375     event UpdatedTreasury(address newTreasury);
376     event UpdatedTeam(address newTeam);
377     event UpdatedEcosystemFund(address newEcosystemFund);
378     event UpdatedLongTermLockUp(address newLongTermLockUp);
379     event TokenSet(address token);
380     event InitialDeposit(address _to, uint256 _amount, uint _cliff, uint _vesting);
381     event TokensClaimed(address _holder, uint256 _amount);
382     event ReferenceDateSet(uint256 _referenceDate);
383 
384     // functions
385     function setToken(address token) external;
386     function initialized() external view returns(bool);
387     function treasury() external view returns(address);
388     function updateTreasuryWallet(address newTreasury) external;
389     function team() external view returns(address);
390     function updateTeamWallet(address newTeam) external;
391     function ecosystemFund() external view returns(address);
392     function updateEcosystemFundWallet(address newEcosystemFund) external;
393     function longTermLockUp() external view returns(address);
394     function updateLongTermLockUpWallet(address newLongTermLockUp) external;
395     function initialDeposit(address _to, uint256 _amount, uint _cliff, uint _vesting) external;
396     function claim() external;
397     function claimFor(address _holder) external;
398     function claimAll() external;
399     function getBalances(address _holder) external view returns(uint, uint, uint);
400 
401 }
402 
403 // File: contracts/token/BMEX.sol
404 // Author : Tokeny Solutions
405 
406 contract BMEX is Context, IERC20, IERC20Metadata, BlacklistManagerRole, Pausable {
407 
408     // event emitted when a wallet is blacklisted by a blacklist manager
409     event Blacklisted(address wallet);
410     // event when a wallet that was blacklisted is removed from the blacklist by the blacklist manager
411     event Whitelisted(address wallet);
412 
413     mapping(address => uint256) private _balances;
414 
415     mapping(address => mapping(address => uint256)) private _allowances;
416 
417     // blacklisting status of wallets
418     mapping(address => bool) private _blacklisted;
419 
420     uint256 private _totalSupply;
421 
422     string private _name;
423     string private _symbol;
424 
425     // address of the vesting contract on which the non-circulating supply is blocked temporarily
426     address public _vestingContract;
427 
428 
429     /**
430      * @dev constructor of the token
431      * sets the name and symbol of the token
432      * @param owner the owner wallet of the contract
433      * @param vestingContract the address of the vesting contract
434      * note that the constructor is not making the full initialization of the token, it is required
435      * to call initialize() after deployment of the token contract
436      */
437     constructor(address owner, address vestingContract) {
438         _name = 'BitMEX Token';
439         _symbol = 'BMEX';
440         _vestingContract = vestingContract;
441         _transferOwnership(owner);
442     }
443 
444     /**
445      * @dev initializes the token supply and sends the tokens to the vesting contract
446      * on a supply of 450M tokens, only 36M are free at launch, on the treasury wallet
447      * the rest of the tokens are locked on the vesting smart contract
448      * this function is setting the token address on the vesting contract
449      * the function cannot be called twice
450      */
451     function initialize() external {
452         require(!IVesting(_vestingContract).initialized(), 'already initialized');
453         IVesting(_vestingContract).setToken(address(this));
454         _mint(address(this), 450000000*10**6);
455         _approve(address(this), _vestingContract, 414000000*10**6);
456         IVesting(_vestingContract).initialDeposit(IVesting(_vestingContract).treasury(), 76500000*10**6, 0, 12);
457         IVesting(_vestingContract).initialDeposit(IVesting(_vestingContract).team(), 90000000*10**6, 9, 33);
458         IVesting(_vestingContract).initialDeposit(IVesting(_vestingContract).ecosystemFund(), 135000000*10**6, 3, 21);
459         IVesting(_vestingContract).initialDeposit(IVesting(_vestingContract).longTermLockUp(), 112500000*10**6, 24, 60);
460         _transfer(address(this), IVesting(_vestingContract).treasury(), 36000000*10**6);
461     }
462 
463     /**
464      * @dev pauses the token, blocking all transfers as long as paused
465      * requires the token to not be paused yet
466      * only owner can call
467      */
468     function pause() public onlyOwner {
469         _pause();
470     }
471 
472     /**
473      * @dev unpauses the token, allowing transfers to happen again
474      * requires the token to be paused first
475      * only owner can call
476      */
477     function unpause() public onlyOwner {
478         _unpause();
479     }
480 
481     /**
482      * @dev getter function returning true if a wallet is blacklisted, false otherwise
483      * @param _wallet the address to check
484      */
485     function blacklisted(address _wallet) public view returns (bool) {
486         return _blacklisted[_wallet];
487     }
488 
489     /**
490      * @dev blacklists a wallet address
491      * requires the wallet to not be blacklisted yet
492      * @param _wallet the wallet to blacklist
493      */
494     function blacklist(address _wallet) external onlyBlacklistManager {
495         require(!blacklisted(_wallet), 'wallet already blacklisted');
496         _blacklisted[_wallet] = true;
497         emit Blacklisted(_wallet);
498     }
499 
500     /**
501      * @dev remove blacklisting from a wallet
502      * requires the wallet to be blacklisted first
503      * @param _wallet the address to whitelist
504      */
505     function whitelist(address _wallet) external onlyBlacklistManager {
506         require(blacklisted(_wallet), 'wallet not blacklisted');
507         _blacklisted[_wallet] = false;
508         emit Whitelisted(_wallet);
509     }
510 
511     /**
512      * @dev Destroys `amount` tokens from the caller.
513      *
514      * See {ERC20-_burn}.
515      */
516     function burn(uint256 amount) public {
517         _burn(_msgSender(), amount);
518     }
519 
520     /**
521      * @dev Returns the name of the token.
522      */
523     function name() public view virtual override returns (string memory) {
524         return _name;
525     }
526 
527     /**
528      * @dev Returns the symbol of the token, usually a shorter version of the
529      * name.
530      */
531     function symbol() public view virtual override returns (string memory) {
532         return _symbol;
533     }
534 
535     /**
536      * @dev Returns the number of decimals used to get its user representation.
537      * For example, if `decimals` equals `2`, a balance of `505` tokens should
538      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
539      *
540      * Tokens usually opt for a value of 18, imitating the relationship between
541      * Ether and Wei. This is the value {ERC20} uses, unless this function is
542      * overridden;
543      * BMEX token is using 8 decimals instead of 18
544      *
545      * NOTE: This information is only used for _display_ purposes: it in
546      * no way affects any of the arithmetic of the contract, including
547      * {IERC20-balanceOf} and {IERC20-transfer}.
548      */
549     function decimals() public view virtual override returns (uint8) {
550         return 6;
551     }
552 
553     /**
554      * @dev See {IERC20-totalSupply}.
555      */
556     function totalSupply() public view virtual override returns (uint256) {
557         return _totalSupply;
558     }
559 
560     /**
561      * @dev See {IERC20-balanceOf}.
562      */
563     function balanceOf(address account) public view virtual override returns (uint256) {
564         return _balances[account];
565     }
566 
567     /**
568      * @dev See {IERC20-transfer}.
569      *
570      * Requirements:
571      *
572      * - `recipient` cannot be the zero address.
573      * - the caller must have a balance of at least `amount`.
574      */
575     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
576         _transfer(_msgSender(), recipient, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-allowance}.
582      */
583     function allowance(address owner, address spender) public view virtual override returns (uint256) {
584         return _allowances[owner][spender];
585     }
586 
587     /**
588      * @dev See {IERC20-approve}.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      */
594     function approve(address spender, uint256 amount) public virtual override returns (bool) {
595         _approve(_msgSender(), spender, amount);
596         return true;
597     }
598 
599     /**
600      * @dev See {IERC20-transferFrom}.
601      *
602      * Emits an {Approval} event indicating the updated allowance. This is not
603      * required by the EIP. See the note at the beginning of {ERC20}.
604      *
605      * Requirements:
606      *
607      * - `sender` and `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      * - the caller must have allowance for ``sender``'s tokens of at least
610      * `amount`.
611      */
612     function transferFrom(
613         address sender,
614         address recipient,
615         uint256 amount
616     ) public virtual override returns (bool) {
617         _transfer(sender, recipient, amount);
618 
619         uint256 currentAllowance = _allowances[sender][_msgSender()];
620         require(currentAllowance >= amount, 'ERC20: transfer amount exceeds allowance');
621     unchecked {
622         _approve(sender, _msgSender(), currentAllowance - amount);
623     }
624 
625         return true;
626     }
627 
628     /**
629      * @dev Atomically increases the allowance granted to `spender` by the caller.
630      *
631      * This is an alternative to {approve} that can be used as a mitigation for
632      * problems described in {IERC20-approve}.
633      *
634      * Emits an {Approval} event indicating the updated allowance.
635      *
636      * Requirements:
637      *
638      * - `spender` cannot be the zero address.
639      */
640     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
641         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
642         return true;
643     }
644 
645     /**
646      * @dev Atomically decreases the allowance granted to `spender` by the caller.
647      *
648      * This is an alternative to {approve} that can be used as a mitigation for
649      * problems described in {IERC20-approve}.
650      *
651      * Emits an {Approval} event indicating the updated allowance.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      * - `spender` must have allowance for the caller of at least
657      * `subtractedValue`.
658      */
659     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
660         uint256 currentAllowance = _allowances[_msgSender()][spender];
661         require(currentAllowance >= subtractedValue, 'ERC20: decreased allowance below zero');
662     unchecked {
663         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
664     }
665 
666         return true;
667     }
668 
669     /**
670      * @dev Moves `amount` of tokens from `sender` to `recipient`.
671      *
672      * This internal function is equivalent to {transfer}, and can be used to
673      * e.g. implement automatic token fees, slashing mechanisms, etc.
674      *
675      * Emits a {Transfer} event.
676      *
677      * Requirements:
678      *
679      * - `sender` cannot be the zero address.
680      * - `recipient` cannot be the zero address.
681      * - `sender` must have a balance of at least `amount`.
682      */
683     function _transfer(
684         address sender,
685         address recipient,
686         uint256 amount
687     ) internal virtual {
688         require(sender != address(0), 'ERC20: transfer from the zero address');
689         require(recipient != address(0), 'ERC20: transfer to the zero address');
690 
691         _beforeTokenTransfer(sender, recipient, amount);
692 
693         uint256 senderBalance = _balances[sender];
694         require(senderBalance >= amount, 'ERC20: transfer amount exceeds balance');
695     unchecked {
696         _balances[sender] = senderBalance - amount;
697     }
698         _balances[recipient] += amount;
699 
700         emit Transfer(sender, recipient, amount);
701 
702         _afterTokenTransfer(sender, recipient, amount);
703     }
704 
705     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
706      * the total supply.
707      *
708      * Emits a {Transfer} event with `from` set to the zero address.
709      *
710      * Requirements:
711      *
712      * - `account` cannot be the zero address.
713      */
714     function _mint(address account, uint256 amount) internal virtual {
715         require(account != address(0), 'ERC20: mint to the zero address');
716 
717         _beforeTokenTransfer(address(0), account, amount);
718 
719         _totalSupply += amount;
720         _balances[account] += amount;
721         emit Transfer(address(0), account, amount);
722 
723         _afterTokenTransfer(address(0), account, amount);
724     }
725 
726     /**
727      * @dev Destroys `amount` tokens from `account`, reducing the
728      * total supply.
729      *
730      * Emits a {Transfer} event with `to` set to the zero address.
731      *
732      * Requirements:
733      *
734      * - `account` cannot be the zero address.
735      * - `account` must have at least `amount` tokens.
736      */
737     function _burn(address account, uint256 amount) internal virtual {
738         require(account != address(0), 'ERC20: burn from the zero address');
739 
740         _beforeTokenTransfer(account, address(0), amount);
741 
742         uint256 accountBalance = _balances[account];
743         require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
744     unchecked {
745         _balances[account] = accountBalance - amount;
746     }
747         _totalSupply -= amount;
748 
749         emit Transfer(account, address(0), amount);
750 
751         _afterTokenTransfer(account, address(0), amount);
752     }
753 
754     /**
755      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
756      *
757      * This internal function is equivalent to `approve`, and can be used to
758      * e.g. set automatic allowances for certain subsystems, etc.
759      *
760      * Emits an {Approval} event.
761      *
762      * Requirements:
763      *
764      * - `owner` cannot be the zero address.
765      * - `spender` cannot be the zero address.
766      */
767     function _approve(
768         address owner,
769         address spender,
770         uint256 amount
771     ) internal virtual {
772         require(owner != address(0), 'ERC20: approve from the zero address');
773         require(spender != address(0), 'ERC20: approve to the zero address');
774 
775         _allowances[owner][spender] = amount;
776         emit Approval(owner, spender, amount);
777     }
778 
779     /**
780      * @dev Hook that is called before any transfer of tokens. This includes
781      * minting and burning.
782      *
783      * Calling conditions:
784      *
785      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
786      * will be transferred to `to`.
787      * - when `from` is zero, `amount` tokens will be minted for `to`.
788      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
789      * - `from` and `to` are never both zero.
790      *
791      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
792      * token transfers blocked if from or to a blacklisted wallet
793      * token transfers blocked if token paused
794      */
795     function _beforeTokenTransfer(
796         address from,
797         address to,
798         uint256 /* amount */
799     ) internal virtual {
800         require(!paused(), 'ERC20Pausable: token transfer while paused');
801         require(!blacklisted(to) && !blacklisted(from), 'Cannot transfer tokens to or from blacklisted');
802     }
803 
804     /**
805      * @dev Hook that is called after any transfer of tokens. This includes
806      * minting and burning.
807      *
808      * Calling conditions:
809      *
810      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
811      * has been transferred to `to`.
812      * - when `from` is zero, `amount` tokens have been minted for `to`.
813      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
814      * - `from` and `to` are never both zero.
815      *
816      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
817      */
818     function _afterTokenTransfer(
819         address from,
820         address to,
821         uint256 amount
822     ) internal virtual {}
823 
824 }