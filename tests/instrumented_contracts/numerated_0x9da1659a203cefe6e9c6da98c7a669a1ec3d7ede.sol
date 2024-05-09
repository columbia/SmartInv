1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 contract Ownable {
110     address private _owner;
111 
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115      * @dev Initializes the contract setting the deployer as the initial owner.
116      */
117     constructor () internal {
118         _owner = msg.sender;
119         emit OwnershipTransferred(address(0), _owner);
120     }
121 
122     /**
123      * @dev Returns the address of the current owner.
124      */
125     function owner() public view returns (address) {
126         return _owner;
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         require(isOwner(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     /**
138      * @dev Returns true if the caller is the current owner.
139      */
140     function isOwner() public view returns (bool) {
141         return msg.sender == _owner;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * > Note: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public onlyOwner {
152         emit OwnershipTransferred(_owner, address(0));
153         _owner = address(0);
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public onlyOwner {
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      */
167     function _transferOwnership(address newOwner) internal {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 }
173 
174 library Roles {
175     struct Role {
176         mapping (address => bool) bearer;
177     }
178 
179     /**
180      * @dev Give an account access to this role.
181      */
182     function add(Role storage role, address account) internal {
183         require(!has(role, account), "Roles: account already has role");
184         role.bearer[account] = true;
185     }
186 
187     /**
188      * @dev Remove an account's access to this role.
189      */
190     function remove(Role storage role, address account) internal {
191         require(has(role, account), "Roles: account does not have role");
192         role.bearer[account] = false;
193     }
194 
195     /**
196      * @dev Check if an account has this role.
197      * @return bool
198      */
199     function has(Role storage role, address account) internal view returns (bool) {
200         require(account != address(0), "Roles: account is the zero address");
201         return role.bearer[account];
202     }
203 }
204 
205 contract MinterRole {
206     using Roles for Roles.Role;
207 
208     event MinterAdded(address indexed account);
209     event MinterRemoved(address indexed account);
210 
211     Roles.Role private _minters;
212 
213     constructor () internal {
214         _addMinter(msg.sender);
215     }
216 
217     modifier onlyMinter() {
218         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
219         _;
220     }
221 
222     function isMinter(address account) public view returns (bool) {
223         return _minters.has(account);
224     }
225 
226     function addMinter(address account) public onlyMinter {
227         _addMinter(account);
228     }
229 
230     function renounceMinter() public {
231         _removeMinter(msg.sender);
232     }
233 
234     function _addMinter(address account) internal {
235         _minters.add(account);
236         emit MinterAdded(account);
237     }
238 
239     function _removeMinter(address account) internal {
240         _minters.remove(account);
241         emit MinterRemoved(account);
242     }
243 }
244 
245 interface IERC20 {
246     /**
247      * @dev Returns the amount of tokens in existence.
248      */
249     function totalSupply() external view returns (uint256);
250 
251     /**
252      * @dev Returns the amount of tokens owned by `account`.
253      */
254     function balanceOf(address account) external view returns (uint256);
255 
256     /**
257      * @dev Moves `amount` tokens from the caller's account to `recipient`.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a `Transfer` event.
262      */
263     function transfer(address recipient, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Returns the remaining number of tokens that `spender` will be
267      * allowed to spend on behalf of `owner` through `transferFrom`. This is
268      * zero by default.
269      *
270      * This value changes when `approve` or `transferFrom` are called.
271      */
272     function allowance(address owner, address spender) external view returns (uint256);
273 
274     /**
275      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * > Beware that changing an allowance with this method brings the risk
280      * that someone may use both the old and the new allowance by unfortunate
281      * transaction ordering. One possible solution to mitigate this race
282      * condition is to first reduce the spender's allowance to 0 and set the
283      * desired value afterwards:
284      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285      *
286      * Emits an `Approval` event.
287      */
288     function approve(address spender, uint256 amount) external returns (bool);
289 
290     /**
291      * @dev Moves `amount` tokens from `sender` to `recipient` using the
292      * allowance mechanism. `amount` is then deducted from the caller's
293      * allowance.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * Emits a `Transfer` event.
298      */
299     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
300 
301     /**
302      * @dev Emitted when `value` tokens are moved from one account (`from`) to
303      * another (`to`).
304      *
305      * Note that `value` may be zero.
306      */
307     event Transfer(address indexed from, address indexed to, uint256 value);
308 
309     /**
310      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
311      * a call to `approve`. `value` is the new allowance.
312      */
313     event Approval(address indexed owner, address indexed spender, uint256 value);
314 }
315 
316 contract ERC20 is IERC20 {
317     using SafeMath for uint256;
318 
319     mapping (address => uint256) private _balances;
320 
321     mapping (address => mapping (address => uint256)) private _allowances;
322 
323     uint256 private _totalSupply;
324 
325     /**
326      * @dev See `IERC20.totalSupply`.
327      */
328     function totalSupply() public view returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev See `IERC20.balanceOf`.
334      */
335     function balanceOf(address account) public view returns (uint256) {
336         return _balances[account];
337     }
338 
339     /**
340      * @dev See `IERC20.transfer`.
341      *
342      * Requirements:
343      *
344      * - `recipient` cannot be the zero address.
345      * - the caller must have a balance of at least `amount`.
346      */
347     function transfer(address recipient, uint256 amount) public returns (bool) {
348         _transfer(msg.sender, recipient, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See `IERC20.allowance`.
354      */
355     function allowance(address owner, address spender) public view returns (uint256) {
356         return _allowances[owner][spender];
357     }
358 
359     /**
360      * @dev See `IERC20.approve`.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function approve(address spender, uint256 value) public returns (bool) {
367         _approve(msg.sender, spender, value);
368         return true;
369     }
370 
371     /**
372      * @dev See `IERC20.transferFrom`.
373      *
374      * Emits an `Approval` event indicating the updated allowance. This is not
375      * required by the EIP. See the note at the beginning of `ERC20`;
376      *
377      * Requirements:
378      * - `sender` and `recipient` cannot be the zero address.
379      * - `sender` must have a balance of at least `value`.
380      * - the caller must have allowance for `sender`'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
384         _transfer(sender, recipient, amount);
385         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to `approve` that can be used as a mitigation for
393      * problems described in `IERC20.approve`.
394      *
395      * Emits an `Approval` event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
402         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to `approve` that can be used as a mitigation for
410      * problems described in `IERC20.approve`.
411      *
412      * Emits an `Approval` event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
421         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Moves tokens `amount` from `sender` to `recipient`.
427      *
428      * This is internal function is equivalent to `transfer`, and can be used to
429      * e.g. implement automatic token fees, slashing mechanisms, etc.
430      *
431      * Emits a `Transfer` event.
432      *
433      * Requirements:
434      *
435      * - `sender` cannot be the zero address.
436      * - `recipient` cannot be the zero address.
437      * - `sender` must have a balance of at least `amount`.
438      */
439     function _transfer(address sender, address recipient, uint256 amount) internal {
440         require(sender != address(0), "ERC20: transfer from the zero address");
441         require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443         _balances[sender] = _balances[sender].sub(amount);
444         _balances[recipient] = _balances[recipient].add(amount);
445         emit Transfer(sender, recipient, amount);
446     }
447 
448     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
449      * the total supply.
450      *
451      * Emits a `Transfer` event with `from` set to the zero address.
452      *
453      * Requirements
454      *
455      * - `to` cannot be the zero address.
456      */
457     function _mint(address account, uint256 amount) internal {
458         require(account != address(0), "ERC20: mint to the zero address");
459 
460         _totalSupply = _totalSupply.add(amount);
461         _balances[account] = _balances[account].add(amount);
462         emit Transfer(address(0), account, amount);
463     }
464 
465      /**
466      * @dev Destoys `amount` tokens from `account`, reducing the
467      * total supply.
468      *
469      * Emits a `Transfer` event with `to` set to the zero address.
470      *
471      * Requirements
472      *
473      * - `account` cannot be the zero address.
474      * - `account` must have at least `amount` tokens.
475      */
476     function _burn(address account, uint256 value) internal {
477         require(account != address(0), "ERC20: burn from the zero address");
478 
479         _totalSupply = _totalSupply.sub(value);
480         _balances[account] = _balances[account].sub(value);
481         emit Transfer(account, address(0), value);
482     }
483 
484     /**
485      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
486      *
487      * This is internal function is equivalent to `approve`, and can be used to
488      * e.g. set automatic allowances for certain subsystems, etc.
489      *
490      * Emits an `Approval` event.
491      *
492      * Requirements:
493      *
494      * - `owner` cannot be the zero address.
495      * - `spender` cannot be the zero address.
496      */
497     function _approve(address owner, address spender, uint256 value) internal {
498         require(owner != address(0), "ERC20: approve from the zero address");
499         require(spender != address(0), "ERC20: approve to the zero address");
500 
501         _allowances[owner][spender] = value;
502         emit Approval(owner, spender, value);
503     }
504 
505     /**
506      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
507      * from the caller's allowance.
508      *
509      * See `_burn` and `_approve`.
510      */
511     function _burnFrom(address account, uint256 amount) internal {
512         _burn(account, amount);
513         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
514     }
515 }
516 
517 
518 contract ERC20Mintable is ERC20, MinterRole {
519     /**
520      * @dev See `ERC20._mint`.
521      *
522      * Requirements:
523      *
524      * - the caller must have the `MinterRole`.
525      */
526     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
527         _mint(account, amount);
528         return true;
529     }
530 }
531 
532 
533 contract ERC20Capped is ERC20Mintable {
534     uint256 private _cap;
535 
536     /**
537      * @dev Sets the value of the `cap`. This value is immutable, it can only be
538      * set once during construction.
539      */
540     constructor (uint256 cap) public {
541         require(cap > 0, "ERC20Capped: cap is 0");
542         _cap = cap;
543     }
544 
545     /**
546      * @dev Returns the cap on the token's total supply.
547      */
548     function cap() public view returns (uint256) {
549         return _cap;
550     }
551 
552     /**
553      * @dev See `ERC20Mintable.mint`.
554      *
555      * Requirements:
556      *
557      * - `value` must not cause the total supply to go over the cap.
558      */
559     function _mint(address account, uint256 value) internal {
560         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
561         super._mint(account, value);
562     }
563 }
564 
565 /**
566  * @dev Optional functions from the ERC20 standard.
567  */
568 contract ERC20Detailed is IERC20 {
569     string private _name;
570     string private _symbol;
571     uint8 private _decimals;
572 
573     /**
574      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
575      * these values are immutable: they can only be set once during
576      * construction.
577      */
578     constructor (string memory name, string memory symbol, uint8 decimals) public {
579         _name = name;
580         _symbol = symbol;
581         _decimals = decimals;
582     }
583 
584     /**
585      * @dev Returns the name of the token.
586      */
587     function name() public view returns (string memory) {
588         return _name;
589     }
590 
591     /**
592      * @dev Returns the symbol of the token, usually a shorter version of the
593      * name.
594      */
595     function symbol() public view returns (string memory) {
596         return _symbol;
597     }
598 
599     /**
600      * @dev Returns the number of decimals used to get its user representation.
601      * For example, if `decimals` equals `2`, a balance of `505` tokens should
602      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
603      *
604      * Tokens usually opt for a value of 18, imitating the relationship between
605      * Ether and Wei.
606      *
607      * > Note that this information is only used for _display_ purposes: it in
608      * no way affects any of the arithmetic of the contract, including
609      * `IERC20.balanceOf` and `IERC20.transfer`.
610      */
611     function decimals() public view returns (uint8) {
612         return _decimals;
613     }
614 }
615 
616 contract PauserRole {
617     using Roles for Roles.Role;
618 
619     event PauserAdded(address indexed account);
620     event PauserRemoved(address indexed account);
621 
622     Roles.Role private _pausers;
623 
624     constructor () internal {
625         _addPauser(msg.sender);
626     }
627 
628     modifier onlyPauser() {
629         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
630         _;
631     }
632 
633     function isPauser(address account) public view returns (bool) {
634         return _pausers.has(account);
635     }
636 
637     function addPauser(address account) public onlyPauser {
638         _addPauser(account);
639     }
640 
641     function renouncePauser() public {
642         _removePauser(msg.sender);
643     }
644 
645     function _addPauser(address account) internal {
646         _pausers.add(account);
647         emit PauserAdded(account);
648     }
649 
650     function _removePauser(address account) internal {
651         _pausers.remove(account);
652         emit PauserRemoved(account);
653     }
654 }
655 
656 contract Pausable is PauserRole {
657     /**
658      * @dev Emitted when the pause is triggered by a pauser (`account`).
659      */
660     event Paused(address account);
661 
662     /**
663      * @dev Emitted when the pause is lifted by a pauser (`account`).
664      */
665     event Unpaused(address account);
666 
667     bool private _paused;
668 
669     /**
670      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
671      * to the deployer.
672      */
673     constructor () internal {
674         _paused = false;
675     }
676 
677     /**
678      * @dev Returns true if the contract is paused, and false otherwise.
679      */
680     function paused() public view returns (bool) {
681         return _paused;
682     }
683 
684     /**
685      * @dev Modifier to make a function callable only when the contract is not paused.
686      */
687     modifier whenNotPaused() {
688         require(!_paused, "Pausable: paused");
689         _;
690     }
691 
692     /**
693      * @dev Modifier to make a function callable only when the contract is paused.
694      */
695     modifier whenPaused() {
696         require(_paused, "Pausable: not paused");
697         _;
698     }
699 
700     /**
701      * @dev Called by a pauser to pause, triggers stopped state.
702      */
703     function pause() public onlyPauser whenNotPaused {
704         _paused = true;
705         emit Paused(msg.sender);
706     }
707 
708     /**
709      * @dev Called by a pauser to unpause, returns to normal state.
710      */
711     function unpause() public onlyPauser whenPaused {
712         _paused = false;
713         emit Unpaused(msg.sender);
714     }
715 }
716 
717 contract ERC20Pausable is ERC20, Pausable {
718     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
719         return super.transfer(to, value);
720     }
721 
722     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
723         return super.transferFrom(from, to, value);
724     }
725 
726     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
727         return super.approve(spender, value);
728     }
729 
730     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
731         return super.increaseAllowance(spender, addedValue);
732     }
733 
734     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
735         return super.decreaseAllowance(spender, subtractedValue);
736     }
737 }
738 
739 
740 contract Pngcoin is ERC20Capped, ERC20Detailed, Pausable, Ownable {
741 
742 	string public _name = "Pngcoin";
743 	string public _symbol = "PNG";
744 	uint8 public _decimals = 18;
745 	uint256 private _initialSupply = 665000000; // 665,000,000
746 
747     uint256 _cap = 1192258185 * (10 ** uint256(_decimals)); // cap of 1,192,258,185
748 
749     event Checkpoint(uint256 data);
750 
751 	constructor() ERC20Capped(_cap) ERC20Detailed(_name, _symbol, _decimals) public {
752 		_mint(msg.sender, _initialSupply * (10 ** uint256(decimals())));
753 	}
754 
755     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
756         return super.transfer(_to, _value);
757     }	
758 
759     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
760         return super.transferFrom(_from, _to, _value);
761     }
762     
763     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
764         return super.approve(_spender, _value);
765     }
766 
767     function checkpoint(uint256 checkpointData) public {
768         emit Checkpoint(checkpointData);
769     }
770 
771 }