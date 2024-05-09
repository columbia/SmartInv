1 pragma solidity ^0.5.2;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see {ERC20Detailed}.
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
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
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
59      * Emits a {Transfer} event.
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
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a, "SafeMath: subtraction overflow");
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, "SafeMath: division by zero");
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 }
183 
184 /**
185  * @dev Implementation of the {IERC20} interface.
186  *
187  * This implementation is agnostic to the way tokens are created. This means
188  * that a supply mechanism has to be added in a derived contract using {_mint}.
189  * For a generic mechanism see {ERC20Mintable}.
190  *
191  * TIP: For a detailed writeup see our guide
192  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
193  * to implement supply mechanisms].
194  *
195  * We have followed general OpenZeppelin guidelines: functions revert instead
196  * of returning `false` on failure. This behavior is nonetheless conventional
197  * and does not conflict with the expectations of ERC20 applications.
198  *
199  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
200  * This allows applications to reconstruct the allowance for all accounts just
201  * by listening to said events. Other implementations of the EIP may not emit
202  * these events, as it isn't required by the specification.
203  *
204  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
205  * functions have been added to mitigate the well-known issues around setting
206  * allowances. See {IERC20-approve}.
207  */
208 contract ERC20 is IERC20 {
209     using SafeMath for uint256;
210 
211     mapping (address => uint256) private _balances;
212 
213     mapping (address => mapping (address => uint256)) private _allowances;
214 
215     uint256 private _totalSupply;
216 
217     /**
218      * @dev See {IERC20-totalSupply}.
219      */
220     function totalSupply() public view returns (uint256) {
221         return _totalSupply;
222     }
223 
224     /**
225      * @dev See {IERC20-balanceOf}.
226      */
227     function balanceOf(address account) public view returns (uint256) {
228         return _balances[account];
229     }
230 
231     /**
232      * @dev See {IERC20-transfer}.
233      *
234      * Requirements:
235      *
236      * - `recipient` cannot be the zero address.
237      * - the caller must have a balance of at least `amount`.
238      */
239     function transfer(address recipient, uint256 amount) public returns (bool) {
240         _transfer(msg.sender, recipient, amount);
241         return true;
242     }
243 
244     /**
245      * @dev See {IERC20-allowance}.
246      */
247     function allowance(address owner, address spender) public view returns (uint256) {
248         return _allowances[owner][spender];
249     }
250 
251     /**
252      * @dev See {IERC20-approve}.
253      *
254      * Requirements:
255      *
256      * - `spender` cannot be the zero address.
257      */
258     function approve(address spender, uint256 value) public returns (bool) {
259         _approve(msg.sender, spender, value);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-transferFrom}.
265      *
266      * Emits an {Approval} event indicating the updated allowance. This is not
267      * required by the EIP. See the note at the beginning of {ERC20};
268      *
269      * Requirements:
270      * - `sender` and `recipient` cannot be the zero address.
271      * - `sender` must have a balance of at least `value`.
272      * - the caller must have allowance for `sender`'s tokens of at least
273      * `amount`.
274      */
275     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
278         return true;
279     }
280 
281     /**
282      * @dev Atomically increases the allowance granted to `spender` by the caller.
283      *
284      * This is an alternative to {approve} that can be used as a mitigation for
285      * problems described in {IERC20-approve}.
286      *
287      * Emits an {Approval} event indicating the updated allowance.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
294         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
295         return true;
296     }
297 
298     /**
299      * @dev Atomically decreases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      * - `spender` must have allowance for the caller of at least
310      * `subtractedValue`.
311      */
312     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
313         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
314         return true;
315     }
316 
317     /**
318      * @dev Moves tokens `amount` from `sender` to `recipient`.
319      *
320      * This is internal function is equivalent to {transfer}, and can be used to
321      * e.g. implement automatic token fees, slashing mechanisms, etc.
322      *
323      * Emits a {Transfer} event.
324      *
325      * Requirements:
326      *
327      * - `sender` cannot be the zero address.
328      * - `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `amount`.
330      */
331     function _transfer(address sender, address recipient, uint256 amount) internal {
332         require(sender != address(0), "ERC20: transfer from the zero address");
333         require(recipient != address(0), "ERC20: transfer to the zero address");
334 
335         _balances[sender] = _balances[sender].sub(amount);
336         _balances[recipient] = _balances[recipient].add(amount);
337         emit Transfer(sender, recipient, amount);
338     }
339 
340     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
341      * the total supply.
342      *
343      * Emits a {Transfer} event with `from` set to the zero address.
344      *
345      * Requirements
346      *
347      * - `to` cannot be the zero address.
348      */
349     function _mint(address account, uint256 amount) internal {
350         require(account != address(0), "ERC20: mint to the zero address");
351 
352         _totalSupply = _totalSupply.add(amount);
353         _balances[account] = _balances[account].add(amount);
354         emit Transfer(address(0), account, amount);
355     }
356 
357      /**
358      * @dev Destroys `amount` tokens from `account`, reducing the
359      * total supply.
360      *
361      * Emits a {Transfer} event with `to` set to the zero address.
362      *
363      * Requirements
364      *
365      * - `account` cannot be the zero address.
366      * - `account` must have at least `amount` tokens.
367      */
368     function _burn(address account, uint256 value) internal {
369         require(account != address(0), "ERC20: burn from the zero address");
370 
371         _totalSupply = _totalSupply.sub(value);
372         _balances[account] = _balances[account].sub(value);
373         emit Transfer(account, address(0), value);
374     }
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
378      *
379      * This is internal function is equivalent to `approve`, and can be used to
380      * e.g. set automatic allowances for certain subsystems, etc.
381      *
382      * Emits an {Approval} event.
383      *
384      * Requirements:
385      *
386      * - `owner` cannot be the zero address.
387      * - `spender` cannot be the zero address.
388      */
389     function _approve(address owner, address spender, uint256 value) internal {
390         require(owner != address(0), "ERC20: approve from the zero address");
391         require(spender != address(0), "ERC20: approve to the zero address");
392 
393         _allowances[owner][spender] = value;
394         emit Approval(owner, spender, value);
395     }
396 
397     /**
398      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
399      * from the caller's allowance.
400      *
401      * See {_burn} and {_approve}.
402      */
403     function _burnFrom(address account, uint256 amount) internal {
404         _burn(account, amount);
405         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
406     }
407 }
408 
409 /**
410  * @title Roles
411  * @dev Library for managing addresses assigned to a Role.
412  */
413 library Roles {
414     struct Role {
415         mapping (address => bool) bearer;
416     }
417 
418     /**
419      * @dev Give an account access to this role.
420      */
421     function add(Role storage role, address account) internal {
422         require(!has(role, account), "Roles: account already has role");
423         role.bearer[account] = true;
424     }
425 
426     /**
427      * @dev Remove an account's access to this role.
428      */
429     function remove(Role storage role, address account) internal {
430         require(has(role, account), "Roles: account does not have role");
431         role.bearer[account] = false;
432     }
433 
434     /**
435      * @dev Check if an account has this role.
436      * @return bool
437      */
438     function has(Role storage role, address account) internal view returns (bool) {
439         require(account != address(0), "Roles: account is the zero address");
440         return role.bearer[account];
441     }
442 }
443 
444 contract PauserRole {
445     using Roles for Roles.Role;
446 
447     event PauserAdded(address indexed account);
448     event PauserRemoved(address indexed account);
449 
450     Roles.Role private _pausers;
451 
452     constructor () internal {
453         _addPauser(msg.sender);
454     }
455 
456     modifier onlyPauser() {
457         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
458         _;
459     }
460 
461     function isPauser(address account) public view returns (bool) {
462         return _pausers.has(account);
463     }
464 
465     function addPauser(address account) public onlyPauser {
466         _addPauser(account);
467     }
468 
469     function renouncePauser() public {
470         _removePauser(msg.sender);
471     }
472 
473     function _addPauser(address account) internal {
474         _pausers.add(account);
475         emit PauserAdded(account);
476     }
477 
478     function _removePauser(address account) internal {
479         _pausers.remove(account);
480         emit PauserRemoved(account);
481     }
482 }
483 
484 /**
485  * @dev Contract module which allows children to implement an emergency stop
486  * mechanism that can be triggered by an authorized account.
487  *
488  * This module is used through inheritance. It will make available the
489  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
490  * the functions of your contract. Note that they will not be pausable by
491  * simply including this module, only once the modifiers are put in place.
492  */
493 contract Pausable is PauserRole {
494     /**
495      * @dev Emitted when the pause is triggered by a pauser (`account`).
496      */
497     event Paused(address account);
498 
499     /**
500      * @dev Emitted when the pause is lifted by a pauser (`account`).
501      */
502     event Unpaused(address account);
503 
504     bool private _paused;
505 
506     /**
507      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
508      * to the deployer.
509      */
510     constructor () internal {
511         _paused = false;
512     }
513 
514     /**
515      * @dev Returns true if the contract is paused, and false otherwise.
516      */
517     function paused() public view returns (bool) {
518         return _paused;
519     }
520 
521     /**
522      * @dev Modifier to make a function callable only when the contract is not paused.
523      */
524     modifier whenNotPaused() {
525         require(!_paused, "Pausable: paused");
526         _;
527     }
528 
529     /**
530      * @dev Modifier to make a function callable only when the contract is paused.
531      */
532     modifier whenPaused() {
533         require(_paused, "Pausable: not paused");
534         _;
535     }
536 
537     /**
538      * @dev Called by a pauser to pause, triggers stopped state.
539      */
540     function pause() public onlyPauser whenNotPaused {
541         _paused = true;
542         emit Paused(msg.sender);
543     }
544 
545     /**
546      * @dev Called by a pauser to unpause, returns to normal state.
547      */
548     function unpause() public onlyPauser whenPaused {
549         _paused = false;
550         emit Unpaused(msg.sender);
551     }
552 }
553 
554 /**
555  * @title Pausable token
556  * @dev ERC20 with pausable transfers and allowances.
557  *
558  * Useful if you want to stop trades until the end of a crowdsale, or have
559  * an emergency switch for freezing all token transfers in the event of a large
560  * bug.
561  */
562 contract ERC20Pausable is ERC20, Pausable {
563     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
564         return super.transfer(to, value);
565     }
566 
567     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
568         return super.transferFrom(from, to, value);
569     }
570 
571     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
572         return super.approve(spender, value);
573     }
574 
575     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
576         return super.increaseAllowance(spender, addedValue);
577     }
578 
579     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
580         return super.decreaseAllowance(spender, subtractedValue);
581     }
582 }
583 
584 /**
585  * @dev Optional functions from the ERC20 standard.
586  */
587 contract ERC20Detailed is IERC20 {
588     string private _name;
589     string private _symbol;
590     uint8 private _decimals;
591 
592     /**
593      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
594      * these values are immutable: they can only be set once during
595      * construction.
596      */
597     constructor (string memory firstName, string memory symbol, uint8 decimals) public {
598         _name = firstName;
599         _symbol = symbol;
600         _decimals = decimals;
601     }
602 
603     /**
604      * @dev Returns the name of the token.
605      */
606     function name() public view returns (string memory) {
607         return _name;
608     } 
609 
610     /**
611      * @dev Returns the symbol of the token, usually a shorter version of the
612      * name.
613      */
614     function symbol() public view returns (string memory) {
615         return _symbol;
616     }
617 
618     /**
619      * @dev Returns the number of decimals used to get its user representation.
620      * For example, if `decimals` equals `2`, a balance of `505` tokens should
621      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
622      *
623      * Tokens usually opt for a value of 18, imitating the relationship between
624      * Ether and Wei.
625      *
626      * NOTE: This information is only used for _display_ purposes: it in
627      * no way affects any of the arithmetic of the contract, including
628      * {IERC20-balanceOf} and {IERC20-transfer}.
629      */
630     function decimals() public view returns (uint8) {
631         return _decimals;
632     }
633 }
634 
635 /**
636  * @dev Contract module which provides a basic access control mechanism, where
637  * there is an account (an owner) that can be granted exclusive access to
638  * specific functions.
639  *
640  * This module is used through inheritance. It will make available the modifier
641  * `onlyOwner`, which can be applied to your functions to restrict their use to
642  * the owner.
643  */
644 contract Ownable {
645     address private _owner;
646 
647     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
648 
649     /**
650      * @dev Initializes the contract setting the deployer as the initial owner.
651      */
652     constructor () internal {
653         _owner = msg.sender;
654         emit OwnershipTransferred(address(0), _owner);
655     }
656 
657     /**
658      * @dev Returns the address of the current owner.
659      */
660     function owner() public view returns (address) {
661         return _owner;
662     }
663 
664     /**
665      * @dev Throws if called by any account other than the owner.
666      */
667     modifier onlyOwner() {
668         require(isOwner(), "Ownable: caller is not the owner");
669         _;
670     }
671 
672     /**
673      * @dev Returns true if the caller is the current owner.
674      */
675     function isOwner() public view returns (bool) {
676         return msg.sender == _owner;
677     }
678 
679     /**
680      * @dev Leaves the contract without owner. It will not be possible to call
681      * `onlyOwner` functions anymore. Can only be called by the current owner.
682      *
683      * NOTE: Renouncing ownership will leave the contract without an owner,
684      * thereby removing any functionality that is only available to the owner.
685      */
686     function renounceOwnership() public onlyOwner {
687         emit OwnershipTransferred(_owner, address(0));
688         _owner = address(0);
689     }
690 
691     /**
692      * @dev Transfers ownership of the contract to a new account (`newOwner`).
693      * Can only be called by the current owner.
694      */
695     function transferOwnership(address newOwner) public onlyOwner {
696         _transferOwnership(newOwner);
697     }
698 
699     /**
700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
701      */
702     function _transferOwnership(address newOwner) internal {
703         require(newOwner != address(0), "Ownable: new owner is the zero address");
704         emit OwnershipTransferred(_owner, newOwner);
705         _owner = newOwner;
706     }
707 }
708 
709 // File: BiggCash.sol
710 
711 contract BiggCash is ERC20Pausable, ERC20Detailed, Ownable {
712 
713     event TokenNameChanged(string indexed name, string indexed newName);
714     event TokenTransferLimited(address indexed addr, uint256 num_days);
715     event TokenTransferUnlimited(address indexed addr);   
716   
717     mapping (address => uint256) public limitTransfer;
718     
719     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply)
720     public
721     ERC20Detailed (name, symbol, decimals) {
722         uint256 totSupply = totalSupply * (uint256(10) ** decimals);
723         _mint(msg.sender, totSupply);
724     }
725     
726     modifier checkLimitTransfer(address addr) {
727         require(limitTransfer[addr] <= now);
728         _;
729     }
730 
731     function transfer(address _to, uint _value) public checkLimitTransfer(msg.sender) returns (bool) {
732         return super.transfer(_to, _value);
733     }
734 
735     function transferFrom(address _from, address _to, uint _value) public checkLimitTransfer(_from) returns (bool) {
736         return super.transferFrom(_from, _to, _value);
737     }
738 
739     function approve(address _spender, uint256 _value) public checkLimitTransfer(msg.sender) returns (bool) {
740         return super.approve(_spender, _value);    
741     }
742 
743     function increaseAllowance(address _spender, uint _addedValue) public checkLimitTransfer(msg.sender) returns (bool success) {
744         return super.increaseAllowance(_spender, _addedValue);
745     }
746 
747     function decreaseAllowance(address _spender, uint _subtractedValue) public checkLimitTransfer(msg.sender) returns (bool success) {
748         return super.decreaseAllowance(_spender, _subtractedValue);
749     }
750 
751     function limitTokenTransfer(address addr, uint256 num_days) onlyOwner public {
752         require(addr != address(0));
753         require(num_days != 0);
754         require(limitTransfer[addr] == 0);
755         
756         emit TokenTransferLimited(addr, num_days);
757         limitTransfer[addr] = now + (num_days * 1 days);
758     }
759 
760     function unlimitTokenTransfer(address addr) onlyOwner public {
761         require(addr != address(0));
762         require(limitTransfer[addr] != 0);
763         emit TokenTransferUnlimited(addr);
764         limitTransfer[addr] = 0;
765     }   
766 }