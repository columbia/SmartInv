1 pragma solidity ^0.5.10;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 // Contract function to receive approval and execute function in one call
80 contract ApproveAndCallFallBack {
81     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
82 }
83 
84 
85 
86 /**
87  * @title Roles
88  * @dev Library for managing addresses assigned to a Role.
89  */
90 library Roles {
91     struct Role {
92         mapping (address => bool) bearer;
93     }
94 
95     /**
96      * @dev Give an account access to this role.
97      */
98     function add(Role storage role, address account) internal {
99         require(!has(role, account), "Roles: account already has role");
100         role.bearer[account] = true;
101     }
102 
103     /**
104      * @dev Remove an account's access to this role.
105      */
106     function remove(Role storage role, address account) internal {
107         require(has(role, account), "Roles: account does not have role");
108         role.bearer[account] = false;
109     }
110 
111     /**
112      * @dev Check if an account has this role.
113      * @return bool
114      */
115     function has(Role storage role, address account) internal view returns (bool) {
116         require(account != address(0), "Roles: account is the zero address");
117         return role.bearer[account];
118     }
119 }
120 
121 
122 contract AdministratorRole {
123     using Roles for Roles.Role;
124 
125     event AdministratorAdded(address indexed account);
126     event AdministratorRemoved(address indexed account);
127 
128     Roles.Role private _administrators;
129 
130     constructor () internal {
131         _addAdministrator(msg.sender);
132     }
133 
134     modifier onlyAdministrator() {
135         require(isAdministrator(msg.sender), "AdministratorRole: caller does not have the Administrator role");
136         _;
137     }
138 
139     function isAdministrator(address account) public view returns (bool) {
140         return _administrators.has(account);
141     }
142 
143     function addAdministrator(address account) public onlyAdministrator {
144         _addAdministrator(account);
145     }
146 
147     function renounceAdministrator() public {
148         _removeAdministrator(msg.sender);
149     }
150 
151     function _addAdministrator(address account) internal {
152         _administrators.add(account);
153         emit AdministratorAdded(account);
154     }
155 
156     function _removeAdministrator(address account) internal {
157         _administrators.remove(account);
158         emit AdministratorRemoved(account);
159     }
160 }
161 
162 
163 
164 
165 
166 
167 
168 /**
169  * @dev Wrappers over Solidity's arithmetic operations with added overflow
170  * checks.
171  *
172  * Arithmetic operations in Solidity wrap on overflow. This can easily result
173  * in bugs, because programmers usually assume that an overflow raises an
174  * error, which is the standard behavior in high level programming languages.
175  * `SafeMath` restores this intuition by reverting the transaction when an
176  * operation overflows.
177  *
178  * Using this library instead of the unchecked operations eliminates an entire
179  * class of bugs, so it's recommended to use it always.
180  */
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      * - Addition cannot overflow.
190      */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         uint256 c = a + b;
193         require(c >= a, "SafeMath: addition overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      * - Subtraction cannot overflow.
206      */
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         require(b <= a, "SafeMath: subtraction overflow");
209         uint256 c = a - b;
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the multiplication of two unsigned integers, reverting on
216      * overflow.
217      *
218      * Counterpart to Solidity's `*` operator.
219      *
220      * Requirements:
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225         // benefit is lost if 'b' is also tested.
226         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227         if (a == 0) {
228             return 0;
229         }
230 
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         // Solidity only automatically asserts when dividing by 0
250         require(b > 0, "SafeMath: division by zero");
251         uint256 c = a / b;
252         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269         require(b != 0, "SafeMath: modulo by zero");
270         return a % b;
271     }
272 }
273 
274 
275 /**
276  * @dev Implementation of the `IERC20` interface.
277  *
278  * This implementation is agnostic to the way tokens are created. This means
279  * that a supply mechanism has to be added in a derived contract using `_mint`.
280  * For a generic mechanism see `ERC20Mintable`.
281  *
282  * *For a detailed writeup see our guide [How to implement supply
283  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
284  *
285  * We have followed general OpenZeppelin guidelines: functions revert instead
286  * of returning `false` on failure. This behavior is nonetheless conventional
287  * and does not conflict with the expectations of ERC20 applications.
288  *
289  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
290  * This allows applications to reconstruct the allowance for all accounts just
291  * by listening to said events. Other implementations of the EIP may not emit
292  * these events, as it isn't required by the specification.
293  *
294  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
295  * functions have been added to mitigate the well-known issues around setting
296  * allowances. See `IERC20.approve`.
297  */
298 contract ERC20 is IERC20 {
299     using SafeMath for uint256;
300 
301     mapping (address => uint256) private _balances;
302 
303     mapping (address => mapping (address => uint256)) private _allowances;
304 
305     uint256 private _totalSupply;
306 
307     /**
308      * @dev See `IERC20.totalSupply`.
309      */
310     function totalSupply() public view returns (uint256) {
311         return _totalSupply;
312     }
313 
314     /**
315      * @dev See `IERC20.balanceOf`.
316      */
317     function balanceOf(address account) public view returns (uint256) {
318         return _balances[account];
319     }
320 
321     /**
322      * @dev See `IERC20.transfer`.
323      *
324      * Requirements:
325      *
326      * - `recipient` cannot be the zero address.
327      * - the caller must have a balance of at least `amount`.
328      */
329     function transfer(address recipient, uint256 amount) public returns (bool) {
330         _transfer(msg.sender, recipient, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See `IERC20.allowance`.
336      */
337     function allowance(address owner, address spender) public view returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See `IERC20.approve`.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 value) public returns (bool) {
349         _approve(msg.sender, spender, value);
350         return true;
351     }
352 
353     /**
354      * @dev See `IERC20.transferFrom`.
355      *
356      * Emits an `Approval` event indicating the updated allowance. This is not
357      * required by the EIP. See the note at the beginning of `ERC20`;
358      *
359      * Requirements:
360      * - `sender` and `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `value`.
362      * - the caller must have allowance for `sender`'s tokens of at least
363      * `amount`.
364      */
365     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
366         _transfer(sender, recipient, amount);
367         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
368         return true;
369     }
370 
371     /**
372      * @dev Atomically increases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to `approve` that can be used as a mitigation for
375      * problems described in `IERC20.approve`.
376      *
377      * Emits an `Approval` event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
384         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
385         return true;
386     }
387 
388     /**
389      * @dev Atomically decreases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to `approve` that can be used as a mitigation for
392      * problems described in `IERC20.approve`.
393      *
394      * Emits an `Approval` event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      * - `spender` must have allowance for the caller of at least
400      * `subtractedValue`.
401      */
402     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
403         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
404         return true;
405     }
406 
407     /**
408      * @dev Moves tokens `amount` from `sender` to `recipient`.
409      *
410      * This is internal function is equivalent to `transfer`, and can be used to
411      * e.g. implement automatic token fees, slashing mechanisms, etc.
412      *
413      * Emits a `Transfer` event.
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
425         _balances[sender] = _balances[sender].sub(amount);
426         _balances[recipient] = _balances[recipient].add(amount);
427         emit Transfer(sender, recipient, amount);
428     }
429 
430     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
431      * the total supply.
432      *
433      * Emits a `Transfer` event with `from` set to the zero address.
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
447      /**
448      * @dev Destoys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a `Transfer` event with `to` set to the zero address.
452      *
453      * Requirements
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 value) internal {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _totalSupply = _totalSupply.sub(value);
462         _balances[account] = _balances[account].sub(value);
463         emit Transfer(account, address(0), value);
464     }
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
468      *
469      * This is internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an `Approval` event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(address owner, address spender, uint256 value) internal {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = value;
484         emit Approval(owner, spender, value);
485     }
486 
487     /**
488      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
489      * from the caller's allowance.
490      *
491      * See `_burn` and `_approve`.
492      */
493     function _burnFrom(address account, uint256 amount) internal {
494         _burn(account, amount);
495         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
496     }
497 }
498 
499 
500 
501 
502 
503 /**
504  * @dev Optional functions from the ERC20 standard.
505  */
506 contract ERC20Detailed is IERC20 {
507     string private _name;
508     string private _symbol;
509     uint8 private _decimals;
510 
511     /**
512      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
513      * these values are immutable: they can only be set once during
514      * construction.
515      */
516     constructor (string memory name, string memory symbol, uint8 decimals) public {
517         _name = name;
518         _symbol = symbol;
519         _decimals = decimals;
520     }
521 
522     /**
523      * @dev Returns the name of the token.
524      */
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     /**
530      * @dev Returns the symbol of the token, usually a shorter version of the
531      * name.
532      */
533     function symbol() public view returns (string memory) {
534         return _symbol;
535     }
536 
537     /**
538      * @dev Returns the number of decimals used to get its user representation.
539      * For example, if `decimals` equals `2`, a balance of `505` tokens should
540      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
541      *
542      * Tokens usually opt for a value of 18, imitating the relationship between
543      * Ether and Wei.
544      *
545      * > Note that this information is only used for _display_ purposes: it in
546      * no way affects any of the arithmetic of the contract, including
547      * `IERC20.balanceOf` and `IERC20.transfer`.
548      */
549     function decimals() public view returns (uint8) {
550         return _decimals;
551     }
552 }
553 
554 
555 
556 
557 
558 /**
559  * @dev Extension of `ERC20` that allows token holders to destroy both their own
560  * tokens and those that they have an allowance for, in a way that can be
561  * recognized off-chain (via event analysis).
562  */
563 contract ERC20Burnable is ERC20 {
564     /**
565      * @dev Destoys `amount` tokens from the caller.
566      *
567      * See `ERC20._burn`.
568      */
569     function burn(uint256 amount) public {
570         _burn(msg.sender, amount);
571     }
572 
573     /**
574      * @dev See `ERC20._burnFrom`.
575      */
576     function burnFrom(address account, uint256 amount) public {
577         _burnFrom(account, amount);
578     }
579 }
580 
581 
582 
583 // Owned contract
584 contract Owned {
585     address public owner;
586     address public newOwner;
587 
588     event OwnershipTransferred(address indexed _from, address indexed _to);
589 
590     constructor() public {
591         owner = msg.sender;
592     }
593 
594     /**
595      * @dev Returns true if the caller is the current owner.
596      */
597     function isOwner() public view returns (bool) {
598         return msg.sender == owner;
599     }
600 
601     modifier onlyOwner {
602         require(msg.sender == owner);
603         _;
604     }
605 
606     function transferOwnership(address _newOwner) public onlyOwner {
607         newOwner = _newOwner;
608     }
609 
610     function acceptOwnership() public {
611         require(msg.sender == newOwner);
612         emit OwnershipTransferred(owner, newOwner);
613         owner = newOwner;
614         newOwner = address(0);
615     }
616 }
617 
618 
619 
620 // The Marblecoin (MBC) contract.
621 // Initial supply of 100 Million MBC without a capped supply.
622 //   Contract owner may elect to permanently freeze inflation.
623 //
624 // Built by splitiron@protonmail.com for Marble.Cards
625 
626 // ERC20 implements the standard ERC20 interface
627 // Owned provides superpowers to the contract deployer
628 // AdministratorRole allows for non-owners to be allowed to perform actions on the contract
629 // ERC20Detailed adds "name", "symbol", and "decimal" values
630 // ERC20Burnable allows for coins to be burned by anyone
631 contract MarbleCoin is ERC20, Owned, AdministratorRole, ERC20Detailed, ERC20Burnable {
632 
633     // Set to true when inflation is frozen.
634     bool private _supplycapped = false;
635 
636     // 18 decimal token
637     uint256 private MBC = 1e18;
638 
639     // Defines the initial contract
640     constructor () public ERC20Detailed("Marblecoin", "MBC", 18) {
641         // Generate 100 million tokens in the contract owner's account
642         mint(msg.sender, 100000000 * MBC);
643     }
644 
645     // Modifier to revert if msg.sender is not an Administrator or the Owner account.
646     modifier onlyAdministratorOrOwner() {
647         require(isAdministrator(msg.sender) || isOwner());
648         _;
649     }
650 
651     // Override the addAdministrator function to only allow the owner or other administrators to create
652     function addAdministrator(address account) public onlyOwner {
653         _addAdministrator(account);
654     }
655 
656     // Allow Administrator or Owner to remove an Administrator
657     function removeAdministrator(address account) public onlyOwner {
658         _removeAdministrator(account);
659     }
660 
661     // Override the default ownership renunciation to prevent accidental or malicious renunciation.
662     function renounceOwnership() public onlyOwner {
663     }
664 
665     // Pausable functionality modified from openzeppelin.
666 
667     // State variable, true if the contract is paused.
668     bool private _paused;
669 
670     // Modifier to allow actions only when the contract IS NOT paused
671     modifier whenNotPaused() {
672         require(!_paused);
673         _;
674     }
675 
676     // Modifier to allow actions only when the contract IS paused
677     modifier whenPaused() {
678         require(_paused);
679         _;
680     }
681 
682     function paused() public view returns (bool) {
683         return _paused;
684     }
685 
686     // Called by owner or admin role to pause the contract in the case of a bug or exploit.
687     function pause() external onlyAdministratorOrOwner whenNotPaused {
688         _paused = true;
689     }
690 
691     // Unpauses the contract
692     // Should only be called by the owner because the contract may be paused due to a compromised Administrator account.
693     function unpause() public onlyOwner whenPaused {
694         _paused = false;
695     }
696 
697     // Add modifier to disallow transfers during pause
698     function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {
699         return super.transfer(recipient, amount);
700     }
701 
702     // Convenience function to transfer MBC in whole units
703     // Add modifier to disallow transfers during pause
704     function transferMBC(address recipient, uint256 amount) public whenNotPaused returns (bool) {
705         return super.transfer(recipient, amount * MBC);
706     }
707 
708     // Add modifier to disallow transferFrom during pause
709     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
710         return super.transferFrom(from, to, value);
711     }
712 
713     // Convenience function to transfer MBC in whole units
714     // Add modifier to disallow transferFrom during pause
715     function transferMBCFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
716         return super.transferFrom(from, to, value * MBC);
717     }
718 
719     // Allows an administrator or owner to mint a number of coins
720     function mint(address account, uint256 amount) public onlyAdministratorOrOwner whenNotPaused returns (bool) {
721         require(totalSupply() + amount > totalSupply(), "Increase in supply would cause overflow.");
722         require(!isSupplyCapped(), "Supply has been capped.");
723         _mint(account, amount);
724         return true;
725     }
726 
727     // Helper to mint whole amounts
728     function mintMBC(address account, uint256 amount) public onlyAdministratorOrOwner whenNotPaused returns (bool) {
729         return mint(account, amount * MBC);
730     }
731 
732     // An administator or the contract owner can prevent the minting of new coins
733     // This is a one-way function. Once the supply is capped it can't be uncapped.
734     function freezeMint() public onlyOwner returns (bool) {
735         _supplycapped = true;
736         return isSupplyCapped();
737     }
738 
739     // View function to check whether the supply has been capped.
740     function isSupplyCapped() public view returns (bool) {
741         return _supplycapped;
742     }
743 
744     // Helper to burn MBC whole units (amount * 1e18)
745     function burnMBC(uint256 amount) public {
746         burn(amount * MBC);
747     }
748 
749     // Token owner can approve for `spender` to transferFrom(...) `tokens`
750     // from the token owner's account. The `spender` contract function
751     // `receiveApproval(...)` is then executed
752     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
753         _approve(msg.sender, spender, tokens);
754         emit Approval(msg.sender, spender, tokens);
755         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
756         return true;
757     }
758 
759     // Don't accept ETH
760     function () external payable {
761         revert();
762     }
763 
764     // Owner can transfer out any accidentally sent ERC20 tokens
765     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdministratorOrOwner returns (bool success) {
766         return ERC20(tokenAddress).transfer(owner, tokens);
767     }
768 }