1 pragma solidity 0.4.26;
2 
3 contract StandardERC20Factory {
4 
5   // index of created contracts
6 
7   mapping (address => bool) public validContracts; 
8   address[] public contracts;
9 
10   // useful to know the row count in contracts index
11 
12   function getContractCount() 
13     public
14     view
15     returns(uint contractCount)
16   {
17     return contracts.length;
18   }
19 
20   //get all contracts
21 
22   function getDeployedContracts() public view returns (address[] memory)
23   {
24     return contracts;
25   }
26 
27   // deploy a new contract
28 
29   function newStandardERC20(string memory name, string memory symbol, uint8 decimals, uint256 cap, uint256 init, address owner)
30     public
31     returns(address)
32   {
33     StandardERC20 c = new StandardERC20(name, symbol, decimals, cap, init, owner);
34     validContracts[c] = true;
35     contracts.push(c);
36     return c;
37   }
38 }
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations with added overflow
42  * checks.
43  *
44  * Arithmetic operations in Solidity wrap on overflow. This can easily result
45  * in bugs, because programmers usually assume that an overflow raises an
46  * error, which is the standard behavior in high level programming languages.
47  * `SafeMath` restores this intuition by reverting the transaction when an
48  * operation overflows.
49  *
50  * Using this library instead of the unchecked operations eliminates an entire
51  * class of bugs, so it's recommended to use it always.
52  */
53 library SafeMath {
54     /**
55      * @dev Returns the addition of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `+` operator.
59      *
60      * Requirements:
61      * - Addition cannot overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      * - Subtraction cannot overflow.
78      */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a, "SafeMath: subtraction overflow");
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `*` operator.
91      *
92      * Requirements:
93      * - Multiplication cannot overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97         // benefit is lost if 'b' is also tested.
98         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0, "SafeMath: division by zero");
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b != 0, "SafeMath: modulo by zero");
142         return a % b;
143     }
144 }
145 
146 
147 /**
148  * @title Roles
149  * @dev Library for managing addresses assigned to a Role.
150  */
151 library Roles {
152     struct Role {
153         mapping (address => bool) bearer;
154     }
155 
156     /**
157      * @dev Give an account access to this role.
158      */
159     function add(Role storage role, address account) internal {
160         require(!has(role, account), "Roles: account already has role");
161         role.bearer[account] = true;
162     }
163 
164     /**
165      * @dev Remove an account's access to this role.
166      */
167     function remove(Role storage role, address account) internal {
168         require(has(role, account), "Roles: account does not have role");
169         role.bearer[account] = false;
170     }
171 
172     /**
173      * @dev Check if an account has this role.
174      * @return bool
175      */
176     function has(Role storage role, address account) internal view returns (bool) {
177         require(account != address(0), "Roles: account is the zero address");
178         return role.bearer[account];
179     }
180 }
181 
182 contract MinterRole {
183     using Roles for Roles.Role;
184 
185     event MinterAdded(address indexed account);
186     event MinterRemoved(address indexed account);
187 
188     Roles.Role private _minters;
189 
190     modifier onlyMinter() {
191         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
192         _;
193     }
194 
195     function isMinter(address account) public view returns (bool) {
196         return _minters.has(account);
197     }
198 
199     function addMinter(address account) public onlyMinter {
200         _addMinter(account);
201     }
202 
203     function renounceMinter() public {
204         _removeMinter(msg.sender);
205     }
206 
207     function _addMinter(address account) internal {
208         _minters.add(account);
209         emit MinterAdded(account);
210     }
211 
212     function _removeMinter(address account) internal {
213         _minters.remove(account);
214         emit MinterRemoved(account);
215     }
216 }
217 
218 contract PauserRole {
219     using Roles for Roles.Role;
220 
221     event PauserAdded(address indexed account);
222     event PauserRemoved(address indexed account);
223 
224     Roles.Role private _pausers;
225 
226     modifier onlyPauser() {
227         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
228         _;
229     }
230 
231     function isPauser(address account) public view returns (bool) {
232         return _pausers.has(account);
233     }
234 
235     function addPauser(address account) public onlyPauser {
236         _addPauser(account);
237     }
238 
239     function renouncePauser() public {
240         _removePauser(msg.sender);
241     }
242 
243     function _addPauser(address account) internal {
244         _pausers.add(account);
245         emit PauserAdded(account);
246     }
247 
248     function _removePauser(address account) internal {
249         _pausers.remove(account);
250         emit PauserRemoved(account);
251     }
252 }
253 
254 /**
255  * @dev Contract module which allows children to implement an emergency stop
256  * mechanism that can be triggered by an authorized account.
257  *
258  * This module is used through inheritance. It will make available the
259  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
260  * the functions of your contract. Note that they will not be pausable by
261  * simply including this module, only once the modifiers are put in place.
262  */
263 contract Pausable is PauserRole {
264     /**
265      * @dev Emitted when the pause is triggered by a pauser (`account`).
266      */
267     event Paused(address account);
268 
269     /**
270      * @dev Emitted when the pause is lifted by a pauser (`account`).
271      */
272     event Unpaused(address account);
273 
274     bool private _paused;
275 
276     /**
277      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
278      * to the deployer.
279      */
280     constructor () internal {
281         _paused = false;
282     }
283 
284     /**
285      * @dev Returns true if the contract is paused, and false otherwise.
286      */
287     function paused() public view returns (bool) {
288         return _paused;
289     }
290 
291     /**
292      * @dev Modifier to make a function callable only when the contract is not paused.
293      */
294     modifier whenNotPaused() {
295         require(!_paused, "Pausable: paused");
296         _;
297     }
298 
299     /**
300      * @dev Modifier to make a function callable only when the contract is paused.
301      */
302     modifier whenPaused() {
303         require(_paused, "Pausable: not paused");
304         _;
305     }
306 
307     /**
308      * @dev Called by a pauser to pause, triggers stopped state.
309      */
310     function pause() public onlyPauser whenNotPaused {
311         _paused = true;
312         emit Paused(msg.sender);
313     }
314 
315     /**
316      * @dev Called by a pauser to unpause, returns to normal state.
317      */
318     function unpause() public onlyPauser whenPaused {
319         _paused = false;
320         emit Unpaused(msg.sender);
321     }
322 }
323 
324 /**
325  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
326  * the optional functions; to access them see `ERC20Detailed`.
327  */
328 interface IERC20 {
329     /**
330      * @dev Returns the amount of tokens in existence.
331      */
332     function totalSupply() external view returns (uint256);
333 
334     /**
335      * @dev Returns the amount of tokens owned by `account`.
336      */
337     function balanceOf(address account) external view returns (uint256);
338 
339     /**
340      * @dev Moves `amount` tokens from the caller's account to `recipient`.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a `Transfer` event.
345      */
346     function transfer(address recipient, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Returns the remaining number of tokens that `spender` will be
350      * allowed to spend on behalf of `owner` through `transferFrom`. This is
351      * zero by default.
352      *
353      * This value changes when `approve` or `transferFrom` are called.
354      */
355     function allowance(address owner, address spender) external view returns (uint256);
356 
357     /**
358      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * > Beware that changing an allowance with this method brings the risk
363      * that someone may use both the old and the new allowance by unfortunate
364      * transaction ordering. One possible solution to mitigate this race
365      * condition is to first reduce the spender's allowance to 0 and set the
366      * desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      *
369      * Emits an `Approval` event.
370      */
371     function approve(address spender, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Moves `amount` tokens from `sender` to `recipient` using the
375      * allowance mechanism. `amount` is then deducted from the caller's
376      * allowance.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a `Transfer` event.
381      */
382     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Emitted when `value` tokens are moved from one account (`from`) to
386      * another (`to`).
387      *
388      * Note that `value` may be zero.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 value);
391 
392     /**
393      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
394      * a call to `approve`. `value` is the new allowance.
395      */
396     event Approval(address indexed owner, address indexed spender, uint256 value);
397 }
398 
399 contract ERC20 is IERC20 {
400     using SafeMath for uint256;
401 
402     mapping (address => uint256) internal _balances;
403 
404     mapping (address => mapping (address => uint256)) internal _allowances;
405 
406     uint256 internal _totalSupply;
407 
408     /**
409      * @dev See `IERC20.totalSupply`.
410      */
411     function totalSupply() public view returns (uint256) {
412         return _totalSupply;
413     }
414 
415     /**
416      * @dev See `IERC20.balanceOf`.
417      */
418     function balanceOf(address account) public view returns (uint256) {
419         return _balances[account];
420     }
421 
422     /**
423      * @dev See `IERC20.transfer`.
424      *
425      * Requirements:
426      *
427      * - `recipient` cannot be the zero address.
428      * - the caller must have a balance of at least `amount`.
429      */
430     function transfer(address recipient, uint256 amount) public returns (bool) {
431         _transfer(msg.sender, recipient, amount);
432         return true;
433     }
434 
435     /**
436      * @dev See `IERC20.allowance`.
437      */
438     function allowance(address owner, address spender) public view returns (uint256) {
439         return _allowances[owner][spender];
440     }
441 
442     /**
443      * @dev See `IERC20.approve`.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      */
449     function approve(address spender, uint256 value) public returns (bool) {
450         _approve(msg.sender, spender, value);
451         return true;
452     }
453 
454     /**
455      * @dev See `IERC20.transferFrom`.
456      *
457      * Emits an `Approval` event indicating the updated allowance. This is not
458      * required by the EIP. See the note at the beginning of `ERC20`;
459      *
460      * Requirements:
461      * - `sender` and `recipient` cannot be the zero address.
462      * - `sender` must have a balance of at least `value`.
463      * - the caller must have allowance for `sender`'s tokens of at least
464      * `amount`.
465      */
466     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
467         _transfer(sender, recipient, amount);
468         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
469         return true;
470     }
471 
472     /**
473      * @dev Atomically increases the allowance granted to `spender` by the caller.
474      *
475      * This is an alternative to `approve` that can be used as a mitigation for
476      * problems described in `IERC20.approve`.
477      *
478      * Emits an `Approval` event indicating the updated allowance.
479      *
480      * Requirements:
481      *
482      * - `spender` cannot be the zero address.
483      */
484     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
485         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
486         return true;
487     }
488 
489     /**
490      * @dev Atomically decreases the allowance granted to `spender` by the caller.
491      *
492      * This is an alternative to `approve` that can be used as a mitigation for
493      * problems described in `IERC20.approve`.
494      *
495      * Emits an `Approval` event indicating the updated allowance.
496      *
497      * Requirements:
498      *
499      * - `spender` cannot be the zero address.
500      * - `spender` must have allowance for the caller of at least
501      * `subtractedValue`.
502      */
503     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
504         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
505         return true;
506     }
507 
508     /**
509      * @dev Moves tokens `amount` from `sender` to `recipient`.
510      *
511      * This is internal function is equivalent to `transfer`, and can be used to
512      * e.g. implement automatic token fees, slashing mechanisms, etc.
513      *
514      * Emits a `Transfer` event.
515      *
516      * Requirements:
517      *
518      * - `sender` cannot be the zero address.
519      * - `recipient` cannot be the zero address.
520      * - `sender` must have a balance of at least `amount`.
521      */
522     function _transfer(address sender, address recipient, uint256 amount) internal {
523         require(sender != address(0), "ERC20: transfer from the zero address");
524         require(recipient != address(0), "ERC20: transfer to the zero address");
525 
526         _balances[sender] = _balances[sender].sub(amount);
527         _balances[recipient] = _balances[recipient].add(amount);
528         emit Transfer(sender, recipient, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a `Transfer` event with `from` set to the zero address.
535      *
536      * Requirements
537      *
538      * - `to` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _totalSupply = _totalSupply.add(amount);
544         _balances[account] = _balances[account].add(amount);
545         emit Transfer(address(0), account, amount);
546     }
547 
548      /**
549      * @dev Destroys `amount` tokens from `account`, reducing the
550      * total supply.
551      *
552      * Emits a `Transfer` event with `to` set to the zero address.
553      *
554      * Requirements
555      *
556      * - `account` cannot be the zero address.
557      * - `account` must have at least `amount` tokens.
558      */
559     function _burn(address account, uint256 value) internal {
560         require(account != address(0), "ERC20: burn from the zero address");
561 
562         _totalSupply = _totalSupply.sub(value);
563         _balances[account] = _balances[account].sub(value);
564         emit Transfer(account, address(0), value);
565     }
566 
567     /**
568      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
569      *
570      * This is internal function is equivalent to `approve`, and can be used to
571      * e.g. set automatic allowances for certain subsystems, etc.
572      *
573      * Emits an `Approval` event.
574      *
575      * Requirements:
576      *
577      * - `owner` cannot be the zero address.
578      * - `spender` cannot be the zero address.
579      */
580     function _approve(address owner, address spender, uint256 value) internal {
581         require(owner != address(0), "ERC20: approve from the zero address");
582         require(spender != address(0), "ERC20: approve to the zero address");
583 
584         _allowances[owner][spender] = value;
585         emit Approval(owner, spender, value);
586     }
587 
588     /**
589      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
590      * from the caller's allowance.
591      *
592      * See `_burn` and `_approve`.
593      */
594     function _burnFrom(address account, uint256 amount) internal {
595         _burn(account, amount);
596         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
597     }
598 }
599 
600 /**
601  * @dev Extension of `ERC20` that allows token holders to destroy both their own
602  * tokens and those that they have an allowance for, in a way that can be
603  * recognized off-chain (via event analysis).
604  */
605 contract ERC20Burnable is ERC20 {
606     /**
607      * @dev Destroys `amount` tokens from the caller.
608      *
609      * See `ERC20._burn`.
610      */
611     function burn(uint256 amount) public {
612         _burn(msg.sender, amount);
613     }
614 
615     /**
616      * @dev See `ERC20._burnFrom`.
617      */
618     function burnFrom(address account, uint256 amount) public {
619         _burnFrom(account, amount);
620     }
621 }
622 
623 /**
624  * @title Pausable token
625  * @dev ERC20 with pausable transfers and allowances.
626  *
627  * Useful if you want to e.g. stop trades until the end of a crowdsale, or have
628  * an emergency switch for freezing all token transfers in the event of a large
629  * bug.
630  */
631 contract ERC20Pausable is ERC20, Pausable {
632     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
633         return super.transfer(to, value);
634     }
635 
636     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
637         return super.transferFrom(from, to, value);
638     }
639 
640     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
641         return super.approve(spender, value);
642     }
643 
644     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
645         return super.increaseAllowance(spender, addedValue);
646     }
647 
648     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
649         return super.decreaseAllowance(spender, subtractedValue);
650     }
651 }
652 
653 /**
654  * @dev Optional functions from the ERC20 standard.
655  */
656 contract StandardERC20 is MinterRole, ERC20Burnable, ERC20Pausable {
657     string private _name;
658     string private _symbol;
659     uint8 private _decimals;
660     uint256 private _cap;
661     address private _owner;
662 
663     /**
664      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
665      * these values are immutable: they can only be set once during
666      * construction.
667      */
668     constructor (string memory name, string memory symbol, uint8 decimals, uint256 cap, uint256 init, address owner) public {
669         require(cap > 0, "ERC20Capped: cap is 0");
670         _name = name;
671         _symbol = symbol;
672         _decimals = decimals;
673         _cap = cap;
674         _owner = owner;
675         _balances[_owner] = init; //provides initial deposit to owner set by constructor
676         _totalSupply = init; //initializes totalSupply with initial deposit
677         _addMinter(_owner);
678         _addPauser(_owner);
679     }
680     
681     /**
682      * @dev See `ERC20._mint`.
683      *
684      * Requirements:
685      *
686      * - the caller must have the `MinterRole`.
687      */
688     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
689         _mint(account, amount);
690         return true;
691     }
692     
693     /**
694      * @dev See `ERC20Mintable.mint`.
695      *
696      * Requirements:
697      *
698      * - `value` must not cause the total supply to go over the cap.
699      */
700     function _mint(address account, uint256 value) internal {
701         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
702         super._mint(account, value);
703     }
704 
705     /**
706      * @dev Returns the name of the token.
707      */
708     function name() public view returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev Returns the symbol of the token, usually a shorter version of the
714      * name.
715      */
716     function symbol() public view returns (string memory) {
717         return _symbol;
718     }
719 
720     /**
721      * @dev Returns the number of decimals used to get its user representation.
722      * For example, if `decimals` equals `2`, a balance of `505` tokens should
723      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
724      *
725      * Tokens usually opt for a value of 18, imitating the relationship between
726      * Ether and Wei.
727      *
728      * > Note that this information is only used for _display_ purposes: it in
729      * no way affects any of the arithmetic of the contract, including
730      * `IERC20.balanceOf` and `IERC20.transfer`.
731      */
732     function decimals() public view returns (uint8) {
733         return _decimals;
734     }
735     
736     /**
737      * @dev Returns the cap on the token's total supply.
738      */
739     function cap() public view returns (uint256) {
740         return _cap;
741     }
742 }